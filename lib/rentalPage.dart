import 'package:flutter/material.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({Key key}) : super(key: key);

  @override
  _RentalPageState createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Rental"),
      ),
    );
  }
}
