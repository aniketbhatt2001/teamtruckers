// ignore_for_file: prefer_const_constructors

import 'package:book_rides/Screens/UserSingleBooking.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Widgets/Badge.dart';
import 'package:book_rides/Widgets/Drawer.dart';
import 'package:book_rides/Widgets/RequestHistoryHeaders.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../Utils/Constatnts.dart';
import 'PassengerMapScreen.dart';

final passengerSlugProvider = StateProvider.autoDispose<String?>((ref) => null);

final requestHistoryProvider =
    FutureProvider.autoDispose.family((ref, String? slug) {
  final slug = ref.watch(passengerSlugProvider);
  return getBookingHistories(ref.read(userModelProvider).userId!, slug);
});

class RequestHistory extends ConsumerWidget {
  const RequestHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data =
        ref.watch(requestHistoryProvider(ref.read(passengerSlugProvider)));
    // print(ref.read(userModelProvider).userId);
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          pop();
        } else {
          Get.offAll(UserMapInfo());
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          drawer: MyDrawer(),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primary,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            title: const Text(
              'Request History',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 70, child: RequestHistoryHeadersList()),
              Expanded(
                child: data.when(
                  data: (data) {
                    return data != null
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(UserSingleBooking(
                                      book_driver_id:
                                          data.response![index].bookDriverId!));
                                },
                                child: Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data.response![index].dateTime!,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            MyBadge(
                                              color: data.response![index]
                                                  .showStatusBgcolor!,
                                              status: data
                                                  .response![index].showStatus!,
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
                                                size: 10,
                                              ),
                                            ),
                                            SizedBox(
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
                                              width: 10,
                                            ),
                                            Text(
                                              data.response![index]
                                                  .destinationLocationAddress!,
                                              maxLines: null,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 13,
                                        ),
                                        data.response![index].final_fare!
                                                .isNotEmpty
                                            ? Row(
                                                children: [
                                                  Text('Fare :'),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    data.response![index]
                                                        .final_fare!,
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
                              'No Data Found',
                              style: Theme.of(context).textTheme.titleLarge,
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
            ],
          )
          // Column(

          //   children: [],
          // ),
          ),
    );
  }
}
