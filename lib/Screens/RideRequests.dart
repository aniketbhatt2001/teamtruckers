// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/Screens/SplashScreen.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Screens/passengerRideDetails.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../Models/BookingsViewModel.dart';
import '../Utils/Constatnts.dart';
import '../main.dart';

final statusProvider = StateProvider.autoDispose((ref) => false);
// final currentScreen = StateProvider.autoDispose<String?>(
//   (ref) => 'ride_req',
// );
//final toggleUserBookings = StateProvider.autoDispose((ref) => false);
final toggleUserActiveBookingStatus = StateProvider.autoDispose((ref) => false);
// final userBookings = FutureProvider.autoDispose((ref) {
//   ref.watch(toggleUserBookings);
//   return user_requested_booking_view(ref.read(userModelProvider).userId!);
// });
// final timerProvider =
//     StateProvider((ref) => Timer.periodic(Duration(seconds: 5), (timer) {}));

class RideRequests extends ConsumerStatefulWidget {
  RideRequests({super.key});

  @override
  ConsumerState<RideRequests> createState() => _RideRequestsState();
}

class _RideRequestsState extends ConsumerState<RideRequests> {
  //BookingsViewModel? bookingsViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Callback function after the UI is built

      // if (ref.read(bidInfoDetailIndex) != null) {
      //   showsuccesBar(ref.read(bidInfoDetailIndex).toString());
      //   showModalBottomSheet(
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      //     isScrollControlled: true,
      //     context: context,
      //     builder: (context) {
      //       return LayoutBuilder(
      //         builder: (p0, p1) => Container(
      //           height: p1.maxHeight / 2.8,
      //           child: FutureBuilder(
      //             future: user_requested_booking_view(
      //                 ref.read(userModelProvider).userId!),
      //             builder: (context, snapshot) {
      //               if (snapshot.hasData && snapshot.data != null) {
      //                 int myindex = ref.read(bidInfoDetailIndex)!;

      //                 return ListView(
      //                     // physics: NeverScrollableScrollPhysics(),
      //                     children: [
      //                       SelectedRideDetail(
      //                           //index: ref.read(bidInfoDetailIndex)!,
      //                           index: myindex,
      //                           bookingViewModel: snapshot.data),
      //                       snapshot.data!.response![myindex].bidInfo!
      //                               .isNotEmpty
      //                           ? Card(
      //                               elevation: 4,
      //                               margin: EdgeInsets.symmetric(
      //                                   horizontal: 10, vertical: 16),
      //                               color: Colors.white,
      //                               child: Padding(
      //                                 padding: const EdgeInsets.all(10.0),
      //                                 child: Column(
      //                                   children: [
      //                                     Row(
      //                                       mainAxisAlignment:
      //                                           MainAxisAlignment.spaceBetween,
      //                                       children: [
      //                                         Align(
      //                                           alignment: Alignment.centerLeft,
      //                                           child: Text(
      //                                             snapshot
      //                                                 .data!
      //                                                 .response![myindex]
      //                                                 .bidInfo![0]
      //                                                 .fare!,
      //                                             style: large(context)
      //                                                 .copyWith(
      //                                                     color: Colors.red),
      //                                           ),
      //                                         ),
      //                                         Container(
      //                                           decoration: BoxDecoration(
      //                                             borderRadius:
      //                                                 BorderRadius.circular(10),
      //                                             color: HexColor(snapshot
      //                                                 .data!
      //                                                 .response![myindex]
      //                                                 .bidInfo![0]
      //                                                 .shownBidStatusBgcolor!),
      //                                           ),
      //                                           width: 70,
      //                                           height: 25,
      //                                           child: Center(
      //                                             child: Text(
      //                                               snapshot
      //                                                   .data!
      //                                                   .response![myindex]
      //                                                   .bidInfo![0]
      //                                                   .shownBidStatus!,
      //                                               style: TextStyle(
      //                                                   color: Colors.white),
      //                                             ),
      //                                           ),
      //                                         )
      //                                       ],
      //                                     ),
      //                                     SizedBox(
      //                                       height: 20,
      //                                     ),
      //                                     Row(
      //                                       children: [
      //                                         Icon(Icons.calendar_month),
      //                                         SizedBox(
      //                                           width: 10,
      //                                         ),
      //                                         Text(
      //                                           snapshot
      //                                               .data!
      //                                               .response![myindex]
      //                                               .bidInfo![0]
      //                                               .bookingDate!,
      //                                           style: medium(context),
      //                                         ),
      //                                         SizedBox(
      //                                           width: 10,
      //                                         ),
      //                                         Text(
      //                                           snapshot
      //                                               .data!
      //                                               .response![myindex]
      //                                               .bidInfo![0]
      //                                               .bookingTime!,
      //                                           style: medium(context),
      //                                         )
      //                                       ],
      //                                     ),
      //                                     SizedBox(
      //                                       height: 16,
      //                                     ),
      //                                     Row(
      //                                       children: [
      //                                         Icon(Icons.comment),
      //                                         SizedBox(
      //                                           width: 10,
      //                                         ),
      //                                         Text(
      //                                           snapshot
      //                                               .data!
      //                                               .response![myindex]
      //                                               .bidInfo![0]
      //                                               .comments!,
      //                                           maxLines: null,
      //                                         )
      //                                       ],
      //                                     )
      //                                   ],
      //                                 ),
      //                               ),
      //                             )
      //                           : SizedBox()
      //                     ]);
      //               } else if (snapshot.connectionState ==
      //                   ConnectionState.waiting) {
      //                 return Center(
      //                   child: RefreshProgressIndicator(),
      //                 );
      //               } else {
      //                 return SizedBox();
      //               }
      //             },
      //           ),
      //         ),
      //       );
      //     },
      //   );
      //   ref.read(bidInfoDetailIndex.notifier).state = null;
      // }

