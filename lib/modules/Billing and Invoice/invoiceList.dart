import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:rickshaw2/modules/Billing%20and%20Invoice/viewCustomerDetailsInvoice.dart";

class InvoiceList extends StatefulWidget {
  const InvoiceList({super.key});

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
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
  String year = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentMonth();
    setState(() {
      year = getCurrentYear();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:Column(

        children: [
          SizedBox(height: 20,),
          Text("Billing and Invoice",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:25)),

          // =============dropdown=====================
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
          SizedBox(height:20,),

          Container(
              width:340,
              child:viewDeatils.isEmpty?Center(child: Text("No Data Found",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),))

                  :
              // ListTile(
              //
              //   title: Text("Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
              //   trailing: Text("Amount",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),
              //
              //   ),
              // ),

              Container(
                height:500,

                decoration: BoxDecoration(

                ),
                child: ListView.builder(itemCount: viewDeatils.length,itemBuilder:(context, index) {


                  return Container(
                    child: Column(
                      children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:Border(bottom: BorderSide(color: Colors.grey,width: 1))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(

                                      children: [
                                        Image.asset("assets/images/autoimg.jpg",width:50),
                                        Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(child: Text("${viewDeatils[index]["Customer Name"]}")),
                                            Container(child: Text("${viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Total Paid Date"]}")),
                                            Container(child: Text("₹ ${viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Amount"]}"))

                                          ],

                                        ),
                                        ElevatedButton(onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCustomerDetailsInvoice(status: viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Status"],remainingAmount:(viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Remaining Amount"]),customerName:"${viewDeatils[index]["Customer Name"]}" ,driverName: viewDeatils[index]["DriverName"],monthPaid:viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Total Paid Date"],amount: viewDeatils[index]["Payment"]["${year}"]["${selectedMonth}"]["Amount"]),));
                                        }, child: Text("View Bill")),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    ),
                                  )
                                ),
                              )
                      ],
                    ),
                  );

                }


                ),
              )
          ),
        ],
      )),
    );
  }
}
