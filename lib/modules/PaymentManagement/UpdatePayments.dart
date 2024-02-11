import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateDetails extends StatefulWidget {
  const UpdateDetails({super.key});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
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
              SizedBox(height:25,),
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

  String getCurrentYear() {
    DateTime now = DateTime.now();
    return now.year.toString();
  }
  Future<void>getPaymentDetails(newValue,status)async{
    String currentUserName =await fetchCurrentUserName();
    String? month = getCurrentMonth();
    String year = getCurrentYear();
    final db = await FirebaseFirestore.instance.collection("Payments").where("DriverName",isEqualTo: "${currentUserName}").where("Payment.${year}.${newValue}.Status",isEqualTo:"${status}");
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
  String getCurrentDate(){
    var now = DateTime.now();
    var formatter = DateFormat('dd-MMMM-yyyy');
    return formatter.format(now);
  }

  void updatePaymentsInfo(String customerName,int totalAmount,int PartialAmount,int RemainingAmount,int amountPaid)async{
    //fetching the currentUser name
    String driverName = await fetchCurrentUserName();

    //ref fot the document
    CollectionReference ref = FirebaseFirestore.instance.collection("Payments");
    String year = getCurrentYear();

    //query to fetch the required document acoording to the current user and customer
    final db = await FirebaseFirestore.instance.collection("Payments").where("DriverName",isEqualTo: "${driverName}").where("Customer Name",isEqualTo: "${customerName}");
    QuerySnapshot snapshot = await db.get();



    if (snapshot.docs.isNotEmpty) {
      // Assuming there is only one matching document; update the specified attribute
      String documentId = snapshot.docs.first.id;
      String getcurrentDate = getCurrentDate();
      //logic to update the db according to the amount paid

      if(PartialAmount>0){
        int diff = PartialAmount - amountPaid;
        if(diff==0){
          await ref.doc(documentId).update({
            "Payment.${year}.${selectedMonth}.Partially Paid Amount":0,
            "Payment.${year}.${selectedMonth}.Remaining Amount":0,
            "Payment.${year}.${selectedMonth}.Status":"Paid",
            "Payment.${year}.${selectedMonth}.Total Paid Date":getcurrentDate,

          });
        }
      }

      if(totalAmount==amountPaid){
        await ref.doc(documentId).update({
          "Payment.${year}.${selectedMonth}.Partially Paid Amount":0,
          "Payment.${year}.${selectedMonth}.Remaining Amount":0,
          "Payment.${year}.${selectedMonth}.Status":"Paid",
          "Payment.${year}.${selectedMonth}.Total Paid Date":getcurrentDate,

        });
      }else {
        int diff = totalAmount-amountPaid;
        await ref.doc(documentId).update({
          "Payment.${year}.${selectedMonth}.Partially Paid Amount": amountPaid,
          "Payment.${year}.${selectedMonth}.Remaining Amount":diff,

        });
      }

      print('Attribute updated successfully!');
    } else {
      print('No matching document found for the specified driver and customer names.');
    }
  }


  Future showDia(BuildContext context,String name,int amount,partialAmount,remainingAmount){
    return showDialog(context: context, builder:(context) {
      TextEditingController amountPaid = new TextEditingController();
      return SingleChildScrollView(
        child: AlertDialog(
          backgroundColor:Colors.white,
          elevation:100,
          // icon: Icon(Icons.check),
          shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("${name}",style: TextStyle(color: Colors.black),),SizedBox(width: 20,)],),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                Row(children: [Text("Month : - "),SizedBox(width:10,),Text("${selectedMonth}")],),
                SizedBox(height: 10,),
                Row(children:
                [
                  Text("Amount to be Paid : - ${amount}"),
                  SizedBox(width:10,),
                ],),
                SizedBox(height: 10,),
                Row(children: [Text("Partially Paid Amount : - "),SizedBox(width:10,),Text("${partialAmount}")],),
                SizedBox(height: 10,),
                Row(children: [Text("Remaining Amount : - "),SizedBox(width:10,),Text("${remainingAmount}")],),

                SizedBox(height: 10,),
                TextFormField(
                  controller: amountPaid,
                  decoration: InputDecoration(

                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 2)),
                    label: Text("Enter Amount"),

                  ),

                ),
                // SizedBox(height: 10,),
                // Row(children: [Text("Remaining Amount : - "),SizedBox(width:10,),Text("200")],),
              ],
            ),
          ),
          actions: [
            ElevatedButton(style:ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white),padding: MaterialStatePropertyAll(EdgeInsets.all(15)),backgroundColor:MaterialStatePropertyAll(Colors.black)),onPressed: (){
              Navigator.pop(context, MaterialPageRoute(builder: (context) =>UpdateDetails(),));
            }, child: Text("Back")),
            ElevatedButton(style:ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white),padding: MaterialStatePropertyAll(EdgeInsets.all(15)),backgroundColor:MaterialStatePropertyAll(Colors.green)),onPressed: () {
              updatePaymentsInfo(name,amount,partialAmount,remainingAmount,int.parse(amountPaid.text));
              Navigator.of(context).pop();
            }, child:Text("Update")),
          ],
        ),
      );
    },);
  }


