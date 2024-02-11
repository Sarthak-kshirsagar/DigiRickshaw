// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// // import 'package:flutter_PDFVIEWSCREEEN/flutter_PDFVIEWSCREEEN.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
//
// class PDFVIEWSCREEEN extends StatefulWidget {
//   const PDFVIEWSCREEEN({super.key});
//
//   @override
//   State<PDFVIEWSCREEEN> createState() => _PDFVIEWSCREEENState();
// }
//
// class _PDFVIEWSCREEENState extends State<PDFVIEWSCREEEN> {
//   String pathPDF = "";
//
//
//    File? pfile;
//   bool isLoading = false;
//
//   Future <void>loadNetWorkImage()async{
//     setState(() {
//       isLoading = true;
//     });
//     var finalUrl = 'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf';
//     final response = await http.get(Uri.parse(finalUrl));
//     final bytes = response.bodyBytes;
//     final fileName = basename(finalUrl);
//     final dir = await getApplicationDocumentsDirectory();
//     var file = File('${dir.path}/$fileName');
//     await file.writeAsBytes(bytes,flush: true);
//     setState(() {
//       pfile=file;
//     });
//
//     print(pfile);
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//
//
//   //gpt code
//   Future<File> fromPath(String filePath, String filename) async {
//     Completer<File> completer = Completer();
//     try {
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/$filename");
//
//       // Read the file from the specified path
//       var bytes = await File(filePath).readAsBytes();
//
//       // Write the bytes to the new file
//       await file.writeAsBytes(bytes, flush: true);
//
//       completer.complete(file);
//     } catch (e) {
//       throw Exception('Error reading or writing file!');
//     }
//
//     return completer.future;
//   }
//   @override
//   void initState() {
//     super.initState();
//     loadNetWorkImage().then((_) {
//       fromPath(pfile!.path, 'dog.pdf').then((f) {
//         setState(() {
//           pathPDF = f.path;
//         });
//       });
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment:MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//       Stack(
//         children:[
//           if(isLoading)Center(child: CircularProgressIndicator()),
//           if(pathPDF.isNotEmpty)
//           Center(
//             child: ElevatedButton(onPressed: (){
//
//               Navigator.push(context, MaterialPageRoute(builder: (context) =>pdfff(path: pathPDF,),));
//
//                     }, child: Text("Press the button to open pdf")),
//           ),
//
//
//         ]
//       ),
//         ],
//       ),
//     );
//   }
// }
//
// class pdfff extends StatefulWidget {
//   final String? path;
//
//   const pdfff({Key? key, this.path}) : super(key: key);
//
//   @override
//   _pdfffState createState() => _pdfffState();
// }
//
// class _pdfffState extends State<pdfff> with WidgetsBindingObserver {
//   final Completer<PDFViewController> _controller =
//   Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//               ? const Center(
//             child: CircularProgressIndicator(),
//           )
//               : Container()
//               : Center(
//             child: Text(errorMessage + "${widget.path}"),
//           )
//         ],
//       ),
//     );
//   }
// }
// =====================================================

