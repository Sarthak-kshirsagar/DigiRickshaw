import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:digitalrickshaw/pages/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rickshaw2/Authentication/Login.dart';
import 'package:rickshaw2/Authentication/testaut.dart';
import 'package:rickshaw2/infoScreen/paymentMngInfo.dart';
import 'package:rickshaw2/pages/splashScreen.dart';

import 'mainScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController mobileController = new TextEditingController();







  @override
  void initState() {

    super.initState();

    // _navigatorScreen();
  }

  // _navigatorScreen()async{
  //   await Future.delayed(Duration(seconds:3),() {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>MainScreen(),));
  //   },);
  // }


// ====================function to calculate the total amount of per month====================


  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Submitted',
          style: TextStyle(color: Colors.green),
        ),
      ),
    );
  }
  bool isLoading = false;
  Future <String?> createUser(String mobile,String name,String email,String password) async{
    try {
      setState(() {
        isLoading = true;
      });
      final UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      String? userId = user.user?.uid;
      final db = FirebaseFirestore.instance;
      final customerRef = FirebaseFirestore.instance;
      db.collection("StoredDocuments").doc("${userId}").set({"DriverName":"${name}","LICURL":"","InsURL":""});
      db.collection("Users").doc("${userId}").set({"Mobile":"${mobile}","Name": "${name}","Email":"${email}","Password":"${password}"});
      db.collection("Graphs").doc("${userId}").set({"Driver Name":"${name}","Customer Count":{
      "January":0,
        "February":0,
        "March":0,
        "April":0,
        "May":0,
        "June":0,
        "July":0,
        "August":0,
        "September":0,
        "October":0,
        "November":0,
        "December":0,
      },
        "Monthly Income":{
        "2023":{
          "January":0,
          "February":0,
          "March":0,
          "April":0,
          "May":0,
          "June":0,
          "July":0,
          "August":0,
          "September":0,
          "October":0,
          "November":0,
          "December":0,
        },
        "2024":{
          "January":0,
          "February":0,
          "March":0,
          "April":0,
          "May":0,
          "June":0,
          "July":0,
          "August":0,
          "September":0,
          "October":0,
          "November":0,
          "December":0,
        }
        },
        "Yearly Income":{
        "2023":0,
          "2024":0,

        }
      });
      setState(() {
        isLoading = false;
      });
      return "Registration Successfull";


    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(context: context, builder: (context) {
          return Container(
            width: 250,
            height: 100,
            child: Center(
              child: AlertDialog(
                content: Text("Weak Password"),
              ),
            ),
          );
        },);
        print('The password provided is too weak.');

        return "Password is too Weak";
        AlertDialog(title: Text("Weak Password"),);
      } else if (e.code == 'email-already-in-use') {
        showDialog(context: context, builder: (context) {
          return Container(
            width: 250,
            height: 100,
            child: Center(
              child: AlertDialog(
                content: Text("Email Already Exists"),
              ),
            ),
          );
        },);
        print('The account already exists for that email');

        return "The account already exists for that email";
      }
    } catch (e) {
      print(e);
      print(e);
      showDialog(context: context, builder: (context) {
        return Container(
          width: 250,
          height:150,
          child: AlertDialog(
            content: Text("Error Occured while Registering\nPlease Try Later"),
          ),
        );
      },);
      return "Error";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Container(
                  child: Text("Welcome to ",style: TextStyle(color: Colors.grey,fontWeight:FontWeight.bold,),),
                ),
            SizedBox(height: 10,),
            AnimatedTextKit(animatedTexts: [TyperAnimatedText("Digi-Auto",textStyle: TextStyle(
              color:Colors.black,fontWeight: FontWeight.bold,fontSize:25,
            ),speed: Duration(milliseconds:150))],totalRepeatCount:3),
                Container(
                  width:200,
                  height:200 ,
                  child: Image.asset("assets/images/icon.jpg"),
                ),
                Container(
                  child: Text("Register using Name and Email Address",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:15,
                  ),),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Form(
                    key: _formKey,
                      child: Column(children: [
                    Container(

                      width: 300,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: nameController,
                          validator: (value) {
                            if(value==Null){
                              return "Enter your Name";
                            }else if(!isValidName(value!)){
                              return "Enetr Valid Name";
                            }
                            return null;
                          },

                        decoration: InputDecoration(
                          label: Text("Full Name"),
                          prefixIcon: Icon(Icons.person_2_sharp,color: Colors.black),
                          hintText: "Enter Your Full Name",
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width:12)),

                        ),

                      ),

                    ),
                    SizedBox(
                      height: 20,
                    ),
                        Container(

                          width: 300,
                          child: TextFormField(

                            textInputAction: TextInputAction.next,
                            controller: mobileController,
                            validator: (value) {
                              if(value==Null){
                                return "Enter your Mobile Number";
                              }else if(!isValidMobileNumber(value!)){
                                return "Enter valid Number";
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              label: Text("Mobile Number"),
                              prefixIcon: Icon(Icons.person_2_sharp,color: Colors.black),
                              hintText: "Enter Your Mobile Number",
                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width:12)),

                            ),

                          ),

                        ),
                        SizedBox(
                          height: 20,
                        ),
                    Container(
                      width: 300,
                      height: 80,

                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        decoration:InputDecoration(

                          label: Text("Email Address"),
                      prefixIcon: Icon(Icons.email_rounded,color: Colors.black,),
                      hintText: "Enter Your Email Address",
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width:12)),
                    ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if(value.length<2){
                            return "Name Should be more than Characters";
                          }

                          else if (!isValidEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },

                      ),
                    ),
                        SizedBox(height:20),
                        Container(
                          width: 300,
                          child: TextFormField(
                            controller: passwordController,

                            validator: (value) {
                              if(value!.isEmpty){
                                return "Enter password";
                              }else if(!isValidPassword(value)){
                                return "Password Length must be 8 \n Include one Lowercase,Uppercase & Digit";
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              label: Text("Password"),
                              prefixIcon: Icon(Icons.password_sharp,color: Colors.black),
                              hintText: "Enter Password",

                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width:12)),

                            ),

                          ),

                        ),
                        SizedBox(
                          height: 20,
                        ),
                  ],)),
                  
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(

                          style: ButtonStyle(

                              foregroundColor: MaterialStatePropertyAll(Colors.white),
                              backgroundColor: MaterialStatePropertyAll(Colors.green)),


                          child:

                          Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [

                              Text("Begin",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                              Icon(Icons.arrow_circle_right)

                            ],

                          ), onPressed: ()async{

                          if (_formKey.currentState!.validate()) {
                            // _formKey.currentState.sav  e();
                            // Now you can use _name and _email for further processing
                            // print('Name: $_name, Email: $_email');
                             String? currentUser = await createUser(mobileController.value.text.trim(),nameController.value.text.trim(),emailController.value.text.trim(),passwordController.value.text.trim());

                             if(currentUser=="Registration Successfull"){
                               showToastMessage("Regsitration Successful");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen(),));
                              Future.delayed(Duration(milliseconds: 2500),(){
                                //creating the user

                                Navigator.of(context).pop(SplashScreen());
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(),));
                                showToastMessage("Thanks For Registering");
                              });
                            }


                            // Fluttertoast.showToast(
                            //   msg: "Registered Successfully",
                            //   // gravity: ToastGravity.TOP,
                            //   // timeInSecForIosWeb: 1,
                            //   // backgroundColor: Colors.green,
                            //   // textColor: Colors.black,
                            //   // fontSize: 16.0,
                            //
                            // );
                            // _showSnackBar();


                          }


                        },
                        ),
                        SizedBox(width: 10,),
                        if(isLoading==true)
                          CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(

                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                }, child: Text("Login")),

              ],
            ),
          ),
        ),
      ),
    );





  }
//to validate the email
  bool isValidEmail(String value) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(value);
  }
  bool isValidMobileNumber(String value) {
    // Mobile number pattern: 10 digits, starting with 7, 8, or 9
    final mobileRegExp = RegExp(r'^[789]\d{9}$');
    return mobileRegExp.hasMatch(value);
  }
  bool isValidPassword(String value) {
    // Password pattern: At least 8 characters, including at least one uppercase letter, one lowercase letter, and one digit
    final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return passwordRegExp.hasMatch(value);
  }
}





//to validate the name
bool isValidName(String name) {
  final nameRegExp = RegExp(r'^[a-zA-Z\s-]{2,}$');
  return nameRegExp.hasMatch(name);
}


void showToastMessage(String msg)=>Fluttertoast.showToast(msg: msg,gravity:ToastGravity.TOP,backgroundColor: Colors.green,timeInSecForIosWeb: 1,textColor: Colors.black);












