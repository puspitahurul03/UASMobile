import 'package:finance_flutter/helper_functions.dart';
import 'package:finance_flutter/pages/admin/addbilling_page.dart';
import 'package:finance_flutter/pages/admin/detail_tagihan_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPaymentsPage extends StatefulWidget {
  @override
  _UserPaymentsPageState createState() => _UserPaymentsPageState();
}

class _UserPaymentsPageState extends State<UserPaymentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List _payments = [];

  @override
  void initState() {
    super.initState();
    _fetchUsersAndPayments();
    // print(_payments);
  }

  void _fetchUsersAndPayments() async {
  final QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore
      .collection('users')
      .get();

  final List<DocumentSnapshot> users = userSnapshot.docs;
  final List<DocumentSnapshot> userPayments = [];

  for (final userDoc in users) {
    final QuerySnapshot<Map<String, dynamic>> paymentSnapshot = await userDoc.reference
        .collection('payments')
        .get();
    userPayments.addAll(paymentSnapshot.docs);
  }

  setState(() {
    _payments = users.map((userDoc) {
      final user = userDoc.data();
      final payments = userPayments
          .where((paymentDoc) => paymentDoc.reference.parent.parent?.id == userDoc.id)
          .map((paymentDoc) => paymentDoc.data())
          .toList();

      return {
        'userid':userDoc.id,
        'user': user,
        'payments': payments,
      };
    }).toList();
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Payments'),
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBillingPage(),
              ),
            );
            },
            child: Icon(Icons.add),
          ),
      body: ListView.builder(
        itemCount: _payments.length,
        itemBuilder: (context, index) {
          // print(_payments[index]);
              return _payments[index]['payments'].length>0 ?
              Card(
                child: ListTile(
                  onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPaymentDetailsPage(userId: _payments[index]['userid']),
                        ),
                      );
                  },
                  title: Text('Nama :' + _payments[index]['user']['nama']),
                ),
              ):SizedBox();
          // }
        },
      ),
    );
  }

  void _approvePayment(Map<String, dynamic> payment) async {
    final paymentRef = payment['reference'];

    try {
      await paymentRef.update({'approved': true});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment approved'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving payment'),
        ),
      );
    }
  }
}
