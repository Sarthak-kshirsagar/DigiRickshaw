import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rickshaw2/modules/storeDocuments/finalPdf.dart';
import 'package:rickshaw2/modules/storeDocuments/viewDocuments.dart';
import 'package:rickshaw2/modules/view.dart';

// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class UploadToCloud extends StatefulWidget {
  const UploadToCloud({super.key});

  @override
  State<UploadToCloud> createState() => _UploadToCloudState();
}

class _UploadToCloudState extends State<UploadToCloud>
    with SingleTickerProviderStateMixin {
  bool isFilePickingLic = false;
  bool isFilePickingIns = false;
  PlatformFile? pickedFileLic;
  String fileNameForLic = "Please Select File";
  String fileNameForIns = "Please Select File";
  PlatformFile? pickedFileIns;
  late TabController _tabController;

  String downloadLinkForLic = "";
  String downloadLinkForIns = "";
  bool isUploadingLic = false;
  bool isUploadingIns = false;
  double uploadProgress = 0.0;
  bool pickFileButton = true;
  bool isTickedLic = false;
  bool isTickedIns = false;
  //to get the lic document
  Future uploadFileOfLic() async {
    if (pickedFileLic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 20,
              left: 20),
          content: Text('Please select a file.'),
          duration: Duration(seconds: 2),
        ),
      );
      return print("select filw");
    } else {
      setState(() {
        isUploadingLic = true;
        uploadProgress = 0.0;
        pickFileButton = false;
      });
      final currentUSer = await fetchCurrentUserName();
      final path = '${currentUSer}/${pickedFileLic!.name}';
      final file = File(pickedFileLic!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);
      uploadTask.snapshotEvents.listen((event) {
        uploadProgress = event.bytesTransferred / event.totalBytes;
      });

      await uploadTask.whenComplete(() {
        setState(() {
          isUploadingLic = false;
          uploadProgress = 0.0;
          pickFileButton = true;
          isTickedLic = true;

        });
      });
      print("uploadedd filee");
      String downloadUrl = await ref.getDownloadURL();
      print(downloadUrl);
      setState(() {
        downloadLinkForLic = downloadUrl;
      });

      addDownloadUrlToDb();
      print("url uploaded");
    }
  }
