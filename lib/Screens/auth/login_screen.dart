// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../utils.dart';
import 'signup_screen.dart';
import 'reset_password.dart';
import '../../homepage/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? firebaseSession;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final prefs = await SharedPreferences.getInstance();
        final myfxbookSession = prefs.getString('myfxbook_session');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              firebaseSession: firebaseUser.uid,
              session: '', // Pass the Myfxbook session ID
            ),
          ),
          (Route<dynamic> route) =>
              false, // This will remove all previous routes from the stack
        );
        print(firebaseUser.uid);
        print(myfxbookSession);
      }
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to login. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firebaseSession = prefs.getString('firebaseSession');
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
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
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
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
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
                                            "Sign in",
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
                                        TextFormField(
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            errorStyle:
                                                TextStyle(color: Colors.red),
                                            labelText: 'Email',
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: true,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            errorStyle:
                                                TextStyle(color: Colors.red),
                                            labelText: 'Password',
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(GlobalColors
                                                            .secondaryColor
                                                            .withOpacity(0.7)),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    side: BorderSide(
                                                        color: GlobalColors
                                                            .secondaryColor),
                                                  ),
                                                ),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(
                                                  const Size(
                                                      double.infinity, 40),
                                                ),
                                              ),
                                              onPressed:
                                                  _isLoading ? null : _login,
                                              child: _isLoading
                                                  ? const CircularProgressIndicator()
                                                  : const Text('Login'),
                                            ),
                                          ),
                                        ]),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "OR",
                                          style: SafeGoogleFont(
                                            'Roboto',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            height: 1.5,
                                            color: GlobalColors.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(GlobalColors
                                                            .secondaryColor
                                                            .withOpacity(0.7)),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    side: BorderSide(
                                                        color: GlobalColors
                                                            .secondaryColor),
                                                  ),
                                                ),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(
                                                  const Size(
                                                      double.infinity, 40),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          (const RegistrationPage())),
                                                );
                                              },
                                              child: const Text('Sign Up'),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(GlobalColors
                                                            .secondaryColor
                                                            .withOpacity(0.7)),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    side: BorderSide(
                                                        color: GlobalColors
                                                            .secondaryColor),
                                                  ),
                                                ),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(
                                                  const Size(
                                                      double.infinity, 40),
                                                ),
                                              ),
                                              onPressed: () {
                                                // TODO: Navigate to password reset screen
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          // ignore: prefer_const_constructors
                                                          (ResetPasswordPage())),
                                                );
                                              },
                                              child: const Text(
                                                  'Forgot password?'),
                                            ),
                                          ),
                                        ]),
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
