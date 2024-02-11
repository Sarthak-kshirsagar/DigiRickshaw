import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
class GetPathForreceipt extends StatefulWidget {
  const GetPathForreceipt({super.key});

  @override
  State<GetPathForreceipt> createState() => _GetPathForreceiptState();
}

class _GetPathForreceiptState extends State<GetPathForreceipt> {
  Future<Directory?>? _tempDirectory;
  String? _tempDirectoryPath;
  void _requestTempDirectory() async {
    try {
      Directory? tempDir = await getDownloadsDirectory();
      setState(() {
        _tempDirectoryPath = tempDir!.path;
      });
    } catch (e) {
      // Handle any errors that occurred during the process
      print('Error getting temporary directory: $e');
    }
    print("${_tempDirectoryPath} hi");
  }
  final String contactNumber="+919850144361";

  // Future<void> createAndSharePdf() async {
  //
  //   final pdf = pw.Document();
  //
  //   // Add your PDF content here...
  //
  //   // Save the PDF to a temporary file
  //   final directory = await getDownloadsDirectory();
  //   final path = '${directory!.path}/final_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
  //   final file = File(path);
  // print("printing the file path ${file.path}");
  //   final bytes = await pdf.save();
  //   print("pdf saved at:---${path}");
  //   await file.writeAsBytes(bytes);
  //   final Uri url = Uri.parse('whatsapp://send?phone=9823559899&text=Please check this PDF!&document=file://${path}');
  //   _launchUrl(url);
  //   // Open WhatsApp with the contact number and share the file
  //   // final whatsappUrl = 'whatsapp://send?phone=${contactNumber}&text=Please check this PDF!';
  //   // try{
  //   //   if (await canLaunchUrlString(whatsappUrl)) {
  //   //     await launchUrlString(whatsappUrl);
  //   //   }
  //   // }catch(e){
  //   //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   //     content: Text('WhatsApp is not installed or not accessible.+${e}'),
  //   //   ));
  //   // }
  //
  // }
  // Future<bool> requestStoragePermission() async {
  //   // Check if storage permission has already been granted
  //   final permissionStatus = await Permission.storage.status;
  //   if (permissionStatus == PermissionStatus.granted) {
  //     return true; // Permission already granted
  //   }
  //
  //   // Request storage permission
  //   final permissionResult = await Permission.storage.request();
  //
  //   // Return true if permission granted, false otherwise
  //   return permissionResult == PermissionStatus.granted;
  // }

  // final Uri _url = Uri.parse('whatsapp://send?phone=9823559899&text=Please check this PDF!');
  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

@override


  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){

                // _requestTempDirectory();
                // createAndSharePdf();
                // _launchUrl();
        
              }, child:Text("Press mii")),
              Text("${_tempDirectoryPath}"),

            ],
          ),
        ),
      ),
    );
  }
}
