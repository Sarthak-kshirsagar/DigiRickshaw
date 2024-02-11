import 'package:flutter/material.dart';

class NotifyCustomers extends StatefulWidget {
  const NotifyCustomers({super.key});

  @override
  State<NotifyCustomers> createState() => _NotifyCustomersState();
}

class _NotifyCustomersState extends State<NotifyCustomers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text(style: TextStyle(
              color: Colors.red
            ),"Service not Available")),
          ],
        ),
      ),
    );;
  }
}
