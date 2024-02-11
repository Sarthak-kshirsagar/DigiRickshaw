import 'package:flutter/material.dart';
import 'package:rickshaw2/modules/privacyfeatures/LiveLocation.dart';
import 'package:rickshaw2/modules/privacyfeatures/TwoStepAuthentication.dart';
import 'package:rickshaw2/modules/privacyfeatures/changePass.dart';
import 'package:rickshaw2/modules/privacyfeatures/deviceLocation.dart';
import 'package:rickshaw2/modules/privacyfeatures/pro.dart';
import 'package:rickshaw2/modules/privacyfeatures/verifyEmail.dart';

import '../modules/privacyfeatures/privacyInfo.dart';

class PrivacyPage extends StatefulWidget {
  String email;
   PrivacyPage({required this.email});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width:MediaQuery.of(context).size.width,
              height:150,
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Privacy",style: TextStyle(fontWeight: FontWeight.bold,fontSize:35)),
                    SizedBox(height:15,),
                    Text(style: TextStyle(fontWeight: FontWeight.w400,fontSize:15),"Let us know how you would like to control your privacy",textAlign:TextAlign.center,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text(textAlign: TextAlign.center,"Your Data and Privacy at\n Digi Rickshaw",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            Container(
              width:600,
              height:450,



              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(

                    children: [
                      privacyInfo("Per",Image.asset("assets/images/autoStu.jpg",fit: BoxFit.fitHeight),"Customer Data"),
                      SizedBox(width:20,),
                      privacyInfo("Trans",Image.asset("assets/images/privacy.jpg"),"Vehicle Data"),
                      SizedBox(width:20,),
                      privacyInfo("Ser",Image.asset("assets/images/reportAna.jpg"),"Analytics & Usage"),
                      SizedBox(width:20,),
                      privacyInfo("Ser",Image.asset("assets/images/autoFian.jpg"),"Payments"),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
            Text("Location Sharing",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

            listWidgtes(DeviceLocation(),Icons.location_searching_rounded,"Device Location"),
            listWidgtes(LiveLocationPage(),Icons.location_on_rounded,"Live Location"),
            Divider(),
            Text("Account Security",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

            listWidgtes(VerifyEmailAddress(email: "${widget.email}"),Icons.email_sharp,"Verify Email"),
            listWidgtes(ResetPassword(),Icons.password_rounded,"Change Password"),
            listWidgtes(TwoStepAuthen(),Icons.security_sharp,"Two Step Authentication"),
            Divider(),
            Text("How do we approach privacy at\nDigi Auto ?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            SizedBox(height: 15,),
            InkWell(
              onTap: (){},
              child: InkWell(
                onTap: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(),));
                },
                child: Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey,width: 1.5),
                  ),
                  child: Center(child: Text("Go through our Privacy Page",style: TextStyle(color: Colors.grey))),


                ),
              ),

            ),
            Container(
              width: 250,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.location_on),
                  Icon(Icons.person),
                  Icon(Icons.security,size: 50),
                  Icon(Icons.document_scanner_outlined),

                  Icon(Icons.payment_rounded),

                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
  Widget listWidgtes(Widget w,IconData i, text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          // color: Colors.grey,
        ),
        child: InkWell(
          onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => w));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Icon(i, size: 35,color: Colors.black),
                      SizedBox(
                        width: 20,
                      ),
                      Text("${text}",style: TextStyle(fontWeight: FontWeight.bold)),


                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_sharp,size:25,color: Colors.black,)
              ],
            ),
          ),
        ),
      ),
    );
  }

    Widget privacyInfo(String whatToEpand,Image i,heading){
    return  Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      width:250,
      height:400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20)

      , boxShadow:[
        BoxShadow(color: Colors.grey,offset:Offset(0,0),blurRadius:8,spreadRadius:0,blurStyle: BlurStyle.outer),                  ],
          border: Border.all(color: Colors.grey,width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                width:250,
                height:250,
                child: i
              ),
            ),
            Text("${heading}",style:TextStyle(fontWeight: FontWeight.bold,fontSize:18),),
            SizedBox(height:10),
            Container(width:200,child: Text("Ensure the security of your account by setting a strong password,.",textAlign: TextAlign.center,)),
            Row(
              children: [
                SizedBox(width: 10,),
                ElevatedButton(

                    style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white),backgroundColor: MaterialStatePropertyAll(Colors.black)),

                    onPressed: (){
                      if(whatToEpand=="Per"){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExploreDataPage(trans: false,services: false,per: true),));
                      }
                      if(whatToEpand=="Ser"){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExploreDataPage(trans: false,per: false,services: true),));

                      }
                      if(whatToEpand=="Trans"){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExploreDataPage(per: false,services: false,trans: true),));

                      }
                    }, child: Text("View Details")),
              ],
            ),


          ],
        ),
      ),
    );


    }


}
