import 'package:finance_flutter/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List billings = [];
  final double billingAmount = 0.0; // Replace with actual billing amount
  List transactionHistory = []; // Initialize transaction history as an empty list
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences _prefs;
  num tagihanAkhir = 0;


  @override
  void initState() {
    super.initState();
    _fetchTransactionHistory();
  }

  void _fetchTransactionHistory() async {
    _prefs = await SharedPreferences.getInstance();
    final String id_user = _prefs.getString('id_user') ?? '';
    num tagihan = 0;

    // Fetch the billing data from the 'billing' collection in Firestore
    final billingSnapshot = await _firestore
        .collection('billing')
        .get();

    // Extract the billing data from the documents
    final List<Map<String, dynamic>> billingData =
        billingSnapshot.docs.map((doc){
          // hitung jumlah tagihan : 
          // ambil semua billing data total masukin ke tagihan 
            tagihan = tagihan + doc.data()['total'];
          return doc.data();
          }).toList();

    // print(tagihan);
    setState(() {
      billings = billingData;
    });

    _prefs = await SharedPreferences.getInstance();
     // terus ambil semua dari data payment user 
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(id_user)
        .collection('payments')
        .get();

    // // Extract the transaction history from the documents
    final transactions = snapshot.docs.map((doc) => doc.data()).toList();
    // print(transactions);
    setState(() {
      transactionHistory = transactions.cast<dynamic>();
    });
   
    // perulangan billing
    billingSnapshot.docs.forEach((doc) {
      final billingDokumenId = doc.id;
      final dataBillings = doc.data();
    
     // perulangan payment  
      snapshot.docs.forEach((doc) {
        final paymentUserId = doc.id;
        final dataPayment = doc.data();
        // jika dari billing dan payment ada dan approved payment true , maka kurangin jumlah tagihan
          // print(billingDokumenId == dataPayment['billid']);
        if(dataPayment['billid'] == billingDokumenId){

          if(dataPayment['approved'] == true){
            tagihan = tagihan - dataPayment['nominal'];
          }
        }
      });
    });

    setState(() {
      tagihanAkhir = tagihan;
    });
    
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Home'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Card(
              child: ListTile(
                title: Text(
                  'Total Tagihan ',
                  // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${convertRupiah(tagihanAkhir)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween
              ,children: [
              Text(
                'History Pembayaran',
                style: TextStyle(fontSize: 18),
              ),
              Text('Selengkapnya')
            ],),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: transactionHistory.length,
              itemBuilder: ((context, index)  {
                return Card(
                  child:ListTile(
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: transactionHistory[index]['approved']==true?Color.fromARGB(255, 139, 244, 125):const Color.fromARGB(255, 255, 142, 134),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                      child:Text(transactionHistory[index]['approved']==true?'Diterima':"Pending")
                    ),
                    title: Text('Pembayaran '+convertRupiah(transactionHistory[index]["nominal"])),
                    subtitle: Text("Tanggal :"+convertTimestamp(transactionHistory[index]["date"]),
                    
                    ),
                  )
                );
              }
              )
              )
            // Text(
            //   transactionHistory.isNotEmpty ? transactionHistory.last : 'No transaction',
            //   style: TextStyle(fontSize: 16),
            // ),
          ],
        ),
      ),
    );
  }
}
