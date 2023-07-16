import 'package:finance_flutter/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _showMainScreen = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final SharedPreferences prefs = await _prefs;
    final bool showMainScreen = prefs.getBool('showMainScreen') ?? true;

    setState(() {
      _showMainScreen = showMainScreen;
    });
  }

  Future<void> _saveSession() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('showMainScreen', false);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (!_showMainScreen) {
      return LoginPage();
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Image.asset('assets/welcome_screen.png', width: size.width * 0.7),
              SizedBox(height: 20),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Selamat Datang',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Di Aplikasi Keuangan STMIK AMIK Bandung',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Permudah Sistem pembayaranmu dengan menggunakan aplikasi ini',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Container(
                width: size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveSession();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text(
                    'Selengkapnya',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
