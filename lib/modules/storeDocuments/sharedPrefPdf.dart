// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:rickshaw2/modules/storeDocuments/finalPdf.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPDFSCREEN extends StatefulWidget {
//   const SharedPDFSCREEN({Key? key}) : super(key: key);
//
//   @override
//   State<SharedPDFSCREEN> createState() => _SharedPDFSCREENState();
// }
//
// class _SharedPDFSCREENState extends State<SharedPDFSCREEN> {
//   String pathPDF = "";
//   File? pfile;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     checkDownloadedFiles();
//   }
//
//   Future<void> checkDownloadedFiles() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool filesDownloaded = prefs.getBool('filesDownloaded') ?? false;
//
//     if (!filesDownloaded) {
//       await downloadAndStoreFiles();
//       prefs.setBool('filesDownloaded', true);
//     } else {
//       loadLocalFiles();
//     }
//   }
//
//   Future<void> downloadAndStoreFiles() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       var finalUrl =
//           'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf';
//       final response = await http.get(Uri.parse(finalUrl));
//       final bytes = response.bodyBytes;
//       final fileName = basename(finalUrl);
//       final dir = await getApplicationDocumentsDirectory();
//       var file = File('${dir.path}/$fileName');
//       await file.writeAsBytes(bytes, flush: true);
//       setState(() {
//         pfile = file;
//       });
//     } catch (e) {
//       print('Error loading PDF: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> loadLocalFiles() async {
//     try {
//       var finalUrl =
//           'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf';
//       final dir = await getApplicationDocumentsDirectory();
//       var fileName = basename(finalUrl);
//       var file = File('${dir.path}/$fileName');
//
//       if (await file.exists()) {
//         setState(() {
//           pfile = file;
//         });
//       } else {
//         // Handle the case where the local file doesn't exist (maybe it was deleted)
//         print('Local file does not exist.');
//       }
//     } catch (e) {
//       // Handle any potential errors
//       print('Error loading local file: $e');
//     }
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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (isLoading)
//             CircularProgressIndicator()
//           else
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PDFScreen(path: pfile?.path ?? ''),
//                   ),
//                 );
//               },
//               child: Text("Press the button to open pdf"),
//             ),
//         ],
//       ),
//     );
//   }
// }


// ==========================================================================

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rickshaw2/modules/storeDocuments/finalPdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPDFSCREEN extends StatefulWidget {
  const SharedPDFSCREEN({Key? key}) : super(key: key);

  @override
  State<SharedPDFSCREEN> createState() => _SharedPDFSCREENState();
}

class _SharedPDFSCREENState extends State<SharedPDFSCREEN> {
  // List<File?> pfiles = List.generate(2, (index) => null);
  // bool isLoading = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   checkDownloadedFiles();
  // }

  // Future<void> checkDownloadedFiles() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var filesToDownload = [
  //     {
  //       'url': 'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf',
  //       'filename': 'dog.pdf',
  //     },
  //     {
  //       'url': 'https://tourism.gov.in/sites/default/files/2019-04/dummy-pdf_2.pdf',
  //       'filename': 'dummy.pdf',
  //     },
  //     // Add more files as needed
  //   ];
  //
  //   for (var fileInfo in filesToDownload) {
  //     var fileDownloadedKey = 'fileDownloaded_${fileInfo['filename']}';
  //     bool fileDownloaded = prefs.getBool(fileDownloadedKey) ?? false;
  //
  //     if (!fileDownloaded) {
  //       print("files are not downloaded");
  //       await downloadAndStoreFile(fileInfo['url'].toString(), fileInfo['filename'].toString());
  //       prefs.setBool(fileDownloadedKey, true);
  //     }
  //   }
  //
  //   loadLocalFiles();
  // }
  //
  // Future<void> downloadAndStoreFile(String url, String filename) async {
  //   print("entered to downlaod");
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //     final response = await http.get(Uri.parse(url));
  //     final bytes = response.bodyBytes;
  //
  //     var dir = await getApplicationDocumentsDirectory();
  //     var file = File('${dir.path}/$filename');
  //     await file.writeAsBytes(bytes, flush: true);
  //
  //     setState(() {
  //       pfiles.add(file);
  //       print("file added");
  //     });
  //   } catch (e) {
  //     print('Error downloading and storing file: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  //
  // Future<void> loadLocalFiles() async {
  //
  //   try {
  //     var filesToLoad = [
  //       {
  //         'url': 'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf',
  //         'filename': 'dog.pdf',
  //       },
  //       {
  //         'url': 'https://tourism.gov.in/sites/default/files/2019-04/dummy-pdf_2.pdf',
  //         'filename': 'dummy.pdf',
  //       },
  //       // Add more files as needed
  //     ];
  //
  //     for (var fileInfo in filesToLoad) {
  //       var dir = await getApplicationDocumentsDirectory();
  //       var fileName = fileInfo['filename'];
  //       var file = File('${dir.path}/$fileName');
  //
  //       if (await file.exists()) {
  //         setState(() {
  //           pfiles.add(file);
  //           print("file added in list");
  //         });
  //       } else {
  //         // Handle the case where the local file doesn't exist (maybe it was deleted)
  //         print('Local file $fileName does not exist.');
  //         await downloadAndStoreFile(fileInfo['url'].toString(), fileName.toString());
  //         // prefs.setBool(fileDownloadedKey, true);
  //
  //       }
  //     }
  //   } catch (e) {
  //     // Handle any potential errors
  //     print('Error loading local files: $e');
  //   }
  // }


  // ======working code===========

