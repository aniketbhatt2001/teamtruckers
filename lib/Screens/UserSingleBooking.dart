// ignore_for_file: prefer_const_constructors
import 'package:book_rides/Models/BookingHistoryModel.dart';
import 'package:book_rides/Screens/PassengerChatScreen.dart';
import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import '../Services/mapServices.dart';
import '../Widgets/MyRating.dart';

// final usersingleBookingProvider =
//     FutureProvider.autoDispose.family((ref, String book_driver_id) async {
//   return userSingleBooking(ref.read(userModelProvider).userId!, book_driver_id);
// });
final toggleUserSinglBookingStatus = StateProvider.autoDispose((ref) => false);

class UserSingleBooking extends ConsumerWidget {
  final codeClr = TextEditingController();
  final String book_driver_id;
  UserSingleBooking({
    required this.book_driver_id,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //print(ref.read(markerPrvider).markers);
    // final data = ref.watch(usersingleBookingProvider(book_driver_id));
    ref.watch(toggleUserSinglBookingStatus);
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          pop();
        } else {
          Get.offAll(UserMapInfo());
        }
        return F;
      },
      child: LayoutBuilder(
          builder: (p0, p1) => FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Scaffold(
                        backgroundColor: Colors.white,
                        appBar: AppBar(
                          elevation: 0,
                          backgroundColor: primary,
                          title: const Text('Booking Detail'),
                        ),
                        floatingActionButton:
                            snapshot.data!.response![0].show_message_sent == '1'
                                ? Stack(
                                    children: [
                                      FloatingActionButton(
                                        onPressed: () {
                                          Get.off(
                                            PassengerChatSCreen(
                                                snapshot.data!.response![0]
                                                    .bookDriverId!,
                                                snapshot.data!.response![0]
                                                    .message_send_call!,
                                                snapshot.data!.response![0]
                                                    .message_send_text!,
                                                snapshot.data!.response![0]
                                                    .driverUserInfo![0]),
                                          );
                                        },
                                        backgroundColor: primary,
                                        child: Icon(
                                          Icons.chat,
                                        ),
                                      ),
                                      Positioned(
                                          left: 30,
                                          // top: 10,
                                          child: (snapshot.data!.response![0]
                                                      .message_new_count!) !=
                                                  '0'
                                              ? Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Center(
                                                    child: Text(
                                                      snapshot
                                                          .data!
                                                          .response![0]
                                                          .message_new_count!,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox())
                                    ],
                                  )
                                : null,
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
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                  double.parse(snapshot
                                                      .data!
                                                      .response![0]
                                                      .sourceLatitude!),
                                                  double.parse(snapshot
                                                      .data!
                                                      .response![0]
                                                      .sourceLongitude!)),
                                              zoom: 14.0,
                                            ),
                                            markers: {
                                              Marker(
                                                  markerId:
                                                      const MarkerId('source1'),
                                                  position: LatLng(
                                                      double.parse(snapshot
                                                          .data!
                                                          .response![0]
                                                          .sourceLatitude!),
                                                      double.parse(snapshot
                                                          .data!
                                                          .response![0]
                                                          .sourceLongitude!)),
                                                  infoWindow: const InfoWindow(
                                                      title: 'Pickup')),
                                              Marker(
                                                  markerId:
                                                      const MarkerId('source2'),
                                                  position: LatLng(
                                                      double.parse(snapshot
                                                          .data!
                                                          .response![0]
                                                          .destinationLatitude!),
                                                      double.parse(snapshot
                                                          .data!
                                                          .response![0]
                                                          .destinationLongitude!)),
                                                  infoWindow: const InfoWindow(
                                                      title: 'destination')),
                                            },
                                            polylines: {
                                              Polyline(
                                                  polylineId: const PolylineId(
                                                      'polyline'),
                                                  points: [
                                                    LatLng(
                                                        double.parse(snapshot
                                                            .data!
                                                            .response![0]
                                                            .sourceLatitude!),
                                                        double.parse(snapshot
                                                            .data!
                                                            .response![0]
                                                            .sourceLongitude!)),
                                                    LatLng(
                                                        double.parse(snapshot
                                                            .data!
                                                            .response![0]
                                                            .destinationLatitude!),
                                                        double.parse(snapshot
                                                            .data!
                                                            .response![0]
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
                                                  (snapshot.data!.response![0]
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
                                            "${snapshot.data!.response![0].bookingDate!}  ${snapshot.data!.response![0].bookingTime!}",
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
                                              snapshot.data!.response![0]
                                                  .sourceLocationAddress!,
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
                                              snapshot.data!.response![0]
                                                  .destinationLocationAddress!,
                                              maxLines: null,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      child: snapshot.data!.response![0]
                                              .comments!.isNotEmpty
                                          ? Row(
                                              children: [
                                                const Icon(
                                                  Icons.comment,
                                                  size: 18,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: Text(
                                                    snapshot.data!.response![0]
                                                        .comments!,
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
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
                              snapshot.data!.response![0].bidInfo!.isNotEmpty
                                  ? // )
                                  ListView.builder(
                                      shrinkWrap: T,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot
                                          .data!.response![0].bidInfo!.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 4,
                                          margin: EdgeInsets.all(12),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .response![0]
                                                          .bidInfo![index]
                                                          .finalFare!,
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: HexColor(snapshot
                                                            .data!
                                                            .response![0]
                                                            .bidInfo![index]
                                                            .shownBidStatusBgcolor!),
                                                      ),
                                                      width: 70,
                                                      height: 25,
                                                      child: Center(
                                                        child: Text(
                                                          snapshot
                                                              .data!
                                                              .response![0]
                                                              .bidInfo![index]
                                                              .shownBidStatus!,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
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
                                                        '${snapshot.data!.response![0].bidInfo![index].bookingDate!}  ${snapshot.data!.response![0].bidInfo![index].bookingTime!} ',
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        '${snapshot.data!.response![0].bidInfo![index].bidDriverUserInfo![0].fname!} ${snapshot.data!.response![0].bidInfo![index].bidDriverUserInfo![0].lname!} ',
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      launchDialer(
                                                          snapshot
                                                              .data!
                                                              .response![0]
                                                              .bidInfo![index]
                                                              .bidDriverUserInfo![
                                                                  0]
                                                              .mobile!,
                                                          context);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.phone,
                                                          size: 20,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          '${snapshot.data!.response![0].bidInfo![index].bidDriverUserInfo![0].mobile!} ',
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                snapshot
                                                        .data!
                                                        .response![0]
                                                        .bidInfo![index]
                                                        .comments!
                                                        .isNotEmpty
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.comment),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                snapshot
                                                                    .data!
                                                                    .response![
                                                                        0]
                                                                    .bidInfo![
                                                                        index]
                                                                    .comments!,
                                                                maxLines: null,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox(),

                              Card(
                                elevation: 4,
                                margin: EdgeInsets.all(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Verify Code :',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(snapshot
                                              .data!.response![0].verifyCode!),
                                        ],
                                      ),
                                      snapshot.data!.response![0].verifyCodeMsg!
                                              .isNotEmpty
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(snapshot.data!
                                                  .response![0].verifyCodeMsg!),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              snapshot.data!.response![0]
                                          .user_rating_review_btn_show ==
                                      '1'
                                  ? Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: roundedRectangleBorder,
                                              backgroundColor: primary),
                                          onPressed: () {
                                            showUserRatingAppDialog(
                                                snapshot.data!.response![0]
                                                    .bookDriverId!,
                                                ref);
                                          },
                                          child: Text('Give Review')),
                                    )
                                  : SizedBox(),
                              snapshot.data!.response![0].driverUserRating !=
                                          '0' &&
                                      snapshot.data!.response![0]
                                          .driverUserRating!.isNotEmpty
                                  ? Card(
                                      elevation: 4,
                                      margin: EdgeInsets.all(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                    value: int.parse(snapshot
                                                        .data!
                                                        .response![0]
                                                        .driverUserRating!)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            snapshot
                                                    .data!
                                                    .response![0]
                                                    .driverUserReview!
                                                    .isNotEmpty
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 6),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .response![0]
                                                            .driverUserReview!,
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              snapshot.data!.response![0].userRating!
                                          .isNotEmpty &&
                                      snapshot.data!.response![0].userRating !=
                                          '0'
                                  ? Card(
                                      elevation: 4,
                                      margin: EdgeInsets.all(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Driver Rating',
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
                                                    value: int.parse(snapshot
                                                        .data!
                                                        .response![0]
                                                        .userRating!)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            snapshot.data!.response![0]
                                                    .userReview!.isNotEmpty
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 6),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .response![0]
                                                            .userReview!,
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                            ])));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(
                        child: RefreshProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text(snapshot.error.toString()),
                      ),
                    );
                  } else {
                    return Scaffold(
                      body: Center(
                        child: Text(
                          'No History Found',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                },
                future: userSingleBooking(
                    ref.read(userModelProvider).userId!, book_driver_id),
              )),
    );
  }
}
