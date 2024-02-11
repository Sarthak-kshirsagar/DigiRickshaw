import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:digitalrickshaw/modules/addStudent.dart';
// import 'package:digitalrickshaw/modules/fetchStudents.dart';
import 'package:flutter/material.dart';
import 'package:rickshaw2/modules/upComing.dart';

import '../modules/addStudent.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:url_launcher/url_launcher.dart';

class StudentManagement extends StatefulWidget {
  const StudentManagement({super.key});

  @override
  State<StudentManagement> createState() => _StudentManagementState();
}

// student management page
class _StudentManagementState extends State<StudentManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DocumentSnapshot> documents = [];

  Future<String> fetchCurrentUserName() async {
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

  void fetchData() async {
    CollectionReference db = FirebaseFirestore.instance.collection("Customers");
    String currentUserName = await fetchCurrentUserName();
    QuerySnapshot querySnapshot =
        await db.where("Driver Name", isEqualTo: "${currentUserName}").get();
    setState(() {
      documents = querySnapshot.docs;
    });
  }
  String getCurrentYear() {
    DateTime now = DateTime.now();
    return now.year.toString();
  }
  Future<void>updateDetailsOfCustomers(oldName,newCustomerName,address,destination,mobile,fare)async{
    String currentUserName = await fetchCurrentUserName();
    CollectionReference ref = FirebaseFirestore.instance.collection("Customers");
    final db = FirebaseFirestore.instance.collection("Customers").where("Driver Name",isEqualTo: currentUserName).where("Customer Name",isEqualTo:oldName);
    QuerySnapshot snapshot = await db.get();
    String year = getCurrentYear();
    if(snapshot.docs.isNotEmpty){
      String documentId = snapshot.docs.first.id;
          await ref.doc(documentId).update({
            "Customer Name":newCustomerName,
            "Address":address,
            "Destination":destination,
            "Mobile":mobile,
            "Fare":fare,

          });
    }




  }
  late List<String> selectableMonths;
  String selectedMonth = '';
  List<String> generateSelectableMonths() {
    final currentMonth = DateTime.now().month;
    final months = [
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
    ];

    return months.sublist(currentMonth - 1);
  }

  Future<void>addAfterNewRegister(oldName,nextMonthAmount,selectedValue)async{
    try {
      print("entered for reregistering");
      print("selected value is ${selectedValue}");
      print("next month value is ${nextMonthAmount}");
      String currentUserName = await fetchCurrentUserName();
      print("curent user is ${currentUserName}");
      CollectionReference ref = FirebaseFirestore.instance.collection("Customers");
      final db = FirebaseFirestore.instance.collection("Customers").where("Driver Name",isEqualTo: currentUserName).where("Customer Name",isEqualTo:oldName);
      QuerySnapshot snapshot = await db.get();
      String year = getCurrentYear();

      if(snapshot.docs.isNotEmpty){
        String documentId = snapshot.docs.first.id;
        await ref.doc(documentId).set({

          "Registered Months":{
            "${year}":{
              "${selectedValue}":"Yes",
            }
          }
        });
      }
      CollectionReference ref2 = FirebaseFirestore.instance.collection("Payments");
      final db2 = await ref2.where("DriverName",isEqualTo: "${currentUserName}").where("Customer Name",isEqualTo: oldName);
      QuerySnapshot snap = await db2.get();
      if(snap.docs.isNotEmpty){
        String documentId = snapshot.docs.first.id;
        await ref.doc(documentId).update({
          "Payment":{
            "${year}":{
              "${selectedValue}":{
                "Amount":nextMonthAmount,
                "Partially Paid Amount":0,
                "Partially Paid Date":"Not Paid",
                "Status":"Pending",
                "Total Paid Date":"Not Paid",
                "HI":"hi",
              }
            }
          }
        });
      }
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

 Future showDiaToRegister(BuildContext ctx,OldName){
    TextEditingController newFare  = new TextEditingController();

    return showDialog(context: context, builder: (context) {

      return Container(
        height: 250,
        child: AlertDialog(
          actions: [
            ElevatedButton(onPressed: (){
              print("selected month is ${selectedMonth}");
              addAfterNewRegister(OldName,newFare.text,selectedMonth);
              print("button clicked for registration");
            }, child: Text("Register")),
          ],
          content:SingleChildScrollView(
            child: Column(
              children: [
                DropdownButton<String>(
                  value: selectedMonth,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                    });
                  },
                  items: selectableMonths.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),

                ),

                TextFormField(
                  controller: newFare,

                  decoration: InputDecoration(
                    label: Text("Fare"),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  ),

                ),
              ],
            ),
          ),
        )
      );
    },);
 }
  Future showDia(BuildContext ctx,customerName,address,destination,mobile,fare){
    return showDialog(context: context, builder: (context) {
      TextEditingController newCustomerName = new TextEditingController(text: customerName);
      TextEditingController newAddress = new TextEditingController(text: address);
      TextEditingController newDestination = new TextEditingController(text: destination);
      TextEditingController newMobile = new TextEditingController(text: mobile);
      TextEditingController newFare = new TextEditingController(text: fare.toString());

      return  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: AlertDialog(
          actions: [
            ElevatedButton(style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black),
                foregroundColor:MaterialStatePropertyAll(Colors.white)),onPressed: (){
              Navigator.pop(context);
            }, child:Text("Back")),
            ElevatedButton(onPressed: (){
              updateDetailsOfCustomers(customerName, newCustomerName.text,newAddress.text, newDestination.text, newMobile.text,newFare.text);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content:Text("Updated Details")));
              print("updated");
            }, child: Text("Apply")),
            

          ],
          title: Text("Edit ${customerName} Details",style: TextStyle(fontSize:15)),
          content: SizedBox(height: 250,child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: newCustomerName,
                
                      decoration: InputDecoration(
                        label: Text("Enter new Name"),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: newAddress,
                
                      decoration: InputDecoration(
                        label: Text("Enter new Address"),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: newDestination,
                
                
                      decoration: InputDecoration(
                        label: Text("Enter new Destination"),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: newMobile,
                
                
                      decoration: InputDecoration(
                        label: Text("Enter new Number"),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: newFare,
                
                
                      decoration: InputDecoration(
                        label: Text("Enter new Fare Amount"),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
      );
    },);
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchData();
    selectableMonths = generateSelectableMonths();
    selectedMonth = selectableMonths.first;
  }

  // _callNumber(String numbers) async{
  //   const number = '9503904361'; //set the number here
  //   bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  // }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        //top bar
        length: 3,
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // Text("data"),
                    TabBar(
                        indicatorColor: Colors.white,
                        indicatorWeight: 3,
                        controller: _tabController,
                        tabs: [
                          Tab(
                            icon: Icon(Icons.add,color: Colors.white),
                          ),
                          Tab(
                            icon: Icon(Icons.view_compact_alt,color: Colors.white),
                          ),
                          Tab(
                            icon: Icon(Icons.payment_rounded,color: Colors.white),
                          ),
                        ]),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                // tabbar accepts the widgets which is to be shown
                children: [
                  SizedBox(width: 250, height: 50, child: AddStudent()),
                  Scaffold(
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        fetchData();
                      },
                      child: Icon(Icons.refresh),
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                              height: 50,
                              child: Text(
                                "Customers",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
          
                          Container(
                            height:450,
                            width: 350,
          
                            child: SingleChildScrollView(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
          
                                    Container(
                                      height: 450,
                                      child:
                                          documents.isEmpty?Center(child: Text("No Customers",style: TextStyle(
                                            color: Colors.red,fontSize:18,
                                          ),)):
                                      ListView.builder(shrinkWrap: true,itemCount: documents.length,itemBuilder: (context, index) {
                                        return

                                          Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 15,),
                                              Container(
                                                height:100,
                                                width: 350,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),border: Border.all(color: Colors.grey,width: 1)),
                                                child: Column(
          
                                                  children: [
                                                    ListTile(
          
          
                                                      trailing: Container(
                                                        width: 50,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            IconButton(onPressed: (){
                                                              showDia(context,documents[index]["Customer Name"],documents[index]["Address"],documents[index]["Destination"],documents[index]["Mobile"],documents[index]["Fare"]);
                                                            }, icon: Icon(Icons.edit_sharp))
                                                          ],
                                                        ),
                                                      ),
          
                                                      leading: Icon(Icons.person,size: 30,),
          
                                                      title: Column(
                                                        children: [
                                                          Text("${documents[index]["Customer Name"]}",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                                                          Text("${documents[index]["Address"]} to ${documents[index]["Destination"]}",style: TextStyle(color: Colors.grey,fontSize:17,fontWeight: FontWeight.normal)),
          
                                                        ],
                                                      ),
          
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height:20,)
                                            ],
                                          ),
                                        );
                                      },),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
          
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: UpcomingPayments(),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
