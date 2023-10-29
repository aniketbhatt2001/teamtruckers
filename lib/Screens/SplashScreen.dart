// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'package:book_rides/Models/CountryListModel.dart';
import 'package:book_rides/Models/DriverSingleBookingModel.dart';
import 'package:book_rides/Screens/DirverRequestHistoryScreen.dart';
import 'package:book_rides/Screens/DriverSingleBooking.dart';
import 'package:book_rides/Screens/PermitScreen.dart';
import 'package:book_rides/Screens/SelectModeScreen.dart';
import 'package:book_rides/Screens/UserSingleBooking.dart';
import 'package:book_rides/response/Screens/RequestHistory.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:book_rides/Screens/DriverHomeScreen.dart';
import 'package:book_rides/Screens/DriverRegistration.dart';
import 'package:book_rides/Screens/Login.dart';
import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/Screens/Register.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Screens/passengerRideDetails.dart';
import 'package:book_rides/providers/BaiscProviders.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/UserAppConfigModel.dart';
import '../Models/UserModel.dart';
import '../Utils/Constatnts.dart';
import '../providers/UserModelProvider.dart';

final userAppConfigProvider =
    StateNotifierProvider<UserAppConfigModelNotifier, UserAppConfigModel>(
        (ref) => UserAppConfigModelNotifier(UserAppConfigModel()));

//final openIdProvider = StateProvider<String?>((ref) => null);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userAppConfig().then((value) {
      if (value != null) {
        ref.read(userAppConfigProvider.notifier).setState(value);
        fetchCountries().then((value) {
          if (value != null) {
            ref.read(countryListProvider.notifier).updateState(value);
            requestNotificationPermission(ref);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Image.asset(
              'assets/teamTruckers.png',
              height: p1.maxHeight / 2,
            ),
          ),
        ),
      ),
    );
  }
}

getUser(WidgetRef ref) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.getBool('loggedIn') != null) {
    final id = sharedPreferences.getString('userId');
    final user = await getmyUserDetail(id!, ref);
    ref.read(sharedPrefsProvider).setPrefs(sharedPreferences);
    if (user != null) {
      final res = await updateUserAppInfo(user.userId!, fcmToken!);

      if (res) {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        RemoteMessage? remoteMessage = await messaging.getInitialMessage();
        if (remoteMessage != null && remoteMessage.data['open_page']) {
          final String openId = remoteMessage.data['open_id'];
          final String open_page = remoteMessage.data['open_page'];
          //ref.read(openIdProvider.notifier).state = openId;
          switch (open_page) {
            case 'driver_req_booking':
              if (user.userMode != 'Driver') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'Driver');
                if (res != null) {
                  // final user = await getUserDetail(
                  //     ref.read(userModelProvider).userId!, ref);
                  if (res) {
                    ref.read(modeProvider.notifier).state = Mode.Driver;
                    Get.offAll(DriverHomeScreen());
                  }
                }
              } else {
                Get.offAll(DriverHomeScreen());
              }
              break;
            case 'driver_all_booking':
              if (user.userMode != 'Driver') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'Driver');
                if (res != null) {
                  // final user = await getUserDetail(
                  //     ref.read(userModelProvider).userId!, ref);
                  if (res) {
                    ref.read(modeProvider.notifier).state = Mode.Driver;
                    Get.offAll(DirverRequestHistoryScreen());
                  }
                }
              } else {
                Get.offAll(DirverRequestHistoryScreen());
              }
              break;
            case 'driver_single_booking':
              if (user.userMode != 'Driver') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'Driver');
                if (res != null) {
                  // final user = await getUserDetail(
                  //     ref.read(userModelProvider).userId!, ref);
                  if (res) {
                    ref.read(modeProvider.notifier).state = Mode.Driver;
                    Get.offAll(DriverSingleBooking(
                      book_driver_id: openId!,
                    ));
                  }
                }
              } else {
                Get.offAll(DriverSingleBooking(
                  book_driver_id: openId!,
                ));
              }
              break;
            case 'active_booking':
              if (user.userMode != 'Customer') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'Customer');

                if (res != null) {
                  ref.read(modeProvider.notifier).state = Mode.Customer;
                  Get.offAll(RideDetails());
                }
              } else {
                Get.offAll(RideDetails());
              }
              break;
            case 'all_booking':
              if (user.userMode != 'Customer') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'Customer');

                // final user = await getUserDetail(
                //     ref.read(userModelProvider).userId!, ref);
                if (res != null) {
                  ref.read(modeProvider.notifier).state = Mode.Customer;
                  Get.offAll(RequestHistory());
                }
              } else {
                Get.offAll(Get.offAll(RequestHistory()));
              }
              break;
            case 'single_booking':
              if (user.userMode != 'Customer') {
                final res = await changeUserMode(
                    ref.read(userModelProvider).userId!, 'DrivCustomerer');

                // final user = await getUserDetail(
                //     ref.read(userModelProvider).userId!, ref);
                if (res != null) {
                  ref.read(modeProvider.notifier).state = Mode.Customer;
                  Get.offAll(UserSingleBooking(
                    book_driver_id: openId,
                  ));
                }
              } else {
                Get.offAll(UserSingleBooking(
                  book_driver_id: openId,
                ));
              }
              break;
            default:
              Get.offAll(LoginForm());
          }
        } else if (user.show_user_mode_screen == '1') {
          Get.offAll(SelectModescreen());
        } else if (user.showRegisterScreen == '1') {
          Get.offAll(RegistrationScreen());
        } else if (user.userMode == 'Driver') {
          ref.read(modeProvider.notifier).state = Mode.Driver;
          if (user.show_register_driver_screen == '1') {
            Get.offAll(DriverRegistration());
          } else {
            Get.offAll(DriverHomeScreen());
          }
        } else if (user.userMode == 'Customer') {
          ref.read(modeProvider.notifier).state = Mode.Customer;
          // Get.offAll(UserMapInfo());
          final response = await getActiveBookings(id);
          if (response != null) {
            Get.offAll(RideDetails());
          } else {
            if (ref.read(userModelProvider).showRegisterScreen == '1') {
              Get.offAll(RegistrationScreen());
            } else {
              Get.offAll(UserMapInfo());
            }
          }
        }
      }
    }
  } else {
    Get.offAll(LoginForm());
  }
}

Future<UserModel?> getmyUserDetail(String id, WidgetRef ref) async {
  final respoonse =
      await ApiServices.getResponse('$baseUrl/user/user_detail/MOB/$id');

  return respoonse.fold((l) {
    Get.snackbar(l.message, 'inside getUserDetail');
    return null;
  }, (r) {
    final res = r.body;
    final user = ref
        .read(userModelProvider.notifier)
        .updateUserModel(UserModel.fromJson(res['response'][0]));

    return user;
  });
}

Future<void> requestNotificationPermission(WidgetRef ref) async {
  final PermissionStatus status = await Permission.notification.request();
  final PermissionStatus location = await Permission.location.request();
  if (status.isDenied && location.isDenied) {
    // Permission denied
    // You can show a message or perform any desired action
    showFailureBar('Please grant requrired permissions');
  } else {
    getUser(ref);
  }
}
