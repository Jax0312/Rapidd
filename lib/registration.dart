import 'package:flutter/material.dart';
import 'package:rapidd/login.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                  FlatButton(
                    child: Text('Register'),
                    color: Color(0xFFC4C4C4),
                    onPressed: () {/** */},
                  ),
                ],
              ),
              Spacer(flex: 3),
              Container(
                color: Colors.white,
                width: size.width * 0.9,
                child: TextField(
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Create a Username",
                  ),
                ),
              ),
              Spacer(),
              Container(
                color: Colors.white,
                width: size.width * 0.9,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Create a Passwords",
                  ),
                ),
              ),
              Spacer(
                flex: 5,
              ),
              FlatButton(
                child: Text('Sign Up'),
                color: Color(0xFFC4C4C4),
                onPressed: () {/** */},
              ),
              Spacer(
                flex: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
