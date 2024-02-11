import 'package:flutter/material.dart';
import 'package:rickshaw2/modules/Billing%20and%20Invoice/invoiceList.dart';
import 'package:rickshaw2/modules/PaymentManagement/graph.dart';
import 'package:rickshaw2/modules/PaymentManagement/paymentMng.dart';
import 'package:rickshaw2/modules/uploadFiles/uploadFile.dart';


class ServicesLanding extends StatefulWidget {
  const ServicesLanding({super.key});

  @override
  State<ServicesLanding> createState() => _ServicesLandingState();
}

class _ServicesLandingState extends State<ServicesLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ServiceFeature("ho", Icons.safety_check, "Semd", "hi vasu"),
            SizedBox(height:20,),
            Text("Your Management Companion\nSimplifying Your Daily Tasks",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
            SizedBox(height: 50,),
            ServiceFeature(context,PaymentMng(),"Payment Management", Icons.payment_rounded, "Manage all the Payments"),
            ServiceFeature(context,ReportsPage(),"Reports and Analytics", Icons.graphic_eq_sharp, "Graphs,Charts and More"),
            ServiceFeature(context,InvoiceList(),"Billing & Invoice", Icons.receipt_long, "Generate Receipts"),
            ServiceFeature(context,UploadToCloud(),"Access Documents", Icons.document_scanner_rounded, "Access all your Documents"),
          ],
        ),
      )),
    );
  }
}

Widget ServiceFeature(BuildContext ctx,Widget w,String header,IconData icon,String Content){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: (){
        Navigator.push(ctx, MaterialPageRoute(builder: (context) => w,));
      },
      child: Container(
        width:double.infinity,
        height:80,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.black,width: 2)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon,color: Colors.black),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(header,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  Text(Content,style: TextStyle(fontSize: 13),),
                ],
              ),

              Icon(Icons.arrow_forward_ios_sharp,color: Colors.black,),

            ],
          ),
        ),
      ),
    ),
  );
}