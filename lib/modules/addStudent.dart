// import 'dart:js_util';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rickshaw2/modules/PaymentList.dart';
import 'package:rickshaw2/modules/upComing.dart';
import 'package:rickshaw2/pages/mainScreen.dart';


class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> with AutomaticKeepAliveClientMixin{
// with AutomaticKeepAliveClientMixin<AddStudent>;


//creating the instance of the clouddb

final FirebaseFirestore db=FirebaseFirestore.instance;



String currentUserName="";
String currentMonth = "";
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
Future<void> currentUserNameAssigned()async{
  String userName = await fetchCurrentUserName();
  setState(() {
    currentUserName = userName;
  });
}
  void clear(){
    name.clear();
    MiddleName.clear();
    SurName.clear();
    ParentsMobileNum.clear();
    CustomerAge.clear();
    Address.clear();
    PickUp.clear();
    Drop.clear();
  }
  final FormKey = GlobalKey<FormState>();
  TextEditingController doj = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController MiddleName = new TextEditingController();
  TextEditingController SurName = new TextEditingController();
  TextEditingController ParentsMobileNum = new TextEditingController();
  TextEditingController CustomerAge = new TextEditingController();
  TextEditingController Address = new TextEditingController();
  TextEditingController PickUp = new TextEditingController();
  TextEditingController Drop = new TextEditingController();
  TextEditingController Fare = new TextEditingController();
 String name1 = "";

  RegExp nameRegExp = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
  RegExp mobileRegExp = RegExp(r'^[0-9]{10}$');
  RegExp addressRegExp = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');




  RegExp ageRegExp = RegExp(r'^(0?[1-9]|[1-9][0-9])$');
RegExp fareRegExp = RegExp(r'^\d+(\.\d{1,2})?$');


// =============vaiables===============

//initially all the value of the of the payement values will be null and further they will be upadted

  String getCurrentMonth() {
    var now = DateTime.now();
    var formatter = DateFormat('MMMM');
    return formatter.format(now);

  }

  String getCurrentDate(){
    var now = DateTime.now();
    var formatter = DateFormat('dd-MMMM-yyyy');
    return formatter.format(now);
  }

Future <void> addData (name,mobileNum,address,destination,fare) async {

  CollectionReference customers = FirebaseFirestore.instance.collection("Customers");
  String finalName = await fetchCurrentUserName();
  String date = getCurrentDate();
  String Monthregistered = getCurrentMonth();
  setState(() {
    currentUserName=finalName;
    currentMonth=Monthregistered;
  });
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final User? currentUserAuthInfo = auth.currentUser;
//   final String? currentUserUid = currentUserAuthInfo?.uid.toString();
//
//
//   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//       .collection('Users')
//       .doc(currentUserUid)
//       .get();
// // ========================
//
//   if (documentSnapshot.exists) {
//     // Retrieve the "name" field
//     String? fetchedName = documentSnapshot.get('Name');
//     setState(() {
//       currentUserName = fetchedName;
//     });
//
//   } else {
//     // Document does not exist
//     print('Document with ID  does not exist.');
//     return null;
//   }

  // =====================
  try {
    final addDataMap = <String,dynamic>{
      "Driver Name":finalName,
      "Customer Name":name,
      "Mobile":mobileNum,
      "Address":address,
      "Destination":destination,
      "Registered Date":date,
      "Registered Months":{
        "${Monthregistered}":"Yes",

      },
      "Fare":fare,
    };
    print(addDataMap);
    await customers.add(addDataMap);
  }catch(e){
    print(e);
  }

}
Future<void> addPaymentData(month,name,mobileNum,fare)async{
  CollectionReference payment = FirebaseFirestore.instance.collection("Payments");
  String finalName = await fetchCurrentUserName();
  String date = getCurrentDate();
  String Monthregistered = getCurrentMonth();
  String currentYear = getCurrentYear();
   try{
     final paymentInfoMap = <String,dynamic>{
       "DriverName":finalName,
       "Customer Name":name,
       "Mobile":mobileNum,
       "Registration Date":date,
       "Re-registration Date":"",
       "Payment":{
         "${currentYear}":{
          "${currentMonth}":{
            "Amount":fare,
            "Status":"Pending",
            "Partially Paid Amount":0,
            "Partially Paid Amount Date":"Not Paid",
            "Remaining Amount":fare,
            "Total Paid Date":"Not Paid",
          }
         },
       },


     };
     print(paymentInfoMap);
     await payment.add(paymentInfoMap);
   }catch(e){
     print(e);
   }
}


// =====count customer and update====
  Future<int> calculateCustomerCountForDriverAndMonth(String driverName, String month) async {
    print("entered for caluclating customers");
    CollectionReference customers = FirebaseFirestore.instance.collection('Customers');

    try {
      QuerySnapshot querySnapshot = await customers
          .where('Driver Name', isEqualTo: driverName)
          .where('Registered Months.${month}', isEqualTo: 'Yes')
          .get();

      return querySnapshot.size+1;
    } catch (e) {
      print("Error calculating customer count: $e");
      return 0; // Return a default value or handle the error accordingly
    }
  }

