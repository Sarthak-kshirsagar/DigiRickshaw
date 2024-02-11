import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifyEmailAddress extends StatefulWidget {
  String email;
   VerifyEmailAddress({required this.email});

  @override
  State<VerifyEmailAddress> createState() => _VerifyEmailAddressState();
}

class _VerifyEmailAddressState extends State<VerifyEmailAddress> {
    bool isLoading = false;
    bool isStatusfetching = false;
    String emailAddres="";
  TextEditingController EmailAddressController =  TextEditingController();
  bool isEmailVerifedVar = false;
    final auth = FirebaseAuth.instance;
  Future <void> isEmailVerified()async{
    setState(() {
      isStatusfetching = true;
    });
    User? user = auth.currentUser;
    print(user?.emailVerified);
    try {
      await user?.reload();
      if(user?.emailVerified==true){
        setState(() {
          isEmailVerifedVar = true;

        });
      }else if(user?.emailVerified==false){
        setState(() {
          isEmailVerifedVar=false;
        });
      }
    } on Exception catch (e) {
      // TODO
      print(e);

    }
    setState(() {
      isStatusfetching = false;
    });
  }
  Future <void> verifyEmail()async{
    setState(() {
      isLoading = true;
    });

    try{
      User? user = auth.currentUser;
      if(user?.emailVerified == false){
        print("checked user is not verified");
        await user?.sendEmailVerification();
        print("email verification link set...");
        setState(() {
          isLoading = false;
        });
        print("exited ");
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error send email")),
      );
    }


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      emailAddres=widget.email;
      EmailAddressController = TextEditingController(text: emailAddres);
    });
    isEmailVerified();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child:
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Email Verification",style: TextStyle(
              color: Colors.black,
              fontSize:25,
              fontWeight: FontWeight.bold,

            )),
            SizedBox(height:20,),
            Container(
              width: 250,
              height: 80,
              child: TextFormField(
                controller: EmailAddressController,
                decoration: InputDecoration(
                  label:Text("Enter the email address"),
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
                      verifyEmail();
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Verification Email Sent !"),
                      actions: [

                      ElevatedButton(onPressed: (){
                        try {
                          Uri emailUrl = Uri.parse("https://gmail.com");
                          launchUrl(emailUrl);
                        } on Exception catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Failed to open the Email,please open manually")));
                        }
                      }, child:Text("Open Email")),
                    ],);
                  },);
                }, child:Text("Verify Email")),
                if(isLoading==true) CircularProgressIndicator(),
                SizedBox(width: 10,),


              ],
            ),
            SizedBox(height: 20,),

            Column(
              children: [
                if(isStatusfetching==true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Fetching Status"),
                      SizedBox(width: 10,),
                      CircularProgressIndicator(),
                    ],
                  ),
                if(isStatusfetching==false) Column(
                  children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(isEmailVerifedVar==true)
                          Text("Email Already Verified",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
                          if(isEmailVerifedVar==true)
                          Icon(Icons.check,color: Colors.green,size:50),
                          if(isEmailVerifedVar==false)
                            Text("Email Not Verified",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
                          if(isEmailVerifedVar==false)
                          Icon(Icons.error,color: Colors.red,size:50),
                        ],
                      ),


                  ],
                )

              ],
            )
          ],
        ),
      )
      )
    );
  }
}
