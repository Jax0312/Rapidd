import 'package:flutter/material.dart';
import 'package:rapidd/mainPage.dart';
import 'package:rapidd/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  SharedPreferences prefs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  static final key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getSpInstance();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Main.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(
                flex: 3,
              ),
              Container(
                height: size.height * 0.2,
                width: size.width * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/RAPIDD Logo.png"),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text('Log in'),
                    color: Color(0xFFC4C4C4),
                    onPressed: () {/** */},
                  ),
                  FlatButton(
                    child: Text('Register'),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationPage()));
                    },
                  ),
                ],
              ),
              Spacer(flex: 3),
              Container(
                color: Colors.white,
                width: size.width * 0.9,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Enter a valid E-mail",
                  ),
                ),
              ),
              Spacer(),
              Container(
                color: Colors.white,
                width: size.width * 0.9,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Enter your Passwords",
                  ),
                ),
              ),
              Spacer(
                flex: 5,
              ),
              FlatButton(
                child: Text('Log in'),
                color: Color(0xFFC4C4C4),
                onPressed: () {
                  if (emailController.text != "" &&
                      passwordController.text != "") {
                    prefs.setBool('isLogin', true);
                    prefs.setString('email', emailController.text);
                    prefs.setString('password', passwordController.text);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainPage()));
                  } else {
                    key.currentState.showSnackBar(SnackBar(
                        content: Text(
                          "Enter Email and Password",
                          textAlign: TextAlign.center,
                        )));
                  }
                },
              ),
              Spacer(
                flex: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getSpInstance() async {
    prefs = await SharedPreferences.getInstance();
  }
}