String year  = "";
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
            // ListTile(
            //
            //   title: Text("Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
            //   trailing: Text("Amount",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),
            //
            //   ),
            // ),

            SingleChildScrollView(
                child:
                Container(
                  height:400,
                  child: ListView.builder(itemCount: viewDeatils.length,itemBuilder:(context, index) {



                    return Container(
                      height:100,
                      width: 270,

                      child: Column(
                        children: [
  // SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(

                              ),
                            width:250,
                            height:50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${viewDeatils[index]["Customer Name"]}",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                                // if(selectedStatus=="Pending")
                                // Text("${viewDeatils[index]["Payment"]["${selectedMonth}"]["Remaining Amount"]}"),
                        if(selectedStatus=="Paid")
                          Text(style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),"${viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Amount"]}"),
                        if(selectedStatus=="Pending")
                                ElevatedButton(style:ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white),backgroundColor: MaterialStatePropertyAll(Colors.black)),onPressed: (){
                                  showDia(context,viewDeatils[index]["Customer Name"],viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Amount"],viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Partially Paid Amount"],viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Remaining Amount"]);
                                }, child: Text("Update")),
                              ],
                            ),

                          ),
                    Divider(height:10),
                        ],
                      ),
                    );

                  }


                  ),
                )
            )
          ),

// ==================================================================================
          // SingleChildScrollView(
          //     child:
          //     Container(
          //       height:300,
          //       child: ListView.builder(itemCount: viewDeatils.length,itemBuilder:(context, index) {
          //
          //
          //
          //         return Container(
          //           height: 100,
          //
          //           child: Column(
          //             children: [
          //               Container(
          //
          //           width:250,
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: [
          //                     Text("${viewDeatils[index]["Name"]}"),
          //                     Text("${viewDeatils[index]["Amount"]}"),
          //                     ElevatedButton(onPressed: (){}, child: Text("Update")),
          //                   ],
          //                 ),
          //                 decoration: BoxDecoration(
          //                   boxShadow: [
          //                     BoxShadow(
          //                   color: Colors.grey,
          //                   blurRadius: 10,
          //                   spreadRadius: 1,
          //                   blurStyle: BlurStyle.outer,
          //
          //                     )
          //                   ]
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //
          //       }
          //
          //
          //       ),
          //     )
          // )

          // ===============================================================
        ],
      ),
    );
  }
}







