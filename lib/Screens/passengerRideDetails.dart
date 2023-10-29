// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'dart:developer';

import 'package:book_rides/Screens/BidInfo.dart';
import 'package:book_rides/Screens/BookingCancelOptionsScreen.dart';
import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/Screens/RequestHistory.dart';
import 'package:book_rides/Screens/RideRequests.dart';
import 'package:book_rides/Services/NotificationService.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Services/mapServices.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/Widgets/Drawer.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Models/UserActiveBooking.dart';

// final bidProvider = FutureProvider.autoDispose((ref) {
//  // ref.watch(toggleBidStatus);
//   return getPassengerBidInfo(ref.read(userModelProvider).userId!);
// });

final toggleStatus = StateProvider((ref) => false);

// final toggleStatusDriver = StateProvider((ref) => false);
final rideDetailProvider = FutureProvider.autoDispose((ref) {
  ref.watch(toggleStatus);
  return getActiveBookings(ref.read(userModelProvider).userId!);
});
//final isActive = StateProvider.autoDispose((ref) => F);
final options = FutureProvider.autoDispose((ref) => bookingCancelOptions());

class RideDetails extends ConsumerStatefulWidget {
  const RideDetails({super.key});

  @override
  ConsumerState<RideDetails> createState() => _RideDeatialsState();
}

class _RideDeatialsState extends ConsumerState<RideDetails> {
  @override
  void initState() {
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   setState(() {
    //     final status = ref.read(toggleStatus);
    //     ref.read(toggleStatus.notifier).state = !status;
    //   });
    // });

    // TODO: implement initState
    super.initState();
    NotificationService.inItLocalNotification(
        context, ref.read(userModelProvider).userId!, ref);
  }

  @override
  Widget build(BuildContext context) {
    //log(ref.watch(userModelProvider).userId!);
    final value = ref.watch(rideDetailProvider);

    return LayoutBuilder(
      builder: (p0, p1) => WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).canPop()) {
            pop();
          } else {
            Get.offAll(UserMapInfo());
          }
          return F;
        },
        child: Scaffold(
            drawer: MyDrawer(),
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              elevation: 0,
              title: Text('Finding Transporters'),
              centerTitle: true,
              backgroundColor: primary,
            ),
            body: value.when(
                data: (data) {
                  final toggle = ref.read(toggleStatus);
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          backgroundColor: Colors.green,
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          color: Colors.blue.shade100,
                          child: Row(
                            children: [
                              Icon(Icons.alarm),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  data!.response![0].showTopTitle!,
                                  style: large(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 16,
                        // ),
                        BidInfoList(
                          data: data,
                          ref: ref,
                          toggle: toggle,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data.response![0].mainTitle!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        Text(data.response![index].verifyCode!)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "${data.response![0].bookingDate!}  ${data.response![0].bookingTime!}",
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          radius: 10,
                                          child: Icon(
                                            FontAwesomeIcons.a,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            data.response![0]
                                                .sourceLocationAddress!,
                                            maxLines: null,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.green,
                                          child: Icon(
                                            FontAwesomeIcons.b,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            data.response![0]
                                                .destinationLocationAddress!,
                                            maxLines: null,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.comment,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            data.response![0].comments!,
                                            maxLines: null,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "${data.response![0].showTime!} ago")),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade100,
                                            shape: roundedRectangleBorder),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return BookingCancelScreen(
                                                  book_driver_id: data
                                                      .response![0]
                                                      .bookDriverId!,
                                                );
                                              },
                                              isScrollControlled: T);
                                        },
                                        child: SizedBox(
                                            width: double.infinity,
                                            child: Center(
                                                child: Text(
                                              'Cancel Ride',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )))),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: data.response!.length,
                        ),
                      ],
                    ),
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => Center(child: RefreshProgressIndicator()))),
      ),
    );
  }
}
