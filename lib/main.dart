// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:book_rides/Screens/DriverHomeScreen.dart';
import 'package:book_rides/Screens/Login.dart';
import 'package:book_rides/Screens/OtpScreen.dart';

import 'package:book_rides/Screens/Register.dart';
import 'package:book_rides/Screens/RideRequests.dart';
import 'package:book_rides/Screens/SelectModeScreen.dart';
import 'package:book_rides/Screens/SplashScreen.dart';
import 'package:book_rides/Widgets/MyRating.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import 'Utils/Constatnts.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('inside background');
  // showSimpleNotification(Container(
  //   child: Text(message.notification!.body!),
  // ));
  // print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  fcmToken = await messaging.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await messaging.subscribeToTopic("all");
  runApp(ProviderScope(
      child: GetMaterialApp(
    home: MyApp(),
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    routes: {
      '/driver_home': (p0) => DriverHomeScreen(),
      '/ride_req': (p0) => RideRequests(),
    },
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SplashScreen();
  }
}
