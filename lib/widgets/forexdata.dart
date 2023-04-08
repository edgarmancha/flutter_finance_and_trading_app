// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchExchangeRates() async {
  final response = await http.get(Uri.parse(
      'https://openexchangerates.org/api/latest.json?app_id=e68316b6aafd4fd68e1cd7d8aef396cc'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['rates'];
  } else {
    throw Exception('Failed to fetch exchange rates');
  }
}

class ExchangeRatesScreen extends StatefulWidget {
  const ExchangeRatesScreen({Key? key}) : super(key: key);

  @override
  _ExchangeRatesScreenState createState() => _ExchangeRatesScreenState();
}

class _ExchangeRatesScreenState extends State<ExchangeRatesScreen> {
  late Map<String, dynamic> _exchangeRates;

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    final exchangeRates = await fetchExchangeRates();
    setState(() {
      _exchangeRates = exchangeRates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Rates'),
      ),
      body: ListView.builder(
        itemCount: _exchangeRates.length,
        itemBuilder: (context, index) {
          final currencyCode = _exchangeRates.keys.elementAt(index);
          final exchangeRate = _exchangeRates[currencyCode];
          return ListTile(
            title: Text(currencyCode),
            subtitle: Text(exchangeRate.toStringAsFixed(2)),
          );
        },
      ),
    );
  }
}
