import 'package:flutter/material.dart';
class HelpContent {
  final String question;
  final String answer;

  HelpContent({
    required this.question,
    required this.answer,
  });
}
class HelpScreen extends StatelessWidget {
  final List<HelpContent> helpContents = [
    HelpContent(
      question: 'How to add customers?',
      answer: 'Navigate to the home, then go to customer management, and finally, add a new customer.',
    ),
    HelpContent(
      question: 'How to manage payments?',
      answer: 'Navigate to the home, then go to payment management, and finally, update.',
    ),
    HelpContent(
      question: 'How to generate and share invoices?',
      answer: 'Navigate to billing and invoicing, then select customers according to your needs using the dropdown. Next, click on "View Bill," followed by "View Receipt," and finally, click on "Share."',
    ),

    // Add more help contents as needed
  ];
double Fontdouble =40;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:20,),
              Text(
                textAlign: TextAlign.center,
                "Help",
                style: TextStyle(
                  fontSize:Fontdouble,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25,),
              Container(
                width: MediaQuery.of(context).size.width,
                height:500,
                child: ListView.builder(
                  itemCount: helpContents.length,
                  itemBuilder: (context, index) {
                    return HelpExpansionTile(helpContent: helpContents[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpExpansionTile extends StatelessWidget {
  final HelpContent helpContent;

  HelpExpansionTile({required this.helpContent});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ExpansionTile(

        title: Text(
          helpContent.question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              helpContent.answer,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}