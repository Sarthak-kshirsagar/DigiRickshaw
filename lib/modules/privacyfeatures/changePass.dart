import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController NewPasswordController = new TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  bool? statusOfReset;
  final auth = FirebaseAuth.instance;
  bool failed = false;

  Future<void> resetPassword(BuildContext ctx,String newPassword)async{
    if(newPassword.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height -150,
              right: 20,
              left: 20),

            backgroundColor: Colors.red,content: Text("Please enter the Password")),
      );
    }
    setState(() {
      isLoading = true;
    });
    User? user = auth.currentUser;
    setState(() {
      statusOfReset = false;
    });
   try{
      await  user?.updatePassword(newPassword);
      print("reset passwod");
      setState(() {
        statusOfReset = true;
        isLoading=false;
      });
      showDialog(context:context,builder: (context) {
        return Center(
          child: Container(
            width: 250,
            height:80,
            child: AlertDialog(

              content: Column(
                children: [
                  Text("Password Updated "),
                  SizedBox(height: 10,),
                  Icon(
                    Icons.check,color: Colors.green,size:50,
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        );
      },

      );
   }catch(e){
     print(e);
      setState(() {
        failed=true;
        isLoading = false;

      });

     // ScaffoldMessenger.of(ctx).showSnackBar(
     //
     //   SnackBar(
     //       behavior: SnackBarBehavior.floating,
     //       margin: EdgeInsets.only(
     //           bottom: MediaQuery.of(context).size.height - 150,
     //           right: 20,
     //           left: 20),
     //       backgroundColor: Colors.red,content: Text(textAlign:TextAlign.center,"Failed to reset the password\nEmail must be Verified")),
     // );
   }

  }

  String? errorMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SafeArea(child:
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Reset Password",style: TextStyle(
                color: Colors.black,
                fontSize:25,
                fontWeight: FontWeight.bold,

              )),
              SizedBox(height:20,),
              Container(
                width: 250,
                height: 80,
                child: TextFormField(
                  controller: NewPasswordController,

                  onChanged: (value) {
                    if(value.length<6){
                      setState(() {
                         errorMsg = "Length must be greater than 6";
                      });
                    }else{
                      setState(() {
                        errorMsg=null;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    errorText: errorMsg,
                      label:Text("Enter the new password"),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey,width:1.5),
                        borderRadius: BorderRadius.circular(10),

                      )
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.black),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      onPressed: (){
                      resetPassword(context,NewPasswordController.value.text);


                      }, child:Text("Reset Password")),
                  SizedBox(width: 10,),
                  if(isLoading==true) CircularProgressIndicator(),
                  SizedBox(width: 10,),



                ],
              ),

              if(failed==true)
                Text(textAlign: TextAlign.center,"Our Mistake ,Failed to Update Password\nPlease try later.",style: TextStyle(color: Colors.red),),
            ],
          ),


        )
        )
    );
  }
}
