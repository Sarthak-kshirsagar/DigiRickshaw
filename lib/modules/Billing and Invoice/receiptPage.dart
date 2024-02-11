

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rickshaw2/modules/Billing%20and%20Invoice/getPathReceipt.dart';
import 'package:url_launcher/url_launcher.dart';


class ReceiptPage extends StatefulWidget {
  num doubleAmount = 0;
  num remainingAmount = 0;
  String status ="";
  String date = "";
  String customerName = "";
  String driverName = "";
   ReceiptPage({required this.driverName,required this.customerName,required this.remainingAmount,required this.doubleAmount,required this.status,required this.date});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  String requiredDateFormat = "";
  List<DocumentSnapshot> snap = [];
  String mobileNum = "";
  bool isLoading = false;
  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = "${_getMonthName(now.month)} ${now.day}, ${now.year}";
    return formattedDate;
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
  Future getMobileNum()async{
    setState(() {
      isLoading = true;
    });
    String currentUser = await fetchCurrentUserName();
    CollectionReference ref = await FirebaseFirestore.instance.collection("Customers");
    QuerySnapshot snapshot = await ref.where("Driver Name",isEqualTo: currentUser).where("Customer Name",isEqualTo: widget.customerName).get();
    if(snapshot.docs.isNotEmpty){
      String documentId = snapshot.docs.first.id;
      var customerData = snapshot.docs.first.data() as Map<String, dynamic>;
      var mobileNumber = customerData['Mobile'];
      print(mobileNumber);
    }
    setState(() {
      isLoading = false;
    });
  }

  String temp_Path = "";
  String appPath = "";
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
bool permissionGranted=false;

  Future _getStoragePermission() async {

    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });

    }
    print("executedddddd");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      requiredDateFormat = getCurrentDate();
    });
    getMobileNum();
    _getStoragePermission();


  }

  void sendWhatsAppMessage(customerName,totalAmount,remainingAmount,status,paymentDate) async {
    // Construct the message body
    String messageBody = '''
    Hello $customerName,
    Payment Status for Month is:
    Total Amount:$totalAmount
    Remaining Amount:$remainingAmount
    Status:$status
    Payment:$paymentDate

    Regards,
    DigiAuto
  ''';

    // Encode the message body
    String encodedMessage = Uri.encodeComponent(messageBody);

    // Construct the WhatsApp URL

    // https://wa.me/$mobileNum/?text=$encodedMessage
    var whatsapp = mobileNum;
    Uri  whatsappUrl =Uri.parse("whatsapp://send?phone=" + whatsapp + "&text=${encodedMessage}"); // Replace 1234567890 with the recipient's phone number
    //   Uri whatsappUrl = Uri.parse('whatsapp://send?phone=$mobileNum&text=${Uri.parse(encodedMessage)}');
    // Check if the URL can be launched
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      // Handle the case where WhatsApp is not installed
      print('Could not launch WhatsApp');
    }
  }

  void sendSmsMsg(customerName,totalAmount,remainingAmount,status,paymentDate) async {
    // Construct the message body
    String messageBody = '''
    Hello $customerName,
    Payment Status for Month is:
    Total Amount:$totalAmount
    Remaining Amount:$remainingAmount
    Status:$status
    Payment:$paymentDate

    Regards,
    DigiAuto
  ''';

    // Encode the message body
    String encodedMessage = Uri.encodeComponent(messageBody);

    // Construct the WhatsApp URL
    Uri  smsUrl =Uri.parse('sms:${mobileNum}?body=$encodedMessage'); // Replace 1234567890 with the recipient's phone number

    // Check if the URL can be launched
    if (await canLaunchUrl(smsUrl)) {
      await launchUrl(smsUrl);
    } else {
      // Handle the case where WhatsApp is not installed
      print('Could not launch WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start  ,
        
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Receipt",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
            ),
            SizedBox(height: 15,),
            Container(
              height:320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:100,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${requiredDateFormat}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                  ),
                  SizedBox(height:0,),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Thanks for \nChoosing \n Digi Rickshaw !",style: TextStyle(fontWeight: FontWeight.bold,fontSize:25)),
                  ),
                  Center(child: Text(textAlign: TextAlign.center,"Below are the Customer Details",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black
                  ),)),

                ],
              ),
        
            ),
            SizedBox(height: 15,),
            if(isLoading==true) Center(child: CircularProgressIndicator()),
            if(isLoading ==false)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height:200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green,width:5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.customerName}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:22),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total",style: TextStyle(fontSize:21,fontWeight: FontWeight.bold,),),
                          Text("₹${widget.doubleAmount}",style: TextStyle(fontSize:21,fontWeight: FontWeight.bold,),),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Remaining Amount",style: TextStyle(fontSize:19,fontWeight: FontWeight.bold),),
                          Text("${widget.remainingAmount}",style: TextStyle(fontSize:19,fontWeight: FontWeight.bold,color: Colors.red),),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status",style: TextStyle(fontSize:19,fontWeight: FontWeight.bold,),),
                          Text("${widget.status}",style: TextStyle(fontSize:19,fontWeight: FontWeight.bold,color: Colors.green),),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Payment Date",style: TextStyle(fontSize:19,fontWeight: FontWeight.bold,),),
                          Text("${widget.date}",style: TextStyle(fontSize:19,fontWeight: FontWeight.bold,color: Colors.green),),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),

            Column(
              children: [
                SizedBox(height: 10,),
                Text("Share with Parents ?",style: TextStyle(fontSize:18)),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width:150,
                      child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)),onPressed: (){
                        sendWhatsAppMessage(widget.customerName,widget.doubleAmount,widget.remainingAmount,widget.status,widget.date);
                      }, child: Row(
                        children: [
                          Icon(Icons.person,color: Colors.white),
                          Text("Whatsapp",style: TextStyle(color: Colors.white),),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      )),
                    ),
                    Container(
                      width:150,
                      child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)),onPressed: (){
                        sendSmsMsg(widget.customerName,widget.doubleAmount,widget.remainingAmount,widget.status,widget.date);
                      }, child: Row(
                        children: [
                          Icon(Icons.email_rounded,color: Colors.white),
                          Text("Message",style: TextStyle(color: Colors.white),),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      )),
                    ),
                  ],

                ),

              ],
            ),
          ],
        )),
      ),
    );
  }
}
