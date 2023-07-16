import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddBillingPage extends StatefulWidget {
  @override
  _AddBillingPageState createState() => _AddBillingPageState();
}
class _AddBillingPageState extends State<AddBillingPage> {
  final TextEditingController _perihalController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences _prefs;

  void _submitForm() async {
    final String perihal = _perihalController.text.trim();
    final int total = int.parse(_totalController.text.trim());
    _prefs = await SharedPreferences.getInstance();
    final String id_user = _prefs.getString('id_user') ?? '';

    if (perihal.isNotEmpty && total > 0 ) {
      try {
        await _firestore.collection('billing').add({
          'perihal': perihal,
          'total': total,
          'xuser': id_user,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Billing saved'),
          ),
        );

        Navigator.pop(context); // Return to previous page
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving billing'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Billing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _perihalController,
              decoration: InputDecoration(
                labelText: 'Perihal',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _totalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total',
              ),
            ),
            SizedBox(height: 16.0),
           
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
