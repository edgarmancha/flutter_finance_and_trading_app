import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ForexSymbolsPage extends StatefulWidget {
  @override
  _ForexSymbolsPageState createState() => _ForexSymbolsPageState();
}

class _ForexSymbolsPageState extends State<ForexSymbolsPage> {
  List<dynamic> forexSymbols = [];

  @override
  void initState() {
    super.initState();
    fetchForexSymbols();
  }

  Future<void> fetchForexSymbols() async {
    final response = await http.get(Uri.parse(
        'https://fcsapi.com/api-v3/forex/latest?symbol=all_forex&access_key=re7c2dybBUfCvRtV8St7tx'));

    if (response.statusCode == 200) {
      setState(() {
        forexSymbols = jsonDecode(response.body)['response'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forex Symbols and Prices'),
      ),
      body: ListView.builder(
        itemCount: forexSymbols.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(forexSymbols[index]['s']),
            subtitle: Text('Price: ${forexSymbols[index]['c']}'),
          );
        },
      ),
    );
  }
}
