// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:convert';

import 'package:finance/components/smallbutton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../utils.dart';

class AccountsView extends StatefulWidget {
  final String? session;
  final List<dynamic> accounts;

  const AccountsView({super.key, this.session, required this.accounts});

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  bool _isLoading = true;
  List<dynamic> _accounts = [];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://www.myfxbook.com/api/get-my-accounts.json?session=${widget.session}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] == false) {
        setState(() {
          _isLoading = false;
          _accounts = jsonResponse['accounts'];
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(jsonResponse['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      throw const FormatException('Error fetching data');
    }
  }

  _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(initialPage: 0),
      onPageChanged: _onPageChanged,
      scrollDirection: Axis.horizontal,
      itemCount: _accounts.length,
      itemBuilder: (BuildContext context, int index) {
        final account = _accounts[index];
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(account['name'].toUpperCase(),
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: GlobalColors.primaryColor,
                    )),
              ),
              // const SizedBox(height: 8.0),
              Divider(
                color: GlobalColors.primaryColor,
              ),

              //Bottons
              // ignore: avoid_unnecessary_containers
              Container(
                child: Row(
                  children: [
                    SmallButton(
                      textColor: Colors.white,
                      backgroundColor: GlobalColors.secondaryColor,
                      borderColor: GlobalColors.secondaryColor,
                      text: '${account['currency']}',
                      isIcon: false,
                      icon: Icons.credit_card,
                      // icon: icon)
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    SmallButton(
                      textColor: Colors.white,
                      backgroundColor:
                          account['gain'] >= 0 ? Colors.green : Colors.red,
                      borderColor: GlobalColors.secondaryColor,
                      text: '${account['gain'].toStringAsFixed(4)} %',
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SmallButton(
                      textColor: Colors.white,
                      backgroundColor: GlobalColors.primaryColor,
                      borderColor: GlobalColors.secondaryColor,
                      text: "ID:# ${account['accountId']}",
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                  ],
                ),
              ),

              //balance
              Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      child: Text(
                        '${account['currency']} ${NumberFormat('#,##0.00').format(account['balance'])}',
                        style: SafeGoogleFont(
                          'Roboto',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: GlobalColors.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SmallButton(
                      height: 35,

                      textColor: Colors.white,
                      backgroundColor: const Color.fromARGB(199, 67, 65, 65),
                      borderColor: const Color.fromARGB(199, 67, 65, 65),
                      text:
                          'Equity:\n${account['currency']}  ${NumberFormat('#,##0.00').format(account['equity'])}'
                              .toUpperCase(),
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SmallButton(
                      height: 35,

                      textColor: Colors.white,
                      backgroundColor: const Color.fromARGB(199, 67, 65, 65),
                      borderColor: const Color.fromARGB(199, 67, 65, 65),
                      text:
                          'Profit:\n${account['currency']}  ${NumberFormat('#,##0.00').format(account['profit'])}'
                              .toUpperCase(),
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;

  const PageIndicator({
    Key? key,
    required this.currentIndex,
    required this.pageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          width: 5.5,
          height: 5.5,
          decoration: BoxDecoration(
            color:
                index == currentIndex ? GlobalColors.primaryColor : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
