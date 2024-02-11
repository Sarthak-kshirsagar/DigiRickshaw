import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(

                padding: const EdgeInsets.all(8.0),
                child: Text("Messages",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:30)),
              ),
              SizedBox(height:15 ,),
              messagesUi(Icons.person,"Change in Privacy Policies"),
              messagesUi(Icons.update,"Security Update"),
            ],
          ),
        ),
      ),
    );
  }
  Widget messagesUi(IconData i,heading){
    return Container(
        width:double.infinity,
        height: 250,

        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(i,size: 35,color: Colors.red),
              SizedBox(width: 15,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 200,
                      child: Text("${heading}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)),
                  SizedBox(height:10,),
                  Container(
                      width:250,
                      child: Text("New privacy polices will be in effect from 1 January 2024")),
                  SizedBox(height: 15,),
                  ElevatedButton(style: ButtonStyle(foregroundColor:
                  MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStatePropertyAll(Colors.black)
                  ),onPressed: (){}, child:Text("View Details"))

                ],
              )
            ],
          ),
        )
    );
  }
}
