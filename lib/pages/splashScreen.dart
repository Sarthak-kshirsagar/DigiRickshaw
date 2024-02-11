// import 'package:digitalrickshaw/pages/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:rickshaw2/Authentication/Register.dart';

import 'mainScreen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center ,
          children: [
            Container(
              width: 200,
              height: 200,
              child:Image.asset("assets/images/icon.jpg"),
            ),

          ],
        ),
      ),
    );
  }
}
