import 'package:flutter/material.dart';
import 'package:rickshaw2/services/StudentMng.dart';

class StudentMngInfo extends StatefulWidget {
  const StudentMngInfo({super.key});

  @override
  State<StudentMngInfo> createState() => _StudentMngInfoState();
}



class _StudentMngInfoState extends State<StudentMngInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Stack(
          children: [
            Image.asset(fit: BoxFit.cover,"assets/images/autoStu.jpg"),
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
                        Text("Customer Management",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                        SizedBox(height:20,),
                        ListTile(
                          leading: Icon(Icons.add_box_rounded,color: Colors.black),
                          title: Text("Add the new Customers easily",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        ListTile(
                          leading: Icon(Icons.payment_outlined,color: Colors.black),
                          title: Text("Manage their Payments",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        ListTile(
                          leading: Icon(Icons.notification_add,color: Colors.black),
                          title: Text("Send Notifications directly to their parents",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          child: ElevatedButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>StudentManagement(),));
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

