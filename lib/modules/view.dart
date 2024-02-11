// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:pdfx/pdfx.dart';
//
// class ViewPDF extends StatefulWidget {
//   const ViewPDF({super.key});
//
//   @override
//   State<ViewPDF> createState() => _ViewPDFState();
// }
//
// class _ViewPDFState extends State<ViewPDF> {
//   late PdfControllerPinch pdfControllerPinch;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openAsset('assets/images/pdf.pdf'));
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:Expanded(
//         child:PdfViewPinch(controller: pdfControllerPinch),
//       ) ,
//
//     );;
//   }
// }
