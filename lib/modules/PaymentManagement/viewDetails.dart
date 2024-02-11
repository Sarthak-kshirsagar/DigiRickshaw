import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewPaymentDetails extends StatefulWidget {
  const ViewPaymentDetails({super.key});

  @override
  State<ViewPaymentDetails> createState() => _ViewPaymentDetailsState();
}

class _ViewPaymentDetailsState extends State<ViewPaymentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Center(child: Text("Payment Management",style: TextStyle( color: Colors.black,fontWeight: FontWeight.bold,fontSize:25),)),
              SizedBox(height: 10,),
              Text("Update,Inform and more...",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(alignment:Alignment.topLeft ,child: Text("View Details",style: TextStyle(fontWeight: FontWeight.normal,fontSize:18),)),
              ),
              PaymentDetailsInfo(),
            ],
          ),
        ),
      ),
    );
  }
}


// ===================

class PaymentDetailsInfo extends StatefulWidget {
  @override
  _PaymentDetailsInfoState createState() => _PaymentDetailsInfoState();
}

class _PaymentDetailsInfoState extends State<PaymentDetailsInfo> {
  String getCurrentMonth() {
    var now = DateTime.now();
    var formatter = DateFormat('MMMM');
    String result = formatter.format(now);
    return result;
    setState(() {
      selectedMonth = result;
    });

  }

  String selectedMonth ="January";
  String selectedStatus = 'Paid';
  String year="";
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> viewDeatils =[];

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


  Future<void>getPaymentDetails(newValue,status)async{
    String currentUserName =await fetchCurrentUserName();
    final db = await FirebaseFirestore.instance.collection("Payments").where("DriverName",isEqualTo: "${currentUserName}").where("Registered Month",isEqualTo: "${newValue}").where("Status",isEqualTo:"${status}");
    QuerySnapshot snapshot  = await db.get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        viewDeatils = snapshot.docs;
      });
    } else {
      setState(() {
        viewDeatils.clear();
      });
      print('No upcoming payments found for the current user.month->${newValue}');
      print("${currentUserName}");
    }
  }
  String getCurrentYear() {
    DateTime now = DateTime.now();
    return now.year.toString();
  }
  @override void initState() {
    // TODO: implement initState
    super.initState();
    // viewDeatils = [];
    getCurrentMonth();

    setState(() {
    year = getCurrentYear();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              DropdownButton<String>(
                value: selectedMonth,
                items: [
                  'January',
                  'February',
                  'March',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October',
                  'November',
                  'December',
                ].map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (String? newValue) {

                  setState(() {
                    viewDeatils.clear();
                    selectedMonth = newValue!;
                    getPaymentDetails(selectedMonth.toString(),newValue.toString());
                  });



                },
              ),
              SizedBox(width:30),

              // Dropdown for selecting the status
              DropdownButton<String>(
                value: selectedStatus,
                items: ['Paid', 'Pending'].map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                  viewDeatils.clear();
                    selectedStatus = newValue!;
                  getPaymentDetails(selectedMonth.toString(),newValue.toString());
                  });

                },
              ),
              // SizedBox(width: 20),

            ],
          ),
          // Dropdown for selecting the month
              SizedBox(height: 10,),
          // Search bar
          Container(
            width: 250,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Customers...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 2),borderRadius: BorderRadius.circular(10))
              ),
              onChanged: (value) {
                // Implement your search logic here
                // You can use the 'value' variable to get the text entered in the search bar
                print('Searching for: $value');
              },
            ),
          ),


      // ElevatedButton(onPressed: (){
      //
      //   print("=========calleddddd");
      //   print("${selectedStatus + " " + selectedMonth}");
      //   getPaymentDetails(selectedMonth,selectedStatus);
      // }, child: Text("Fetch")),

      SizedBox(height:20,),


          Container(
            width: 200,
            child:viewDeatils.isEmpty?Center(child: Text("No Data Found",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),))

                :
            ListTile(

              title: Text("Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
              trailing: Text("Amount",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),

              ),
            ),
          ),


          SingleChildScrollView(
            child:
            Container(
              height:300,
              child: ListView.builder(itemCount: viewDeatils.length,itemBuilder:(context, index) {



                  return Container(
                  height: 100,
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        child: SizedBox(

                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey)),
                            title: Text("${viewDeatils[index]["Customer Name"]}"),
                            trailing: Text("${viewDeatils[index]["Payment"]["${year}"]["December"]["Amount"]}"),
                          ),
                        ),
                      ),

                    ],
                  ),
                );

                }


              ),
            )
          )
        ],
      ),
    );
  }
}

