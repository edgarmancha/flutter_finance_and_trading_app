import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EconomicCalendarPage extends StatefulWidget {
  @override
  _EconomicCalendarPageState createState() => _EconomicCalendarPageState();
}

class _EconomicCalendarPageState extends State<EconomicCalendarPage> {
  List<dynamic> economicData = [];
  String fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String toDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 30)));

  @override
  void initState() {
    super.initState();
    fetchEconomicCalendarData();
  }

  Future<void> fetchEconomicCalendarData() async {
    final response = await http.get(Uri.parse(
        'https://fcsapi.com/api-v3/forex/economy_cal?symbol=USD&from=$fromDate&to=$toDate&access_key=re7c2dybBUfCvRtV8St7tx'));

    if (response.statusCode == 200) {
      setState(() {
        economicData = jsonDecode(response.body)['response'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Economic Calendar'),
      ),
      body: ListView.builder(
        itemCount: economicData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${economicData[index]['title']}'),
            subtitle: Text(
                'Actual: ${economicData[index]['actual']}, Forecast: ${economicData[index]['forecast']}, Previous: ${economicData[index]['previous']}'),
          );
        },
      ),
    );
  }
}
