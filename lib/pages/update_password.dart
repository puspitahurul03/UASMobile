import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePasswordPage extends StatefulWidget {

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
   late SharedPreferences _prefs;

  
  bool _isLoading = false;

  void _submitForm() async {
    _prefs = await SharedPreferences.getInstance();
    final String id_user = _prefs.getString('id_user') ?? '';
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Update the password in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(id_user)
            .update({'password': _passwordController.text});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password updated successfully'),
          ),
        );
        Navigator.pop(context); // Return to the previous page
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating password'),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

 

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Password'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Update Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
