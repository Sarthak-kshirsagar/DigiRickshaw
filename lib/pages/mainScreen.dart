// import 'dart:html';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rickshaw2/pages/servicesLanding.dart';

import '../infoScreen/billMngInfo.dart';
import '../infoScreen/docsMngInfo.dart';
import '../infoScreen/paymentMngInfo.dart';
import '../infoScreen/reportMngInfo.dart';
import '../infoScreen/studentMngInfo.dart';
import '../services/StudentMng.dart';
import '../services/profile.dart';
import 'DashboardPage.dart';


class MainScreen extends StatefulWidget {
   String? currentUserID;

   MainScreen(this.currentUserID,{super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final String currentUserName = "Sarthak";

  final int monthlyIncome = 10000;
   String? _selectedMonth;
   final int registeredCustomers = 52;

  List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  int _selectedTab = 0;

  //bootom navigation bar items to be returned
  List<Widget> bottomList = [
      Main(),

    StudentManagement(),
    ServicesLanding(),
    ProfilePage(),


  ];
  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  // upcoming students list


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    return ScaffoldMessenger(
      child: Scaffold(
      
        body:bottomList[_selectedTab],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: [
            //bottom navigation bar
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Customers"),
            BottomNavigationBarItem(
                icon:Image.asset(width:20,"assets/images/application.png"), label: "Services"),
      
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      
      ),
    );
  }
}


// DropdownButton<String>(
// hint: Text('Select a month'),
// value: _selectedMonth,
// onChanged: (String? newValue) {
// setState(() {
// _selectedMonth = newValue;
// });
// },
// items: months.map<DropdownMenuItem<String>>((String value) {
// return DropdownMenuItem<String>(
// value: value,
// child: Text(value),
// );
// }).toList(),
// ),







// =======================================================================================================================

