import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rickshaw2/modules/HelpSection/helpSec.dart';
import 'package:rickshaw2/modules/PaymentManagement/graph.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../infoScreen/billMngInfo.dart';
import '../infoScreen/docsMngInfo.dart';
import '../infoScreen/paymentMngInfo.dart';
import '../infoScreen/reportMngInfo.dart';
import '../infoScreen/studentMngInfo.dart';


class Main extends StatefulWidget {


  Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  List<DocumentSnapshot> studentData = [

  ];
  // String? currentUser
  int? count = 0;
  bool isLoading = false;
  Future<String> fetchCurrentUserName()async{
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final User? currentUserAuthInfo = await auth.currentUser;
    final String? currentUserUid = await currentUserAuthInfo?.uid.toString();
    print("Printing the current user id ${currentUserUid}");


    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserUid)
        .get();
// ========================

    if (documentSnapshot.exists) {
      // Retrieve the "name" field
      String? userName = await documentSnapshot.get("Name");
      print("got the name is name is ${userName}");
      setState(() {
        currentUserName = userName;
      });
      return userName!;
    } else {
      // Document does not exist
      print('Document with ID  does not exist.');
      return "no data";
    }
  }
  String getCurrentMonth() {
    var now = DateTime.now();
    var formatter = DateFormat('MMMM');
    return formatter.format(now);

  }
  String month="";
  String year="";
  String getCurrentYear() {
    DateTime now = DateTime.now();
    return now.year.toString();
  }
  Future<void>getUpcomingPayments()async{
    setState(() {
      isLoading=true;
    });
    String currentUserName =await fetchCurrentUserName();
    print("${currentUserName}");
    final db = FirebaseFirestore.instance.collection("Payments").where("DriverName",isEqualTo: "${currentUserName}").count().get().then((value) {
      setState(() {
        count = value.count;

      });
    },);
    setState(() {
      month = getCurrentMonth();
    });
    final db2 = FirebaseFirestore.instance.collection("Payments");

    // Query to get documents with pending status
    String currentYear = getCurrentYear();
    setState(() {
      year = currentYear;
    });
    final pendingQuery = db2.where("DriverName", isEqualTo: currentUserName)
        .where("Payment.${currentYear}.${month}.Status",isEqualTo: "Pending");
    QuerySnapshot pendingSnapshot = await pendingQuery.get();
    setState(() {
      studentData = pendingSnapshot.docs;
    });

    setState(() {
      isLoading=false;
    });

  }

  // final String currentUserName = "Sarthak";
  double monthlyIncome=0;
  String? _selectedMonth;
  final int registeredCustomers = 52;

  List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String? currentUserId;
  String? currentUserName;
  void getUser() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      currentUserId = user?.uid.toString();
    });

  }

  Future<String?> retrieveName(String documentId) async {
    try {

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentId)
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Retrieve the "name" field
        String? name = documentSnapshot.get('Name');
        setState(() {
          currentUserName=name;
        });
        return name;
      } else {
        // Document does not exist
        print('Document with ID $documentId does not exist.');
        return null;
      }
    } catch (e) {
      print('Error retrieving document: $e');
      return null;
    }
  }
  Future<void>updateMonthlyAndYealyGraph()async{
    print("entered function to update the monthly graph");
    CollectionReference reff = FirebaseFirestore.instance.collection("Graphs");
    String driverName = await fetchCurrentUserName();
    final ref = await FirebaseFirestore.instance.collection("Graphs").where("Driver Name",isEqualTo: "${driverName}");
    String currentYear = getCurrentYear();
    String getMonth = getCurrentMonth();
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
  Future<double> calculateTotalAmountForDriverAndMonth(String driverName, String monthh) async {
    // Reference to the "Payment" collection in Firestore
    print("entered to calucalte and username is ${driverName}");
    CollectionReference payments = FirebaseFirestore.instance.collection('Payments');
    String currentYear = getCurrentYear();

    try {
      // Query the Firestore collection for the specified conditions
      QuerySnapshot querySnapshot = await payments
          .where('DriverName', isEqualTo: driverName)
          .where('Payment.${currentYear}.${monthh}.Amount', isGreaterThan: 0) // Assuming amount is a positive number
          .get();

      // Calculate the total amount from the query results
      double totalAmount = 0;
      print("Entering for calucalationssssss");
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Assuming there is a field called 'amount' in your Firestore documents
        totalAmount += document['Payment']["${year}"]["${month}"]['Amount'] ?? 0;
      }
        print("Printing total amount + ${totalAmount}");
      return totalAmount;
    } catch (e) {
      // Handle errors (e.g., Firestore query error)
      print("Error calculating total amount: $e");
      return 0.0; // Return a default value or handle the error accordingly
    }
  }

  Future<void> assignMonthly()async{
    setState(() {
      isLoading = true;
    });
    String currentUserName = await fetchCurrentUserName();
    String currentMonth =  getCurrentMonth();
    print("assign monthly and the user name is ${currentUserName}");
    double calculateMonthlyIncome = await calculateTotalAmountForDriverAndMonth(currentUserName,currentMonth);
    setState(() {
      monthlyIncome = calculateMonthlyIncome;
      isLoading=false;
    });
    updateMonthlyAndYealyGraph();
  }