// ========to upload the file of ins
  Future uploadFileOfIns() async {
    if (pickedFileIns == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 20,
              left: 20),
          content: Text('Please select a file.'),
          duration: Duration(seconds: 2),
        ),
      );
      return print("select filw");
    }else{
      setState(() {
        isUploadingIns = true;
        uploadProgress = 0.0;
        pickFileButton = false;
      });
    final currentUSer = await fetchCurrentUserName();
    final path = '${currentUSer}/${pickedFileIns!.name}';
    final file = File(pickedFileIns!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);
    //track the progres of uplaod
    uploadTask.snapshotEvents.listen((event) {
      uploadProgress = event.bytesTransferred / event.totalBytes;
    });

    await uploadTask.whenComplete(() {
      setState(() {
        isUploadingIns = false;
        uploadProgress = 0.0;
        pickFileButton = true;
        isTickedIns = true;
      });
    });
    print(ref.getDownloadURL());
    String urlForIns = await ref.getDownloadURL();
    setState(() {
      downloadLinkForIns = urlForIns;

    });
    addDownloadUrlToDb();
  }
  }

  Future selectFileForLic() async {
    setState(() {
      isFilePickingLic = true;


    });
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) {
      setState(() {
        isFilePickingLic = false;

      });

    }
    setState(() {
      pickedFileLic = result?.files.first;
      isFilePickingLic = false;
      fileNameForLic = pickedFileLic!.name.substring(0, 8);
    });


  }

  Future selectFileForIns() async {
    setState(() {
      isFilePickingIns = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Specify your allowed file extensions here
      );

      if (result != null) {
        // File picked successfully
        setState(() {
          pickedFileIns = result.files.first;
          fileNameForIns = pickedFileIns!.name.substring(0, 8);
          isFilePickingIns = false;
        });
      } else {
        // User canceled file picking
        setState(() {
          isFilePickingIns = false;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Valid file")));
      setState(() {
        isFilePickingIns = false;
      });
    }
  }

  String currentUserName = "";
  Future<String> fetchCurrentUserName() async {
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

  Future addDownloadUrlToDb() async {
    String currentUserName = await fetchCurrentUserName();
    print("${currentUserName}");
    final db = await FirebaseFirestore.instance.collection("StoredDocuments");
    final query = await FirebaseFirestore.instance
        .collection("StoredDocuments")
        .where("DriverName", isEqualTo: "${currentUserName}");
    QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      String documentId = snapshot.docs.first.id;
      await db.doc(documentId).update({
        "LICURL": "${downloadLinkForLic}",
        "InsURL": "${downloadLinkForIns}",
      });
      print("updated donwload urls");
    } else {
      print("no docs found");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  flexibleSpace: Column(
                    children: [
                      TabBar(controller: _tabController, tabs: [
                        Tab(child: Icon(Icons.upload_file)),
                        Tab(
                          child: Icon(Icons.document_scanner_outlined),
                        ),
                      ]),
                    ],
                  ),
                  automaticallyImplyLeading: false,
                ),
                body: TabBarView(controller: _tabController, children: [
                  uploadPdfUi(selectFileForLic,uploadFileOfLic,selectFileForIns,uploadFileOfIns),
                  PDFVIEWSCREEEN(),
                ]),
              ))),
    );
  }

  // Widget uploadPdfUi(){
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //
  //           child: Container(
  //
  //             decoration: BoxDecoration(
  //               // border: Border.all(color: Colors.grey,width: 2),
  //                 borderRadius: BorderRadius.circular(25),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey,
  //                     // offset:Offset(1, 2),
  //                     blurStyle: BlurStyle.outer,
  //                     spreadRadius:5,
  //                     blurRadius: 5,
  //                   )
  //                 ]
  //             ),
  //             child: Column(
  //               children: [
  //
  //
  //                 Container(
  //
  //
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(12.0),
  //
  //                     child:
  //
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         Text("Upload License",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
  //
  //                         Text("${fileNameForLic}",style: TextStyle(decoration: TextDecoration.underline)),
  //
  //                         Visibility(visible: isTicked,child: Icon(Icons.check,color: Colors.green,size:30,)),
  //                       ],
  //                     ),
  //                   ),
  //
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //
  //                       Visibility(
  //                         visible: pickFileButton,
  //                         child: ElevatedButton(onPressed: (){
  //                           selectFileForLic();
  //                         }, child: Text("Pick the File")),
  //                       ),
  //                       ElevatedButton(onPressed: (){
  //                         uploadFileOfLic();
  //                         print("Uploaded the file");
  //                         // uplaodDownlaodLinkOfUploadedFile();
  //                       }, child:Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Icon(Icons.upload_file),SizedBox(width: 10,),Text("Upload File"),
  //                         ],)),
  //                       if(isUploading)
  //
  //                         CircularProgressIndicator() ,
  //
  //                     ],
  //                   ),
  //                 ),
  //
  //               ],
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //
  //           child: Container(
  //
  //             decoration: BoxDecoration(
  //               // border: Border.all(color: Colors.grey,width: 2),
  //                 borderRadius: BorderRadius.circular(25),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey,
  //                     // offset:Offset(1, 2),
  //                     blurStyle: BlurStyle.outer,
  //                     spreadRadius:5,
  //                     blurRadius: 5,
  //                   )
  //                 ]
  //             ),
  //             child: Column(
  //               children: [
  //                 Container(
  //
  //
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(12.0),
  //
  //                     child:
  //
  //                     Text("${pickedFileIns?.name.substring(0,15)}"),
  //                   ),
  //                   decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.green,width: 1),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //
  //                       ElevatedButton(onPressed: (){
  //                         selectFileForIns();
  //                       }, child: Text("Pick the File")),
  //                       ElevatedButton(onPressed: (){
  //                         uploadFileOfIns();
  //                         print("Uploaded the file");
  //                         // uplaodDownlaodLinkOfUploadedFile();
  //                       }, child:Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Icon(Icons.upload_file),SizedBox(width: 10,),Text("Upload File"),
  //                         ],))
  //                     ],
  //                   ),
  //                 ),
  //                       ElevatedButton(onPressed: (){
  //
  //                       }, child: Text("View pdf")),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget uploadPdfUi(pickLicFile(),uplaodLic(),pickIns(),uploadIns()) {
    return Column(
      children: [
        Container(
          child: Icon(
            Icons.cloud_upload_rounded,
            size: 120,
            color: Colors.green,
          ),
        ),
    Text("Note: Only .PDF are allowed",style: TextStyle(color: Colors.red)),
        SizedBox(height: 15),
        Center(

            child: Container(
              margin: EdgeInsets.only(left:15,right:15),
                      // width: 300,
                      // height:450,
                      decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),


              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                        uploadFileButtonUi(isFilePickingLic,"License",isUploadingLic,isTickedLic,fileNameForLic,pickLicFile,uplaodLic),
                        uploadFileButtonUi(isFilePickingIns,"Insurance",isUploadingIns,isTickedIns,fileNameForIns,pickIns,uploadIns),

                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
                    )),
      ],
    );
  }
  Widget uploadFileButtonUi(isPicking,heading,isUploading,isticked,filename,pickLicFile(),uplaodLic()){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            SizedBox(height: 10,),
            Text("Upload ${heading}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
            SizedBox(height: 10,),
            Row(


              children: [
                ElevatedButton(onPressed: (){
                  pickLicFile();
                }, child: Text("Pick File")),
                SizedBox(width: 30,),
                if(isPicking==true)
                  CircularProgressIndicator(),
                if(isPicking==false)
                Text("${filename}",textAlign:TextAlign.center),


              ],
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                ElevatedButton(onPressed: (){
                  uplaodLic();
                }, child: Text("Upload File")),
                SizedBox(width: 60,),
                if(isUploading)
                  CircularProgressIndicator(),
                if(isticked)
                  Icon(Icons.check,size:30,color: Colors.green,)
              ],
              // mainAxisAlignment: MainAxisAlignment.,
            ),
            SizedBox(height: 5,),
            Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}

