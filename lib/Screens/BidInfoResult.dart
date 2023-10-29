import 'package:book_rides/Models/BookingsViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../Services/apis_services.dart';
import 'RideRequests.dart';

class BidInfoResult extends StatelessWidget {
  final BookingsViewModel bookingsViewModel;
  final String id;
  final int index;
  const BidInfoResult(
      {super.key,
      required this.id,
      required this.index,
      required this.bookingsViewModel});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) => FutureBuilder(
        future: user_requested_booking_view(id),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!.response![index];
            return SingleChildScrollView(
              child: Column(
                children: [
                  SelectedRideDetail(
                    bookingViewModel: bookingsViewModel,
                    index: index,
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
