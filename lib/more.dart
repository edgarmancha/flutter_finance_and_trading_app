// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/Screens/auth/auth.dart';
import 'package:finance/constants/colors.dart';
import 'package:finance/utils.dart';
import 'package:finance/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _fullName; // Add a field to store the user's full name
  bool _isLoading = true;

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
          setState(() {
            _fullName = '$firstName $lastName';
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Settings'),
      backgroundColor: GlobalColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage(
                                    'assets/american-flag-medium.jpg'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 1,
                                color: GlobalColors.whiteAcc.withOpacity(0.7))),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: GlobalColors.thirdColor,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        height: 35,
                        decoration: BoxDecoration(
                            color: GlobalColors.thirdColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text('@ username',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                              color: GlobalColors.whiteAcc,
                            )),
                      ),
                      const SizedBox(width: 10),
                      Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          height: 35,
                          decoration: BoxDecoration(
                              color: GlobalColors.thirdColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(5)),
                          child: Icon(
                            Icons.share,
                            size: 20,
                            color: GlobalColors.whiteAcc.withOpacity(0.7),
                          )),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          AuthCheck.logout(context);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            height: 35,
                            decoration: BoxDecoration(
                                color: GlobalColors.thirdColor.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(5)),
                            child: Icon(
                              Icons.logout,
                              size: 20,
                              color: GlobalColors.whiteAcc.withOpacity(0.7),
                            )),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15),
              Text(_fullName ?? 'TradeStack User',
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: GlobalColors.whiteAcc,
                  )),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    decoration: BoxDecoration(
                        color: GlobalColors.thirdColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text('View Profile',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                          color: GlobalColors.whiteAcc,
                        )),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    decoration: BoxDecoration(
                        color: GlobalColors.secondaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text('Edit Profile',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                          color: GlobalColors.whiteAcc,
                        )),
                  )),
                ],
              )
            ]),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.bottomLeft,
                            height: 50,
                            child: Text('App Preferences',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  color: GlobalColors.whiteAcc,
                                )),
                          ),
                          Icon(
                            Icons.settings,
                            color: GlobalColors.whiteAcc.withOpacity(0.7),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: GlobalColors.whiteAcc.withOpacity(0.7),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.bottomLeft,
                            height: 50,
                            child: Text('About Us',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  color: GlobalColors.whiteAcc,
                                )),
                          ),
                          Icon(
                            Icons.book_online,
                            color: GlobalColors.whiteAcc.withOpacity(0.7),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: GlobalColors.whiteAcc.withOpacity(0.7),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.bottomLeft,
                            height: 50,
                            child: Text('Security',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  color: GlobalColors.whiteAcc,
                                )),
                          ),
                          Icon(
                            Icons.lock,
                            color: GlobalColors.whiteAcc.withOpacity(0.7),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: GlobalColors.whiteAcc.withOpacity(0.7),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.bottomLeft,
                            height: 50,
                            child: Text('Legal',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  color: GlobalColors.whiteAcc,
                                )),
                          ),
                          Icon(
                            Icons.gavel,
                            color: GlobalColors.whiteAcc.withOpacity(0.7),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: GlobalColors.whiteAcc.withOpacity(0.7),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.bottomLeft,
                            height: 50,
                            child: Text('Get Help',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  color: GlobalColors.whiteAcc,
                                )),
                          ),
                          Icon(
                            Icons.help,
                            color: GlobalColors.whiteAcc.withOpacity(0.7),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: GlobalColors.whiteAcc.withOpacity(0.7),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            AuthCheck.logout(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text('Logout',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  color: GlobalColors.whiteAcc,
                                )),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
