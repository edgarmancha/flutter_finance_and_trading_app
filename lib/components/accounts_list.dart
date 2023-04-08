// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unused_field, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/Screens/auth/myfxbook_signup.dart';
import 'package:finance/components/smallbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../Screens/auth/myfxbook_login.dart';
import '../constants/colors.dart';
import '../utils.dart';

class AccountsList extends StatefulWidget {
  final String? session;
  final List<dynamic>? accounts;

  const AccountsList({
    Key? key,
    required this.session,
    this.accounts,
  }) : super(key: key);

  @override
  _AccountsListState createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  late List<dynamic>? _accounts;
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _fullName; // Add a field to store the user's full name
  String? _myfxbookSessionId;

  Future<bool> _checkMyfxbookSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('session');
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    _checkMyfxbookSession().then((myfxSessionExists) {
      if (myfxSessionExists) {
        SharedPreferences.getInstance().then((prefs) {
          final sessionId = prefs.getString('session');
          setState(() {
            _myfxbookSessionId = sessionId;
          });
        });
      }
    });
    _loadUserData(); // Load user data when the widget is initialized

    _accounts = widget.accounts;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMyfxbookLogin(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('session', sessionId);
    setState(() {
      _myfxbookSessionId = sessionId;
    });
  }

  Future<void> _fetchData() async {
    if (widget.session == null) {
      setState(() {
        _isLoading = false;
        _accounts = null;
      });
      return;
    }
    final response = await http.get(
      Uri.parse(
          'https://www.myfxbook.com/api/get-my-accounts.json?session=${widget.session}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] == false) {
        setState(() {
          _accounts = jsonResponse['accounts'];
        });
      } else {
        if (jsonResponse['message'] == "invalid session") {
          // Prompt the user to log in again to myfxbook
          setState(() {
            _isLoading = false;
            _accounts = null;
          });
        } else {
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     title: const Text('Error'),
          //     content: Text(jsonResponse['message']),
          //     actions: [
          //       TextButton(
          //         onPressed: () => Navigator.pop(context),
          //         child: const Text('OK'),
          //       ),
          //     ],
          //   ),
          // );
          setState(() {
            _isLoading = false;
            _accounts = null;
          });
        }
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

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final firstName = snapshot.data()!['firstName'];
        final lastName = snapshot.data()!['lastName'];
        if (firstName != null && lastName != null) {
          if (mounted) {
            // Check if the state object is still mounted
            setState(() {
              _fullName = '$firstName $lastName';
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_accounts == null) {
      return Container(
        decoration: BoxDecoration(color: GlobalColors.primaryColor),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(_fullName ?? 'Account Name'.toUpperCase(),
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: GlobalColors.whiteAcc,
                  )),
            ),
            // const SizedBox(height: 8.0),
            Divider(
              color: GlobalColors.whiteAcc,
            ),

            //Bottons
            // ignore: avoid_unnecessary_containers
            Container(
              child: Row(
                children: [
                  SmallButton(
                    textColor: Colors.white,
                    backgroundColor: GlobalColors.thirdColor,
                    borderColor: GlobalColors.thirdColor,
                    text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
                    isIcon: false,
                    icon: Icons.credit_card,
                    // icon: icon)
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  SmallButton(
                    textColor: Colors.white,
                    backgroundColor: GlobalColors.thirdColor,
                    borderColor: GlobalColors.thirdColor,
                    text: DateFormat('HH:mm').format(DateTime.now()),
                    isIcon: false,
                    icon: Icons.credit_card,

                    // icon: icon)
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SmallButton(
                    textColor: Colors.white,
                    backgroundColor: GlobalColors.secondaryColor,
                    borderColor: GlobalColors.secondaryColor,
                    text: "Login to view balances",
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
                      'USD **,***.**',
                      style: SafeGoogleFont(
                        'Roboto',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: GlobalColors.whiteAcc,
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
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: const SizedBox(
                              child: MyfxBookSignup(),
                            ),
                          );
                        },
                      );
                    },
                    child: SmallButton(
                      height: 35,
                      textColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      borderColor: GlobalColors.whiteAcc,
                      text: 'Create Account'.toUpperCase(),
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyfxbookLoginPage(
                            onLoggedIn: _onMyfxbookLogin,
                          ),
                        ),
                      );
                    },
                    child: SmallButton(
                      height: 35,

                      textColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      borderColor: GlobalColors.whiteAcc,
                      text: 'Sign in'.toUpperCase(),
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      );
    } else if (_accounts!.isEmpty) {
      return Container(
        decoration: BoxDecoration(color: GlobalColors.primaryColor),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(_fullName ?? 'Account Name'.toUpperCase(),
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: GlobalColors.whiteAcc,
                  )),
            ),
            // const SizedBox(height: 8.0),
            Divider(
              color: GlobalColors.whiteAcc,
            ),

            //Bottons
            // ignore: avoid_unnecessary_containers
            Container(
              child: Row(
                children: [
                  SmallButton(
                    textColor: Colors.white,
                    backgroundColor: GlobalColors.thirdColor,
                    borderColor: GlobalColors.thirdColor,
                    text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
                    isIcon: false,
                    icon: Icons.credit_card,
                    // icon: icon)
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  SmallButton(
                    textColor: Colors.white,
                    backgroundColor: GlobalColors.thirdColor,
                    borderColor: GlobalColors.thirdColor,
                    text: DateFormat('HH:mm').format(DateTime.now()),
                    isIcon: false,
                    icon: Icons.credit_card,

                    // icon: icon)
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SmallButton(
                    textColor: Colors.white,
                    backgroundColor: GlobalColors.secondaryColor,
                    borderColor: GlobalColors.secondaryColor,
                    text: "No Accounts to show",
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
                      'USD **,***.**',
                      style: SafeGoogleFont(
                        'Roboto',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: GlobalColors.whiteAcc,
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
                  child: InkWell(
                    onTap: () async {
                      const url = 'https://www.myfxbook.com/settings';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: SmallButton(
                      height: 35,
                      textColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      borderColor: GlobalColors.whiteAcc.withOpacity(0.7),
                      text: 'Add Accounts'.toUpperCase(),
                      isIcon: false,
                      icon: Icons.credit_card,

                      // icon: icon)
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () async {
                    const url =
                        'https://www.myfxbook.com/help#helpHowToLinkToSystemPage';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: SmallButton(
                    height: 35,
                    width: 35,
                    textColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    borderColor: GlobalColors.whiteAcc.withOpacity(0.7),
                    text: 'Sign in'.toUpperCase(),
                    isIcon: true,
                    icon: Icons.help,

                    // icon: icon)
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: PageView.builder(
        controller: PageController(initialPage: 0),
        onPageChanged: _onPageChanged,
        scrollDirection: Axis.horizontal,
        itemCount: _accounts!.length,
        itemBuilder: (BuildContext context, int index) {
          final account = _accounts![index];
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: GlobalColors.primaryColor),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text('${account['name']}'.toUpperCase(),
                      style: SafeGoogleFont(
                        'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: GlobalColors.whiteAcc,
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
                        backgroundColor: GlobalColors.thirdColor,
                        borderColor: GlobalColors.thirdColor,
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
                        backgroundColor: GlobalColors.secondaryColor,
                        borderColor: GlobalColors.secondaryColor,
                        text: "ID:# ${account['accountId']}",
                        isIcon: false,
                        icon: Icons.credit_card,

                        // icon: icon)
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SmallButton(
                        textColor: Colors.white,
                        backgroundColor: GlobalColors.thirdColor,
                        borderColor: GlobalColors.thirdColor,
                        text: "${account['server']['name']}".toUpperCase(),
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
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            color: GlobalColors.whiteAcc,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Divider(
                      color: GlobalColors.whiteAcc,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SmallButton(
                            height: 35,

                            textColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(199, 67, 65, 65)
                                    .withOpacity(0),
                            borderColor: const Color.fromARGB(199, 67, 65, 65),
                            text:
                                'Equity:${account['currency']}  ${NumberFormat('#,##0.00').format(account['equity'])}'
                                    .toUpperCase(),
                            isIcon: false,
                            icon: Icons.credit_card,

                            // icon: icon)
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          thickness: 1,
                          width: 1,
                        ),
                        Expanded(
                          child: SmallButton(
                            height: 35,

                            textColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(199, 67, 65, 65)
                                    .withOpacity(0),
                            borderColor: const Color.fromARGB(199, 67, 65, 65),
                            text:
                                'Profit:${account['currency']}  ${NumberFormat('#,##0.00').format(account['profit'])}'
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
              ],
            ),
          );
        },
      ),
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
