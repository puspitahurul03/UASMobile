import 'package:finance_flutter/pages/user/user_screen.dart';
import 'package:finance_flutter/pages/admin/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  bool isPasswordVisible = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      final String role = _prefs.getString('role') ?? '';
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage()),
        );
      }
    }
  }

  void _saveSession(String id_user,String role, String nama, {String? npm}) async {
    await _prefs.setBool('isLoggedIn', true);
    await _prefs.setString('id_user',id_user);
    await _prefs.setString('role', role);
    await _prefs.setString('email', email);
    await _prefs.setString('nama', nama);
    if (role == 'users') {
      await _prefs.setString('npm', npm ?? '');
    }
  }

 void _login() async {
  // Perform login logic here
  print('Email: $email');
  print('Password: $password');

  // Check if the user exists in the Firestore collection
  final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
      .collection('users')
      .where('email', isEqualTo: email)
      .where('password', isEqualTo: password)
      .get();

  if (snapshot.docs.isNotEmpty) {
    // User exists, show snackbar with user information
    final user = snapshot.docs.first.data();
    final name = user['nama'];
    final role = user['role'];
    final npm = user['npm'];
    final id_user = snapshot.docs.first.id;
    // Access the 'payments' collection within the 'users' collection
    // final paymentsCollection =
    //     _firestore.collection('users/${snapshot.docs.first.id}/payments');

    // // Retrieve the documents within the 'payments' collection
    // final paymentsSnapshot = await paymentsCollection.get();
    // final payments = paymentsSnapshot.docs.map((doc) => doc.data()).toList();

    // // Print the payment documents
    // print(payments);
    // return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged in as $name'),
      ),
    );

    _saveSession(id_user,role, name, npm: role == 'users' ? npm : null); // Save the session

    // Redirect to the appropriate homepage based on the user's role
    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserHomePage()),
      );
    }
  } else {
    // User doesn't exist, show snackbar with error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Username/password salah'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 40,),
                    Text('LOGIN',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28)),
                    SizedBox(height: 10,),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: !isPasswordVisible,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
                    SizedBox(height: 40,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
