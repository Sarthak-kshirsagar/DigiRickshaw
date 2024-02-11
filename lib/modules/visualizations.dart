

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyReportGraph extends StatefulWidget {
  const MonthlyReportGraph({super.key});

  @override
  State<MonthlyReportGraph> createState() => _MonthlyReportGraphState();
}

class _MonthlyReportGraphState extends State<MonthlyReportGraph> {
  //
  final FirestoreService service = FirestoreService();
   List<BarData> _datalist=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    print("Printing data");


  }
Future<void>_getData() async{
    List<BarData> datalist = await service.getData();
    setState(() {
      _datalist = datalist;

    });

}



// ========bard=================






  // ============================================
  List<int> year = [2000,2023];
  @override

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height:100,
              child: ListView.builder(itemCount: _datalist?.length ?? 0,itemBuilder: (context, index) {
                BarData data = _datalist![index];
                return ListTile(
                  title: Text("${data.year}"),
                  leading: Text("${data.value}"),
                );
              },),
            ),
            SizedBox(height:50,),
            Center(
              child: Container(
                child: AspectRatio(
                  aspectRatio:1,
                  child: BarChart(

                    BarChartData(


                      borderData: FlBorderData(

                        border: Border(

                          top: BorderSide.none,
                          left: BorderSide(color: Colors.black,width: 1),
                          right:BorderSide(width: 1,color: Colors.black),
                          bottom: BorderSide(color: Colors.black,width: 1),

                        ),

                      ),
                      groupsSpace:10,
                      barGroups: [

                        // BarChartGroupData(x:10,barRods: [
                        //   BarChartRodData(fromY: 0,toY: 100,)
                        // ])

                        for (int i = 0; i < _datalist.length; i++)

                          BarChartGroupData(

                            x:_datalist[i].year.toInt(),
                  // Use index for x-axis position
                            barRods: [
                              BarChartRodData(
                                fromY: 0, // Adjust this based on your data
                                toY: _datalist[i].value.roundToDouble(), // Use value from the list
                              ),
                            ],
                          ),


                      ],


                    ),

                  ),
                ),
              ),
            )

          ],
        ),
      ),
    ));
  }
}

class BarData {
  int year;
  int value;
  BarData({required this.year, required this.value});
}

class FirestoreService{
  final CollectionReference ref = FirebaseFirestore.instance.collection("Reports");

  Future<List<BarData>> getData() async{
    QuerySnapshot snapshot = await ref.get();

    return snapshot.docs.map((e){
      Map<String,dynamic> data = e.data() as Map<String,dynamic>;
      // Check if ID is numerical before parsing
      final year = int.tryParse(e.id) ?? 0;
      return BarData(year:year, value: data["value"]);
    }).toList();
}

}


