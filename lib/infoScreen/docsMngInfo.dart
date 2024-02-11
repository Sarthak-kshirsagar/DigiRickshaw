import 'package:flutter/material.dart';
import 'package:rickshaw2/modules/storeDocuments/viewDocuments.dart';
import 'package:rickshaw2/modules/uploadFiles/uploadFile.dart';

import '../modules/storeDocuments/finalPdf.dart';
import '../modules/storeDocuments/sharedPrefPdf.dart';
class StoreDocsInfo extends StatefulWidget {
  const StoreDocsInfo({super.key});

  @override
  State<StoreDocsInfo> createState() => _StoreDocsInfoState();
}

class _StoreDocsInfoState extends State<StoreDocsInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:Stack(
            children: [
              Image.asset(fit: BoxFit.cover,"assets/images/AutoDoc.jpg"),
              ClipRRect(
                child: Align(
                  alignment: Alignment.center,
                  child: FractionalTranslation(
                    translation: Offset(0.0, 0.40),
                    child: SingleChildScrollView(
                      child: Container(
                        width:double.infinity,
                        height:500,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(70),topRight: Radius.circular(70)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 30,),
                            Text("Store Documents",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                            SizedBox(height:20,),
                            ListTile(
                              leading: Icon(Icons.document_scanner_rounded,color: Colors.black),
                              title: Text("Store Your Important Documents",style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            ListTile(
                              leading: Icon(Icons.add_alert,color: Colors.black),
                              title: Text("Alert on Renewal of Documents",style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            ListTile(
                              leading: Icon(Icons.security_rounded,color: Colors.black),
                              title: Text("Stored Securely on our Cloud",style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            ListTile(
                              leading: Icon(Icons.access_alarm_rounded,color: Colors.black),
                              title: Text("24/7 Available",style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            // ElevatedButton(onPressed: (){
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => PDFVIEWSCREEEN(),));
                            // }, child: Text("Shared Pref")),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              child: ElevatedButton(onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadToCloud(),));
                              },
                      
                                  style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white),backgroundColor: MaterialStatePropertyAll(Colors.black)),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                      
                                      Text("Proceed",textAlign:TextAlign.center),
                                      SizedBox(width:110,),
                                      Icon(Icons.forward_rounded),
                                    ],
                                  )),
                            ),
                      
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          )
      ),
    );
  }
}
