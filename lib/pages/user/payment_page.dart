import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nominalController = TextEditingController();
  File? _selectedImage;
  late SharedPreferences _prefs;
  List<dynamic> _billIds = []; // List to store bill IDs
  String? _selectedBillId; // Currently selected bill ID

  @override
  void initState() {
    super.initState();
    _fetchBillIds();
  }

  void _fetchBillIds() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('billing')
        .get();

    final List<dynamic> billIds =
        snapshot.docs.map((doc) => {'perihal':doc.data()['perihal'],'id':doc.id}).toList();

    setState(() {
      _billIds = billIds;
    });
  }

  void _selectImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitPayment() async {
    _prefs = await SharedPreferences.getInstance();
    final String id_user = _prefs.getString('id_user') ?? '';
    if (_formKey.currentState!.validate() && _selectedBillId != null) {
      // Form is valid and bill ID is selected, proceed with payment submission

      // Get the form values
      final double nominal = double.parse(_nominalController.text);
      final String base64Image =
          base64Encode(_selectedImage!.readAsBytesSync());
      final Timestamp timestamp = Timestamp.now();

      try {
        // Update the payments collection within the nested users collection
        await _firestore
            .collection('users')
            .doc(id_user)
            .collection('payments')
            .add({
          'billid': _selectedBillId!,
          'nominal': nominal,
          'bukti': base64Image,
          'date': timestamp,
          'approved':false
        });

        // Payment submitted successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment submitted successfully'),
          ),
        );
      } catch (error) {
        // Error occurred during payment submission
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting payment'),
          ),
        );
      }
    } else {
      // No bill ID selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a bill ID'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Pembayaran'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedBillId,
                  decoration: InputDecoration(labelText: 'Bill ID'),
                  items: _billIds.map((billId) {
                    return DropdownMenuItem<String>(
                      value: billId['id'],
                      child: Text(billId['perihal']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBillId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a bill ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Nominal'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the nominal';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid nominal';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _selectImage,
                  child: Text('Select Image'),
                ),
                SizedBox(height: 16.0),
                _selectedImage != null
                    ? Image.file(_selectedImage!)
                    : Text('No image selected'),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitPayment,
                  child: Text('Submit Payment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
