import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  color: Color(0xFFC4C4C4),
                  onPressed: () {/** */},
                ),
                FlatButton(
                  child: Text('Register'),
                  color: Colors.white,
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
                  hintText: "E-mail/Username",
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
                  hintText: "Passwords",
                ),
              ),
            ),
            Spacer(
              flex: 5,
            ),
            FlatButton(
              child: Text('Log in'),
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
