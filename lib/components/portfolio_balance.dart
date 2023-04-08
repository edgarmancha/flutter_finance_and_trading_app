import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils.dart';
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

class PortfolioBalance extends StatefulWidget {
  const PortfolioBalance({Key? key}) : super(key: key);

  @override
  State<PortfolioBalance> createState() => _PortfolioBalanceState();
}

class _PortfolioBalanceState extends State<PortfolioBalance> {
  Map<String, dynamic>? _exchangeRates;

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    final response = await http.get(Uri.parse(
        'https://api.exchangerate.host/latest?base=USD&symbols=GBP,EUR,NGN,CHF,AED,CAD,CNY'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _exchangeRates = jsonResponse['rates'];
      });
    } else {
      throw Exception('Failed to fetch exchange rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: .3,
            color: Colors.white.withOpacity(0.5),
          ),
          bottom: BorderSide(
            width: .3,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        color: GlobalColors.primaryColor,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            color: GlobalColors.whiteAcc.withOpacity(.05),
            child: Text(
              'FX USD /'.toUpperCase(),
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.5,
                color: GlobalColors.whiteAcc,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _exchangeRates == null
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('GBP',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                      color: GlobalColors.whiteAcc,
                                    )),
                                Text('EUR',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                      color: GlobalColors.whiteAcc,
                                    )),
                                Text('NGN',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                      color: GlobalColors.whiteAcc,
                                    )),
                                Text('CHF',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                      color: GlobalColors.whiteAcc,
                                    )),
                                Text('AED',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                      color: GlobalColors.whiteAcc,
                                    )),
                                Text('CAD',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                      color: GlobalColors.whiteAcc,
                                    )),
                                Text('CNY',
                                    style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                      color: GlobalColors.whiteAcc,
                                    )),
                              ],
                            ),
                            // Text('Loading Rates ...',
                            //     style: SafeGoogleFont(
                            //       'Poppins',
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.normal,
                            //       height: 1.5,
                            //       color: GlobalColors.whiteAcc,
                            //     )),
                            LinearProgressIndicator(
                              color: GlobalColors.whiteAcc.withOpacity(0.5),
                              minHeight: 1,
                            )
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final currencyCode in [
                              'GBP',
                              'EUR',
                              'NGN',
                              'CHF',
                              'AED',
                              'CAD',
                              'CNY'
                            ])
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      currencyCode,
                                      style: TextStyle(
                                          color: GlobalColors.whiteAcc),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _exchangeRates![currencyCode]
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: GlobalColors.whiteAcc),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                const Divider(
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
