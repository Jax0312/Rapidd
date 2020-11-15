import 'package:flutter/material.dart';


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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text('Log in'),
                  color: Colors.white,
                  onPressed: () {/** */},
                ),
                FlatButton(
                  child: Text('Register'),
                  color: Color(0xFFC4C4C4),
                  onPressed: () {/** */},
                ),
              ],
            ),
            Spacer(
                flex: 3),
            Container(
              color: Colors.white,
              width: size.width * 0.6,
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
              width: size.width * 0.6,
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
              width: size.width * 0.6,
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
    );
  }
}
