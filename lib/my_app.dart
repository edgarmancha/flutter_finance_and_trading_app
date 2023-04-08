// ignore_for_file: library_private_types_in_public_api

import 'package:finance/more.dart';
import 'package:finance/updates.dart';
import 'package:finance/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Screens/auth/auth.dart';
import 'channels/chat_groups.dart';
import 'constants/colors.dart';
import 'homepage/home_page.dart';
import 'News/news.dart';

class MyApp extends StatefulWidget {
  final String? session;
  final String? firebaseSession;

  const MyApp({
    Key? key,
    this.session,
    this.firebaseSession,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _onLoggedIn(String session) {
    setState(() {
      _widgetOptions[0] = HomePage(
        firebaseSession: FirebaseAuth.instance.currentUser!.uid,
        session: widget.session,
      );
    });
  }

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      // AuthCheck(
      //   session: widget.session,
      //   firebaseSession: FirebaseAuth.instance.currentUser!.uid,
      // ),
      HomePage(
          firebaseSession: FirebaseAuth.instance.currentUser!.uid,
          session: widget.session),
      // const HomePage(),
      const ChatGroupsPage(),
      Updates(),
      const NewsDashboard(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.primaryColor,
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomAppBar(
        color: GlobalColors.primaryColor,
        child: BottomNavigationBar(
          elevation: 10,
          unselectedLabelStyle: SafeGoogleFont(
            'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            height: 1.5,
            color: GlobalColors.whiteAcc.withOpacity(0.8),
          ),
          selectedLabelStyle: SafeGoogleFont(
            'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            height: 1.5,
            color: GlobalColors.whiteAcc.withOpacity(0.8),
          ),
          unselectedItemColor: GlobalColors.whiteAcc.withOpacity(0.7),
          selectedItemColor: GlobalColors.whiteAcc.withOpacity(0.7),
          type: BottomNavigationBarType.fixed,
          backgroundColor: GlobalColors.primaryColor,
          selectedIconTheme:
              IconThemeData(color: GlobalColors.whiteAcc.withOpacity(0.7)),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.send),
              icon: Icon(Icons.send_outlined),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.notifications),
              icon: Icon(Icons.notifications_outlined),
              label: 'Updates',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.newspaper),
              icon: Icon(Icons.newspaper_outlined),
              label: 'News',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.apps),
              icon: Icon(Icons.apps_outlined),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
