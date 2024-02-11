import 'package:flutter/material.dart';

import '../modules/PaymentManagement/graph.dart';
import '../modules/visualizations.dart';


class ReportAnalytics extends StatefulWidget {
  const ReportAnalytics({super.key});

  @override
  State<ReportAnalytics> createState() => _ReportAnalyticsState();
}

class _ReportAnalyticsState extends State<ReportAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:Stack(
            children: [
              Image.asset(fit: BoxFit.cover,"assets/images/reportAna.jpg"),
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
                          Text("Report and Analytics",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                          SizedBox(height:20,),
                          ListTile(
                            leading: Icon(Icons.graphic_eq_sharp,color: Colors.black),
                            title: Text("Graphs to Visulaize the total Earning ",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          ListTile(
                            leading: Icon(Icons.payment_outlined,color: Colors.black),
                            title: Text("Income and Expense Reports over Time",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          ListTile(
                            leading: Icon(Icons.auto_graph,color: Colors.black),
                            title: Text("Intelligent Suggestions",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),

                          Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: ElevatedButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage(),));
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
