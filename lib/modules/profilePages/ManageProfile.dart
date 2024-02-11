import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rickshaw2/services/profile.dart';

class ManageProfile extends StatefulWidget {
  String oldName = "";
  String oldMobile = "";
  String oldEmail = "";

  ManageProfile({required this.oldName, required this.oldEmail,required this.oldMobile});

  @override
  State<ManageProfile> createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController CarNum = TextEditingController();
  String newName = "";
  String newEmail = "";
  String newMobile = "";
  String newVehi = "";
  String _errorMessage = '';
    bool isLoading = false;
    bool isLoadingPic = false;
    bool isUploading = false;

  Future updateCustomers(name)async{
    setState(() {
      isLoading= true;
    });
    CollectionReference ref = await FirebaseFirestore.instance.collection("Customers");
    final db = await ref.where("Driver Name",isEqualTo: "${widget.oldName}");
    QuerySnapshot snapshot = await db.get();
    if(snapshot.docs.isNotEmpty){
      for(QueryDocumentSnapshot sp in snapshot.docs){
        String docId = sp.id;
        await ref.doc(docId).update({
          "Driver Name":"${name}"
        });
      }

    }
    print("new naemis ${name}");
    setState(() {
      isLoading= false;
    });
  }
  Future updateGraph(name)async{
    setState(() {
      isLoading= true;
    });
    CollectionReference ref = await FirebaseFirestore.instance.collection("Graphs");
    final db = await ref.where("Driver Name",isEqualTo: "${widget.oldName}");
    QuerySnapshot snapshot = await db.get();
    if(snapshot.docs.isNotEmpty){
      String docId = snapshot.docs.first.id;
      await ref.doc(docId).update({
        "Driver Name":"${name}"
      });
    }
    print("new naemis ${name}");
    setState(() {
      isLoading= false;
    });
  }
  Future updatePayments(name)async{
    setState(() {
      isLoading= true;
    });
    CollectionReference ref = await FirebaseFirestore.instance.collection("Payments");
    final db = await ref.where("DriverName",isEqualTo: "${widget.oldName}");
    QuerySnapshot snapshot = await db.get();
    if(snapshot.docs.isNotEmpty){
      for(QueryDocumentSnapshot sp in snapshot.docs){
        String docId = sp.id;
        await ref.doc(docId).update({
          "DriverName":"${name}"
        });
      }

    }
    print("new naemis ${name}");
    setState(() {
      isLoading= false;
    });
  }
  Future updateStoredDocs(name)async{
    setState(() {
      isLoading= true;
    });
    CollectionReference ref = await FirebaseFirestore.instance.collection("StoredDocuments");
    final db = await ref.where("DriverName",isEqualTo: "${widget.oldName}");
    QuerySnapshot snapshot = await db.get();
    if(snapshot.docs.isNotEmpty){
      String docId = snapshot.docs.first.id;
      await ref.doc(docId).update({
        "DriverName":"${name}"
      });
    }
    print("new naemis ${name}");
    setState(() {
      isLoading= false;
    });
  }

  Future updateDetails(name,email,mobile,vehiNum)async{
    setState(() {
      isLoading= true;
    });
    CollectionReference ref = await FirebaseFirestore.instance.collection("Users");
    final db = await ref.where("Name",isEqualTo: "${widget.oldName}");
    QuerySnapshot snapshot = await db.get();
    if(snapshot.docs.isNotEmpty){
      String docId = snapshot.docs.first.id;
      await ref.doc(docId).update({
        "Name":"${name}",
        "Email":"${email}",
        "Mobile":"${mobile}",
        "Vehicle Num":"${vehiNum}",
      });
    }
    updateCustomers(name);
    updateGraph(name);
    updatePayments(name);
    updateStoredDocs(name);
    print("new naemis ${name}");
    setState(() {
      isLoading= false;
    });

    // User? user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   try {
    //     await user.updateEmail(email);
    //   } catch (e) {
    //     // Handle email update error
    //     print("Error updating email: $e");
    //     setState(() {
    //       _errorMessage = 'Error updating email.';
    //       isLoading = false;
    //     });
    //     return;
    //   }
    // }
  }
PlatformFile? pickedFileProfile;

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


