// ignore_for_file: use_build_context_synchronously, unused_field, must_be_immutable, library_private_types_in_public_api, avoid_print

import 'package:finance/constants/colors.dart';
import 'package:finance/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../components/accounts_list.dart';
import '../components/events_list.dart';
import '../components/latestsignal.dart';
import '../components/latestupdates.dart';
import '../components/portfolio_balance.dart';
import '../components/quick_actions.dart';
import '../widgets/appbar.dart';

class HomePage extends StatefulWidget {
  final String? firebaseSession;
  final String? session;

  const HomePage({
    Key? key,
    this.firebaseSession,
    this.session,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

  // Add this method to prevent the user from going back
  Future<bool> onWillPop() async {
    return false;
  }
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  List<dynamic>? _accounts = [];
  DateTime? _currentBackPressTime;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final myfxbookSession = prefs.getString('session');

    final session = myfxbookSession ?? widget.firebaseSession;

    if (session == null) {
      setState(() {
        _isLoading = false;
        _accounts = null;
      });
      return;
    }

    final response = await http.get(
      Uri.parse(
          'https://www.myfxbook.com/api/get-my-accounts.json?session=$session'),
    );
    print(response.body); // Add this line to print the response body

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] == false) {
        setState(() {
          _isLoading = false;
          _accounts = jsonResponse['accounts'];
        });
      } else {
        setState(() {
          _isLoading = false;
          _accounts = null;
        });
      }
    } else {
      throw const FormatException('Error fetching data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget body;

    return WillPopScope(
        onWillPop: widget.onWillPop,
        child: Scaffold(
            backgroundColor: GlobalColors.primaryColor,
            appBar: const MyAppBar(
              title: 'Accounts',
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AccountsList(
                    session: widget.session,
                    accounts: _accounts,
                  ),
                  const PortfolioBalance(),
                  const LatestUpdates(),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Latest Signals",
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: GlobalColors.whiteAcc,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LatestSignal(),
                  // const QuickActions(),

                  const SizedBox(height: 10)
                ],
              ),
            )));
  }
}
