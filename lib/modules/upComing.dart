import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rickshaw2/modules/PaymentManagement/paymentMng.dart';


class UpcomingPayments extends StatefulWidget {
  const UpcomingPayments({super.key});

  @override
  State<UpcomingPayments> createState() => _UpcomingPaymentsState();
}

class _UpcomingPaymentsState extends State<UpcomingPayments> {
  List<DocumentSnapshot> upcomingPayments = [];
  String? currentMonth;
    bool isloading = false;
  Future<String> fetchCurrentUserName()async{
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? currentUserAuthInfo = await auth.currentUser;
    final String? currentUserUid = await currentUserAuthInfo?.uid.toString();


    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserUid)
        .get();
// ========================

    if (documentSnapshot.exists) {
      // Retrieve the "name" field
      String? userName = await documentSnapshot.get("Name");
      return userName!;
    } else {
      // Document does not exist
      print('Document with ID  does not exist.');
      return "no data";
    }
  }

  Future<void>getUpcomingPayments()async{
    setState(() {
      isloading = true;
    });
    String currentUserName =await fetchCurrentUserName();
    final db = await FirebaseFirestore.instance.collection("Payments").where("DriverName",isEqualTo: "${currentUserName}");
  QuerySnapshot snapshot  = await db.get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        upcomingPayments = snapshot.docs;
        currentMonth = getCurrentMonth();
        print(upcomingPayments);
      });

    } else {
      print('No upcoming payments found for the current user.');
    }
    setState(() {
      isloading = false;
    });
  }


  String getCurrentMonth() {
    var now = DateTime.now();
    var formatter = DateFormat('MMMM');
    return formatter.format(now);


  }
  String getCurrentYear() {
    DateTime now = DateTime.now();
    return now.year.toString();
  }
  String year = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingPayments();
    setState(() {
      year = getCurrentYear();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Container(
                  height:50,
                  child: Text("Upcoming Payments",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20),)),

              SizedBox(height:10,),

              Container(
                height: 600,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if(isloading==true)  Center(child: CircularProgressIndicator()) ,
                      if(isloading==false)
                      Container(
                        height:450,
                        child:

                            upcomingPayments.isEmpty ?
                            Center(child: Text("No Customers",style: TextStyle(
                              color: Colors.red,fontSize:18,
                            ),))
                                :
                        GridView.builder(shrinkWrap: true,itemCount: upcomingPayments.length,gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 10,childAspectRatio:1.5,crossAxisCount:2), itemBuilder: (context, index) {
                          return Card(
                            elevation:10,

                            color: Colors.white70,

                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${upcomingPayments[index]["Customer Name"]}",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color: Colors.black),),
                                    Text("${upcomingPayments[index]["Payment"]["${year}"]["${currentMonth.toString()}"]["Amount"]}",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),

                                    Text("Status:- ${upcomingPayments[index]["Payment"]["${year}"]["${currentMonth.toString()}"]["Status"]}",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },),
                      ),
                      SizedBox(height:20,),
                      ElevatedButton(style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white),backgroundColor: MaterialStatePropertyAll(Colors.black)),onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context) => PaymentMng(),));
                      }, child: Text("Manage Payments"))

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
