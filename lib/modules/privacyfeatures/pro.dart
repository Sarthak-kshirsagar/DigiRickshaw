import 'package:flutter/material.dart';




class ExploreDataPage extends StatefulWidget {

  bool per;
  bool services;
  bool trans;
  ExploreDataPage({required this.per,required this.services,required this.trans});

  @override
  State<ExploreDataPage> createState() => _ExploreDataPageState();
}

class _ExploreDataPageState extends State<ExploreDataPage> {
  ExpansionTileController tileControl = new ExpansionTileController();
  bool isExpandedPer = false;
  bool isExpandedTransportation  = false;
  bool isExpandedservices = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isExpandedPer = widget.per;
      isExpandedTransportation = widget.trans;
      isExpandedservices = widget.services;

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height:15.0),
                Text(
                  textAlign: TextAlign.center,
                  "Explore your data",
                  style: TextStyle(
                    fontSize:50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  width: MediaQuery.of(context).size.width,

                  child: ClipRRect(borderRadius: BorderRadius.circular(25),child: Image.asset("assets/images/privacy.jpg",fit: BoxFit.fitWidth,)),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "This is how your Data is Preserved and Used to provide you services.",
                    style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.grey),
                  ),
                ),

                SizedBox(height: 8.0),
                ExpansionTile(
                  initiallyExpanded:isExpandedPer,

                    shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 1.5)),title: Text("Personal Information",style: TextStyle(fontWeight: FontWeight.bold)),children: [
                  buildBulletPoint(
                    "Your full name is crucial for personalizing our services and enhancing your overall experience within the app. It allows us to address you appropriately and ensures a more personalized interaction.",
                  ),
                  buildBulletPoint(
                    "We collect your mobile number to facilitate communication and provide timely updates regarding your transactions, bookings, and other relevant information related to the services provided through our app.",
                  ),
                  buildBulletPoint(
                    "Your email address serves as a primary mode of communication, allowing us to send you important notifications, updates, and receipts. Additionally, it provides a secure means for account recovery and customer support.",
                  ),
                ]),

                ExpansionTile(

                    initiallyExpanded: isExpandedservices,shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 1.5)),title: Text("Transportation",style: TextStyle(fontWeight: FontWeight.bold)),children: [
                  buildBulletPoint(
                    "For certain services, such as transportation bookings or delivery, we may collect your address. This information is essential for ensuring the accurate delivery of services to your specified location.",
                  ),
                  buildBulletPoint(
                    "When using our app for transportation services, we collect destination information to optimize route planning and provide you with the most efficient and timely service.",
                  ),
                  buildBulletPoint(
                    "We offer users the option to enhance their profiles by providing additional information such as profile pictures or personal preferences. This data is entirely optional and serves to customize your app experience.",
                  ),
                ]),

        ExpansionTile(
            initiallyExpanded: isExpandedTransportation,
            shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 1.5)),title: Text("Services and Documents",style: TextStyle(fontWeight: FontWeight.bold)),children: [
          buildBulletPoint(
            "For users managing vehicles within our app, we collect relevant documentation to verify and authenticate the associated vehicles. This may include registration certificates, insurance documents, and other legally required information.",
          ),
          buildBulletPoint(
            "In the context of school-associated services, where the app is used for managing student transportation, we collect necessary documents related to students. This may include identification cards, emergency contact information, and other details required for their safety and well-being.",
          ),
          SizedBox(height: 8.0),
          buildBulletPoint(
            "We acknowledge the sensitivity of the information collected and assure you that your consent is paramount. By using our app, you explicitly consent to the collection, processing, and storage of the aforementioned customer data for the purposes outlined in this Privacy Policy.",
          ),
          SizedBox(height: 8.0),
          buildBulletPoint(
            "Access to customer data is strictly limited to authorized personnel involved in providing and improving our services. We employ robust security measures, including encryption and access controls, to safeguard this information from unauthorized access.",
          ),
          SizedBox(height: 8.0),
          buildBulletPoint(
            "You retain ownership of your data, and if you wish to delete any specific information or your entire account, please contact us at [contact email/number]. We will promptly respond to your requests and provide guidance on the process.",
          ),
        ]),
                Container(
                  width: 250,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.location_on),
                      Icon(Icons.person),
                      Icon(Icons.security,size: 50),
                      Icon(Icons.document_scanner_outlined),

                      Icon(Icons.payment_rounded),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBulletPoint(String bullet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 8.0),
            Text(
              '\u2022', // Unicode character for a bullet point
              style: TextStyle(
                fontSize:30.0,
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                bullet,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