      // );
    });

    Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        if (ref.read(userModelProvider).isOnline == '1') {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(
    BuildContext contex,
  ) {
    //pop();
    ref.watch(userModelProvider.select((value) => value.isOnline));

    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: user_requested_booking_view(
                    ref.read(userModelProvider).userId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return DriverRideRequestView(
                      p1: p1,
                      bookingViewModel: snapshot.data,
                    );
                  } else {
                    return Center(
                      child: Text(
                        ref.read(userModelProvider).isOnline == '1'
                            ? 'Here you\'ll see deliveries that suit \n you'
                            : 'You are offline',
                        textAlign: TextAlign.center,
                        style: large(context),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DriverRideRequestView extends ConsumerWidget {
  final BookingsViewModel? bookingViewModel;
  final BoxConstraints p1;
  DriverRideRequestView(
      {super.key, required this.bookingViewModel, required this.p1});
  final TextEditingController priceClr = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return bookingViewModel != null
        ? ListView.builder(
            itemBuilder: (context, index) {
              final time =
                  bookingViewModel!.response![index].dateTime!.split(' ');

              return GestureDetector(
                onTap: () {
                  //  final data = bookingViewModel!.response![index];
                  showModalBottomSheet(
                    isScrollControlled: T,
                    shape: roundedRectangleBorder.copyWith(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    context: context,
                    builder: (context) {
                      return Container(
                        height: p1.maxHeight / 1.3,
                        // height: p1.maxHeight / 1 * 2,
                        child: BidInfoWidget(
                            id: ref.read(userModelProvider).userId!,
                            index: index,
                            bookingViewModel: bookingViewModel,
                            time: time,
                            priceClr: priceClr),
                      );
                    },
                  );
                },
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            bookingViewModel!.response![index].mainTitle!,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        SizedBox(
                          height: 16,
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
                              "${bookingViewModel!.response![index].bookingDate!}  ${bookingViewModel!.response![index].bookingTime!}",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              child: Icon(
                                FontAwesomeIcons.a,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                bookingViewModel!
                                    .response![index].sourceLocationAddress!,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                maxLines: null,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 10,
                              child: Icon(
                                FontAwesomeIcons.b,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: p1.maxWidth / 1.5,
                              child: Text(
                                bookingViewModel!.response![index]
                                    .destinationLocationAddress!,
                                maxLines: null,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              width: p1.maxWidth * 0.05,
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                        SizedBox(
                          height: 16,
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
                                bookingViewModel!.response![0].comments!,
                                maxLines: null,
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "${bookingViewModel!.response![0].showTime!} ")),
                        Divider(
                          color: Colors.black,
                          height: 30,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                                child: bookingViewModel!.response![index]
                                        .userInfo![0].profilePic!.isEmpty
                                    ? Icon(Icons.person)
                                    : null,
                                backgroundImage: NetworkImage(bookingViewModel!
                                    .response![index]
                                    .userInfo![0]
                                    .profilePic!)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(bookingViewModel!
                                .response![index].userInfo![0].fname!)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: bookingViewModel!.response!.length,
          )
        : Center(
            child: Text(
              'Here you\'ll see deliveries that suit \n you',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
  }
}

class BidInfoWidget extends StatefulWidget {
  const BidInfoWidget(
      {super.key,
      required this.bookingViewModel,
      required this.time,
      required this.priceClr,
      required this.id,
      required this.index});
  final int index;
  final BookingsViewModel? bookingViewModel;
  final String id;
  final List<String> time;
  final TextEditingController priceClr;

  @override
  State<BidInfoWidget> createState() => _BidInfoWidgetState();
}

class _BidInfoWidgetState extends State<BidInfoWidget> {
  TextEditingController commentsClr = TextEditingController();
  @override
  Widget build(
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (p0, p1) => FutureBuilder(
        future: user_requested_booking_view(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!.response![widget.index];

            return SingleChildScrollView(
              child: Column(
                children: [
                  SelectedRideDetail(
                    bookingViewModel: widget.bookingViewModel,
                    index: widget.index,
                  ),
                  data.bidInfo!.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final bidInfo = data.bidInfo;
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 16),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            bidInfo![0].finalFare!,
                                            style: large(context)
                                                .copyWith(color: Colors.red),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: HexColor(data.bidInfo![0]
                                                .shownBidStatusBgcolor!),
                                          ),
                                          width: 70,
                                          height: 25,
                                          child: Center(
                                            child: Text(
                                              data.bidInfo![0].shownBidStatus!,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        bidInfo![0].amountMsg!,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_month),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          bidInfo[0].bookingDate!,
                                          style: medium(context),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          bidInfo[0].bookingTime!,
                                          style: medium(context),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    bidInfo[0].comments!.isNotEmpty
                                        ? Row(
                                            children: [
                                              Icon(Icons.comment),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  bidInfo[0].comments!,
                                                  maxLines: null,
                                                ),
                                              )
                                            ],
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: data.bidInfo!.length,
                          physics: NeverScrollableScrollPhysics(),
                        )
                      : SizedBox(),
                  data.bidInfo!.isEmpty
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 20),
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: roundedRectangleBorder,
                                backgroundColor: primary,
                              ),
                              onPressed: () async {
                                final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                if (time != null) {
                                  final timeSelected = time.format(context);

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  hintText: 'Fare'),
                                              controller: widget.priceClr,
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            TextField(
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                  hintText: 'Comments '),
                                              controller: commentsClr,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              snapshot
                                                  .data!.response![0].amountMsg
                                                  .toString(),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              width: double.infinity,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 0),
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          roundedRectangleBorder,
                                                      backgroundColor: primary),
                                                  onPressed: () async {
                                                    if (widget.priceClr.text
                                                        .isNotEmpty) {
                                                      pop();
                                                      final bidInfoData =
                                                          await bidOnUserBooking(
                                                              widget.id,
                                                              data
                                                                  .bookDriverId!,
                                                              timeSelected,
                                                              data.bookingDate!,
                                                              widget.priceClr
                                                                  .text,
                                                              commentsClr.text);
                                                      if (bidInfoData !=
                                                          null) {}
                                                    } else {
                                                      showFailureBar(
                                                          'Enter fare');
                                                    }
                                                  },
                                                  child: Text('Submit')),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text(
                                'Suggest a price and time',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      : SizedBox(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 22),
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: roundedRectangleBorder,
                          backgroundColor: primary,
                        ),
                        onPressed: () {
                          pop();
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: RefreshProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class SelectedRideDetail extends StatelessWidget {
  const SelectedRideDetail({
    required this.index,
    super.key,
    required this.bookingViewModel,
  });

  final BookingsViewModel? bookingViewModel;
  final int index;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    bookingViewModel!.response![index].mainTitle!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
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
                      '${bookingViewModel!.response![index].bookingDate!}  ${bookingViewModel!.response![index].bookingTime!}',
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
                      radius: 10,
                      child: Icon(
                        FontAwesomeIcons.a,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        bookingViewModel!
                            .response![index].sourceLocationAddress!,
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
                      backgroundColor: Colors.green,
                      radius: 10,
                      child: Icon(
                        FontAwesomeIcons.b,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: p1.maxWidth / 1.5,
                      child: Text(
                        bookingViewModel!
                            .response![0].destinationLocationAddress!,
                        maxLines: null,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
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
                        bookingViewModel!.response![0].comments!,
                        maxLines: null,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("${bookingViewModel!.response![0].showTime!} "))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: double.infinity,
            color: Colors.grey.shade100,
            // margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                    child: bookingViewModel!
                            .response![index].userInfo![0].profilePic!.isEmpty
                        ? Icon(Icons.person)
                        : null,
                    backgroundImage: NetworkImage(bookingViewModel!
                        .response![index].userInfo![0].profilePic!)),
                SizedBox(
                  width: 10,
                ),
                Text(bookingViewModel!.response![index].userInfo![0].fname!),
                SizedBox(
                  width: 10,
                ),
                Text(bookingViewModel!.response![index].userInfo![0].lname!)
              ],
            ),
          )
        ],
      ),
    );
  }
}
