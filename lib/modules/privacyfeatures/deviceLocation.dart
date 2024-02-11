import 'package:flutter/material.dart';

class DeviceLocation extends StatefulWidget {
  const DeviceLocation({super.key});

  @override
  State<DeviceLocation> createState() => _DeviceLocationState();
}

class _DeviceLocationState extends State<DeviceLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Service is not Available as of now...",style: TextStyle(color: Colors.red),)),
    );
  }
}
