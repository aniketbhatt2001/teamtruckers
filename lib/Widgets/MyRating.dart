import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

void showDriverRatingAppDialog(String bookDriverId, String userId) {
  final ratingDialog = RatingDialog(
    submitButtonTextStyle: TextStyle(color: primary, fontSize: 18),
    // ratingColor: Colors.amber,
    title: const Text(
      'Rate Us',
      textAlign: TextAlign.center,
    ),
    // message: 'Rating this app and tell others what you think.'
    //     ' Add more description here if you want.',
    // image: Image.asset("assets/images/devs.jpg",
    //   height: 100,),
    // submitButton: 'Submit',
    onCancelled: () => Get.back(closeOverlays: true),

    onSubmitted: (response) async {
      Get.back(closeOverlays: true);
      await addDriverReview(userId, bookDriverId,
          response.rating.round().toString(), response.comment);

      // Get.offAll(DriverSingleBooking(book_driver_id: bookDriverId));
      // ref.read(toggleDriverSingleBookingStatus.notifier).state =
      //     !ref.read(toggleDriverSingleBookingStatus);
      //ref.refresh(singleBookingProvider(bookDriverId));
    },
    submitButtonText: 'Submit',
  );

  Get.dialog(ratingDialog);
}

void showUserRatingAppDialog(String bookDriverId, WidgetRef ref) async {
  final _ratingDialog = RatingDialog(
    submitButtonTextStyle: TextStyle(color: primary, fontSize: 18),
    // ratingColor: Colors.amber,
    title: const Text(
      'Rate Us',
      textAlign: TextAlign.center,
    ),
    // message: 'Rating this app and tell others what you think.'
    //     ' Add more description here if you want.',
    // image: Image.asset("assets/images/devs.jpg",
    //   height: 100,),
    // submitButton: 'Submit',
    onCancelled: () => Get.back(closeOverlays: true),
    onSubmitted: (response) async {
      // log(response.rating.toString());
      Get.back(closeOverlays: true);
      await addPassengerReview(ref.read(userModelProvider).userId!,
          bookDriverId, response.rating.round().toString(), response.comment);
      // ref.refresh(toggleUserSinglBookingStatus);
      // final status = ref.read(toggleUserSinglBookingStatus);
      //  print(status);
      // Get.offAll(UserSingleBooking(book_driver_id: bookDriverId));
      // ref.read(toggleUserSinglBookingStatus.notifier).state = !status;
      // log(ref.read(toggleUserSinglBookingStatus.notifier).state.toString());
    },
    submitButtonText: 'Submit',
  );

  Get.dialog(_ratingDialog);
}

class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({Key? key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
