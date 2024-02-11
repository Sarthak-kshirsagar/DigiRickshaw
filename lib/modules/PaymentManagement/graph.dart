import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:syncfusion_flutter_charts/charts.dart";

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {

  int value1 = 10000;
  int value2 = 5000;
 late List<MyChartData> data=[];
 late List<MonthlyChartData> monthlyList=[];
 late List<NumberOfCustomersChartData> customersCountData=[];

  List<DocumentSnapshot>montlhyAmount=[];
  String year = "";
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
      assign();
      print("bar chart executed");
      assignToCount();
      print("line chart executed");
      // assignToGraph();
      print("Year graph executed");
    }

  }

  double _jan=0;
  double _feb=0;
  double _mar=0;
  double _apr=0;
  double _may=0;
  double _jun=0;
  double _jul=0;
  double _aug=0;
  double _sept=0;
  double _oct=0;
  double _nov=0;
  double _decemberr=0;

  // double _janCount=0;
  // double _febCount=0;
  // double _marCount=0;
  // double _aprCount=0;
  // double _mayCount=0;
  // double _junCount=0;
  // double _julCount=0;
  // double _augCount=0;
  num _septCount=0;
  num _octCount=0;
  num _novCount=0;
  //
  // double _decemberrCount=0;

  num dummy = 0;
  double _year2023=0;
  double _year2022=0;
  double _year2024=0;
  void assign() {
    // Check if montlhyAmount is not empty and has the expected structure
    if (montlhyAmount.isNotEmpty && montlhyAmount[0]["Monthly Income"] != null) {
      double Jan = montlhyAmount[0]["Monthly Income"]["${year}"]["January"] ?? 0 ;
      double feb = montlhyAmount[0]["Monthly Income"]["${year}"]["February"] ?? 0;
      double Mar = montlhyAmount[0]["Monthly Income"]["${year}"]["March"] ?? 0;
      double Apr = montlhyAmount[0]["Monthly Income"]["${year}"]["April"] ?? 0;
      double May = montlhyAmount[0]["Monthly Income"]["${year}"]["May"] ?? 0;
      double June = montlhyAmount[0]["Monthly Income"]["${year}"]["June"] ?? 0;
      double July = montlhyAmount[0]["Monthly Income"]["${year}"]["July"] ?? 0;
      double Aug = montlhyAmount[0]["Monthly Income"]["${year}"]["August"] ?? 0;
      double Sept = montlhyAmount[0]["Monthly Income"]["${year}"]["September"] ?? 0;
      double Oct = montlhyAmount[0]["Monthly Income"]["${year}"]["October"] ?? 0;
      double Nov = montlhyAmount[0]["Monthly Income"]["${year}"]["November"] ?? 0;
      double december = montlhyAmount[0]["Monthly Income"]["${year}"]["December"] ?? 0;

      num dum = montlhyAmount[0]["Customer Count"]["December"] ??0;
      double year2023 = montlhyAmount[0]["Yearly Income"]["${2023}"]??0;
      double year2022 = montlhyAmount[0]["Yearly Income"]["${2022}"]??0;
      double year2024 = montlhyAmount[0]["Yearly Income"]["${2024}"]??0;




      setState(() {
        _year2023 = year2023;
        _year2022=year2022;
        _year2024=year2024;
        dummy= dum;
        _jan=Jan;
        _feb=feb;
        _mar=Mar;
        _apr=Apr;
        _may=May;
        _apr=Apr;
        _jun=June;
        _aug=Aug;
        _sept=Sept;
        _oct=Oct;
        _nov=Nov;
        _decemberr=december;

        // //for count


        monthlyList = [
          MonthlyChartData(month: "Jan", amount: _jan),
          MonthlyChartData(month: "Feb", amount: _feb),
          MonthlyChartData(month: "Mar", amount: _mar),
          MonthlyChartData(month: "Apr", amount: _apr),
          MonthlyChartData(month: "May", amount: _may),
          MonthlyChartData(month: "Jun", amount: _jun),
          MonthlyChartData(month: "Jul", amount: _jul),
          MonthlyChartData(month: "Aug", amount: _aug),
          MonthlyChartData(month: "Sept", amount: _sept),
          MonthlyChartData(month: "Oct", amount: _oct),
          MonthlyChartData(month: "Nov", amount: _nov),
          MonthlyChartData(month: "Dec", amount: _decemberr),
        ];
        data = [
          MyChartData(x1: "2022", y1: _year2022),
          MyChartData(x1: "2023", y1: _year2023),
          MyChartData(x1: "2024", y1: _year2024),

        ];



      });
    } else {
      print("Data structure does not match expectations");
    }
  }
double _amoount2022=0;
  double _amount2023 =0;
  double _amount2024 = 0;

// void assignToGraph(){
//     print("entered to assign the graph");
//     if(montlhyAmount.isNotEmpty && montlhyAmount[0]["Yearly Income"]!= null){
//       print("condition satisfied");
//       double amount2022 = montlhyAmount[0]["Yearly Income"][2022] ?? 0;
//       double amount2023 = montlhyAmount[0]["Yearly Income"][2023]??0;
//       double amount2024 = montlhyAmount[0]["Yearly Income"][2024]??0;
//       print("values assigned to yearly variables");
//
//       setState(() {
//         _amoount2022 = amount2022;
//         _amount2023=amount2023;
//         _amount2024=amount2024;
//       print("state updated for yearly var dummy value for 2023 is ${_amount2023}");
//
//         print("constructor updated");
//
//       });
//     }
//
// }
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
    FetchGraphMonthlyData();









  }
  @override

  Widget build(BuildContext context) {

    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Reports and Analytics",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
            ),
              SizedBox(height:50,),

              Center(child: Text("Monthly Income",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                ),
                series: <ColumnSeries<MonthlyChartData,String>>[
                  ColumnSeries(dataSource: monthlyList, xValueMapper: (MonthlyChartData x1,_)=>x1.month, yValueMapper:(MonthlyChartData ob,_)=>ob.amount),
                ],
              ),
              SizedBox(height:50,),



              Center(child: Text("Customers Count Across Months",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                ),
                series: <LineSeries<NumberOfCustomersChartData,String>>[
                  LineSeries(dataSource:customersCountData, xValueMapper: (NumberOfCustomersChartData x1,_)=>x1.numberOfCustomerPerMonth, yValueMapper:(NumberOfCustomersChartData ob,_)=>ob.cutomerscount)
                ],
              ),
              SizedBox(height:50,),
              Center(child: Text("Yearly Income",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                ),
                series: <ColumnSeries<MyChartData,String>>[
                  ColumnSeries(dataSource: data, xValueMapper: (MyChartData x1,_)=>x1.x1, yValueMapper:(MyChartData ob,_)=>ob.y1),
                ],
              ),

            ],
          ),
        ),
      )
    );
  }
}
class MyChartData{
  final String? x1;
 final double? y1;

  MyChartData({required this.x1,required this.y1});

}

class MonthlyChartData{
  final String? month;
  final double? amount;

  MonthlyChartData({required this.month,required this.amount});
}

class NumberOfCustomersChartData{
  final String? numberOfCustomerPerMonth;
  final num cutomerscount;
  NumberOfCustomersChartData({required this.numberOfCustomerPerMonth,required this.cutomerscount});
}