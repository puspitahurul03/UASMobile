import 'package:finance_flutter/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List transactionHistory = [];
   late SharedPreferences _prefs;
   var billingData; 

  //  let 

  @override
  void initState() {
    super.initState();
    _fetchTransactionHistory();
    
  }

  _fetchBillingData(billingid) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('billing')
        .doc(billingid) // Use the provided billingId from the widget
        .get();

      print(snapshot);

    
    if (snapshot.exists) {
      setState(() {
        billingData = snapshot.data();
      });
    }
    // print(snapshot.data());
    return snapshot.data()!['perihal'];
  }

  void _fetchTransactionHistory() async {
    _prefs = await SharedPreferences.getInstance();
    final String id_user = _prefs.getString('id_user') ?? '';

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(id_user).collection('payments').get();

      final List transactions =
          snapshot.docs.map((doc) => doc.data()).toList();
          print(transactions);

      setState(() {
        transactionHistory = transactions;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Pembayaran'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),

        child: ListView.builder(
          itemCount: transactionHistory.length,
          itemBuilder: (context, index) {  
      
            return Card(
              child: ListTile(
                title: Text('Pembayaran : '+ convertRupiah(transactionHistory[index]['nominal'])),
                subtitle: Text(convertTimestamp(transactionHistory[index]['date'])),
              ),
            );
          },
        ),
      ),
    );
  }
}