  Future<void> assignCountForMonth(drivername,month)async{
    int count = await calculateCustomerCountForDriverAndMonth(drivername, month);
    print("count assigneddddddddddd");
    CollectionReference reff = FirebaseFirestore.instance.collection("Graphs");
    final ref = await FirebaseFirestore.instance.collection("Graphs").where("Driver Name",isEqualTo: "${drivername}");
    QuerySnapshot snapshot = await ref.get();
   try {
      if (snapshot.docs.isNotEmpty) {
        String documentId = snapshot.docs.first.id;
        await reff.doc(documentId).update({
          "Customer Count": {
            "${month}": count,
          }
        });
      }
    }catch(e){
     print("error updating the count.........${e}");
   }
  }
// ============= to fetch the name and other stuff==============

// =================================================================
  String currentYear = "0";
  String getCurrentYear() {
    DateTime now = DateTime.now();
    return now.year.toString();
  }
  Future<double> calculateTotalAmountForDriverAndMonth(String driverName, String month) async {
    print("entered main function to calucate");
    // Reference to the "Payment" collection in Firestore
    CollectionReference payments = FirebaseFirestore.instance.collection('Payments');
    String year = getCurrentYear();

    try {
      // Query the Firestore collection for the specified conditions
      QuerySnapshot querySnapshot = await payments
          .where('DriverName', isEqualTo: driverName)
          .where('Payment.${year}.${month}.Amount', isGreaterThan: 0) // Assuming amount is a positive number
          .get();

      // Calculate the total amount from the query results
      double totalAmount = 0;
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Assuming there is a field called 'amount' in your Firestore documents
        totalAmount += document['Payment']["${year}"]["${month}"]['Amount'] ?? 0;
      }

      return totalAmount;
    } catch (e) {
      // Handle errors (e.g., Firestore query error)
      print("Error calculating total amount: $e");
      return 0.0; // Return a default value or handle the error accordingly
    }
  }
  double monthlyIncome=0;

  Future<void> assignMonthly(driverName,month)async{
    print("procedding to calucate the month");
    double calculateMonthlyIncome = await calculateTotalAmountForDriverAndMonth(driverName, month);
    print("month calculted and assigned to var");
    print("${calculateMonthlyIncome}");
    setState(() {
      monthlyIncome = calculateMonthlyIncome;
    });
  }

  // ==================

