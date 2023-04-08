// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/constants/colors.dart';
import 'package:finance/my_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/auth/auth.dart';
import 'channels/chat_page.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // Initialize Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle the notification received when the user taps on the notification
    print('Message opened: ${message.notification?.body}');
    // Check if the message is of the chat message type
    if (message.data['type'] == 'CHAT_MESSAGE') {
      String chatGroupId = message.data['chatGroupId'];
      // Navigate to the chat screen for the chatGroupId
    }
  });

  // Set up notification settings and handlers
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle the notification received while the app is in the foreground
    print('Message received: ${message.notification?.body}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle the notification received when the user taps on the notification
    print('Message opened: ${message.notification?.body}');
  });
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final prefs = await SharedPreferences.getInstance();
  final session = prefs.getString('session');
  final firebaseSession = prefs.getString('firebaseSession');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'TradeStack',
    theme: ThemeData(primarySwatch: Colors.indigo),
    // home: AuthCheck(
    //   session: session,
    // ),
    initialRoute: '/',
    routes: {
      '/': (context) => AuthCheck(session: session),
      '/chat': (context) => const ChatPage(
          chatGroupId: '',
          chatGroupName: '',
          chatGroupPhotoUrl: '',
          chatGroupDescription: ''),
    },
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GlobalColors.primaryColor,
      systemNavigationBarColor: GlobalColors.primaryColor));
}
