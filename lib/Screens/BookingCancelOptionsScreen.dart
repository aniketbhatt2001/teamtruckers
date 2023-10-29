// ignore_for_file: sort_child_properties_last

import 'package:book_rides/Models/BookingCancelOption.dart';
import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'passengerRideDetails.dart';

final user_reason_provider =
    StateProvider.autoDispose<List<String>>((ref) => []);

class BookingCancelScreen extends ConsumerStatefulWidget {
  final String book_driver_id;

  const BookingCancelScreen({super.key, required this.book_driver_id});

  @override
  ConsumerState<BookingCancelScreen> createState() =>
      _BookingCancelScreenState();
}

class _BookingCancelScreenState extends ConsumerState<BookingCancelScreen> {
  final TextEditingController other = TextEditingController();

  @override
  Widget build(
    BuildContext context,
  ) {
    final data = ref.watch(options);
    return data.when(
      data: (data) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    //final reasonSelected = ref.read(user_reason_provider);
                    return CancelReason(
                      data: data,
                      index: index,
                    );
                  },
                  itemCount: data!.response!.length,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextField(
                    controller: other,
                    decoration:
                        const InputDecoration(hintText: 'Other (Optional)'),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 12),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (ref.read(user_reason_provider).isNotEmpty) {
                          Get.back(closeOverlays: true);
                          String userReason = '';
                          for (var element in ref.read(user_reason_provider)) {
                            userReason = userReason + element;
                          }
                          cancelRide(ref.read(userModelProvider).userId!,
                                  widget.book_driver_id, userReason, other.text)
                              .then((value) {
                            if (value) {
                              Get.offAll(const UserMapInfo());
                            }
                          });
                        } else {
                          showFailureBar('please select a reason');
                        }
                      },
                      child: const Text('Done'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: roundedRectangleBorder),
                    ))
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return LayoutBuilder(
          builder: (p0, p1) => SizedBox(
            height: p1.maxHeight / 2,
            child: const Center(
              child: RefreshProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class CancelReason extends ConsumerStatefulWidget {
  final BookingCancelOptions data;
  final int index;

  const CancelReason({super.key, required this.data, required this.index});

  @override
  ConsumerState<CancelReason> createState() => _CancelReasonState();
}

class _CancelReasonState extends ConsumerState<CancelReason> {
  bool isSelected = F;
  late String option;

  @override
  Widget build(BuildContext context) {
    option = widget.data!.response![widget.index].optionName!;
    ref.watch(user_reason_provider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          // decoration: reasonSelected.isEmpty
          //     ? null
          //     : reasonSelected ==
          //             data.response![index].optionName!
          //         ? BoxDecoration(
          //             border: Border.all(color: Colors.blue))
          //         : null,
          child: Text(
            widget.data.response![widget.index].optionName!,
            style: large(context),
          ),
        ),
        Checkbox(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              isSelected = !isSelected;

              // optionSelected = optionSelected +
              //     widget.data!.response![widget.index].optionName!;

              if (isSelected) {
                ref
                    .read(user_reason_provider.notifier)
                    .state
                    .add(widget.data!.response![widget.index].optionName!);
              } else {
                if (ref.read(user_reason_provider.notifier).state.contains(
                    widget.data!.response![widget.index].optionName!)) {
                  ref.read(user_reason_provider.notifier).state.removeWhere(
                      (element) =>
                          element ==
                          widget.data!.response![widget.index].optionName!);
                }
              }
              print(ref.read(user_reason_provider));
              //print(optionSelected);
            });
          },
        )
      ],
    );
  }
}
