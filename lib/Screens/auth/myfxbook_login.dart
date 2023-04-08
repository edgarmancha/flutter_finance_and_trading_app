// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:finance/Screens/auth/myfxbook_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../constants/colors.dart';
import '../../utils.dart';
import '../../homepage/home_page.dart';

class MyfxbookLoginPage extends StatefulWidget {
  final ValueChanged<String> onLoggedIn;

  const MyfxbookLoginPage({Key? key, required this.onLoggedIn})
      : super(key: key);

  @override
  _MyfxbookLoginPageState createState() => _MyfxbookLoginPageState();
}

class _MyfxbookLoginPageState extends State<MyfxbookLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleSkipLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          firebaseSession: FirebaseAuth.instance.currentUser!.uid,
          session: '',
        ),
      ),
    );
  }

  Future<void> _myfxbookLogin() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'https://www.myfxbook.com/api/login.json?email=${_emailController.text}&password=${_passwordController.text}'),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] == false) {
        final String session = jsonResponse['session'];
        await _saveSession(session);
        widget.onLoggedIn(
            session); // Inform the _HomePageState about the new session ID

        // Navigate to the HomePage by replacing the current route
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              firebaseSession: FirebaseAuth.instance.currentUser!.uid,
              session: session,
            ),
          ),
        );
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

  Future<void> _saveSession(String session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'firebase_session', FirebaseAuth.instance.currentUser!.uid);
    await prefs.setString('myfxbook_session', session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/dark_back.png"), fit: BoxFit.cover)),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/tradestack.png",
                    width: 200,
                    alignment: Alignment.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Material(
                    child: SizedBox(
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white.withOpacity(0.9)),
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            "Sign In",
                                            style: SafeGoogleFont(
                                              'Roboto',
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5,
                                              color:
                                                  GlobalColors.secondaryColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            "To get full access to more features on the app, please Sign In with your MYFXBOOK login details or you can skip this",
                                            style: SafeGoogleFont(
                                              'Roboto',
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              height: 1.5,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                            labelText: 'Email',
                                            hintText: 'Enter your email',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Password',
                                            hintText: 'Enter your password',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            return null;
                                          },
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              GlobalColors
                                                                  .secondaryColor
                                                                  .withOpacity(
                                                                      0.7)),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          side: BorderSide(
                                                              color: GlobalColors
                                                                  .secondaryColor),
                                                        ),
                                                      ),
                                                      fixedSize:
                                                          MaterialStateProperty
                                                              .all<Size>(
                                                        const Size(
                                                            double.infinity,
                                                            40),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        _myfxbookLogin();
                                                      }
                                                    },
                                                    child: const Text('Login'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 7,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              GlobalColors
                                                                  .secondaryColor
                                                                  .withOpacity(
                                                                      0.7)),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          side: BorderSide(
                                                              color: GlobalColors
                                                                  .secondaryColor),
                                                        ),
                                                      ),
                                                      fixedSize:
                                                          MaterialStateProperty
                                                              .all<Size>(
                                                        const Size(
                                                            double.infinity,
                                                            40),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (_) {
                                                            return const MyfxBookSignup();
                                                          });
                                                    },
                                                    child: const Text(
                                                        'MyFXBook Signup'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .red
                                                                  .withOpacity(
                                                                      0.7)),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                      fixedSize:
                                                          MaterialStateProperty
                                                              .all<Size>(
                                                        const Size(
                                                            double.infinity,
                                                            40),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      _handleSkipLogin();
                                                    },
                                                    child: const Text('Skip'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