  String localImgPath="";
  String downloadLinkForProfile ="";
  Future<void> addDownloadUrlToDb() async {
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
        "Profile":"${downloadLinkForProfile}"
      });
      print("updated donwload urls");
      final link = snapshot.docs.first;
      final profLink = link["Profile"];
      localImgPath = await downloadAndSaveImage(profLink);
      setState(() {


      });

    } else {
      print("no docs found");
    }
  }
  Future uploadFileOfProfile() async {
    if (pickedFileProfile == null) {
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

      });
      final currentUSer = await fetchCurrentUserName();
      final path = '${currentUSer}/${pickedFileProfile!.name}';
      final file = File(pickedFileProfile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);
      uploadTask.snapshotEvents.listen((event) {

      });

      await uploadTask.whenComplete(() {
        setState(() {


        });
      });
      print("uploadedd filee");
      String downloadUrl = await ref.getDownloadURL();
      print(downloadUrl);
      setState(() {
        downloadLinkForProfile = downloadUrl;
      });

      addDownloadUrlToDb();
      print("url uploaded");
    }
  }
  Future selectFileForProfile() async {
    setState(() {
      isUploading = true;
    });
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg','png'],
      );
      if (result == null) {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.error,color: Colors.red,size: 50),
            shape: OutlineInputBorder(

                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey)),
            backgroundColor: Colors.grey[200],
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: 150,
              height:90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Please select the file",style: TextStyle(fontWeight: FontWeight.bold)),


                ],
              ),
            ),
          );
        },);
        return;
      }else{
        setState(() {
          pickedFileProfile = result?.files.first;
        });
        await uploadFileOfProfile();

      }
      setState(() {
        isUploading = false;
      });
      // loadProfileImage();
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.check,color: Colors.green,size: 50),
          shape: OutlineInputBorder(

              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey)),
          backgroundColor: Colors.grey[200],
          contentPadding: EdgeInsets.all(0),
          content: Container(
            width: 150,
            height:90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Profile Picture Updated",style: TextStyle(fontWeight: FontWeight.bold)),

                Text("Please Refresh Screen",style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },);
    } on Exception catch (e) {
      // TODO
    }

  }
  Future<String> downloadAndSaveImage(String imageUrl) async {
    print("enterd to downlad and save");
    // Use Dio for making HTTP requests
    Dio dio = Dio();
    print("dip object creates");
    // Get the temporary directory for storing the downloaded image
    Directory tempDir = await getTemporaryDirectory();

    // Generate a unique filename based on the image URL
    String fileName = imageUrl.split('/').last;
    String filePath = '${tempDir.path}/$fileName';

    // Check if the image is already downloaded
    if (File(filePath).existsSync()) {
      print('Image already downloaded at: $filePath');


      return filePath;
    }

    // Download the image
    try {
      await dio.download(imageUrl, filePath);
      print('Image downloaded successfully at: $filePath');
      return filePath;
    } catch (e) {
      print('Error downloading image: $e');
      throw e; // Handle the error as needed
    }
  }
  Future<void> loadProfileImage() async {
    print("entered to profile");
    try {
      String currentUserName = await fetchCurrentUserName();
      print("${currentUserName}");

      final db = FirebaseFirestore.instance.collection("StoredDocuments");
      final query = await FirebaseFirestore.instance
          .collection("StoredDocuments")
          .where("DriverName", isEqualTo: "${currentUserName}");
      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        final link = snapshot.docs.first;
        final profLink = link["Profile"];
        print("printing thr profile link ${profLink}");
        // Check if the image is already downloaded
        localImgPath = await downloadAndSaveImage(profLink);
        print("got the path and path is ${localImgPath}");

        setState(() {


        });
      } else {
        print("No docs found");
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.error,color: Colors.red,size: 50),
            shape: OutlineInputBorder(

                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey)),
            backgroundColor: Colors.grey[200],
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: 150,
              height:90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error please try later",style: TextStyle(fontWeight: FontWeight.bold)),


                ],
              ),
            ),
          );
        },);
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      newName = widget.oldName;
      newEmail = widget.oldEmail;
      newMobile = widget.oldMobile;
    });
    loadProfileImage();
  }