// ========yearly income calculations=============================

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
    String currentUser = await fetchCurrentUserName();
    double yearAmountt = await calculateTotalAmountForDriverAndYear(currentUser,year);
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
// ================================================================
  Future<double> calculateTotalRemainingAmountForDriver(String driverName,month) async {
    // Reference to the "Payment" collection in Firestore
    CollectionReference payments = FirebaseFirestore.instance.collection('Payments');
    String currentyear = getCurrentYear();
    try {
      // Query the Firestore collection for the specified conditions
      QuerySnapshot querySnapshot = await payments
          .where('DriverName', isEqualTo: driverName)
          .where('Payment.${currentyear}.${month}.Remaining Amount', isGreaterThan: 0) // Assuming amount is a positive number
          .get();

      // Calculate the total amount from the query results
      double totalAmount = 0;
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Assuming there is a field called 'amount' in your Firestore documents
        totalAmount += document['Payment'][year][month]['Remaining Amount'] ?? 0;
      }

      return totalAmount;
    } catch (e) {
      // Handle errors (e.g., Firestore query error)
      print("Error calculating total amount: $e");
      return 0.0; // Return a default value or handle the error accordingly
    }
  }
double remainingAmount = 0;
  Future<void> assignRemainingAmount()async{
    setState(() {
      isLoading=true;
    });
    String currentUserName = await fetchCurrentUserName();
    String currentMonth = getCurrentMonth();
   double _remainingAmount = await calculateTotalRemainingAmountForDriver("${currentUserName}", "${currentMonth}");

   setState(() {
     remainingAmount = _remainingAmount;
     isLoading = false;
   });
  }
  List<DocumentSnapshot>montlhyAmount=[];
  Future <void>FetchGraphMonthlyData() async{
    String driverName = await fetchCurrentUserName();
    print("Fetched current user name and name is ${driverName}");
    final ref = await FirebaseFirestore.instance.collection("Graphs").where("Driver Name",isEqualTo: "${driverName}");
    QuerySnapshot snapshot = await ref.get();
    print("snapshots got and the data is ${snapshot.docs}");
    String yr = getCurrentYear();
    if(snapshot.docs.isNotEmpty){
      setState(() {
        montlhyAmount = snapshot.docs;
        print("assignedd!!");
        year = yr;
      });

      print("bar chart executed");
      assignToCount();
      print("line chart executed");
      // assignToGraph();
      print("Year graph executed");
    }

  }
  num _septCount=0;
  num _octCount=0;
  num _novCount=0;
  //
  // double _decemberrCount=0;

  num dummy = 0;
  void assignToCount(){
    print("entered");
    if (montlhyAmount.isNotEmpty && montlhyAmount[0]["Monthly Income"] != null) {
      print("entered inside");
      // double JanCount = montlhyAmount[0]["Customer Count"]["January"] ?? 0;
      // print("assigned + ${JanCount}");
      // double febCount = montlhyAmount[0]["Customer Count"]["February"] ?? 0;
      // double MarCount = montlhyAmount[0]["Customer Count"]["March"] ?? 0;
      // double AprCount = montlhyAmount[0]["Customer Count"]["April"] ?? 0;
      // double MayCount = montlhyAmount[0]["Customer Count"]["May"] ?? 0;
      // double JuneCount = montlhyAmount[0]["Customer Count"]["June"] ?? 0;
      // double JulyCount = montlhyAmount[0]["Customer Count"]["July"] ?? 0;
      // double AugCount = montlhyAmount[0]["Customer Count"]["August"] ?? 0;
      num SeptCount = montlhyAmount[0]["Customer Count"]["September"] ?? 0;
      num OctCount = montlhyAmount[0]["Customer Count"]["October"] ?? 0;
      num NovCount = montlhyAmount[0]["Customer Count"]["November"] ?? 0;
      // print("hi ${NovCount}");
      num dec = montlhyAmount[0]["Customer Count"]["December"] ?? 0;
      // print("hii dec ${dec}");
      // print("dummy assigned");

      setState(() {
        // _janCount = JanCount;
        // _febCount = febCount;
        // _marCount = MarCount;
        // _aprCount = AprCount;
        // _mayCount = MayCount;
        // _aprCount = AprCount;
        // _junCount = JuneCount;
        // _augCount = AugCount;
        _septCount = SeptCount;
        _octCount = OctCount;
        _novCount = NovCount;
        // _decemberrCount = dec;
        dummy = dec;

        customersCountData = [
          // NumberOfCustomersChartData(
          //     numberOfCustomerPerMonth: "Jan", cutomerscount: _janCount),
          // NumberOfCustomersChartData(
          //     numberOfCustomerPerMonth: "feb", cutomerscount: _febCount),
          // NumberOfCustomersChartData(
          //     numberOfCustomerPerMonth: "Mar", cutomerscount: _marCount),
          // NumberOfCustomersChartData(
          //     numberOfCustomerPerMonth: "Apr", cutomerscount: _aprCount),
          // NumberOfCustomersChartData(
          //     numberOfCustomerPerMonth: "May", cutomerscount: _mayCount),
          // NumberOfCustomersChartData(
          //     numberOfCustomerPerMonth: "Jun", cutomerscount: _junCount),
          // NumberOfCustomersChartData(
          //     numberOfCustomerPerMonth: "Jul", cutomerscount: _julCount),
          // NumberOfCustomersChartData(
          //     numberOfCustomerPerMonth: "Aug", cutomerscount: _augCount),
          NumberOfCustomersChartData(
              numberOfCustomerPerMonth: "Sept", cutomerscount: _septCount),
          NumberOfCustomersChartData(
              numberOfCustomerPerMonth: "Oct", cutomerscount: _octCount),
          NumberOfCustomersChartData(
              numberOfCustomerPerMonth: "Nov", cutomerscount: _novCount),
          NumberOfCustomersChartData(
              numberOfCustomerPerMonth: "Dec", cutomerscount: dummy),
        ];
      });

    }else{
      print("erorrrrr");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    setState(() {
      year = getCurrentYear();
      month = getCurrentMonth();
    });
    print("got current year");
    retrieveName(currentUserId.toString());
    getUpcomingPayments();
    print("got payments");
    print(studentData);
    print("current user name is ${currentUserName}");
    assignMonthly();
    assignRemainingAmount();
    assignYearly();
    print("assigned monthky executed");
    FetchGraphMonthlyData();



  }
  Future <void> onRefresh() async{
    setState(() {
      year = getCurrentYear();
      month = getCurrentMonth();
    });
    print("got current year");
    await retrieveName(currentUserId.toString());
    await getUpcomingPayments();
    print("got payments");
    print(studentData);
    print("current user name is ${currentUserName}");
    await assignMonthly();
    await assignRemainingAmount();
    await assignYearly();
    print("assigned monthky executed");
    await FetchGraphMonthlyData();
  }


  Widget explore(BuildContext context,String path,String heading,String Content,Widget Route){
    return InkWell(
      onTap: (){

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Route));
      },
      child: Padding(

        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow:[
              BoxShadow(color: Colors.grey,offset:Offset(0,0),blurRadius:8,spreadRadius:0,blurStyle: BlurStyle.outer),                  ],
            // border: Border.all(color: Colors.black,width: 1),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(00),topRight:Radius.circular(70),bottomLeft: Radius.circular(30)),
          ),
          width:250,
          // height:200,
          child:Column(

            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(00),topRight:Radius.circular(70),bottomLeft:Radius.circular(0)),child: Image.asset(width:250,path)),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(heading,style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
                    SizedBox(width:10,),
                    Icon(Icons.arrow_forward,size:30,),
                  ],

                ),
              ),

              Padding(

                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                    height:70,
                    child: Text(Content,style:TextStyle(fontSize:15,))),
              ),

            ],
          ) ,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: RefreshIndicator(child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Flexible(
                child: ListView(

                  children: [
                    Padding(

                      padding: const EdgeInsets.all(8.0),

                      child:

                      Column(

                        crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Center(
                          child: Container(

                              width:200,
                              height:100,
                              child: Image.asset(width:50,"assets/images/icon.jpg")),

                        ),
                        //second container

                        Center(
                          child: Container(
                            child: Text("Hi ${currentUserName}",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: Colors.black),),
                          ),
                        ),
                        SizedBox(height:20,),
                        //dashboard design
                        if(isLoading==true) Center(child: CircularProgressIndicator()),
                        if(isLoading==false)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: (){},
                                    child: Container(
                                      // margin: EdgeInsets.only(left:15,top:15),
                                      decoration: BoxDecoration(
                                        // color: Colors.yellow,
                                        boxShadow:[
                                          BoxShadow(color: Colors.grey,offset:Offset(0,0),blurRadius:15,spreadRadius:0,blurStyle: BlurStyle.outer),                  ],
                                        // border: Border.all(color: Colors.black,width: 1),
                                        borderRadius: BorderRadius.circular(15),


                                      ),
                                      width:150,
                                      height:300,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              child:ListTile(contentPadding: EdgeInsets.only(left:10),horizontalTitleGap:10,leading: Image.asset(width:35,'assets/images/monthly.png'),title: Text("Monthly Income",style: TextStyle(fontWeight: FontWeight.bold),),),
                                            ),
                                            // SizedBox(height: 15,),
                                            Container(

                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.currency_rupee_rounded),
                                                  if(isLoading==true) CircularProgressIndicator() ,
                                                  if(isLoading==false)
                                                    Text("${monthlyIncome}",textAlign: TextAlign.center,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize:20),),
                                                ],
                                              ),
                                            ),
                                            Divider(color: Colors.grey,thickness:3,indent: 10,endIndent: 10,),
                                            // SizedBox(height: 10,),
                                            Container(
                                              child:ListTile(contentPadding: EdgeInsets.only(left:10),horizontalTitleGap:10,leading: Image.asset(width:35,'assets/images/income.png'),title: Text("Remaining Amount",style: TextStyle(fontWeight: FontWeight.bold),),),
                                            ),
                                            // SizedBox(height:8,),
                                            Container(

                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.currency_rupee_sharp),
                                                  Text("${remainingAmount}",textAlign: TextAlign.center,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize:20),),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>ReportsPage(),));
                                            }, child: Text("View Details"),style:ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white),backgroundColor: MaterialStatePropertyAll(Colors.black))),
                                          ],
                                        ),
                                      ),

                                      // ================


                                    ),
                                  ),

                                ],
                              ),

                              Column(

                                children: [
                                  InkWell(
                                    onTap: (){},
                                    child: Container(
                                      width:150,
                                      height:100,
                                      decoration: BoxDecoration(
                                        boxShadow:[
                                          BoxShadow(color: Colors.grey,offset:Offset(0,0),blurRadius:15,spreadRadius:0,blurStyle: BlurStyle.outer),                  ],
                                        // border: Border.all(color: Colors.black,width: 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(mainAxisAlignment: MainAxisAlignment.center,

                                            children: [

                                              Icon(Icons.person_3_rounded),
                                              SizedBox(width:10,),
                                              Text("${count}",style:TextStyle(fontWeight: FontWeight.bold,fontSize:25),),


                                            ],),

                                          Text("Registered Students",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),

                                        ],
                                      ),),
                                  ),
                                  SizedBox(height: 20,),
                                  InkWell(
                                    onTap: (){},
                                    child: Container(
                                      width:150,
                                      height:200,
                                      decoration: BoxDecoration(
                                        boxShadow:[
                                          BoxShadow(color: Colors.grey,offset:Offset(0,0),blurRadius:15,spreadRadius:0,blurStyle: BlurStyle.outer),                  ],
                                        // border: Border.all(color: Colors.black,width: 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.payment_rounded),
                                              SizedBox(width:10,),
                                              Text("Upcoming\n Payments",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
                                            ],
                                          ),


                                          Container(
                                            height:140,
                                            child: ListView.builder(

                                              padding: EdgeInsets.all(0),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: studentData.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Container(
                                                  height:80,
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.all(10),
                                                    title: Text(studentData[index]["Customer Name"],style: TextStyle(fontWeight: FontWeight.bold)),
                                                    subtitle: Text("Amount to be paid: \₹${studentData[index]["Payment"]["${year}"]["${month}"]["Amount"]}"),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),


                            ],
                          ),

                        SizedBox(height:25,),
                        Divider(),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Our Services",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,),textAlign: TextAlign.center),
                        ),
                        SizedBox(height:25,),

                        SingleChildScrollView(
                          scrollDirection:Axis.horizontal,
                          child: SizedBox(
                            // height:500,
                            child: Row(
                              children: [
                                explore(context,"assets/images/autoStu.jpg","Customer Management","Effortlessly organize and track student information with our intuitive management system.",StudentMngInfo()),
                                explore(context,"assets/images/autoFian.jpg","Payment Management","Efficiently track and manage student payments with ease.",PaymentMngInfo()),
                                explore(context,"assets/images/AutoBill.jpg","Billing and Invoice","Streamline your billing process with automated invoice generation",BillingMngInfo()),
                                explore(context,"assets/images/reportAna.jpg","Reports & Analytics","Generate comprehensive income analysis and reports effortlessly.",ReportAnalytics()),
                                explore(context,"assets/images/AutoDoc.jpg","Store Documents","Safely store and access important documents anytime, anywhere.",StoreDocsInfo()),


                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:25,),
                        Divider(),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Reports",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,),textAlign: TextAlign.center),
                              SizedBox(width: 15,),
                              Icon(Icons.analytics,color: Colors.green,size: 30),
                            ],
                          ),
                        ),
                        SizedBox(height:25,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height:350,
                          child:  Column(
                            children: [
                              SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                  majorGridLines: MajorGridLines(width: 0),
                                ),
                                series: <LineSeries<NumberOfCustomersChartData,String>>[
                                  LineSeries(dataSource:customersCountData, xValueMapper: (NumberOfCustomersChartData x1,_)=>x1.numberOfCustomerPerMonth, yValueMapper:(NumberOfCustomersChartData ob,_)=>ob.cutomerscount)
                                ],
                              ),

                            ],
                          ),
                        ),
                        // SizedBox(height:25,),

                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Upcoming Services",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,),textAlign: TextAlign.center),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: (){},
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width:200,

                                          child: Column(
                                            children: [
                                              ClipRRect(

                                                  borderRadius:BorderRadius.only(bottomRight: Radius.circular(50),topLeft:Radius.circular(50))
                                                  ,child: Image.asset("assets/images/predi.jpg",)),
                                              SizedBox(height: 15,),
                                              Text("Predictive Analysis",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500),)
                                            ],
                                          ),
                                          decoration: BoxDecoration(

                                            // border: Border.all(color: Colors.black,width: 1.4),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width:20,),
                                    InkWell(
                                      onTap: (){},
                                      child: Container(
                                        width:200,

                                        child: Column(
                                          children: [
                                            ClipRRect(
                                                borderRadius:BorderRadius.only(bottomRight: Radius.circular(50),topLeft:Radius.circular(50))
                                                ,child: Image.asset("assets/images/dp.jpg",)),
                                            SizedBox(height: 15,),
                                            Text("Dynamic Pricing",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500),)
                                          ],
                                        ),
                                        decoration: BoxDecoration(

                                          // border: Border.all(color: Colors.black,width: 1.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
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

                        SizedBox(height: 100,),



                      ],

                      ),

                    ),
                  ],
                ),
              ),

            ],
          ),
        ), onRefresh:onRefresh)

      ),
    );
  }
  Color buttonclr = Colors.green;
  late List<NumberOfCustomersChartData> customersCountData=[];

  final List<HelpContent> helpContents = [
    HelpContent(
      question: 'How to add customers?',
      answer: 'Navigate to the home, then go to customer management, and finally, add a new customer.',
    ),
    HelpContent(
      question: 'How to manage payments?',
      answer: 'Navigate to the home, then go to payment management, and finally, update.',
    ),
    HelpContent(
      question: 'How to generate and share invoices?',
      answer: 'Navigate to billing and invoicing, then select customers according to your needs using the dropdown. Next, click on "View Bill," followed by "View Receipt," and finally, click on "Share."',
    ),

    // Add more help contents as needed
  ];
}