Future<void>updateMonthlyAndYealyGraph(driverName)async{
    print("entered function to update the monthly graph");
  CollectionReference reff = FirebaseFirestore.instance.collection("Graphs");
  final ref = await FirebaseFirestore.instance.collection("Graphs").where("Driver Name",isEqualTo: "${driverName}");
  String currentYear = getCurrentYear();
  String getMonth = getCurrentMonth();
  assignMonthly(driverName, getMonth);
  print("state updated for monthly income");
  QuerySnapshot snapshot = await ref.get();
  try {
    if (snapshot.docs.isNotEmpty) {
      String documentId = snapshot.docs.first.id;
      await reff.doc(documentId).update({
        "Monthly Income": {
          "${currentYear}":{
            "${getMonth}":monthlyIncome,
          },
        }
      });
    }
  }catch(e){
    print("error updating the count.........${e}");
  }



}


  Future<double> calculateTotalAmountForDriverAndYear(String driverName, String year) async {
    print("entered main function to calculate");
    // Reference to the "Payment" collection in Firestore
    CollectionReference payments = FirebaseFirestore.instance.collection('Payments');

    try {
      // Query the Firestore collection for the specified conditions
      QuerySnapshot querySnapshot = await payments
          .where('DriverName', isEqualTo: driverName)
          .where('Payment.${year}', isNotEqualTo: null) // Check if the year exists
          .get();

      // Calculate the total amount from the query results
      double totalAmount = calculateTotalAmountFromSnapshot(querySnapshot);
      print("returned total amount");
      return totalAmount;

    } catch (e) {
      // Handle errors (e.g., Firestore query error)
      print("Error calculating total amount: $e");
      return 0.0; // Return a default value or handle the error accordingly
    }
  }

  double calculateTotalAmountFromSnapshot(QuerySnapshot querySnapshot) {
    double totalAmount = 0;
    String year = getCurrentYear();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      // Assuming there is a field called 'amount' in your Firestore documents
      Map<String, dynamic>? yearData = document['Payment'][year];
      if (yearData != null) {
        // Loop through each month and add the amount
        yearData.forEach((month, monthData) {
          totalAmount += monthData['Amount'] ?? 0;
        });
      }
    }
    return totalAmount;

  }

  Future<void> assignYearly()async{
    print("assigned yearly started");
    String year = getCurrentYear();
    print("inside currebt user name is ${currentUserName}");
    double yearAmountt = await calculateTotalAmountForDriverAndYear(currentUserName,year);
    setState(() {
      yearlyAmount = yearAmountt;
    });
    print("entered function to update the graph of year");
    CollectionReference reff = FirebaseFirestore.instance.collection("Graphs");
    final ref = await FirebaseFirestore.instance.collection("Graphs").where("Driver Name",isEqualTo: "${currentUserName}");
    String currentYear = getCurrentYear();
    String getMonth = getCurrentMonth();
    QuerySnapshot snapshot = await ref.get();
    try {
      if (snapshot.docs.isNotEmpty) {
        String documentId = snapshot.docs.first.id;
        await reff.doc(documentId).update({
          "Yearly Income": {
            "${currentYear}":yearlyAmount,
          }
        });
      }
    }catch(e){
      print("error updating the count.........${e}");
    }
  }

