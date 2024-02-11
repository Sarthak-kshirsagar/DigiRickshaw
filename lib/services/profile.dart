import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rickshaw2/Settings/setCurrency.dart';
import 'package:rickshaw2/modules/HelpSection/Feedback.dart';
import 'package:rickshaw2/modules/profilePages/ManageProfile.dart';
import 'package:rickshaw2/modules/profilePages/about.dart';
import 'package:rickshaw2/modules/profilePages/legal.dart';
import 'package:rickshaw2/modules/profilePages/messages.dart';
import 'package:rickshaw2/modules/profilePages/settings.dart';
import 'package:rickshaw2/pages/HomePage.dart';

import '../modules/HelpSection/helpSec.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isLoading = false;
  bool isFetchingProfile = false;
  bool isUploading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  void signOut() async {
    await auth.signOut().then((value) => Navigator.pushNamedAndRemoveUntil(
        context, Navigator.defaultRouteName, (route) => false));
          ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(backgroundColor: Colors.green,content: Text("Logged Off",)),
    );
  }

  Future<String> fetchCurrentUserName() async {
    setState(() {
      isLoading = true;
    });
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

  List<DocumentSnapshot> userInfo = [];
  Future getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    String userName = await fetchCurrentUserName();
    CollectionReference ref =
        await FirebaseFirestore.instance.collection("Users");
    final db = await ref.where("Name", isEqualTo: "${userName}");
    QuerySnapshot snapshot = await db.get();
    if (snapshot.docs.isNotEmpty) {
      String documentId = snapshot.docs.first.id;

      setState(() {
        userInfo = snapshot.docs;
      });
      assigntovar();
    }
    setState(() {
      isLoading = false;
    });
  }

  String name = "";
  String email = "";
  String password = "";
  String mobile = "";

  void assigntovar() {
    setState(() {
      isLoading = true;
    });
    setState(() {
      name = userInfo[0]["Name"];
      email = userInfo[0]["Email"];
      password = userInfo[0]["Password"];
      mobile = userInfo[0]["Mobile"];
    });
    print(name);
    setState(() {
      isLoading = false;
    });
  }
  String downloadLinkForProfile ="";
  PlatformFile? pickedFileProfile;

  String fetchedLink = "https://firebasestorage.googleapis.com/v0/b/rickshaw2.appspot.com/o/icon.jpg?alt=media&token=857d1169-d522-4262-a685-4c9f993bfa61";
  String localImgPath="";
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

        print("Fetched Link is printing and link is ${fetchedLink}");
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

      await addDownloadUrlToDb();
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
      loadProfileImage();
      setState(() {
        isUploading = false;
      });
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
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

Future<void> onRefresh()async{
  await loadProfileImage();

}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    loadProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child:Container(
              height: MediaQuery.of(context).size.height,
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [


                        Container(
                          width: 350,
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Hi\n ${name}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                              SizedBox(
                                width: 20,
                              ),
                              if(isUploading ==true)
                                CircularProgressIndicator(),

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
                            ],
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            smallContainer(HelpScreen(),Icons.help, "Help"),
                            smallContainer(feedBackPage(),Icons.feedback_rounded, "Feedback")
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            listWidgtes( ManageProfile(oldMobile: "${mobile}",oldName: "${name}", oldEmail: "${email}"), Icons.person, "Manage Profile"),
                            listWidgtes(Support(), Icons.message, "Messages / Support"),
                            listWidgtes(SettingPage(localImgPath: "${localImgPath}",oldMobile: "${mobile}",oldName: "${name}", oldEmail: "${email}"), Icons.settings_suggest_rounded,
                                "Settings"),
                            listWidgtes(LegalPage(), Icons.rule, "Legal"),
                            // listWidgtes(AboutUS(), Icons.info_rounded, "About Us"),
                          ],
                        ),
                        Divider(),
                        Container(
                          width: 400,
                          child: AboutListTile(
                            applicationName: "Digi Auto",
                            applicationVersion:"1.0.0.1",
                            applicationLegalese: "© 2023 Digi Auto.",
                            dense: true,
                            icon:Icon(Icons.info,size:31,color: Colors.black,),
                            child: Text("About Us",style: TextStyle(fontSize: 14)),
                            applicationIcon: Image.asset("assets/images/icon.jpg",width:80),
                            aboutBoxChildren: [

                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              // color: Colors.grey,
                            ),
                            child: InkWell(
                              onTap: () {
                                signOut();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.logout, size:31),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("Log Out"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget smallContainer(Widget w,IconData icon, t) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    w));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[300],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon),
              Text("${t}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget listWidgtes(Widget w, IconData i, text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
            // color: Colors.grey,
            ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => w,
                ));
          },
          child: Row(
            children: [
              Icon(i, size: 35),
              SizedBox(
                width: 20,
              ),
              Text("${text}"),
            ],
          ),
        ),
      ),
    );
  }
}

void showToastMessage(String msg) => Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.green,
    timeInSecForIosWeb: 1,
    textColor: Colors.black);
