import 'package:flutter/material.dart';

// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewDocument extends StatefulWidget {
  const ViewDocument({super.key});

  @override
  State<ViewDocument> createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  late File pfile;
  bool isLoading = false;

  Future <void>loadNetWorkImage()async{
    setState(() {
      isLoading = true;
    });
    var finalUrl = 'https://morth.nic.in/sites/default/files/dd12-13_0.pdf';
    final response = await http.get(Uri.parse(finalUrl));
    final bytes = response.bodyBytes;
    final fileName = basename(finalUrl);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes,flush: true);
    setState(() {
      pfile=file;
    });

    print(pfile);
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    print("printniggggg");
    loadNetWorkImage();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:SafeArea(
        child:
        isLoading ? Center(child:CircularProgressIndicator()):
            Container(),
    //     Container(
    // //       child: Center(
    // //         child: SfPdfViewer.network('https://www.africau.edu/images/default/sample.pdf',
    // // onDocumentLoadFailed: (c){print(c.description);},
    //         child: PDFView(
    //           filePath: pfile.path,
    //         ),
    // //       ),
    // //     ),
    //     ),

    ));
  }
}
