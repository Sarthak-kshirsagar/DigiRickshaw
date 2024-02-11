import 'package:flutter/material.dart';

class TwoStepAuthen extends StatefulWidget {
  const TwoStepAuthen({super.key});

  @override
  State<TwoStepAuthen> createState() => _TwoStepAuthenState();
}

class _TwoStepAuthenState extends State<TwoStepAuthen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Service is not Available as of now...",style: TextStyle(color: Colors.red),)),
    );
  }
}
