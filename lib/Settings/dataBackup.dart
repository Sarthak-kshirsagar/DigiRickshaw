// import 'package:flutter/material.dart';
//
// class DataBackupPage extends StatefulWidget {
//   const DataBackupPage({super.key});
//
//   @override
//   State<DataBackupPage> createState() => _DataBackupPageState();
// }
//
// class _DataBackupPageState extends State<DataBackupPage> {
//   Map<String, bool> checkboxValues = {
//     "Personal Information": false,
//     "Customers Information": false,
//     "Payment Information": false,
//     "Travel History": false,
//     "Reports and Analytics": false,
//   };
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text("Backup Information",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:30)),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Center(
//                     child: Text("Download your Information",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize:20))),
//               ),
//               Divider(),
//               Text("Select which information you need to backup"),
//               requestedInfoUI("Personal Information"),
//               requestedInfoUI("Customers Information"),
//               requestedInfoUI("Payment Information"),
//               requestedInfoUI("Travel History"),
//               requestedInfoUI("Reports and Analytics"),
//
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget requestedInfoUI(heading){
//
//     return CheckboxListTile(
//         value: false,
//       side:BorderSide(width: 1,color: Colors.green),
//       onChanged: (value){
//       setState(() {
//         checkboxValues[heading] = value!;
//       });
//     },title:Text("${heading}"),);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:rickshaw2/Settings/viewPdfff.dart';

class DataBackupPage extends StatefulWidget {
  const DataBackupPage({Key? key}) : super(key: key);

  @override
  State<DataBackupPage> createState() => _DataBackupPageState();
}

class _DataBackupPageState extends State<DataBackupPage> {
  Map<String, bool> checkboxValues = {
    "Personal Information": false,
    "Customers Information": false,
    "Payment Information": false,
    "Travel History": false,
    "Reports and Analytics": false,
  };
  bool isLoading = false;
//code to genrate the pdf and store it in the firebase and local storage

  String getCurrentMonth() {
    var now = DateTime.now();
    var formatter = DateFormat('MMMM');
    return formatter.format(now);
  }
  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final String formattedDate = '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';
    return formattedDate;
  }
  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }

  String month = "";
  String year = "";
  String getCurrentYear() {
    DateTime now = DateTime.now();
    return now.year.toString();
  }

  Future<int?> createPdf(bool? customers,bool? payment) async {

    if(customers==false&&payment==false){
      showDialog(context:context,builder: (context) {
        return Center(
          child: Container(
            width: 250,
            height:200,
            child: AlertDialog(

              content: Column(
                children: [
                  Text("Please Select the Data Needed"),
                  SizedBox(height: 10,),
                  Icon(
                    Icons.error,color: Colors.red,size:50,
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        );
      });
      return 0;
    }
    setState(() {
      isLoading = true;
    });
    final pdf = pw.Document();
    final netImage = await networkImage('https://firebasestorage.googleapis.com/v0/b/rickshaw2.appspot.com/o/icon.jpg?alt=media&token=857d1169-d522-4262-a685-4c9f993bfa61');
  String userName = await fetchCurrentUserName();
  String date = getCurrentDate();
    try{
      pdf.addPage(pw.Page(build: (context) {
        return pw.Column(
          // mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Center(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text("Digi Auto",style: pw.TextStyle(fontSize:50)),
                        pw.Container(
                          width: 250,
                          height: 250,
                          child: pw.Image(netImage),
                        ),
                        pw.SizedBox(height:30),
                        pw.Text("Thanks for using Digi Auto",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize:28)),
                        pw.SizedBox(height:40),
                       pw.Center(
                         child:pw.Column(
                           crossAxisAlignment: pw.CrossAxisAlignment.center,
                           children: [
                             pw.Text("Pdf shows the \nrequested Information till",style: pw.TextStyle(fontSize:28)),
                             pw.SizedBox(height:25),
                             pw.Text("${date}",style: pw.TextStyle(fontSize:25)),
                             pw.SizedBox(height:45),
                             pw.Text("User Name:- ${userName}",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize:30)),
                           ]
                         )
                       )


                      ]
                  )
              )

            ]
        );
      },));
      //if payments
      // if(payment==true){
      //   final PaymentsQuery = await FirebaseFirestore.instance
      //       .collection("Payments")
      //       .where("Driver Name", isEqualTo: "${userName}")
      //       .get();
      //   print("====== got the results from payments db");
      //   var one = 1;
      //   for (final paymentDoc in PaymentsQuery.docs) {
      //     print("For customer one");
      //     final customerData = paymentDoc.data() as Map<String, dynamic>;
      //     final paymentsData = paymentDoc["Payment"] as Map<String, dynamic>;
      //     final yearData = paymentDoc["Payment"]["${year}"] as Map<String, dynamic>;
      //     final monthData =
      //     paymentDoc["Payment"]["${year}"]["${month}"] as Map<String, dynamic>;
      //     final yearTemp = paymentsData.keys.toList();
      //     final monthTemp = yearData.keys.toList();
      //     final imageLogo = MemoryImage((await rootBundle.load('assets/images/ins.png')).buffer.asUint8List());
      //
      //
      //     for (final years in yearTemp) {
      //       for (final months in monthTemp) {
      //
      //         pdf.addPage(
      //
      //             pw.Page(
      //
      //               build: (pw.Context context) {
      //                 return pw.Column(children: [
      //                   pw.Text("Payment Data for ${customerData["Customer Name"]}",
      //                       style: pw.TextStyle(
      //                           fontSize: 20, fontWeight: pw.FontWeight.bold)),
      //                   pw.SizedBox(height:90),
      //
      //                   //heading for the pdfffff
      //                   pw.Row(children: [
      //                     pw.Text("Year",
      //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                     pw.SizedBox(
      //                       width:45,
      //                     ),
      //                     pw.Text("Month",
      //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                     pw.SizedBox(width:45),
      //                     pw.Text("Amount",
      //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                     pw.SizedBox(width:45),
      //                     pw.Text("Payment Date",
      //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                     pw.SizedBox(width:45),
      //                     pw.Text("Status",
      //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                     pw.SizedBox(width:45),
      //                   ]),
      //                   pw.SizedBox(height:40),
      //
      //                   //printing the actual data.....
      //                   pw.Row(children: [
      //                     pw.Text("${years.toString()}"),pw.SizedBox(width:45),
      //                     pw.Text("${months.toString()}"),pw.SizedBox(width:45),
      //                     pw.Text("${customerData["Payment"]["${years}"]["${months}"]["Amount"]}"),
      //                     pw.SizedBox(width:45),
      //                     pw.Text("${customerData["Payment"]["${years}"]["${months}"]["Total Paid Date"]}"),
      //                     pw.SizedBox(width:45),
      //                     pw.Text("${customerData["Payment"]["${years}"]["${months}"]["Status"]}"),
      //                     pw.SizedBox(width:45),
      //                   ]),
      //                   pw.SizedBox(height: 10),
      //                   if(one>=yearTemp.length)
      //                     pw.Divider(),
      //                   pw.Container(
      //                       child: pw.Row(
      //                           mainAxisAlignment: pw.MainAxisAlignment.center,
      //                           children: [
      //                             pw.Text("© Digi Auto"),
      //                             pw.SizedBox(width:50),
      //                             pw.Container(
      //                               width:50,
      //                               height:50,
      //                               child: pw.Image(netImage),
      //                             )
      //                           ]
      //                       )
      //                   )
      //
      //
      //                 ]);
      //               },
      //
      //             )
      //
      //         );
      //       }
      //       one++;
      //     }
      //
      //     // Add a page to the PDF
      //   }
      // }

      // if (customers == true) {
      //   final Customers = await FirebaseFirestore.instance
      //       .collection("Customers")
      //       .where("Driver Name", isEqualTo: "${userName}")
      //       .get();
      //   print("got the results from db");
      //
      //   List<Map<String, dynamic>> customerList = [];
      //
      //   for (final customers in Customers.docs) {
      //     print("For customer one");
      //     final customerData = customers.data() as Map<String, dynamic>;
      //     customerList.add(customerData);
      //   }
      //
      //   pdf.addPage(pw.Page(build: (context) {
      //     return pw.Column(
      //       children: [
      //         for (final customerData in customerList)
      //           pw.Column(
      //             children: [
      //               pw.Text(
      //                 "Customers Data for ${userName}",
      //                 style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
      //               ),
      //               pw.SizedBox(height: 90),
      //               //heading for the pdfffff
      //               pw.Row(
      //                 children: [
      //                   pw.Text("Customer Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                   pw.SizedBox(width: 45),
      //                   pw.Text("Address", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                   pw.SizedBox(width: 45),
      //                   pw.Text("Destination", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                   pw.SizedBox(width: 45),
      //                   pw.Text("Mobile", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                   pw.SizedBox(width: 45),
      //                   pw.Text("Fare", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      //                   pw.SizedBox(width: 45),
      //                 ],
      //               ),
      //               pw.SizedBox(height: 40),
      //               //actual info
      //               pw.Row(
      //                 children: [
      //                   pw.Text("${customerData["Customer Name"]}"),
      //                   pw.SizedBox(width: 45),
      //                   pw.Text("${customerData["Address"]}"),
      //                   pw.SizedBox(width: 45),
      //                   pw.Text("${customerData["Destination"]}"),
      //                   pw.SizedBox(width: 45),
      //                   pw.Text("${customerData["Mobile"]}"),
      //                   pw.SizedBox(width: 45),
      //                   pw.Text("${customerData["Fare"]}"),
      //                   pw.SizedBox(width: 45),
      //                 ],
      //               ),
      //               pw.SizedBox(height: 10),
      //               pw.Divider(),
      //             ],
      //           ),
      //       ],
      //     );
      //   }));
      // }

      if(customers==true || payment==true){

        //for customersss
        final Customers = await FirebaseFirestore.instance
            .collection("Customers")
            .where("Driver Name", isEqualTo: "${userName}")
            .get();
        print("got the results from db");

        List<Map<String, dynamic>> customerList = [];

        for (final customers in Customers.docs) {
          print("For customer one");
          final customerData = customers.data() as Map<String, dynamic>;
          customerList.add(customerData);
        }

        pdf.addPage(pw.Page(build: (context) {
          return pw.Column(
            children: [
              pw.Text(
                "Customers Data for ${userName}",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 90),
              pw.Row(
                children: [
                  pw.Text("Customer Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 45),
                  pw.Text("Address", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 45),
                  pw.Text("Destination", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 45),
                  pw.Text("Mobile", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 45),
                  pw.Text("Fare", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 45),
                ],
              ),
              pw.SizedBox(height: 40),

              for (final customerData in customerList)
                pw.Column(
                  children: [

                    //heading for the pdfffff

                    //actual info
                    pw.Row(
                      children: [
                        pw.Text("${customerData["Customer Name"]}"),
                        pw.SizedBox(width: 45),
                        pw.Text("${customerData["Address"]}"),
                        pw.SizedBox(width: 45),
                        pw.Text("${customerData["Destination"]}"),
                        pw.SizedBox(width: 45),
                        pw.Text("${customerData["Mobile"]}"),
                        pw.SizedBox(width: 45),
                        pw.Text("${customerData["Fare"]}"),
                        pw.SizedBox(width: 45),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Divider(),
                  ],
                ),
              pw.Container(
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text("© Digi Auto"),
                        pw.SizedBox(width:50),
                        pw.Container(
                          width:50,
                          height:50,
                          child: pw.Image(netImage),
                        )
                      ]
                  )
              ),
            ],
          );
        }));

        //for payments
            {
          final PaymentsQuery = await FirebaseFirestore.instance
              .collection("Payments")
              .where("Driver Name", isEqualTo: "${userName}")
              .get();
          print("got the results from db");
          var one = 1;
          for (final paymentDoc in PaymentsQuery.docs) {
            print("For customer one");
            final customerData = paymentDoc.data() as Map<String, dynamic>;
            final paymentsData = paymentDoc["Payment"] as Map<String, dynamic>;
            final yearData = paymentDoc["Payment"]["${year}"] as Map<String, dynamic>;
            final monthData =
            paymentDoc["Payment"]["${year}"]["${month}"] as Map<String, dynamic>;
            final yearTemp = paymentsData.keys.toList();
            final monthTemp = yearData.keys.toList();
            final imageLogo = MemoryImage((await rootBundle.load('assets/images/ins.png')).buffer.asUint8List());


            for (final years in yearTemp) {
              for (final months in monthTemp) {

                pdf.addPage(

                    pw.Page(

                      build: (pw.Context context) {
                        return pw.Column(children: [
                          pw.Text("Payment Data for ${customerData["Customer Name"]}",
                              style: pw.TextStyle(
                                  fontSize: 20, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height:90),

                          //heading for the pdfffff
                          pw.Row(children: [
                            pw.Text("Year",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(
                              width:45,
                            ),
                            pw.Text("Month",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width:45),
                            pw.Text("Amount",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width:45),
                            pw.Text("Payment Date",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width:45),
                            pw.Text("Status",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width:45),
                          ]),
                          pw.SizedBox(height:40),

                          //printing the actual data.....
                          pw.Row(children: [
                            pw.Text("${years.toString()}"),pw.SizedBox(width:45),
                            pw.Text("${months.toString()}"),pw.SizedBox(width:45),
                            pw.Text("${customerData["Payment"]["${years}"]["${months}"]["Amount"]}"),
                            pw.SizedBox(width:45),
                            pw.Text("${customerData["Payment"]["${years}"]["${months}"]["Total Paid Date"]}"),
                            pw.SizedBox(width:45),
                            pw.Text("${customerData["Payment"]["${years}"]["${months}"]["Status"]}"),
                            pw.SizedBox(width:45),
                          ]),
                          pw.SizedBox(height: 10),
                          if(one>=yearTemp.length)
                            pw.Divider(),
                          pw.Container(
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("© Digi Auto"),
                                    pw.SizedBox(width:50),
                                    pw.Container(
                                      width:50,
                                      height:50,
                                      child: pw.Image(netImage),
                                    )
                                  ]
                              )
                          )


                        ]);
                      },

                    )

                );
              }
              one++;
            }

            // Add a page to the PDF
          }
        }

      } else if(payment==true){
        final PaymentsQuery = await FirebaseFirestore.instance
            .collection("Payments")
            .where("Driver Name", isEqualTo: "${userName}")
            .get();
        print("====== got the results from payments db");
        var one = 1;
        for (final paymentDoc in PaymentsQuery.docs) {
          print("For customer one");
          final customerData = paymentDoc.data() as Map<String, dynamic>;
          final paymentsData = paymentDoc["Payment"] as Map<String, dynamic>;
          final yearData = paymentDoc["Payment"]["${year}"] as Map<String, dynamic>;
          final monthData =
          paymentDoc["Payment"]["${year}"]["${month}"] as Map<String, dynamic>;
          final yearTemp = paymentsData.keys.toList();
          final monthTemp = yearData.keys.toList();
          final imageLogo = MemoryImage((await rootBundle.load('assets/images/ins.png')).buffer.asUint8List());


          for (final years in yearTemp) {
            for (final months in monthTemp) {

              pdf.addPage(

                  pw.Page(

                    build: (pw.Context context) {
                      return pw.Column(children: [
                        pw.Text("Payment Data for ${customerData["Customer Name"]}",
                            style: pw.TextStyle(
                                fontSize: 20, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height:90),

                        //heading for the pdfffff
                        pw.Row(children: [
                          pw.Text("Year",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(
                            width:45,
                          ),
                          pw.Text("Month",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(width:45),
                          pw.Text("Amount",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(width:45),
                          pw.Text("Payment Date",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(width:45),
                          pw.Text("Status",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(width:45),
                        ]),
                        pw.SizedBox(height:40),

                        //printing the actual data.....
                        pw.Row(children: [
                          pw.Text("${years.toString()}"),pw.SizedBox(width:45),
                          pw.Text("${months.toString()}"),pw.SizedBox(width:45),
                          pw.Text("${customerData["Payment"]["${years}"]["${months}"]["Amount"]}"),
                          pw.SizedBox(width:45),
                          pw.Text("${customerData["Payment"]["${years}"]["${months}"]["Total Paid Date"]}"),
                          pw.SizedBox(width:45),
                          pw.Text("${customerData["Payment"]["${years}"]["${months}"]["Status"]}"),
                          pw.SizedBox(width:45),
                        ]),
                        pw.SizedBox(height: 10),
                        if(one>=yearTemp.length)
                          pw.Divider(),
                        pw.Container(
                            child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text("© Digi Auto"),
                                  pw.SizedBox(width:50),
                                  pw.Container(
                                    width:50,
                                    height:50,
                                    child: pw.Image(netImage),
                                  )
                                ]
                            )
                        ),


                      ]);
                    },

                  )

              );
            }
            one++;
          }

          // Add a page to the PDF
        }
      }

      else if(customers==true){
        final Customers = await FirebaseFirestore.instance
            .collection("Customers")
            .where("Driver Name", isEqualTo: "${userName}")
            .get();
        print("got the results from db");

        List<Map<String, dynamic>> customerList = [];

        for (final customers in Customers.docs) {
          print("For customer one");
          final customerData = customers.data() as Map<String, dynamic>;
          customerList.add(customerData);
        }

        pdf.addPage(pw.Page(build: (context) {
          return pw.Column(
            children: [
              pw.Text(
                "Customers Data for ${userName}",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 90),
              for (final customerData in customerList)
                pw.Column(
                  children: [

                    //heading for the pdfffff
                    pw.Row(
                      children: [
                        pw.Text("Customer Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 45),
                        pw.Text("Address", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 45),
                        pw.Text("Destination", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 45),
                        pw.Text("Mobile", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 45),
                        pw.Text("Fare", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 45),
                      ],
                    ),
                    pw.SizedBox(height: 40),
                    //actual info
                    pw.Row(
                      children: [
                        pw.Text("${customerData["Customer Name"]}"),
                        pw.SizedBox(width: 45),
                        pw.Text("${customerData["Address"]}"),
                        pw.SizedBox(width: 45),
                        pw.Text("${customerData["Destination"]}"),
                        pw.SizedBox(width: 45),
                        pw.Text("${customerData["Mobile"]}"),
                        pw.SizedBox(width: 45),
                        pw.Text("${customerData["Fare"]}"),
                        pw.SizedBox(width: 45),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Divider(),
                  ],
                ),
              pw.SizedBox(),
              pw.Container(
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text("© Digi Auto"),
                        pw.SizedBox(width:50),
                        pw.Container(
                          width:50,
                          height:50,
                          child: pw.Image(netImage),
                        )
                      ]
                  )
              ),


            ],
          );
        }));
      }

      final documentsDirectory = await getApplicationDocumentsDirectory();

      // Construct the full file path using the path package
      final file = File(p.join(documentsDirectory.path, 'custData.pdf'));


      await file.writeAsBytes(await pdf.save());
      print('PDF created successfully at ${file.path}');

      final pdfFile = File(file.path);
      setState(() {
        isLoading = false;
      });
      if(customers==true || payment==true){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPDFRICK(),));
      }
      await uploadPdfToFirebaseStorage(pdfFile);
      return 1;
    }catch(e){
      showDialog(context:context,builder: (context) {
        return Center(
          child: Container(
            width: 250,
            height:200,
            child: AlertDialog(

              content: Column(
                children: [
                  Text("Error Please try after Some time"),
                  SizedBox(height: 10,),
                  Icon(
                    Icons.error,color: Colors.red,size:50,
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        );
      });
      return 0;

    }




    // Get the app's documents directory


    try {
      // Save the PDF to a file


    } catch (e) {
      print('Error creating PDF: $e');
    }

  }
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

      return userName!;
    } else {
      // Document does not exist
      print('Document with ID  does not exist.');
      return "no data";
    }
  }
  Future<void> openPdfFile() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final filePath = p.join(documentsDirectory.path, 'document.pdf');
      final file = File(filePath);

      // Check if the file exists
      if (await file.exists()) {
        // Open the file using the platform's default app
        await Process.run('open', [file.path]);
      } else {
        print('File not found: $filePath');
      }
    } catch (e) {
      print('Error opening PDF file: $e');
    }
  }

  Future<void> uploadPdfToFirebaseStorage(File file) async {
    try {
      final storage = FirebaseStorage.instance;
      final Reference storageRef =
          storage.ref().child('pdfs').child('document.pdf');

      await storageRef.putFile(file);

      print('PDF uploaded to Firebase Storage');
    } catch (e) {
      print('Error uploading PDF to Firebase Storage: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      month = getCurrentMonth();
      year = getCurrentYear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Backup Information",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Download your Information",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 300,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Select which information you need to backup.",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
              for (var entry in checkboxValues.entries)
                requestedInfoUI(entry.key, entry.value),
              Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                                      width:170,
                                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.black),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: () {
                          createPdf(checkboxValues["Customers Information"],checkboxValues["Payment Information"]);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Request Info"),
                            Icon(Icons.backup),


                          ],
                        )),


                                    ),
                      SizedBox(width: 15,),
                      if (isLoading == true) CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    ],
                  )),

                SizedBox(
                  height: 15,
                ),
              Center(
                  child: Text(
                textAlign: TextAlign.center,
                "Concern Regarding\nInformation?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
              SizedBox(
                height: 10,
              ),
              Center(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey, width: 1.5),
                    ),
                    child: Center(
                        child: Text("Go through our Privacy Page",
                            style: TextStyle(color: Colors.grey))),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_rounded),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(Icons.person),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    child: Image.asset("assets/images/icon.jpg"),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(Icons.security_sharp),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(Icons.data_exploration),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget requestedInfoUI(String heading, bool isChecked) {
    bool isSelectable = true;

    // Define conditions for making entries not selectable
    if (heading=="Personal Information" || heading == "Travel History" || heading == "Reports and Analytics") {
      isSelectable = false;
    }

    return CheckboxListTile(
      side: BorderSide(width: 1, color: Colors.green),
      value: isChecked,
      onChanged: isSelectable
          ? (value) {
        setState(() {
          checkboxValues[heading] = value!;
        });
      }
          : null,
      title: Text("$heading"),
    );
  }
}
