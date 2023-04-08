// // // ignore_for_file: library_private_types_in_public_api

// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // import '../../my_app.dart';
// // import 'auth.dart';
// // import 'myfxbook_login.dart';

// // class RootApp extends StatelessWidget {
// //   final String? session;
// //   const RootApp({Key? key, this.session}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'TradeStack',
// //       theme: ThemeData(primarySwatch: Colors.blue),
// //       home: AuthCheck(session: session),

// //       // home: MyApp(session: session),

// //       routes: {
// //         '/home': (context) => const MyApp(),
// //         '/myfxbook-login': (context) => MyfxbookLoginPage(
// //               onLoggedIn: (session) {
// //                 // Store session in shared preferences
// //                 final prefs = SharedPreferences.getInstance();
// //                 prefs.then((value) => value.setString('session', session));
// //                 Navigator.pushReplacementNamed(context, '/home',
// //                     arguments: session);
// //               },
// //             ),
// //       },
// //     );
// //   }
// // }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../channels/chat_groups.dart';
// import '../../constants/colors.dart';
// import '../../homepage/home_page.dart';
// import '../../more.dart';
// import '../../updates.dart';
// import '../../utils.dart';

// class MainAppContent extends StatefulWidget {
//   final String? session;
//   const MainAppContent({Key? key, this.session}) : super(key: key);

//   @override
//   _MainAppContentState createState() => _MainAppContentState();
// }

// class _MainAppContentState extends State<MainAppContent> {
//   int _selectedIndex = 0;

//   List<Widget> _widgetOptions = [];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Future<String?> _getMyFxBookSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     final myfxbookSession = prefs.getString('session');
//     return myfxbookSession;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _widgetOptions = [
//       HomePage(
//         firebaseSession: FirebaseAuth.instance.currentUser?.uid,
//         session: widget.session,
//       ),
//       const ChatGroupsPage(),
//       Updates(),
//       const SettingsPage(),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String?>(
//       future: _getMyFxBookSession(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           _widgetOptions = [
//             HomePage(
//               firebaseSession: FirebaseAuth.instance.currentUser?.uid,
//               session: widget.session,
//             ),
//             const ChatGroupsPage(),
//             Updates(),
//             const SettingsPage(),
//           ];

//           return Scaffold(
//             backgroundColor: GlobalColors.primaryColor,
//             body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
//             bottomNavigationBar: BottomAppBar(
//               color: GlobalColors.primaryColor,
//               child: BottomNavigationBar(
//                 elevation: 10,
//                 unselectedLabelStyle: SafeGoogleFont(
//                   'Poppins',
//                   fontSize: 12,
//                   fontWeight: FontWeight.normal,
//                   height: 1.5,
//                   color: GlobalColors.whiteAcc.withOpacity(0.8),
//                 ),
//                 selectedLabelStyle: SafeGoogleFont(
//                   'Poppins',
//                   fontSize: 12,
//                   fontWeight: FontWeight.normal,
//                   height: 1.5,
//                   color: GlobalColors.whiteAcc.withOpacity(0.8),
//                 ),
//                 unselectedItemColor: GlobalColors.whiteAcc.withOpacity(0.7),
//                 selectedItemColor: GlobalColors.whiteAcc.withOpacity(0.7),
//                 type: BottomNavigationBarType.fixed,
//                 backgroundColor: GlobalColors.primaryColor,
//                 selectedIconTheme: IconThemeData(
//                     color: GlobalColors.whiteAcc.withOpacity(0.7)),
//                 items: const <BottomNavigationBarItem>[
//                   BottomNavigationBarItem(
//                     activeIcon: Icon(Icons.home),
//                     icon: Icon(Icons.home_outlined),
//                     label: 'Home',
//                   ),
//                   BottomNavigationBarItem(
//                     activeIcon: Icon(Icons.send),
//                     icon: Icon(Icons.send_outlined),
//                     label: 'Chat',
//                   ),
//                   BottomNavigationBarItem(
//                     activeIcon: Icon(Icons.notifications),
//                     icon: Icon(Icons.notifications_outlined),
//                     label: 'Updates',
//                   ),
//                   BottomNavigationBarItem(
//                     activeIcon: Icon(Icons.apps),
//                     icon: Icon(Icons.apps_outlined),
//                     label: 'More',
//                   ),
//                 ],
//                 currentIndex: _selectedIndex,
//                 onTap: _onItemTapped,
//               ),
//             ),
//           );
//         } else {
//           // Show a loading indicator while the session is being fetched
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//       },
//     );
//   }
// }