// ================================working==========================
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
// class PDFVIEWSCREEEN extends StatefulWidget {
//   const PDFVIEWSCREEEN({Key? key}) : super(key: key);
//
//   @override
//   State<PDFVIEWSCREEEN> createState() => _PDFVIEWSCREEENState();
// }
//
// class _PDFVIEWSCREEENState extends State<PDFVIEWSCREEEN> {
//   String pathPDF = "";
//   File? pfile;
//   bool isLoading = false;
//
//   Future<void> loadNetworkImage() async {
//     setState(() {
//       isLoading = true;
//     });
//     var finalUrl = 'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf';
//     final fileName = basename(finalUrl);
//     final dir = await getApplicationDocumentsDirectory();
//     var file = File('${dir.path}/$fileName');
//
//     if (!file.existsSync()) {
//       final response = await http.get(Uri.parse(finalUrl));
//       final bytes = response.bodyBytes;
//       await file.writeAsBytes(bytes, flush: true);
//     }
//
//     setState(() {
//       pfile = file;
//     });
//
//     print(pfile);
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<File> fromPath(String filePath, String filename) async {
//     Completer<File> completer = Completer();
//     try {
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/$filename");
//
//       // Read the file from the specified path
//       var bytes = await File(filePath).readAsBytes();
//
//       // Write the bytes to the new file
//       await file.writeAsBytes(bytes, flush: true);
//
//       completer.complete(file);
//     } catch (e) {
//       throw Exception('Error reading or writing file!');
//     }
//
//     return completer.future;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadNetworkImage().then((_) {
//       fromPath(pfile!.path, 'dog.pdf').then((f) {
//         setState(() {
//           pathPDF = f.path;
//         });
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Stack(
//             children: [
//               if (isLoading) Center(child: CircularProgressIndicator()),
//               if (pathPDF.isNotEmpty)
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => pdfff(path: pathPDF)),
//                       );
//                     },
//                     child: Text("Press the button to open pdf"),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class pdfff extends StatefulWidget {
//   final String? path;
//
//   const pdfff({Key? key, this.path}) : super(key: key);
//
//   @override
//   _pdfffState createState() => _pdfffState();
// }
//
// class _pdfffState extends State<pdfff> with WidgetsBindingObserver {
//   final Completer<PDFViewController> _controller = Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//               ? const Center(
//             child: CircularProgressIndicator(),
//           )
//               : Container()
//               : Center(
//             child: Text(errorMessage + "${widget.path}"),
//           )
//         ],
//       ),
//     );
//   }
// }


// ==============================new code=======================

// =========working great============================
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
// class PDFVIEWSCREEEN extends StatefulWidget {
//   const PDFVIEWSCREEEN({Key? key}) : super(key: key);
//
//   @override
//   State<PDFVIEWSCREEEN> createState() => _PDFVIEWSCREEENState();
// }
//
// class _PDFVIEWSCREEENState extends State<PDFVIEWSCREEEN> {
//   Map<String, File?> pdfFiles = {};
//   bool isLoading = false;
//
//   Future<void> loadNetworkImage(String url) async {
//     setState(() {
//       isLoading = true;
//     });
//
//     await _downloadFile(url);
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<void> _downloadFile(String url) async {
//     var fileName = basename(url);
//     var dir = await getApplicationDocumentsDirectory();
//     var file = File('${dir.path}/$fileName');
//
//     if (!file.existsSync()) {
//       final response = await http.get(Uri.parse(url));
//       final bytes = response.bodyBytes;
//       await file.writeAsBytes(bytes, flush: true);
//     }
//
//     setState(() {
//       pdfFiles[url] = file;
//     });
//   }
//
//   Future<File> fromPath(String filePath, String filename) async {
//     Completer<File> completer = Completer();
//     try {
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/$filename");
//
//       // Read the file from the specified path
//       var bytes = await File(filePath).readAsBytes();
//
//       // Write the bytes to the new file
//       await file.writeAsBytes(bytes, flush: true);
//
//       completer.complete(file);
//     } catch (e) {
//       throw Exception('Error reading or writing file!');
//     }
//
//     return completer.future;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     var urls = [
//       'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf',
//       'https://www.africau.edu/images/default/sample.pdf',
//     ];
//
//     for (var url in urls) {
//       pdfFiles[url] = null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Column(
//             children: [
//               if (isLoading) Center(child: CircularProgressIndicator()),
//               for (var url in pdfFiles.keys)
//                 Center(
//                   child: Column(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           if (pdfFiles[url] == null) {
//                             loadNetworkImage(url);
//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => pdfff(path: pdfFiles[url]!.path),
//                               ),
//                             );
//                           }
//                         },
//                         child: Text(pdfFiles[url] == null
//                             ? "Download PDF (${basename(url)})"
//                             : "Open PDF (${basename(url)})"),
//                       ),
//
//                       SizedBox(height: 20,),
//                     ],
//                   ),
//                 ),
//
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class pdfff extends StatefulWidget {
//   final String? path;
//
//   const pdfff({Key? key, this.path}) : super(key: key);
//
//   @override
//   _pdfffState createState() => _pdfffState();
// }
//
// class _pdfffState extends State<pdfff> with WidgetsBindingObserver {
//   final Completer<PDFViewController> _controller = Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//               ? const Center(
//             child: CircularProgressIndicator(),
//           )
//               : Container()
//               : Center(
//             child: Text(errorMessage + "${widget.path}"),
//           )
//         ],
//       ),
//     );
//   }
// }
// ======to check that it is downloaded ot not ====
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
// class PDFVIEWSCREEEN extends StatefulWidget {
//   const PDFVIEWSCREEEN({Key? key}) : super(key: key);
//
//   @override
//   State<PDFVIEWSCREEEN> createState() => _PDFVIEWSCREEENState();
// }
//
// class _PDFVIEWSCREEENState extends State<PDFVIEWSCREEEN> {
//   Map<String, File?> pdfFiles = {};
//   bool isLoading = false;
//
//   Future<void> loadNetworkImage(String url) async {
//     setState(() {
//       isLoading = true;
//     });
//
//     await _downloadOrLoadFile(url);
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<void> _downloadOrLoadFile(String url) async {
//     var fileName = basename(url);
//     var dir = await getApplicationDocumentsDirectory();
//     var file = File('${dir.path}/$fileName');
//
//     if (!file.existsSync()) {
//       await _downloadFile(url, file);
//     }
//
//     setState(() {
//       pdfFiles[url] = file;
//     });
//   }
//
//   Future<void> _downloadFile(String url, File file) async {
//     final response = await http.get(Uri.parse(url));
//     final bytes = response.bodyBytes;
//     await file.writeAsBytes(bytes, flush: true);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     var urls = [
//       'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf',
//       'https://example.com/second-file.pdf',
//     ];
//
//     for (var url in urls) {
//       pdfFiles[url] = null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Stack(
//             children: [
//               if (isLoading) Center(child: CircularProgressIndicator()),
//               for (var url in pdfFiles.keys)
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (pdfFiles[url] == null) {
//                         loadNetworkImage(url);
//                       } else {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => pdfff(path: pdfFiles[url]!.path),
//                           ),
//                         );
//                       }
//                     },
//                     child: Text(pdfFiles[url] == null
//                         ? "Download PDF (${basename(url)})"
//                         : "Open PDF (${basename(url)})"),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class pdfff extends StatefulWidget {
//   final String? path;
//
//   const pdfff({Key? key, this.path}) : super(key: key);
//
//   @override
//   _pdfffState createState() => _pdfffState();
// }
//
// class _pdfffState extends State<pdfff> {
//   final Completer<PDFViewController> _controller = Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//               ? const Center(
//             child: CircularProgressIndicator(),
//           )
//               : Container()
//               : Center(
//             child: Text(errorMessage + "${widget.path}"),
//           )
//         ],
//       ),
//     );
//   }
// }




// ======== working greatttttt final===========



// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
// class PDFVIEWSCREEEN extends StatefulWidget {
//   const PDFVIEWSCREEEN({Key? key}) : super(key: key);
//
//   @override
//   State<PDFVIEWSCREEEN> createState() => _PDFVIEWSCREEENState();
// }
//
// class _PDFVIEWSCREEENState extends State<PDFVIEWSCREEEN> {
//   Map<String, File?> pdfFiles = {};
//   bool isLoading = false;
//
//   Future<void> loadNetworkImage(String url) async {
//     setState(() {
//       isLoading = true;
//     });
//
//     await _downloadOrLoadFile(url);
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<void> _downloadOrLoadFile(String url) async {
//     var fileName = basename(url);
//     var dir = await getApplicationDocumentsDirectory();
//     var file = File('${dir.path}/$fileName');
//
//     if (!file.existsSync()) {
//       await _downloadFile(url, file);
//     }
//
//     setState(() {
//       pdfFiles[url] = file;
//     });
//   }
//
//   Future<void> _downloadFile(String url, File file) async {
//     final response = await http.get(Uri.parse(url));
//     final bytes = response.bodyBytes;
//     await file.writeAsBytes(bytes, flush: true);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     var urls = [
//       'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf',
//       'https://morth.nic.in/sites/default/files/dd12-13_0.pdf',
//     ];
//
//     for (var url in urls) {
//       pdfFiles[url] = null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Column(
//             children: [
//               if (isLoading) Center(child: CircularProgressIndicator()),
//               for (var url in pdfFiles.keys)
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (pdfFiles[url] == null) {
//                         loadNetworkImage(url);
//                       } else {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => pdfff(path: pdfFiles[url]!.path),
//                           ),
//                         );
//                       }
//                     },
//                     child: Text(pdfFiles[url] == null
//                         ? "Download PDF (${basename(url)})"
//                         : "Open PDF (${basename(url)})"),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class pdfff extends StatefulWidget {
//   final String? path;
//
//   const pdfff({Key? key, this.path}) : super(key: key);
//
//   @override
//   _pdfffState createState() => _pdfffState();
// }
//
// class _pdfffState extends State<pdfff> {
//   final Completer<PDFViewController> _controller = Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//               ? const Center(
//             child: CircularProgressIndicator(),
//           )
//               : Container()
//               : Center(
//             child: Text(errorMessage + "${widget.path}"),
//           )
//         ],
//       ),
//     );
//   }
// }



// =================== for the last time===============
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFVIEWSCREEEN extends StatefulWidget {
  const PDFVIEWSCREEEN({Key? key}) : super(key: key);

  @override
  State<PDFVIEWSCREEEN> createState() => _PDFVIEWSCREEENState();
}

class _PDFVIEWSCREEENState extends State<PDFVIEWSCREEEN> {
  Map<String, File?> pdfFiles = {};
  bool isLoading = false;

  Future<void> loadNetworkImage(String url) async {
    setState(() {
      isLoading = true;
    });

    await _downloadOrLoadFile(url);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _downloadOrLoadFile(String url) async {
    var fileName = basename(url);
    var dir = await getExternalStorageDirectory();
    var file = File('${dir?.path}/$fileName');
    print("aiphf ${dir?.path}");

    if (!file.existsSync()) {
      await _downloadFile(url, file);
    }

    setState(() {
      pdfFiles[url] = file;
    });
  }

  Future<void> _downloadFile(String url, File file) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    await file.writeAsBytes(bytes, flush: true);
  }
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
  Future<void> fetchUrlsForDriverFromFirebase() async {
    String  currentUser = await fetchCurrentUserName();
    // Initialize Firebase
    await FirebaseFirestore.instance
        .collection('StoredDocuments')
        .where('DriverName', isEqualTo: "${currentUser}")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var url1 = doc['InsURL'];
        var url2 = doc['LICURL'];
        print(url1);
        print(url2);
        // Check if URLs are not null or empty before adding to pdfFiles
        if (url1 != null && url1.isNotEmpty) {
          setState(() {
            //new added at 17th night
            pdfFiles.clear();
            pdfFiles[url1] = null;
          });
          print("url added inside1");
        }

        if (url2 != null && url2.isNotEmpty) {
          setState(() {
            pdfFiles[url2] = null;
          });
          print("url2 added");

        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUrlsForDriverFromFirebase();
    print(pdfFiles);
    // var urls = [
    //   'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf',
    //   'https://morth.nic.in/sites/default/files/dd12-13_0.pdf',
    // ];

    // for (var url in urls) {
    //   pdfFiles[url] = null;
    // }
  }
Future <void> onRefresh()async{
    await fetchUrlsForDriverFromFirebase();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: RefreshIndicator(child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [

              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("View Documents",style: TextStyle(fontSize:22,fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.safety_check,size:35,color: Colors.green),
                      SizedBox(width:10,),
                      Text("Securely stored on our Cloud",style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text("Easily access All your Documents"),
                  SizedBox(height: 20,),
                  Text("Please turn on Internet \nif using for First Time",style: TextStyle(color: Colors.grey)),

                  Column(
                    children: [
                      if (isLoading) Center(child: CircularProgressIndicator()),
                      // for (var url in pdfFiles.keys)
                      //   Center(
                      //     child: ElevatedButton(
                      //       onPressed: () {
                      //         if (pdfFiles[url] == null) {
                      //           loadNetworkImage(url);
                      //         } else {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => pdfff(path: pdfFiles[url]!.path),
                      //             ),
                      //           );
                      //         }
                      //       },
                      //       child: Text(pdfFiles[url] == null
                      //           ? "Download License"
                      //           : "Open License"),
                      //     ),
                      //   ),
                      if (!isLoading && pdfFiles.isNotEmpty)
                        Container(
                          height:250,
                          child: ListView.builder(
                            itemCount:pdfFiles.keys.length,
                            itemBuilder: (context, index) {
                              var url = pdfFiles.keys.elementAt(index);
                              var buttonText = index == 0 ? 'License' : 'Insurance';
                              String disImg = index== 0 ? 'assets/images/licen.jpg' : 'assets/images/ins.png';
                              return Column(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(child: Image.asset("${disImg}",width:80),),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (pdfFiles[url] == null) {
                                                loadNetworkImage(url);
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => pdfff(path: pdfFiles[url]!.path),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(pdfFiles[url] == null
                                                ? "Download ${buttonText}"
                                                : "Open ${buttonText}"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height:20,),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          )), onRefresh: onRefresh))
    );
  }


}

class pdfff extends StatefulWidget {
  final String? path;

  const pdfff({Key? key, this.path}) : super(key: key);

  @override
  _pdfffState createState() => _pdfffState();
}

class _pdfffState extends State<pdfff> {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
        actions: <Widget>[

        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
          ),
          errorMessage.isEmpty
              ? !isReady
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage + "${widget.path}"),
          )
        ],
      ),
    );
  }
}