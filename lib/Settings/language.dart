import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLanguage = 'English';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Set Language",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Center(
              child: Text(
                'Selected Language : $selectedLanguage',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Center(
              child: Container(
                  width: 250,
                  child: Divider(color: Colors.grey,thickness:6,)),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select Language',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            ),
            _selectLanguageUi('English'),
            _selectLanguageUi('Marathi'),
            _selectLanguageUi('Hindi'),
            _selectLanguageUi('Gujrati'),
            _selectLanguageUi('Tamil'),
            _selectLanguageUi('Telgu'),
            _selectLanguageUi('Bengali'),

            Center(child: Text("Service is not Available as of now...",style: TextStyle(color: Colors.red),))
          ],
        ),
      ),
    );
  }
  Widget _selectLanguageUi(String currency) {
    return RadioListTile(
      title: Text(currency),
      value: currency,
      groupValue: selectedLanguage,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            selectedLanguage = value;
          });
        }
        // Close the dialog
      },
    );
  }
}
