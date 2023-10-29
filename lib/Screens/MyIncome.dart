import 'package:book_rides/Screens/RideRequests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHistory extends ConsumerWidget {
  const MyHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('my income');
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Text(
          'All your previous requests will be shown here within 24 hours',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
