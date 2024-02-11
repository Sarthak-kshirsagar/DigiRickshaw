import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rickshaw2/Authentication/Login.dart';

class TestAuth extends StatefulWidget {
  const TestAuth({super.key});

  @override
  State<TestAuth> createState() => _TestAuthState();
}

class _TestAuthState extends State<TestAuth> {
  Future<void> verifyPhoneNumberAndShowSignUp(BuildContext ctx,String phoneNumber) async {
    try {
      final phoneNumberWithCountryCode =phoneNumber;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumberWithCountryCode,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Navigate to SignupPage with verification credential
          await FirebaseAuth.instance.signInWithCredential(credential).then((value){
            print("verifiedddd");
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          // Handle verification failure
          print(error.message);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Verification Error'),

            ),
          );
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code auto-retrieval timed out! Please request code again.');
        },
        codeSent: (String verificationId,int? resendToken) async {
          print("verification id is ${verificationId}");
          String smsCode="";
          // Show UI for user to enter received code
          await showDialog(
            context: ctx,
            builder: (context) => AlertDialog(
              title: Text('Enter Verification Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter SMS code',
                    ),
                    onChanged: (code) {
                      // Store the entered code
                      smsCode = code.trim();
                      print("Sms code is updated and value is ${smsCode}");
                    },
                  ),

                ],
              ),
              actions: [
                ElevatedButton(onPressed: (){

                  Navigator.pop(context);
                print("sms code is ${smsCode}");
                  PhoneAuthCredential cred = PhoneAuthProvider.credential(verificationId: verificationId, smsCode:smsCode);
                  FirebaseAuth.instance.signInWithCredential(cred).then((value) {
                    print(cred);
                    print("succesfully created");
                  });

                }, child:Text("verify")),

              ],
            ),
          );
          print("sms code is ${smsCode}");


          },
      );
    } catch (error) {
      print(error.toString());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(error.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Column(
        children: [
          Container(
            child: Text("hi"),
          ),
          ElevatedButton(onPressed: (){
              verifyPhoneNumberAndShowSignUp(context,"+911234567892");
          }, child: Text("Click to signIn")),
        ],
      )),
    );
  }
}
