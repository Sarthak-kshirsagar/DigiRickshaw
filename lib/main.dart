
import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rickshaw2/pages/DashboardPage.dart';
import 'package:rickshaw2/pages/HomePage.dart';
import 'package:rickshaw2/pages/mainScreen.dart';
import 'package:rickshaw2/pages/splashScreen.dart';

import 'firebase_options.dart';




// void main(){
//   runApp(MaterialApp(home:LandingPage(),));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
    //initilization of Firebase app
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.appAttest,
    );
  } on Exception catch (e) {
    print(e);
  }
  // other Firebase service initialization

  runApp(MaterialApp(
debugShowCheckedModeBanner: false,

      home: LandingPage()));
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});


  @override
  State<LandingPage> createState() => _LandingPageState();



}

class _LandingPageState extends State<LandingPage> {
  late StreamSubscription<User?> user;
  String? currentUserID = "";
  Future<void> getUserID()async{
      User? user = FirebaseAuth.instance.currentUser;
      String? id = user?.uid;
      setState(() {
        currentUserID = id;
      });
  }
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    getUserID();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if(user ==null){
        print("not signed in");
      }else{
        print("is signed in");
      }
    });
    // _navigatorScreen();
  }
  // _navigatorScreen()async{
  //   await Future.delayed(Duration(seconds:3),() {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
  //   },);
  // }
  @override
  void dispose(){
    super.dispose();
    user.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FirebaseAuth.instance.currentUser == null ? HomePage() :
      MainScreen(currentUserID),
    );
  }
}



