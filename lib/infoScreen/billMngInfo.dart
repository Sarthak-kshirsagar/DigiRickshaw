import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rickshaw2/modules/Billing%20and%20Invoice/invoiceList.dart';


class BillingMngInfo extends StatefulWidget {
  const BillingMngInfo({super.key});

  @override
  State<BillingMngInfo> createState() => _BillingMngInfoState();
}

class _BillingMngInfoState extends State<BillingMngInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:Stack(
            children: [
              Image.asset(fit: BoxFit.cover,"assets/images/AutoBill.jpg"),
              ClipRRect(
                child: Align(
                  alignment: Alignment.center,
                  child: FractionalTranslation(
                    translation: Offset(0.0, 0.40),
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
                          Text("Billing & Invoice",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                          SizedBox(height:20,),
                          ListTile(
                            leading: Icon(Icons.receipt_long,color: Colors.black),
                            title: Text("Generate Invoice for Customers",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          ListTile(
                            leading: Icon(Icons.history_edu_rounded,color: Colors.black),
                            title: Text("Payment History",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),

                          Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: ElevatedButton(onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceList(),));
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
                          )
                        ],
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
