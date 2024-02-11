import 'package:flutter/material.dart';
import 'package:rickshaw2/modules/PaymentManagement/paymentMng.dart';
class PaymentMngInfo extends StatefulWidget {
  const PaymentMngInfo({super.key});

  @override
  State<PaymentMngInfo> createState() => _PaymentMngInfoState();
}

class _PaymentMngInfoState extends State<PaymentMngInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:Stack(
            children: [
              Image.asset(fit: BoxFit.cover,"assets/images/autoFian.jpg"),
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
                          Text("Payment Management",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                          SizedBox(height:20,),
                          ListTile(
                            leading: Icon(Icons.calendar_month,color: Colors.black),
                            title: Text("Set Monthly fare for each Customer",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          ListTile(
                            leading: Icon(Icons.update,color: Colors.black),
                            title: Text("Update Received and Pending Payments",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          ListTile(
                            leading: Icon(Icons.notifications,color: Colors.black),
                            title: Text("Send Notifications to Parents",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: ElevatedButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>PaymentMng(),));
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
