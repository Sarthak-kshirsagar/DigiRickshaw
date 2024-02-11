import 'package:flutter/material.dart';



class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Digi-Auto',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Last Updated: 21/12/2023',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20.0),
            PrivacyPolicySection(
              title: '1. Introduction',
              flag: false,
              content: """
              Welcome to Digi Auto, a sophisticated mobile application meticulously designed to optimize the management of school-associated vehicles, including rickshaws, school buses, and more. This Privacy Policy is a comprehensive guide outlining the nuances of how we collect, utilize, and protect your information, emphasizing our commitment to transparency and data security.
              """,
            ),
            PrivacyPolicySection(
              title: '2. Information We Collect',
              flag: true,
              bullet1: "Your full name enables us to provide a personalized and respectful user experience.",
              bullet2: "We gather phone numbers and email addresses to facilitate communication and enhance customer support.",
              bullet3: "Users have the option to voluntarily share additional details to tailor the app experience to their preferences.",
              bulletHead1: "Name",
              bulletHead2: "Contact Details",
              bulletHead3: "Additional",
              content: """
              - Name: Your full name enables us to provide a personalized and respectful user experience.
              - **Contact Details:** We gather phone numbers and email addresses to facilitate communication and enhance customer support.
              - **Additional Information:** Users have the option to voluntarily share additional details to tailor the app experience to their preferences.
              """,
            ),
            PrivacyPolicySection(
              title: '3. How We Use Your Information',
              flag:true,
              bullet1: "Personal information aids in providing and continually enhancing the functionality of our app.",
              bullet2: "Payment information is processed securely to facilitate smooth and secure financial transactions.",
              bullet3: "Aggregated and anonymized data are used to generate reports and conduct analysis, contributing to the continual improvement of our app's features and services.",
             bulletHead1: "Service\nProvision",
              bulletHead2: "Transaction\nProcessing",
              bulletHead3: "Operational\nEnhancement",


              content: """
              We are committed to using the collected information responsibly and purposefully:
              - **Service\nProvision:** Personal information aids in providing and continually enhancing the functionality of our app.
              - **Transaction\nProcessing:** Payment information is processed securely to facilitate smooth and secure financial transactions.
              - **Operational\nEnhancement:** Aggregated and anonymized data are used to generate reports and conduct analysis, contributing to the continual improvement of our app's features and services.
              """,
            ),
            PrivacyPolicySection(
              title: '4. Data Security',
              flag: true,
              bullet1: "All data, including personal and transactional information, is encrypted during transmission and storage.",
              bullet2: "Restricted access is granted only to authorized personnel, ensuring the confidentiality of user data.",
              bullet3: "Payment information is processed through secure channels to protect sensitive financial details.",
              bulletHead1: "Encryption",
              bulletHead2: "Access\nControls",
              bulletHead3:"Secure\nTransactions" ,
              content: """
              
              Our dedication to safeguarding your information involves implementing rigorous security measures:
              - **Encryption:** All data, including personal and transactional information, is encrypted during transmission and storage.
              - **Access\nControls:** Restricted access is granted only to authorized personnel, ensuring the confidentiality of user data.
              - **Secure\nTransactions:** Payment information is processed through secure channels to protect sensitive financial details.
              """,
            ),
            PrivacyPolicySection(
              title: '5. Data Retention',
              flag: false,
              content: """
              We retain user data for a duration necessary to fulfill the purposes outlined in this Privacy Policy. Users can request deletion of their information by contacting us at [contact email/number].
              """,
            ),
            PrivacyPolicySection(
              title: '6. Information Sharing',
              flag: false,
              content: """
              Your trust is paramount to us; thus, we commit to not selling, trading, or transferring your personally identifiable information to third parties. Your data is utilized solely for the purposes outlined in this policy.
              """,
            ),
            PrivacyPolicySection(
              title: '7. Changes to the Privacy Policy',
              flag: false,
              content: """
              To stay aligned with evolving practices and legal requirements, we may update this Privacy Policy. Users will be notified of any significant updates, ensuring transparency in our policies.
              """,
            ),
            PrivacyPolicySection(
              title: '8. Contact Us',
              flag:false,
              content: """
              For any inquiries or concerns regarding our Privacy Policy, please do not hesitate to contact our dedicated support team at [contact email/number].
              """,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicySection extends StatelessWidget {
  final String title;
  final String content;
  String? bullet1;
  String? bullet2;
  String? bullet3;
  bool? flag = false;
  String? bulletHead1;
  String? bulletHead2;
  String? bulletHead3;

   PrivacyPolicySection({
    required this.title,
     this.bulletHead1,
     this.bulletHead2,
     this.bulletHead3,
    required this.content,
    this.flag,
     this.bullet1,
     this.bullet2,
     this.bullet3,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        if(flag==true)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

              Text("\u2022", style: TextStyle(fontSize:30),), //bullet text
              SizedBox(width: 10,),
              Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                  child: Text(
                      "${bulletHead1} : - ",style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                  
                ],
              ),

              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      width:MediaQuery.of(context).size.width,
                
                      child: Text(
                          
                          style: TextStyle(),textAlign: TextAlign.start,"${bullet1}")),
                  ],
                ),
              )], )),
          ],
        ),
        if(flag==true)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

                Text("\u2022", style: TextStyle(fontSize:30),), //bullet text
                SizedBox(width: 10,),
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      child: Text(
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          "${bulletHead2} : - ",style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                          width:MediaQuery.of(context).size.width,
                          child: Text(textAlign: TextAlign.start,"${bullet3}")),
                    ],
                  ),
                )], )),
            ],
          ),
        if(flag==true)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

                Text("\u2022", style: TextStyle(fontSize:30),), //bullet text
                SizedBox(width: 10,),
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      child: Text(
                          "${bulletHead3} : - ",style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                          width:MediaQuery.of(context).size.width,
                          child: Text(textAlign: TextAlign.start,"${bullet1}")),
                    ],
                  ),
                )], )),
            ],
          ),
        if(flag==false)
        Text(
          content,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