double yearlyAmount = 0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();


    setState(() {
      currentYear = getCurrentYear();
      currentMonth = getCurrentMonth();


    });
    currentUserNameAssigned();
    print(currentUserName);
    print("Enterging below");

    print("assigned countttttt");


    // print(currentMonth);

  }
  @override
  Widget build(BuildContext context) {
    String currentMonth = getCurrentMonth();
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),
          Text("Add Customer",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20),),
          SizedBox(height: 20,),
          Text("Please fill the below details",style: TextStyle(color: Colors.green),),
          SizedBox(height: 10,),
          Form(key: FormKey,

              child:Column(children: [
            textField(setState,nameRegExp,name,TextInputType.text,Text("Enter Name"),"Name must contain least 2 words"),
            // textField(setState,nameRegExp,MiddleName  ,TextInputType.text,Text("Enter Middle Name"),"Name must contain least 2 words"),
            // textField(setState,nameRegExp,SurName,TextInputType.text,Text("Enter Surname"),"Name must contain least 2 words"),
            textField(setState,mobileRegExp,ParentsMobileNum,TextInputType.phone,Text("Enter Mobile Number"),"Provide without +91"),
            // textField(setState,ageRegExp,CustomerAge,TextInputType.number,Text("Enter Age"),"Enter the Age"),
            textField(setState,addressRegExp,Address,TextInputType.text,Text("Enter Source Address"),"Enter PickupPoint"),
            textField(setState,addressRegExp,Drop ,TextInputType.text,Text("Destination"),"Enter the Destination"),
                textField(setState, fareRegExp, Fare, TextInputType.number, Text("Enter Fare AMount"), "Enter the Fare Amount"),
                ElevatedButton(style:ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.all(15)),foregroundColor: MaterialStatePropertyAll(Colors.white),backgroundColor:MaterialStatePropertyAll(Colors.black)),onPressed: (){
      if(FormKey.currentState!.validate()){
      print("Data Is validddddddddddddddddddddddddddddd");
      addData(name.text, ParentsMobileNum.text, Address.text, Drop.text,int.parse(Fare.text));
      addPaymentData(currentMonth, name.text,ParentsMobileNum.text,int.parse(Fare.text));
      print("Payment data added");

      print("entering count function");
      assignCountForMonth(currentUserName,currentMonth);
      print("entering to update month amouont graph");
      print("${currentUserName} is before entering the update monthly graph");
      updateMonthlyAndYealyGraph(currentUserName);
      print("month updated");
      assignYearly();
      print("function excuted to add year in graph");
      print("assignYearlyexecuted");
      showDia(context);
      clear();

      }
                }, child: Text("Add Customer")),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_rounded),
                    SizedBox(width:15,),
                    Icon(Icons.person),
                    SizedBox(width:15,),
                    Container(
                      width: 90,
                      height:90,
                      child: Image.asset("assets/images/icon.jpg"),
                    ),
                    SizedBox(width:15,),
                    Icon(Icons.security_sharp),
                    SizedBox(width:15,),
                    Icon(Icons.data_exploration),
                  ],
                ),


          ],))




        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


Widget textField(Function setStateFunc,RegExp regExp,TextEditingController c,TextInputType inputType ,Text label,String hintText){
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 250,
          child:TextFormField(
            validator: (value) {
              if(value==null||value.isEmpty){
                return "Please enter ${label.data}";
              }if(!regExp.hasMatch(value)){
                return "Please enter valid ${label.data}";
              }
            },
            onChanged: (value){
              setStateFunc((){
                 c.text = value;
              });
            },
            decoration: InputDecoration(label:label,hintText:hintText,border: OutlineInputBorder(borderSide: BorderSide(width: 2,color:Colors.grey))),
            controller: c,
            keyboardType:inputType,


          ),
          ),
      ),

    ],
  );

}

Future showDia(BuildContext context){
  return showDialog(context: context, builder:(context) {
    return AlertDialog(
      backgroundColor:Colors.white,
    elevation:100,
      // icon: Icon(Icons.check),
      shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Added",style: TextStyle(color: Colors.black),),SizedBox(width: 20,),Icon(Icons.check,color: Colors.green,fill: 0.9,)],),
      content: Text("Customer Added Successfully!!\n\nClick View List to see all the Customers.",style: TextStyle(color: Colors.black,fontSize:18),textAlign:TextAlign.center,),
      actions: [
        ElevatedButton(style:ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white),padding: MaterialStatePropertyAll(EdgeInsets.all(15)),backgroundColor:MaterialStatePropertyAll(Colors.black)),onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => UpcomingPayments(),));
        }, child: Text("View List")),
        ElevatedButton(style:ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white),padding: MaterialStatePropertyAll(EdgeInsets.all(15)),backgroundColor:MaterialStatePropertyAll(Colors.black)),onPressed: () {
          Navigator.of(context).pop();
        }, child:Text("Add More")),
      ],
    );
  },);
}