// ======================================================================
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../../pages/mainScreen.dart';
//
//
// class UpdatePayments extends StatefulWidget {
//   const UpdatePayments({super.key});
//
//   @override
//   State<UpdatePayments> createState() => _UpdatePaymentsState();
// }
//
// class _UpdatePaymentsState extends State<UpdatePayments> {
//   String selectedMonth ="January";
//   String selectedStatus = 'Paid';
//   TextEditingController searchController = TextEditingController();
//   List<DocumentSnapshot> viewDeatils =[];
//
//   Future<String> fetchCurrentUserName()async{
//     final FirebaseAuth auth = await FirebaseAuth.instance;
//     final User? currentUserAuthInfo = await auth.currentUser;
//     final String? currentUserUid = await currentUserAuthInfo?.uid.toString();
//
//
//     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(currentUserUid)
//         .get();
// // ========================
//
//     if (documentSnapshot.exists) {
//       // Retrieve the "name" field
//       String? userName = await documentSnapshot.get("Name");
//       return userName!;
//     } else {
//       // Document does not exist
//       print('Document with ID  does not exist.');
//       return "no data";
//     }
//   }
//
//
//   Future<void>getPaymentDetails(newValue,status)async{
//     String currentUserName =await fetchCurrentUserName();
//     final db = await FirebaseFirestore.instance.collection("Payments").where("DriverName",isEqualTo: "${currentUserName}").where("Registered Month",isEqualTo: "${newValue}").where("Status",isEqualTo:"${status}");
//     QuerySnapshot snapshot  = await db.get();
//     if (snapshot.docs.isNotEmpty) {
//       setState(() {
//         viewDeatils = snapshot.docs;
//       });
//     } else {
//       setState(() {
//         viewDeatils.clear();
//       });
//       print('No upcoming payments found for the current user.month->${newValue}');
//       print("${currentUserName}");
//     }
//   }
//
//


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               SizedBox(height:50,),
//             Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//
//             children: [
//               DropdownButton<String>(
//                 value: selectedMonth,
//                 items: [
//                   'January',
//                   'February',
//                   'March',
//                   'April',
//                   'May',
//                   'June',
//                   'July',
//                   'August',
//                   'September',
//                   'October',
//                   'November',
//                   'December',
//                 ].map<DropdownMenuItem<String>>(
//                       (String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   },
//                 ).toList(),
//                 onChanged: (String? newValue) {
//
//                   setState(() {
//                     viewDeatils.clear();
//                     selectedMonth = newValue!;
//                     getPaymentDetails(selectedMonth.toString(),newValue.toString());
//                   });
//
//
//
//                 },
//               ),
//               SizedBox(width:30),
//
//               // Dropdown for selecting the status
//               DropdownButton<String>(
//                 value: selectedStatus,
//                 items: ['Paid', 'Pending'].map<DropdownMenuItem<String>>(
//                       (String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   },
//                 ).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     viewDeatils.clear();
//                     selectedStatus = newValue!;
//                     getPaymentDetails(selectedMonth.toString(),newValue.toString());
//                   });
//
//                 },
//               ),
//               // SizedBox(width: 20),
//
//             ],
//           ),
//           // Dropdown for selecting the month
//           SizedBox(height: 10,),
//           // Search bar
//           Container(
//             width: 250,
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                   hintText: 'Search Customers...',
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 2),borderRadius: BorderRadius.circular(10))
//               ),
//               onChanged: (value) {
//                 // Implement your search logic here
//                 // You can use the 'value' variable to get the text entered in the search bar
//                 print('Searching for: $value');
//               },
//             ),
//           ),
//           SizedBox(height: 10,),
//                InkWell(
//                  onTap: (){},
//                  child: Container(
//                   decoration: BoxDecoration(boxShadow:[
//                     BoxShadow(color: Colors.grey,blurStyle: BlurStyle.outer,blurRadius:12,spreadRadius: 1)
//                   ],),
//
//
//                   height:170,
//                   width: 150,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         Text("Sarthak",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
//                         SizedBox(height: 10,),
//                         Text("Paid",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
//                         SizedBox(height: 10,),
//                         Text("Amount",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
//                         SizedBox(height: 10,),
//                         ElevatedButton(onPressed: (){
//                           showDia(context);
//                         } , child:Text("Update"),style: ElevatedButton.styleFrom(backgroundColor: Colors.black,)),
//                       ]
//                     ),
//                   ),
//               ),
//                )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
