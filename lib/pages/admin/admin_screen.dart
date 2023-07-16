import 'package:finance_flutter/pages/admin/akun_page.dart';
import 'package:finance_flutter/pages/admin/tagihan_screen.dart';
import 'package:finance_flutter/pages/update_password.dart';
import 'package:finance_flutter/pages/user/billing_page.dart';
import 'package:finance_flutter/pages/user/history_page.dart';
import 'package:finance_flutter/pages/user/home_page.dart';
import 'package:finance_flutter/pages/user/payment_page.dart';
import 'package:finance_flutter/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored session data

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Remove all existing routes from the stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Page 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.train),
              title: const Text('Page 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePasswordPage(),
                  ),
                );
              },
              leading: Icon(Icons.settings),
              title: const Text('Update Password'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout(context); // Call the logout function
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserManagementPage()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        'Manajemen Akun',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserPaymentsPage()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        'Mananjemen Tagihan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
