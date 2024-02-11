import 'package:flutter/material.dart';

class LegalPage extends StatefulWidget {
  const LegalPage({super.key});

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Legal",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:30)),
              ),
          listWidgtes("Copyright"),
              listWidgtes("Terms & Conditions"),
              listWidgtes("Privacy Policy"),
              listWidgtes("Data Products"),
              listWidgtes("Software Licenses"),
              listWidgtes("Payments Policy"),
              listWidgtes("Location Information"),
              listWidgtes("City Regulations"),

            ],
          ),
        ),
      )
    );
  }
  Widget listWidgtes(text) {
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

          },
          child: Row(
            children: [
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
