import 'package:finance_flutter/pages/update_password.dart';
import 'package:finance_flutter/pages/user/billing_page.dart';
import 'package:finance_flutter/pages/user/history_page.dart';
import 'package:finance_flutter/pages/user/home_page.dart';
import 'package:finance_flutter/pages/user/payment_page.dart';
import 'package:finance_flutter/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomePage extends StatefulWidget {
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
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
    final List<Widget> drawerMenus = [
    ListTile(
      onTap: (){
        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
      },
      leading: Icon(Icons.home),
      title: const Text('Home'),
    ),
    ListTile(
      onTap: (){
        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BillingPage()),
                    );
      },
      leading: Icon(Icons.train),
      title: const Text('Tagihan'),
    ),
    ListTile(
      onTap: (){
        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
      },
      leading: Icon(Icons.payment),
      title: const Text('Pembayaran'),
    ),
    ListTile(
      onTap: (){
        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryPage()),
                    );
      },
      leading: Icon(Icons.history),
      title: const Text('History Pembayaran'),
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
      onTap: (){
        _logout(context);
      },
      leading: Icon(Icons.logout),
      title: const Text('Logout'),
    ),
  ];


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
              child: Text(''),
            ),
            ...drawerMenus.map((menu) => menu).toList(),
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
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        'Home',
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
                      MaterialPageRoute(builder: (context) => BillingPage()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        'Tagihan',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Pembayaran',
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
                      MaterialPageRoute(builder: (context) => HistoryPage()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.orange,
                    child: Center(
                      child: Text(
                        'History Pembayaran',
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
