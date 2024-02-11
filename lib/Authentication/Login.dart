import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rickshaw2/Authentication/Register.dart';
import 'package:rickshaw2/pages/HomePage.dart';
import 'package:rickshaw2/pages/mainScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailAddress = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  final db = FirebaseFirestore.instance;
  String? currentUserID;
  bool isLoading = false;
  Future<void> loginInWithEmailNPassword(String email, String Password) async {
    setState(() {
      isLoading = true;
    });
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: Password);

      if (userCredential.user != null) {
        // Store the current user ID
        currentUserID = userCredential.user!.uid;

        // Navigate to MainScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(currentUserID.toString())),
          (route) => false,
        );
      }

    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (context) {

      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        actions: [

        ],
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shadowColor: Colors.grey,contentPadding: EdgeInsets.all(0),title: Text("Invalid Credentials",style: TextStyle(fontSize: 15)),icon: Icon(Icons.error_outline,color: Colors.red),backgroundColor: Colors.white,shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 2)),);
         },);
      setState(() {
        isLoading =false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: Image.asset("assets/images/icon.jpg"),
              ),
              SizedBox(
                child: Text("Login to Digi Auto",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: emailAddress,
                  decoration: InputDecoration(
                    label: Text("Enter Email Address"),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                    label: Text("Enter Password"),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              if(isLoading==true) Center(child: CircularProgressIndicator()),
              if(isLoading==false)
              ElevatedButton(
                  onPressed: () {
                    loginInWithEmailNPassword(
                        emailAddress.text.trim(), password.text.trim());
                  },
                  child: Text("Login"),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black)),
              SizedBox(
                height: 20,
              ),
              Text("Not yet Registered?"),
              SizedBox(
                height: 10,
              ),

              ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                        (route) => false);
                  },
                  child: Text("Register"),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
