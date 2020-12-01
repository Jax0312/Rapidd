import 'package:flutter/material.dart';

class OrderCompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          height: size.height * 0.9,
          width: size.width * 0.9,
          image: AssetImage("assets/images/orderReceiveImage.png"),
        ),
      ),
    );
  }
}
