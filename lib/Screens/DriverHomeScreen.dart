// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:book_rides/Screens/DirverRequestHistoryScreen.dart';
import 'package:book_rides/Screens/DriverEarnings.dart';
import 'package:book_rides/Screens/DriverRegistration.dart';
import 'package:book_rides/Screens/MyIncome.dart';

import 'package:book_rides/Screens/RideRequests.dart';
import 'package:book_rides/Services/NotificationService.dart';
import 'package:book_rides/Services/mapServices.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/Widgets/Drawer.dart';
import 'package:book_rides/Widgets/DriverDrawer.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Services/apis_services.dart';
import '../main.dart';

final driverSCreenIndex = StateProvider.autoDispose((ref) => 0);

class DriverHomeScreen extends ConsumerStatefulWidget {
  DriverHomeScreen({
    super.key,
  });

  @override
  ConsumerState<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends ConsumerState<DriverHomeScreen> {
  // bool isSwitched = false;
  List screens = [
    RideRequests(),
    const DirverRequestHistoryScreen2(),
    MyEarnings()
    // const Rating()
  ];
  late StreamSubscription? streamSubscription;
  //int index = 0;
  int initialIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamSubscription = updateUserLocation(ref);
    NotificationService.inItLocalNotification(
        context, ref.read(userModelProvider).userId!, ref);
    initialIndex = ref.read(userModelProvider).isOnline == '1' ? 1 : 0;

    //updateUserAppInfo(ref.read(userModelProvider).userId!, fcmToken!);
  }

  @override
  Widget build(BuildContext context) {
    // log(fcmToken!);
    // final currentRoute = ModalRoute.of(navigatorKey.currentContext!);
    // print(currentRoute?.settings.name);
    // print(ref.read(userModelProvider).adminApproved);
    // print(ref.read(userModelProvider).adminApprovedDriver);
    final index = ref.watch(driverSCreenIndex);
    final perct = ref.watch(
        userModelProvider.select((value) => value.driver_form_percentage));
    return WillPopScope(
      onWillPop: () async {
        return F;
      },
      child: Scaffold(
        bottomNavigationBar:
            ref.read(userModelProvider).adminApprovedDriver == '1'
                ? BottomNavigationBar(
                    currentIndex: index,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.list,
                          ),
                          label: 'Ride request'),
                      BottomNavigationBarItem(
                          icon: Icon(
                            FontAwesomeIcons.history,
                          ),
                          label: 'My History'),
                      BottomNavigationBarItem(
                          icon: Icon(
                            FontAwesomeIcons.moneyBill,
                          ),
                          label: 'My Earning'),
                    ],
                    onTap: (value) {
                      setState(() {
                        //   index = value;
                        ref.read(driverSCreenIndex.notifier).state = value;
                      });
                    },
                  )
                : null,
        drawer: DriverDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primary,

          elevation: 0,
          // actions: [
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
          // ],
          centerTitle: true,

          iconTheme: const IconThemeData(color: Colors.white),

          title: Opacity(
            opacity: ref.read(userModelProvider).adminApprovedDriver == '1'
                ? 1
                : 0.1,
            child: ToggleSwitch(
              borderColor: [initialIndex == 1 ? Colors.green : Colors.red],
              borderWidth: 1,
              minHeight: 40,
              minWidth: 90.0,
              cornerRadius: 20.0,
              activeBgColors: [
                [Colors.red[800]!],
                [Colors.green[800]!]
              ],
              inactiveBgColor: Colors.white,
              initialLabelIndex: initialIndex,
              totalSwitches: 2,
              labels: const ['Offline', 'Online'],
              radiusStyle: true,
              onToggle: (index) {
                if (ref.read(userModelProvider).adminApprovedDriver == '1' &&
                    mounted) {
                  setState(() {
                    initialIndex = index!;
                    if (initialIndex == 1) {
                      updateDriverOnlineStatus(
                              ref.read(userModelProvider).userId!)
                          .then((value) {
                        pop();
                        if (value) {
                          final status =
                              ref.read(toggleUserActiveBookingStatus);
                          ref
                              .read(toggleUserActiveBookingStatus.notifier)
                              .state = !status;
                          ref
                              .read(userModelProvider.notifier)
                              .updateStatuts('1');
                        }
                      });
                    } else {
                      updateDriverOfflineStatus(
                              ref.read(userModelProvider).userId!)
                          .then((value) {
                        if (value) {
                          final status =
                              ref.read(toggleUserActiveBookingStatus);
                          ref
                              .read(toggleUserActiveBookingStatus.notifier)
                              .state = !status;
                          ref
                              .read(userModelProvider.notifier)
                              .updateStatuts('0');
                        }
                      });
                    }
                  });
                } else {
                  setState(() {
                    if (index == 1) {
                      initialIndex = 0;
                    } else if (index == 0) {
                      initialIndex = 1;
                    }
                  });
                }
              },
            ),
          ),
          // title: const Text(
          //   'City to City',
          //   style: TextStyle(color: Colors.black),
          // ),
        ),
        body: ref.read(userModelProvider).adminApprovedDriver == '1'
            ? screens[index]
            : Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 100, left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ref.read(userModelProvider).driver_form_percentage == '100'
                        ? Image.asset(
                            'assets/server.png',
                            height: 300,
                            fit: BoxFit.fill,
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 22,
                    ),
                    ref.read(userModelProvider).driver_form_percentage == '100'
                        ? Text(
                            ref.read(userModelProvider).adminMessageDriver!,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    ref.read(userModelProvider).driver_form_percentage != '100'
                        ? Column(
                            children: [
                              Image.asset(
                                'assets/home_id.png',
                                height: 300,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Registration Completed',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    final percentage = ref.watch(
                                        userModelProvider.select((value) =>
                                            value.driver_form_percentage));
                                    return LinearPercentIndicator(
                                      barRadius: Radius.circular(10),
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      animation: true,
                                      lineHeight: 20.0,
                                      animationDuration: 2000,
                                      percent: percentage != null
                                          ? double.parse(percentage!) / 100
                                          : 0,
                                      center: Text(
                                        "${ref.read(userModelProvider).driver_form_percentage}%",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      progressColor: primary,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: roundedRectangleBorder,
                                    backgroundColor: primary),
                                onPressed: () {
                                  Get.to(DriverRegistration());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Text('Please complete your registraion'),
                                ),
                              )
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (streamSubscription != null) {
      streamSubscription!.cancel();
    }
  }
}
