// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:book_rides/Models/BookingHistoryModel.dart';
import 'package:book_rides/Screens/DriverHomeScreen.dart';
import 'package:book_rides/Screens/DriverSingleBooking.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/Widgets/RequestHeadersDriver.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Widgets/Badge.dart';
import '../main.dart';
import '../providers/BaiscProviders.dart';
import 'RideRequests.dart';

final driverHistoryProvider =
    FutureProvider.autoDispose.family((ref, String slug) {
  ref.watch(filterSlugSelected);
  return getDriverBookingHistories(ref.read(userModelProvider).userId!, slug);
});

class DirverRequestHistoryScreen extends ConsumerWidget {
  const DirverRequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data =
        ref.watch(driverHistoryProvider(ref.read(filterSlugSelected) ?? 'ALL'));

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          pop();
        } else {
          Get.offAll(DriverHomeScreen());
        }
        return F;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primary,
          title: Text('Request History'),
        ),
        body: renderDriverHistoryList(data),
      ),
    );
  }
}

Column renderDriverHistoryList(AsyncValue<BookingHistoryModel?> data) {
  return Column(children: [
    SizedBox(height: 70, child: DriverRequestHistoryHeadersList()),
    Expanded(
      child: data.when(
        data: (data) {
          return data != null
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(DriverSingleBooking(
                          book_driver_id: data.response![index].bookDriverId!,

                          // date: data.response![index].dateTime!
                        ));
                      },
                      child: Card(
                        elevation: 5,
                        margin:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data.response![index].dateTime!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  MyBadge(
                                    color: data
                                        .response![index].showStatusBgcolor!,
                                    status: data.response![index].showStatus!,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 8,
                                    child: Icon(
                                      FontAwesomeIcons.a,
                                      color: Colors.white,
                                      size: 8,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    data.response![index]
                                        .sourceLocationAddress!,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      FontAwesomeIcons.b,
                                      size: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Text(
                                    data.response![index]
                                        .destinationLocationAddress!,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              data.response![index].fare!.isNotEmpty
                                  ? Row(
                                      children: [
                                        Text('Fare :'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data.response![index].fare!,
                                          maxLines: null,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: data!.response!.length,
                )
              : Center(
                  child: Text(
                    'Data Not Found',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () {
          return Center(child: const RefreshProgressIndicator());
        },
      ),
    )
  ]);
}

class DirverRequestHistoryScreen2 extends ConsumerWidget {
  const DirverRequestHistoryScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final currentRoute = ModalRoute.of(navigatorKey.currentContext!);
    // //print(fcmToken);
    // print(currentRoute?.settings.name);
    final data =
        ref.watch(driverHistoryProvider(ref.read(filterSlugSelected) ?? 'ALL'));

    return Scaffold(body: renderDriverHistoryList(data)
        //  Column(children: [
        //   SizedBox(height: 70, child: DriverRequestHistoryHeadersList()),
        //   Expanded(
        //     child: data.when(
        //       data: (data) {
        //         return data != null
        //             ? ListView.builder(
        //                 itemBuilder: (context, index) {
        //                   return GestureDetector(
        //                     onTap: () {
        //                       Get.to(DriverSingleBooking(
        //                         book_driver_id:
        //                             data.response![index].bookDriverId!,
        //                       ));
        //                     },
        //                     child: Card(
        //                       elevation: 5,
        //                       margin: EdgeInsets.symmetric(
        //                           vertical: 12, horizontal: 15),
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               data.response![index].bookingDate!,
        //                               style: const TextStyle(color: Colors.grey),
        //                             ),
        //                             const SizedBox(
        //                               height: 10,
        //                             ),
        //                             Text(
        //                               data.response![index]
        //                                   .sourceLocationAddress!,
        //                               maxLines: null,
        //                             ),
        //                             const SizedBox(
        //                               height: 10,
        //                             ),
        //                             Text(
        //                               data.response![index]
        //                                   .destinationLocationAddress!,
        //                               maxLines: null,
        //                             ),
        //                             const SizedBox(
        //                               height: 10,
        //                             ),
        //                             Text(
        //                               data.response![index].fare!,
        //                               maxLines: null,
        //                             ),
        //                             Align(
        //                               alignment: Alignment.bottomRight,
        //                               child: MyBadge(
        //                                 color: data
        //                                     .response![index].showStatusBgcolor!,
        //                                 status: data.response![index].showStatus!,
        //                               ),
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   );
        //                 },
        //                 itemCount: data!.response!.length,
        //               )
        //             : Center(
        //                 child: Text(
        //                   'Data Not Found ',
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.bold, fontSize: 20),
        //                 ),
        //               );
        //       },
        //       error: (error, stackTrace) {
        //         return Center(
        //           child: Text(error.toString()),
        //         );
        //       },
        //       loading: () {
        //         return Center(child: const RefreshProgressIndicator());
        //       },
        //     ),
        //   )
        // ]),

        );
  }
}
