import 'dart:convert';

import 'package:finance_flutter/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPaymentDetailsPage extends StatefulWidget {
  final String userId;

  const UserPaymentDetailsPage({required this.userId});

  @override
  State<UserPaymentDetailsPage> createState() => _UserPaymentDetailsPageState();
}

class _UserPaymentDetailsPageState extends State<UserPaymentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Payments'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('payments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final payments = snapshot.data!.docs;

            return ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index].data();
                final bool isApproved = payment['approved'] ?? false;

                return Card(
                  child: ListTile(
                    title: Text('Total: ${convertRupiah(payment['nominal'])}'),
                    trailing: isApproved
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.cancel, color: Colors.red),
                    onTap: () {
                       showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Bukti Pembayaran'),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Text('Terima: ${isApproved ? 'Ya' : 'Tidak'}'),
                                  // Text('Bill ID: ${payment['billid']}'),
                                  Text('Bukti Transfer:',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                  Image.memory(
                                    base64Decode(payment['bukti']),
                                  ),
                                  // Text('Date: ${payment['date']}'),
                                  Text('Tgl:',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                  Text(convertTimestamp(payment['date'])),
                                  Text('Nominal: ',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                  Text('${convertRupiah(payment['nominal']) }',style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey))
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _approvePayment(payments[index].reference);
                                  Navigator.pop(context);
                                },
                                child: Text('Approve'),
                              ),
                            ],
                          ),
                        );
                    },
                  ),
                );
              },
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  void _approvePayment(DocumentReference<Map<String, dynamic>> paymentRef) async {
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
