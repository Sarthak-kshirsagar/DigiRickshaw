import 'package:flutter/material.dart';
import 'package:rickshaw2/infoScreen/paymentMngInfo.dart';
import 'package:rickshaw2/modules/PaymentManagement/NotifyCustomers.dart';
import 'package:rickshaw2/modules/PaymentManagement/UpdatePayments.dart';
import 'package:rickshaw2/modules/PaymentManagement/viewDetails.dart';

import '../PaymentList.dart';


class PaymentMng extends StatefulWidget {
  const PaymentMng({super.key});

  @override
  State<PaymentMng> createState() => _PaymentMngState();
}

class _PaymentMngState extends State<PaymentMng> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // SizedBox(height: ,)
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Payment\n Management",style: TextStyle( color: Colors.black,fontWeight: FontWeight.bold,fontSize:35),),
              ),
              SizedBox(height: 10,),
              Center(child: Text("Update,Inform and more...",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)),
              SizedBox(height: 15,),


              // =======================payment services widgets========================

              // paymentServices(context,"View Details", Icons.info_rounded, "View all Payment Details","See all the information regarding the payments",ViewPaymentDetails()),
              paymentServices(context, "Update Something", Icons.payment_rounded, "Update the Payments","Make changes to payements received and more", UpdateDetails()),
              paymentServices(context, "Notify", Icons.notifications, "Send Notifications", "Inform customers regarding their dues", NotifyCustomers()),
            ],
          ),
        ),
      ),
    );
  }
}

Widget paymentServices(BuildContext,heading,IconData icon,upperHeading,shortContent,Widget route){
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height:5,),
        Text("${heading}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18),),
        SizedBox(height:10,),
        InkWell(
          onTap: (){
            Navigator.push(BuildContext, MaterialPageRoute(builder: (context) => route,));
          }

          ,
          child: ListTile(
            minVerticalPadding:5,
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.grey,width:2)),
          leading:Icon(icon,size:40,color: Colors.black,),

            trailing: Icon(Icons.arrow_right,size:50,),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5,),
                Text("${upperHeading}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                SizedBox(height:3,),
                Text("${shortContent}",style: TextStyle(fontSize:15,color: Colors.grey),textAlign: TextAlign.center),
                SizedBox(height: 5,),
              ],
            ),
          ),
        ),

      ],
    ),
  );
}