// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:book_rides/Models/BookingHistoryModel.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/Widgets/MyRating.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Services/mapServices.dart';
import 'DriverChatScreen.dart';
import 'DriverHomeScreen.dart';

final singleBookingProvider =
    FutureProvider.autoDispose.family((ref, String book_driver_id) {
  ref.watch(toggleDriverSingleBookingStatus);
  return driverSingleBooking(
      ref.read(userModelProvider).userId!, book_driver_id);
});
final toggleDriverSingleBookingStatus =
    StateProvider.autoDispose((ref) => true);

class DriverSingleBooking extends ConsumerWidget {
  final codeClr = TextEditingController();
  final String book_driver_id;
  DriverSingleBooking({
    required this.book_driver_id,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print(fcmToken);
    //print(ref.read(markerPrvider).markers);
    final data = ref.watch(singleBookingProvider(book_driver_id));
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          pop();
        } else {
          Get.offAll(DriverHomeScreen());
        }
        return F;
      },
      child: LayoutBuilder(
        builder: (p0, p1) =>

            // appBar: AppBar(
            //   elevation: 0,
            //   backgroundColor: primary,
            //   title: const Text('History'),
            // ),

            data.when(
          data: (data) {
            return Scaffold(
              floatingActionButton:
                  data!.response![0].show_driver_user_complete_btn == '1'
                      ? FloatingActionButton(
                          onPressed: () {
                            Get.to(DriverChatScreen(
                                data.response![0].bookDriverId!,
                                data.response![0].userInfo![0],
                                data.response![0].message_send_call!,
                                data.response![0].message_send_text!));
                          },
                          child: Icon(Icons.chat),
                          backgroundColor: primary,
                        )
                      : null,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: primary,
                title: const Text('Booking Detail'),
              ),
              body: SingleChildScrollView(
                // physics: AlwaysScrollableScrollPhysics(),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(12),
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: p1.maxHeight / 2.5,
                            child: Stack(
                              children: [
                                GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        double.parse(
                                            data!.response![0].sourceLatitude!),
                                        double.parse(data
                                            .response![0].sourceLongitude!)),
                                    zoom: 14.0,
                                  ),
                                  markers: {
                                    Marker(
                                        markerId: const MarkerId('source1'),
                                        position: LatLng(
                                            double.parse(data!
                                                .response![0].sourceLatitude!),
                                            double.parse(data.response![0]
                                                .sourceLongitude!)),
                                        infoWindow:
                                            const InfoWindow(title: 'Pickup')),
                                    Marker(
                                        markerId: const MarkerId('source2'),
                                        position: LatLng(
                                            double.parse(data!.response![0]
                                                .destinationLatitude!),
                                            double.parse(data.response![0]
                                                .destinationLongitude!)),
                                        infoWindow: const InfoWindow(
                                            title: 'destination')),
                                  },
                                  polylines: {
                                    Polyline(
                                        polylineId:
                                            const PolylineId('polyline'),
                                        points: [
                                          LatLng(
                                              double.parse(data!.response![0]
                                                  .sourceLatitude!),
                                              double.parse(data.response![0]
                                                  .sourceLongitude!)),
                                          LatLng(
                                              double.parse(data!.response![0]
                                                  .destinationLatitude!),
                                              double.parse(data.response![0]
                                                  .destinationLongitude!))
                                        ],
                                        color: Colors.blue,
                                        width: 5)
                                  },
                                ),
                                Positioned(
                                  top: p1.maxHeight / 3.3,
                                  left: 10,
                                  child: FloatingActionButton(
                                    backgroundColor: primary,
                                    onPressed: () {
                                      openGoogleMaps(
                                        (data.response![0]
                                            .sourceLocationAddress!),
                                      );
                                    },
                                    child: Icon(Icons.map),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${data.response![0].bookingDate}  ${data.response![0].bookingTime!}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 10,
                                  child: Icon(
                                    FontAwesomeIcons.a,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    data.response![0].sourceLocationAddress!,
                                    maxLines: null,
                                    // overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 10,
                                  child: Icon(
                                    FontAwesomeIcons.b,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    data.response![0]
                                        .destinationLocationAddress!,
                                    maxLines: null,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.indianRupeeSign,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  data.response![0].finalFare!,
                                  style: const TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: data.response![0].comments!.isNotEmpty
                                ? Row(
                                    children: [
                                      const Icon(
                                        Icons.comment,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        data.response![0].comments!,
                                        style: const TextStyle(fontSize: 15),
                                      )
                                    ],
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    ),

                    // Card(
                    //   child:,
                    // )

                    Card(
                      margin: EdgeInsets.all(12),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  child: data.response![0].userInfo![0]
                                          .profilePic!.isNotEmpty
                                      ? null
                                      : Icon(Icons.person),
                                  radius: 15,
                                  backgroundImage: data.response![0]
                                          .userInfo![0].profilePic!.isNotEmpty
                                      ? NetworkImage(data.response![0]
                                          .userInfo![0].profilePic!)
                                      : null,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data.response![0].userInfo![0].fname!,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data.response![0].userInfo![0].lname!,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            // Text(data.response![0].userInfo![0].email!,
                            //     style: TextStyle(fontWeight: FontWeight.w500)),
                            GestureDetector(
                              onTap: () {
                                launchDialer(
                                    data.response![0].userInfo![0].mobile!,
                                    context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Text(
                                      data.response![0].userInfo![0].mobile!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    Card(
                      elevation: 4,
                      margin: EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.response![0].bidInfo![0].fare!,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: HexColor(data.response![0]
                                        .bidInfo![0].shownBidStatusBgcolor!),
                                  ),
                                  width: 70,
                                  height: 25,
                                  child: Center(
                                    child: Text(
                                      data.response![0].bidInfo![0]
                                          .shownBidStatus!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              data.response![0].bidInfo![0].amountMsg!,
                              // style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${data.response![0].bidInfo![0].bookingDate!} ${data.response![0].bidInfo![0].bookingTime!} ',
                                  )
                                ],
                              ),
                            ),
                            data.response![0].bidInfo![0].comments!.isNotEmpty
                                ? Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.comment),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data.response![0].bidInfo![0]
                                              .comments!,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    data.response![0].show_driver_user_complete_btn == '1'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.dialog(AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: codeClr,
                                        decoration: InputDecoration(
                                          hintText: 'Enter code',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (codeClr.text.isNotEmpty) {
                                            pop();
                                            await completeBooking(
                                                    codeClr.text,
                                                    ref
                                                        .read(userModelProvider)
                                                        .userId!,
                                                    book_driver_id)
                                                .then((value) {
                                              final currentStatus = ref.read(
                                                  toggleDriverSingleBookingStatus);
                                              ref
                                                  .read(
                                                      toggleDriverSingleBookingStatus
                                                          .notifier)
                                                  .state = !currentStatus;
                                            });
                                            codeClr.clear();
                                          } else {
                                            showFailureBar('Enter code');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: primary,
                                            shape: roundedRectangleBorder),
                                        child: Text('Verify'),
                                      )
                                    ],
                                  ),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: roundedRectangleBorder,
                                  backgroundColor: primary),
                              child: Text('Complete Booking'),
                            ),
                          )
                        : SizedBox(),
                    data.response![0].driver_rating_review_btn_show == '1'
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: roundedRectangleBorder,
                                    backgroundColor: primary),
                                onPressed: () {
                                  showDriverRatingAppDialog(
                                      data.response![0].bookDriverId!,
                                      ref.read(userModelProvider).userId!);
                                },
                                child: Text('Give Review')),
                          )
                        : SizedBox(),

                    data.response![0].driverUserRating != '0' &&
                            data.response![0].driverUserRating!.isNotEmpty
                        ? Card(
                            elevation: 4,
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'User Rating',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconTheme(
                                      data: IconThemeData(
                                        color: Colors.amber,
                                        size: 22,
                                      ),
                                      child: StarDisplay(
                                          value: int.parse(data
                                              .response![0].driverUserRating!)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  data.response![0].driverUserReview!.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              data.response![0]
                                                  .driverUserReview!,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    data.response![0].userRating!.isNotEmpty &&
                            data.response![0].userRating != '0'
                        ? Card(
                            elevation: 4,
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'My Rating',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconTheme(
                                      data: IconThemeData(
                                        color: Colors.amber,
                                        size: 22,
                                      ),
                                      child: StarDisplay(
                                          value: int.parse(
                                              data.response![0].userRating!)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  data.response![0].userReview!.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              data.response![0].userReview!,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return Scaffold(
              body: Center(
                child: Text(error.toString()),
              ),
            );
          },
          loading: () {
            return Scaffold(
              body: Center(
                child: RefreshProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
