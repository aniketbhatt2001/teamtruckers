// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../Models/UserActiveBooking.dart';
import '../Services/apis_services.dart';
import '../Utils/Constatnts.dart';
import '../Widgets/rating_avg.dart';
import '../providers/UserModelProvider.dart';
import 'RequestHistory.dart';
import 'passengerRideDetails.dart';

final couponApplied = StateProvider.autoDispose((ref) => '');
final couponvalueProvider = StateProvider.autoDispose((ref) => '');
final couponCode = StateProvider.autoDispose((ref) => '');

class BidInfoList extends ConsumerStatefulWidget {
  const BidInfoList({
    super.key,
    required this.ref,
    required this.toggle,
    required this.data,
  });

  final WidgetRef ref;
  final UserActiveBooking data;
  final bool toggle;

  @override
  ConsumerState<BidInfoList> createState() => _BidInfoState();
}

class _BidInfoState extends ConsumerState<BidInfoList> {
  List<BidInfo> bidInfo = [];
  @override
  void initState() {
    //TODO: implement initState
    Timer.periodic(const Duration(seconds: 5), (timer) {
      //  final status = ref.watch(toggleBidStatus);
      // ref.read(toggleBidStatus.notifier).state = !status;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //final myData = ref.watch(bidProvider);
    //pop();
    return LayoutBuilder(
      builder: (p0, p1) => FutureBuilder(
          future: getPassengerBidInfo(ref.read(userModelProvider).userId!),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bidInfo = snapshot.data!;

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 16),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bidInfo[index].finalFare!,
                                style:
                                    large(context).copyWith(color: Colors.red),
                              ),
                              // Text(
                              //   bidInfo[index].amountMsg.toString(),
                              //   style: large(context).copyWith(color: Colors.red),
                              // ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: HexColor(
                                      bidInfo[index].shownBidStatusBgcolor!),
                                ),
                                width: 70,
                                height: 25,
                                child: Center(
                                  child: Text(
                                    bidInfo[index].shownBidStatus!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                bidInfo[index].bookingDate!,
                                style: medium(context),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                bidInfo[index].bookingTime!,
                                style: medium(context),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                child: bidInfo[index]
                                        .bidDriverUserInfo![0]
                                        .profilePic!
                                        .isNotEmpty
                                    ? null
                                    : const Icon(Icons.person),
                                backgroundImage: bidInfo[index]
                                        .bidDriverUserInfo![0]
                                        .profilePic!
                                        .isNotEmpty
                                    ? NetworkImage(bidInfo[index]
                                        .bidDriverUserInfo![0]
                                        .profilePic!)
                                    : null,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                bidInfo[index].bidDriverUserInfo![0].fname!,
                                maxLines: null,
                                style: medium(context),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                bidInfo[index].bidDriverUserInfo![0].lname!,
                                maxLines: null,
                                style: medium(context),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          bidInfo[index].comments!.isNotEmpty
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.comment,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      bidInfo[index].comments!,
                                      maxLines: null,
                                    ))
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          bidInfo[index]
                                      .bidDriverUserInfo![0]
                                      .ratingAverage!
                                      .isNotEmpty &&
                                  bidInfo[index]
                                          .bidDriverUserInfo![0]
                                          .ratingAverage !=
                                      '0'
                              ? Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      // height: 20,
                                      // width: 60,
                                      child: Text(
                                        bidInfo[index]
                                            .bidDriverUserInfo![0]
                                            .ratingAverage!,
                                        style: const TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // decoration: BoxDecoration(
                                      //     color: Colors.grey.shade500,
                                      //     borderRadius: BorderRadius.circular(10)),
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 6),
                                    ),
                                    AverageRatingIcon(
                                        rating: double.parse(bidInfo[index]
                                            .bidDriverUserInfo![0]
                                            .ratingAverage!)),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          "(${bidInfo[index].bidDriverUserInfo![0].ratingAverageUser!})",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          // Text(bidInfo.)
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              bidInfo[index].showRejectBtn == '1'
                                  ? Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade100,
                                            shape: roundedRectangleBorder),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                titlePadding:
                                                    const EdgeInsets.only(
                                                        top: 10, left: 15
                                                        //vertical: 10
                                                        ),
                                                contentPadding: const EdgeInsets
                                                    .symmetric(),
                                                title: Column(
                                                  children: const [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Are you sure',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 22),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            'Decline ride?')),
                                                  ],
                                                ),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          pop();
                                                          await userDeclineBid(
                                                              widget.ref
                                                                  .read(
                                                                      userModelProvider)
                                                                  .userId!,
                                                              bidInfo[index]
                                                                  .bookDriverBidId!,
                                                              widget
                                                                  .data
                                                                  .response![0]
                                                                  .bookDriverId!,
                                                              "no reason");

                                                          widget.ref
                                                                  .read(toggleStatus
                                                                      .notifier)
                                                                  .state =
                                                              !widget.toggle;
                                                        },
                                                        child: const Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        )),
                                                    TextButton(
                                                        onPressed: () async {
                                                          pop();
                                                        },
                                                        child: const Text(
                                                          'No',
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ))
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Center(
                                            child: Text(
                                          'Decline',
                                          style: TextStyle(color: Colors.red),
                                        )),
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                width: 12,
                              ),
                              bidInfo[index].showAcceptBtn == '1'
                                  ? Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: primary,
                                            shape: roundedRectangleBorder),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                titlePadding:
                                                    const EdgeInsets.only(
                                                        top: 10, left: 15
                                                        //vertical: 10
                                                        ),
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                title: Column(
                                                  children: const [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Are you sure',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 22),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: const Text(
                                                            'Accept ride?')),
                                                  ],
                                                ),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          pop();
                                                          if (widget
                                                                  .data
                                                                  .response![0]
                                                                  .coupon_code_show ==
                                                              '1') {
                                                            showModalBottomSheet(
                                                              isScrollControlled:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return OrderOverView(
                                                                    userActiveBooking:
                                                                        widget
                                                                            .data,
                                                                    index:
                                                                        index,
                                                                    bidInfo:
                                                                        bidInfo);
                                                              },
                                                            );
                                                          } else {
                                                            final result = await preCall(
                                                                ref
                                                                    .read(
                                                                        userModelProvider)
                                                                    .userId!,
                                                                widget
                                                                    .data
                                                                    .response![
                                                                        0]
                                                                    .bookDriverId!,
                                                                bidInfo[index]
                                                                    .bookDriverBidId!,
                                                                null);
                                                            if (result !=
                                                                null) {
                                                              {
                                                                {
                                                                  if (result
                                                                          .response![
                                                                              0]
                                                                          .redirectToPaymentGateway ==
                                                                      '1') {
                                                                    showsuccesBar(
                                                                        'ridirect to final payment gateway');
                                                                  } else if (result
                                                                          .response![
                                                                              0]
                                                                          .redirectToFinalPayment ==
                                                                      '1') {
                                                                    final finalResult = await postfinalCall(
                                                                        ref
                                                                            .read(
                                                                                userModelProvider)
                                                                            .userId!,
                                                                        result
                                                                            .response![
                                                                                0]
                                                                            .orderNo!,
                                                                        result
                                                                            .response![
                                                                                0]
                                                                            .finalTotalAmount!,
                                                                        'success',
                                                                        jsonEncode({
                                                                          'result':
                                                                              'success'
                                                                        }));

                                                                    if (finalResult) {
                                                                      Get.offAll(
                                                                          () =>
                                                                              const RequestHistory());
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        )),
                                                    TextButton(
                                                        onPressed: () async {
                                                          pop();
                                                        },
                                                        child: const Text('No',
                                                            style: TextStyle(
                                                                fontSize: 18))),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Center(
                                            child: Text(
                                          'Accept',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Center(
                child: SizedBox(),
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}

class OrderOverView extends ConsumerWidget {
  final UserActiveBooking userActiveBooking;
  final int index;
  const OrderOverView({
    required this.userActiveBooking,
    required this.index,
    super.key,
    required this.bidInfo,
  });

  final List<BidInfo> bidInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupon = ref.watch(couponApplied);
    final value = ref.watch(couponvalueProvider);
    final code = ref.watch(couponCode);
    return SizedBox(
        height: 400,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bill Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.grey),
                      ),
                      Text(bidInfo[index].finalFare!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ],
                  ),
                  coupon.isNotEmpty
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Coupon Amount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.grey),
                                ),
                                Text(
                                  value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : const SizedBox(),
                  value.isNotEmpty
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Final Amount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.grey),
                                ),
                                Text(
                                  coupon,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            ),
            coupon.isNotEmpty
                ? Container(
                    color: Colors.green.shade100,
                    child: ListTile(
                      trailing: GestureDetector(
                        onTap: () {
                          ref.read(couponApplied.notifier).state = '';
                          ref.read(couponvalueProvider.notifier).state = '';
                        },
                        child: const Icon(
                          CupertinoIcons.minus_circle,
                          color: Colors.red,
                        ),
                      ),
                      leading: const Icon(
                        Icons.local_offer,
                        color: black,
                      ),
                      title: Text(ref.read(couponCode)),
                      subtitle: const Text('Coupon Applied Sucessfully'),
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 0.3, color: Colors.black),
                      bottom: BorderSide(width: 0.4, color: Colors.black),
                    )),
                    child: ListTile(
                      onTap: () {
                        Get.dialog(AlertDialog(
                          title: Text(
                            'Available coupon codes',
                            style: TextStyle(
                                color: primary, fontWeight: FontWeight.bold),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: userActiveBooking
                                .response![0].coupon_code!
                                .map((e) => Card(
                                    shape: roundedRectangleBorder,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    color: Colors.blue.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(e.title!)),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(e.description!)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(e.couponCodeValue!),
                                              ),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      shape:
                                                          roundedRectangleBorder,
                                                      backgroundColor:
                                                          Colors.red),
                                                  onPressed: () {
                                                    pop();
                                                    final double percent =
                                                        calculatePercentage(
                                                            double.parse(
                                                                e.discount!),
                                                            double.parse(bidInfo[
                                                                    index]
                                                                .finalFare!));
                                                    final double couponValue =
                                                        double.parse(
                                                            bidInfo[index]
                                                                .finalFare!);

                                                    final finalPrice =
                                                        couponValue - percent;
                                                    double roundedValue =
                                                        double.parse(finalPrice
                                                            .toStringAsFixed(
                                                                2));
                                                    ref
                                                            .read(couponApplied
                                                                .notifier)
                                                            .state =
                                                        roundedValue.toString();
                                                    ref
                                                        .read(
                                                            couponvalueProvider
                                                                .notifier)
                                                        .state = double.parse(
                                                            percent
                                                                .toStringAsFixed(
                                                                    2))
                                                        .toString();
                                                    ref
                                                            .read(couponCode
                                                                .notifier)
                                                            .state =
                                                        e.couponCodeValue!;
                                                    print(ref.read(couponCode));
                                                  },
                                                  child: const Text(
                                                    'Apply Code',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    )))
                                .toList(),
                          ),
                        ));
                      },
                      leading: const Icon(
                        Icons.local_offer,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Apply Coupon ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.forward,
                        color: Colors.black,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: roundedRectangleBorder.copyWith(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 10)),
                  onPressed: () async {
                    final result = await preCall(
                        ref.read(userModelProvider).userId!,
                        userActiveBooking.response![0].bookDriverId!,
                        bidInfo[index].bookDriverBidId!,
                        ref.read(couponCode));
                    if (result != null) {
                      {
                        {
                          if (result.response![0].redirectToPaymentGateway ==
                              '1') {
                            showsuccesBar('ridirect to final payment gateway');
                          } else if (result
                                  .response![0].redirectToFinalPayment ==
                              '1') {
                            final finalResult = await postfinalCall(
                                ref.read(userModelProvider).userId!,
                                result.response![0].orderNo!,
                                result.response![0].finalTotalAmount!,
                                'success',
                                jsonEncode({'result': 'success'}));

                            if (finalResult) {
                              Get.offAll(() => const RequestHistory());
                            }
                          }
                        }
                      }
                    }
                  },
                  child: const Text(
                    'Procced To Payment',
                    style: TextStyle(fontSize: 18),
                  )),
            )
          ],
        ));
  }
}