  List<File?> pfiles = List.generate(2, (index) => null);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkDownloadedFiles();
  }

  Future<void> checkDownloadedFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool filesDownloaded = prefs.getBool('filesDownloaded') ?? false;

    if (!filesDownloaded) {
      await downloadAndStoreFiles();
      prefs.setBool('filesDownloaded', true);
    } else {
      loadLocalFiles();
    }
  }

  Future<void> downloadAndStoreFiles() async {
    setState(() {
      isLoading = true;
    });

    try {
      var urls = [
        'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf',
        'https://tourism.gov.in/sites/default/files/2019-04/dummy-pdf_2.pdf',
      ];

      for (var i = 0; i <2; i++) {
        var finalUrl = urls[i];
        final response = await http.get(Uri.parse(finalUrl));
        final bytes = response.bodyBytes;
        final fileName = basename(finalUrl);
        final dir = await getApplicationDocumentsDirectory();
        var file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          pfiles[i] = file;
        });
      }
    } catch (e) {
      print('Error loading PDF: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    // await loadLocalFiles();
  }

  Future<void> loadLocalFiles() async {
    try {
      var urls = [
        'https://www.dogdoors.com/wp-content/uploads/2017/10/Dog-breed-book-low-resolution.pdf',
        'https://www.example.com/another-file.pdf',
      ];

      for (var i = 0; i < urls.length; i++) {
        var finalUrl = urls[i];
        var dir = await getApplicationDocumentsDirectory();
        var fileName = basename(finalUrl);
        var file = File('${dir.path}/$fileName');

        if (await file.exists()) {
          setState(() {
            pfiles[i] = file;
          });
          print("local file exists at ${pfiles[i]}");
        } else {
          // Handle the case where the local file doesn't exist (maybe it was deleted)
          print('Local file $i does not exist.');
          // await downloadAndStoreFiles();
        }
      }
    } catch (e) {
      // Handle any potential errors
      print('Error loading local files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            CircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: () {
                // Assuming you want to navigate to a screen to view the PDFs
                // this is working
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFScreen(paths: pfiles.map((file) => file?.path ?? '').toList()),
                  ),
                );

                // ==new
                // Navigator.push(context, MaterialPageRoute(builder: (context) => PDFScreen(paths: pfiles,));
              },
              child: Text("Press the button to open pdf"),
            ),
        ],
      ),
    );
  }
}

// ==========working code=========================
class PDFScreen extends StatefulWidget {
  final List<String> paths;

  const PDFScreen({Key? key, required this.paths}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
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
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: widget.paths.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return PDFView(
                filePath: widget.paths[index],
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
              );
            },
          ),
          errorMessage.isEmpty
              ? !isReady
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          )
        ],
      ),
    );
  }
}

// ==================================other code======================

//
// =====not working===
// class PDFListScreen extends StatelessWidget {
//   final List<File?> pdfPaths;
//
//   PDFListScreen({required this.pdfPaths});
//
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("PDF List"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PDFScreen(pdfIndex: 0, pdfPaths:pdfPaths!),
//                   ),
//                 );
//               },
//               child: Text("Open PDF 1"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PDFScreen(pdfIndex: 1, pdfPaths: pdfPaths),
//                   ),
//                 );
//               },
//               child: Text("Open PDF 2"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class PDFScreen extends StatefulWidget {
//   final int pdfIndex;
//   final List<File?> pdfPaths;
//
//   const PDFScreen({Key? key, required this.pdfIndex, required this.pdfPaths}) : super(key: key);
//
//   @override
//   _PDFScreenState createState() => _PDFScreenState();
// }
//
// class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
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
//             filePath: widget.pdfPaths[widget.pdfIndex].toString().trim(),
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
//             child: Text(errorMessage),
//           )
//         ],
//       ),
//     );
//   }
// }
//
//
//
// =======================================================================
// ==========updaetd not working ========
// class PDFScreen extends StatefulWidget {
//   final List<String> paths;
//
//   const PDFScreen({Key? key, required this.paths}) : super(key: key);
//
//   @override
//   _PDFScreenState createState() => _PDFScreenState();
// }
//
// class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
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
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               _openPDF(context,0);
//             },
//             child: Text("Open PDF 1"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _openPDF(context,1);
//             },
//             child: Text("Open PDF 2"),
//           ),
//           if (errorMessage.isNotEmpty)
//             Center(
//               child: Text(errorMessage),
//             ),
//         ],
//       ),
//     );
//   }
//   Future<void> _openPDF(BuildContext context,int index) async {
//     try {
//       setState(() {
//         isReady = false;
//         errorMessage = '';
//       });
//
//       var path = widget.paths[index];
//       print(path);
//       Navigator.push(context, MaterialPageRoute(builder: (context) =>pdfff(path: path),));
//       // Navigator.push(
//       //   context as BuildContext,
//       //   MaterialPageRoute(
//       //     builder: (context) => PDFViewScreen(filePath: path),
//       //   ),
//       // );
//     } catch (e) {
//       print('Error opening PDF: $e');
//     }
//   }
//
// }
//
// class PDFViewScreen extends StatefulWidget {
//   final String filePath;
//
//   const PDFViewScreen({Key? key, required this.filePath}) : super(key: key);
//
//   @override
//   _PDFViewScreenState createState() => _PDFViewScreenState();
// }
//
// class _PDFViewScreenState extends State<PDFViewScreen> {
//   final Completer<PDFViewController> _controller =
//   Completer<PDFViewController>();
//
//   @override
//   Widget build(BuildContext context) {
//
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
//             filePath: widget.filePath,
//             onRender: (_pages) {
//               // Handle rendering callback if needed
//               print("Rendered $_pages pages");
//
//             },
//             onError: (error) {
//               // Handle error callback if needed
//               print("Error: $error");
//             },
//             onPageError: (page, error) {
//               // Handle page error callback if needed
//               print("Page $page: $error");
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

