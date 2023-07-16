import 'package:finance_flutter/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> billingList = [];

  @override
  void initState() {
    super.initState();
    _fetchBillingData();
  }

  void _fetchBillingData() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('billing').get();

    final List<Map<String, dynamic>> billings =
        snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      billingList = billings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Tagihan'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Tagihan',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: billingList.length,
              itemBuilder: (context, index) {
                final billing = billingList[index];
                final billingAmount = billing['total'];

                return Card(
                  child: ListTile(
                    title: Text('${billing["perihal"]}'),
                    subtitle: Text(convertRupiah(billingAmount)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
