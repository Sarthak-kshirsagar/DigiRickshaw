import 'package:flutter/material.dart';
import 'package:rickshaw2/infoScreen/reportMngInfo.dart';
import 'package:rickshaw2/infoScreen/studentMngInfo.dart';
import 'package:rickshaw2/modules/Billing%20and%20Invoice/receiptPage.dart';
import 'package:rickshaw2/modules/PaymentManagement/paymentMng.dart';
import 'package:rickshaw2/modules/addStudent.dart';
import 'package:rickshaw2/pages/DashboardPage.dart';

class ViewCustomerDetailsInvoice extends StatefulWidget {
  String customerName="";
  String driverName = "";
  String monthPaid ;
  num amount;
  num remainingAmount;
  String status="";

   ViewCustomerDetailsInvoice({required this.status,required this.remainingAmount,required this.customerName,required this.driverName,required this.monthPaid,
  required this.amount});


  @override
  State<ViewCustomerDetailsInvoice> createState() => _ViewCustomerDetailsInvoiceState();
}

class _ViewCustomerDetailsInvoiceState extends State<ViewCustomerDetailsInvoice> {
  String sourceAddress = "Vaijapur";
  String destinationAddress = "Pune";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text("Customer Details",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),

              Container(
                height:250,
                width:500,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Image(image: AssetImage("assets/images/autoStu.jpg"),fit:BoxFit.fill),

              ),
          SizedBox(height: 15,),
          Row(
            children: [
              Text("${widget.customerName} ride \nwith ${widget.driverName}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
              Container(child: Icon(Icons.person,size:50,color: Colors.grey),),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
              SizedBox(height: 10,),
              Container(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date:-${widget.monthPaid}",style: TextStyle(fontSize: 15)),
                    Container(child: Column(
                      children: [
                        Text("Route",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),


                      ],
                    )),



                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text("Amount Paid :- ${widget.amount}",style: TextStyle(fontSize: 15)),
                  Text("${sourceAddress} to ${destinationAddress}",style: TextStyle(fontSize: 15)),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                width:170,
                child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey[200])),onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiptPage(status: widget.status,customerName: widget.customerName,driverName: widget.driverName,doubleAmount: widget.amount,date: widget.monthPaid,remainingAmount: widget.remainingAmount),));
                }, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(Icons.receipt_long,color: Colors.black,size: 30,),
                    SizedBox(width: 10,),
                    Text("Receipt",style: TextStyle(color: Colors.black)),

                  ],),
                )),
              ),
              SizedBox(height: 14,),

              Text("Other",style: TextStyle(fontSize:20)),
              SizedBox(height:15,),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentMng(),));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(

                      border: Border(bottom: BorderSide(color: Colors.grey,width:1)),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Icon(Icons.payment_rounded),
                          ),

                          Container(
                            child: Text("Payment Management",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                          ),

                          Container(
                            child: Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
              ),
SizedBox(height: 20,),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentMngInfo(),));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height:50,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey,width:1)),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Icon(Icons.payment_rounded),
                            ),

                            Container(
                              child: Text("Customer Management",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                            ),

                            Container(
                              child: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ),

              SizedBox(height: 20,),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReportAnalytics(),));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey,width:1)),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Icon(Icons.payment_rounded),
                            ),

                            Container(
                              child: Text("View Dashboard",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                            ),

                            InkWell(
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>ReportAnalytics(),));
                              },
                              child: Container(
                                child: Icon(Icons.arrow_forward),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ),

            ],
          ),
        )),
      ),
    );
  }
}
