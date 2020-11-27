import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rapidd/login.dart';
import 'package:rapidd/mainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;
  bool _initiated = false;
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    getSpInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _initiated == false
            ? Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: new LinearProgressIndicator(backgroundColor: Colors.red,),
          ),
        )
            : _isLogin == true
            ? MainPage()
            : LoginPage(),
      ),
    );
  }

  Future getSpInstance() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLogin = prefs.getBool('isLogin');
      _initiated = true;
    });
  }
}
