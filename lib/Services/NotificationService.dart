import 'dart:convert';
import 'dart:developer';
import 'package:book_rides/Screens/DirverRequestHistoryScreen.dart';
import 'package:book_rides/Screens/DriverHomeScreen.dart';
import 'package:book_rides/Screens/DriverSingleBooking.dart';
import 'package:book_rides/Screens/RideRequests.dart';
import 'package:book_rides/Screens/passengerRideDetails.dart';
import 'package:book_rides/Widgets/MyRating.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:overlay_support/overlay_support.dart';
import '../Utils/Constatnts.dart';
import '../main.dart';
import '../providers/BaiscProviders.dart';
import '../providers/LocationProviders.dart';
import 'apis_services.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static void inItLocalNotification(
      BuildContext context, String userId, WidgetRef ref) async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    // IOSInitializationSettings iosInitializationSettings = const IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        //iOS: iosInitializationSettings
        iOS: const DarwinInitializationSettings());

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        final navigator = Navigator.of(navigatorKey.currentContext!);
        log('inside onDidReceiveNotificationResponse');
        // String map = details.payload.toString();
        final encodedJson = details.payload!;
        final Map<String, dynamic> decodedJson =
            jsonDecode(encodedJson) as Map<String, dynamic>;
        final open_page = decodedJson['open_page'];
        final openSlug = decodedJson['open_slug'];
        final String? open_id = decodedJson['open_id'];
        // log(openPage);
        if (open_page != null) {
          switch (open_page) {
            case 'driver_all_booking':
              if (ref.read(userModelProvider).userMode != 'Driver') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'Driver');
                if (res != null) {
                  ref.read(modeProvider.notifier).state = Mode.Driver;
                  Get.offAll(const DirverRequestHistoryScreen());
                }
              } else {
                Get.offAll(const DirverRequestHistoryScreen());
              }
              break;
            case 'driver_single_booking':
              if (ref.read(userModelProvider).userMode != 'Driver') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'Driver');
                if (res != null) {
                  ref.read(modeProvider.notifier).state = Mode.Driver;
                  Get.offAll(DriverSingleBooking(book_driver_id: open_id!));
                }
              } else {
                Get.offAll(DriverSingleBooking(book_driver_id: open_id!));
              }
              break;
            case 'booking_accepted':
              if (ref.read(userModelProvider).userMode != 'Customer') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'Customer');
                if (res != null) {
                  ref.read(modeProvider.notifier).state = Mode.Customer;
                  Get.offAll(const RideDetails());
                }
              } else {
                Get.offAll(const RideDetails());
              }
              break;
            case 'driver_req_booking':
              if (ref.read(userModelProvider).userMode != 'Driver') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'Driver');
                if (res != null) {
                  ref.read(modeProvider.notifier).state = Mode.Driver;
                  Get.offAll(DriverHomeScreen());
                }
              } else if (ref.read(userModelProvider).userMode == 'Driver' &&
                  ref.read(driverSCreenIndex) != 0) {
                ref.refresh(driverSCreenIndex);
              } else if (ref.read(userModelProvider).userMode == 'Driver' &&
                  navigator.canPop()) {
                ref.refresh(driverSCreenIndex);
                Get.offAll(DriverHomeScreen());
              }
              break;
          }
        }
      },
    );

    FirebaseMessaging.onMessage.listen((event) async {
      final navigator = Navigator.of(navigatorKey.currentContext!);
      // final currentRoute = ModalRoute.of(navigatorKey.currentContext!);

      final data = event.data;
      final String? open_id = data['open_id'];
      final String? open_page = data['open_page'];
      final String title = event.notification!.title!;
      switch (open_page) {
        case 'driver_req_booking':
          if (ref.read(userModelProvider).userMode == 'Driver' &&
              ref.read(driverSCreenIndex) != 0) {
            Get.dialog(AlertDialog(
              shape: roundedRectangleBorder,
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              title: Text(title ?? ''),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: black,
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.refresh(driverSCreenIndex);
                      Get.back(closeOverlays: T);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'Ok',
                        style: TextStyle(fontSize: 18, color: primary),
                      ),
                    ),
                  ),
                ],
              ),
            ));
          } else if (ref.read(userModelProvider).userMode == 'Driver' &&
              navigator.canPop()) {
            Get.dialog(AlertDialog(
              shape: roundedRectangleBorder,
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: black,
                  ),
                  GestureDetector(
                      onTap: () {
                        ref.refresh(driverSCreenIndex);

                        navigator.pushNamedAndRemoveUntil(
                            '/driver_home', (route) => false);

                        // navigator.pushNamedAndRemoveUntil(
                        //     '/driver_home', (route) => false);
                        // Check if the current route is not the home page
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          'Ok',
                          style: TextStyle(fontSize: 18, color: primary),
                        ),
                      )),
                ],
              ),
            ));
          } else if (ref.read(userModelProvider).userMode == 'Customer') {
            Get.dialog(AlertDialog(
              shape: roundedRectangleBorder,
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: black,
                  ),
                  GestureDetector(
                      onTap: () async {
                        Get.back(closeOverlays: true);
                        final res = await changeUserMode(
                            ref.read(userModelProvider).userId!, 'Driver');
                        if (res != null) {
                          ref.read(modeProvider.notifier).state = Mode.Driver;
                          navigator.pushNamedAndRemoveUntil(
                              '/driver_home', (route) => false);
                        }

                        // navigator.pushNamedAndRemoveUntil(
                        //     '/driver_home', (route) => false);
                        // Check if the current route is not the home page
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          'Ok',
                          style: TextStyle(fontSize: 18, color: primary),
                        ),
                      )),
                ],
              ),
            ));
          }

          break;
        case 'driver_booking_complete_review':
          showDriverRatingAppDialog(open_id!, userId);
          break;

        case 'booking_complete_review':
          showUserRatingAppDialog(open_id!, ref);
          break;
        case 'driver_all_booking':
          Get.dialog(AlertDialog(
            shape: roundedRectangleBorder,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  color: black,
                ),
                GestureDetector(
                    onTap: () async {
                      Get.back(closeOverlays: true);
                      if (ref.read(userModelProvider).userMode != 'Driver') {
                        final res = await changeUserMode(
                            ref.read(userModelProvider).userId!, 'Driver');
                        if (res != null) {
                          ref.read(modeProvider.notifier).state = Mode.Driver;
                          Get.offAll(const DirverRequestHistoryScreen());
                        }
                      } else {
                        Get.offAll(const DirverRequestHistoryScreen());
                      }

                      // navigator.pushNamedAndRemoveUntil(
                      //     '/driver_home', (route) => false);
                      // Check if the current route is not the home page
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'Ok',
                        style: TextStyle(fontSize: 18, color: primary),
                      ),
                    )),
              ],
            ),
          ));
          break;
        case 'driver_single_booking':
          Get.dialog(AlertDialog(
            shape: roundedRectangleBorder,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  color: black,
                ),
                GestureDetector(
                    onTap: () async {
                      Get.back(closeOverlays: true);
                      if (ref.read(userModelProvider).userMode != 'Driver') {
                        final res = await changeUserMode(
                            ref.read(userModelProvider).userId!, 'Driver');
                        if (res != null) {
                          ref.read(modeProvider.notifier).state = Mode.Driver;
                          Get.offAll(DriverSingleBooking(
                            book_driver_id: open_id!,
                          ));
                        }
                      } else {
                        Get.offAll(DriverSingleBooking(
                          book_driver_id: open_id!,
                        ));
                      }

                      // navigator.pushNamedAndRemoveUntil(
                      //     '/driver_home', (route) => false);
                      // Check if the current route is not the home page
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'Ok',
                        style: TextStyle(fontSize: 18, color: primary),
                      ),
                    )),
              ],
            ),
          ));
          break;
      }
      // if (event.notification!.body == 'Booking request has been completed' ||
      //     event.notification!.title == 'Booking request has been completed') {
      // Get.dialog(AlertDialog(
      //   contentPadding: EdgeInsets.all(0),
      //   title: Text('Booking request has been completed'),
      //   content: TextButton(
      //       onPressed: () {
      //         pop();
      //         ref.refresh(driverSCreenIndex);
      //       },
      //       child: Text(
      //         'Ok',
      //         style: TextStyle(fontSize: 18),
      //       )),
      // ));
      // }
      //  log('open id ${event.data['open_id'].toString()}');
      await showNotification(event, context, userId);
      // final status = ref.read(toggleStatus);
      // ref.read(toggleStatus.notifier).state = !status;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      log('inside onMessageOpenedApp');
      await showNotification(event, context, userId);
      // final status = ref.read(toggleStatus);
      // ref.read(toggleStatus.notifier).state = !status;
    });
  }

  static Future<void> showNotification(
      RemoteMessage message, BuildContext context, String userId) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      '1',
      "High Importance Notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            priority: Priority.max);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, notificationDetails,
        payload: jsonEncode(message.data));

    // showSimpleNotification(Column(mainAxisSize: MainAxisSize.min, children: [
    //   Text(message.notification!.title!),
    //   SizedBox(
    //     height: 4,
    //   ),
    //   Text(message.notification!.body!)
    // ]));
  }

  static Future<bool> requestNotification() async {
    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
      // TODO: handle the received notificationselse {
    } else {
      print('User declined or has not accepted permission');

      return false;
    }
  }

// static void fireBaseInIt(){

//   FirebaseMessaging.onMessage.listen((event) {
//     log("new message while app in  foreground ");
//     log(event.notification!.body!);
//    // showSimpleNotification(Text(event.notification!.body!));
//     //inItLocalNotification(event);
//   });

//   FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       log("mesaage opened");

//   });

// }
  void handleNotificationTap(String? payload) {
    // Handle the tap action based on the provided payload
    // (e.g., navigate to a specific screen, perform an action, etc.)
  }
}
