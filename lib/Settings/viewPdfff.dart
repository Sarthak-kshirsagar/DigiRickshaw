import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class ViewPDFRICK extends StatefulWidget {
  const ViewPDFRICK({super.key});

  @override
  State<ViewPDFRICK> createState() => _ViewPDFRICKState();
}

class _ViewPDFRICKState extends State<ViewPDFRICK> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:[
          IconButton(onPressed: ()async{

          },icon:Icon(Icons.share)),
        ]
      ),
      body:PDFView(
        filePath: '/data/user/0/com.example.rickshaw2/app_flutter/custData.pdf',
      ),
    );
  }
}
