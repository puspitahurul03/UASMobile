import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DetailPembayaranPage extends StatefulWidget {
  final bool isApproved;
  final reference;
  final String billId;
  final String buktiImage;
  final Timestamp date;
  final num nominal;

  const DetailPembayaranPage({
    required this.reference,
    required this.isApproved,
    required this.billId,
    required this.buktiImage,
    required this.date,
    required this.nominal,
  });

  @override
  State<DetailPembayaranPage> createState() => _DetailPembayaranPageState();
}

class _DetailPembayaranPageState extends State<DetailPembayaranPage> {
  bool _isApproved = false;

  @override
  void initState() {
    super.initState();
    _isApproved = widget.isApproved;
  }

  void _approvePayment() async {
    try {
      // Perform the necessary operation to approve the payment, e.g., update Firestore
      // Here, we are only changing the local state for demonstration purposes
      await widget.reference.update({'approved': true});

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

  void _declinePayment() async {
    try {
      // Perform the necessary operation to decline the payment, e.g., update Firestore
      // Here, we are only changing the local state for demonstration purposes
      await widget.reference.update({'approved': false});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment declined'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error declining payment'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pembayaran'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Approved: ${widget.isApproved ? 'Yes' : 'No'}'),
            ),
            ListTile(
              title: Text('Bill ID: ${widget.billId}'),
            ),
            ListTile(
              title: Image.memory(
                base64Decode(widget.buktiImage),
              ),
            ),
            ListTile(
              title: Text('Date: ${widget.date}'),
            ),
            ListTile(
              title: Text('Nominal: ${widget.nominal}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: (){_isApproved ? null : _approvePayment;},
                  child: Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: (){_declinePayment; },
                  child: Text('Decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
