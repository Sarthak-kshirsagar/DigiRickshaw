import 'package:flutter/material.dart';

class SetCurrency extends StatefulWidget {
  const SetCurrency({super.key});

  @override
  State<SetCurrency> createState() => _SetCurrencyState();
}

class _SetCurrencyState extends State<SetCurrency> {
  String selectedCurrency = 'USD'; // Default currency
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Set Currency",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Center(
              child: Text(
                'Selected Currency: $selectedCurrency',
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
              child: Text('Select Currency',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            ),
            _buildCurrencyItem('IND'),
            Center(child: Text("Service is not Available as of now...",style: TextStyle(color: Colors.red),))


          ],
        ),
      ),
    );
  }
  Future<void> _showCurrencyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Currency'),
          content: Column(
            children: [
              _buildCurrencyItem('USD'),
              _buildCurrencyItem('EUR'),
              _buildCurrencyItem('GBP'),
              _buildCurrencyItem('JPY'),
              // Add more currencies as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrencyItem(String currency) {
    return RadioListTile(
      title: Text(currency),
      value: currency,
      groupValue: selectedCurrency,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            selectedCurrency = value;
          });
        }
      // Close the dialog
      },
    );
  }
}

