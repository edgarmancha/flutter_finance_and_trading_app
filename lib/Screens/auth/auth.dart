// ignore_for_file: use_build_context_synchronously
import 'package:finance/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../my_app.dart';
import '../../utils.dart';
import 'myfxbook_login.dart';
import '../../homepage/home_page.dart';
import 'login_screen.dart';

class AuthCheck extends StatefulWidget {
  final String? session;

  const AuthCheck({
    Key? key,
    this.session,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthCheckState createState() => _AuthCheckState();

  static void logout(BuildContext context) async {
    // Logout from Myfxbook
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('session');

    // Logout from Firebase
    await FirebaseAuth.instance.signOut();

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      // ignore: prefer_const_constructors
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

class _AuthCheckState extends State<AuthCheck> {
  String? _myfxbookSessionId;
  bool _showMyFxBookLogin = true; // Initialize to true

  Future<bool> _myfxbookLoginPageShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('myfxbookLoginPageShown') ?? false;
  }

  Future<bool> _checkMyfxbookSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('session');
  }

  void _onMyfxbookLogin(String session, String firebaseSession) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('session', session);
    prefs.setString('firebaseSession', firebaseSession);
    prefs.setBool('myfxbookLoginPageShown', true);
    setState(() {
      _myfxbookSessionId = session;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkMyfxbookSession().then((myfxSessionExists) {
      if (myfxSessionExists) {
        SharedPreferences.getInstance().then((prefs) {
          final session = prefs.getString('session');
          setState(() {
            _myfxbookSessionId = session;
          });
        });
      } else {
        _myfxbookLoginPageShown().then((shown) {
          if (!shown) {
            setState(() {
              _myfxbookSessionId = ''; // set to an empty string
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            // User is not logged in, show LoginPage
            return const LoginPage();
          } else {
            // User is logged in with Firebase
            if (widget.session != null && widget.session!.isNotEmpty) {
              // User is also signed in with Myfxbook, show HomePage with the session
              return MyApp(
                firebaseSession: FirebaseAuth.instance.currentUser!.uid,
                session: widget.session,
              );
            } else {
              // User is not signed in with Myfxbook, show HomePage with a null session
              return MyApp(
                firebaseSession: FirebaseAuth.instance.currentUser!.uid,
                session: null,
              );
            }
          }
        } else {
          // Show a loading indicator while the connection state is not active
          return Scaffold(
            backgroundColor: GlobalColors.primaryColor,
            body: Column(
              children: [
                // const SizedBox(height: 15),

                Text("You don't have an internet connection...",
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                      color: GlobalColors.whiteAcc,
                    )),
                CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: GlobalColors.whiteAcc.withOpacity(0.5),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