Future<void>onrefresh()async{
    print("refresh");
    await loadProfileImage();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height:MediaQuery.of(context).size.height,
            child: RefreshIndicator(
              onRefresh: onrefresh,
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 350,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: localImgPath.isNotEmpty
                                      ? FileImage(File(localImgPath))
                                      : null, // Only set the backgroundImage if localImgPath is not empty
                                  child: localImgPath.isEmpty
                                      ? Icon(Icons.person,size: 50,) // Show a loading indicator while the image is loading
                                      : null, // No child if not loading
                                ),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: (){
                                      selectFileForProfile();


                                    },
                                    child: Icon(

                                      color: Colors.orange,
                                      Icons.camera_alt,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text("${widget.oldName}",
                                style:
                                TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: FormKey
                          ,child: Column(
                        children: [

                          textField(true,"Name", widget.oldName, newName, nameRegExp,"Digi"),

                          textField(false,"Mobile Number", widget.oldMobile, newMobile,
                              mobileNumberRegExp,"9123456789"),
                          // textField("Email Address", widget.oldEmail, newEmail, emailRegExp,"sart@gmail.com"),
                          textField(true,
                              "Vehicle Number", "", newVehi, rickshawNumberPlateRegExp,"Enter Vehicle Number"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(

                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                                      foregroundColor: MaterialStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    if(FormKey.currentState!.validate()){
                                      print("valid");
                                      updateDetails(newName,newEmail,newMobile,newVehi);
                                    }
                                  },
                                  child: Text("Save")),
                              SizedBox(width: 20,),
                              if(isLoading==true)CircularProgressIndicator(),
                              if(isLoading==false)Icon(Icons.check,color: Colors.green,size:25,),


                            ],
                          ),

                        ],
                      ),),
                      SizedBox(height: 30,),
                                  if(isUploading==true)

                                    Padding(
                                      padding: const EdgeInsets.only(right:18.0),
                                      child: Center(child: CircularProgressIndicator()),
                                    ),

                    ],

                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  RegExp nameRegExp = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
  RegExp mobileNumberRegExp = RegExp(r'^\d{10}$');
  RegExp emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  RegExp rickshawNumberPlateRegExp = RegExp(r'^[A-Z]{2}\s[A-Z0-9]+$');
  final FormKey = GlobalKey<FormState>();
  Widget textField(bool isEnable,String heading, String initial, String parametr, RegExp regExp, String hint) {
    return Column(
      children: [
        Container(
          width: 250,
          height: 80,
          child: TextFormField(

            validator: (value) {
              if (value == null || value.isEmpty) {

                if(heading=="Vehicle Number"){
                  return "Two uppercase follwed by space &\nnumber/alphabets";
                }
                return "Please enter ${heading}";
              }
              if(heading=="Vehicle Number"){
                if (!regExp.hasMatch(value)) {
                  return "Two uppercase follwed by space &\nnumber/alphabets";
                }
              }
              if (!regExp.hasMatch(value)) {
                return "Please enter valid ${heading}";
              }
              return null; // Return null if validation passes
            },
            onChanged: (value) {
              setState(() {
                // Update the corresponding state variable based on the heading
                switch (heading) {
                  case "Name":
                    newName = value;
                    break;
                  case "Mobile Number":
                    newMobile = value;
                    break;
                  case "Email Address":
                    newEmail = value;
                    break;
                  case "Vehicle Number":
                    newVehi = value;
                    break;
                  default:
                    break;
                }
              });
            },

            initialValue: initial,
            decoration: InputDecoration(
              enabled:isEnable,
              hintText: "${hint}",
              enabledBorder: OutlineInputBorder(),

            ),
          ),
        ),
        SizedBox(height: 15,),
      ],
    );
  }

  // Widget textField(heading, initial, parametr, RegExp regExp,hint) {
  //   return Column(
  //     children: [
  //       Container(
  //         width: 250,
  //         height: 80,
  //         child: TextFormField(
  //           validator: (value) {
  //             if (value == null || value.isEmpty) {
  //               return "Please enter ${heading}";
  //             }
  //             if (!regExp.hasMatch(value)) {
  //               return "Please enter valid ${heading}";
  //             }
  //           },
  //           onChanged: (value) {
  //             setState(() {
  //               parametr = value;
  //             });
  //           },
  //           initialValue: initial,
  //           decoration: InputDecoration(
  //             hintText: "${hint}",
  //             enabledBorder: OutlineInputBorder(),
  //             label: Text("${heading}"),
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 15,),
  //     ],
  //   );
  // }
}
