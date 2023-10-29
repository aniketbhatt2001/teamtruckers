import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:cc_avenue/cc_avenue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:url_launcher/url_launcher.dart';
import '../Models/UserActiveBooking.dart';
import '../Services/apis_services.dart';

late final String? fcmToken;
void showLoadUp() {
  Get.dialog(const Loading());
}

void pop() {
  Get.back();
}

final ThemeData darkTheme = ThemeData.dark(useMaterial3: false).copyWith(
  primaryColor: Colors.green,

  // Add more theme properties as needed
);
const mapKey = 'AIzaSyB9EGl7nbIt4lXdtDawExRBbwbff232wPU';
final primary = HexColor('#0a97b7');
const white = Colors.white;
const black = Colors.black;
final BoxDecoration myDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(
      10,
    ),
    color: Colors.grey.shade200);
final roundedRectangleBorder =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
const headers = {
  'Authorization': '\$1\$aRkFpEz3\$qGGbgw/.xtfSv8rvK/j5y0',
  'Client-Service': 'frontend-client-teamtruckers',
  'Auth-Key': 'simplerestapi_teamtruckers',
  'User-ID': '1',
  'Content-Type': 'application/x-www-form-urlencoded'
};
const baseUrl = 'https://scprojects.in.net/projects/teamtruckers_app/api_';
// showSnackBar(String title, [String? message]) {
//   Get.snackbar(title, message ?? '',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       colorText: Colors.white);
// }
List<String> stringToList(String inputString) {
  List<String> stringList = inputString.split(",");
  return stringList;
}

String listToString(List<String> inputList) {
  String concatenatedString = inputList.join(",");
  return concatenatedString;
}

showsuccesBar(String title, [String? message]) {
  Get.snackbar(title, message ?? '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      colorText: Colors.white);
}

showFailureBar(String title, [String? message]) {
  Get.snackbar(title, message ?? '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      colorText: Colors.white);
}

const fadedBlack = Colors.black12;

TextStyle medium(BuildContext context) {
  final medium = Theme.of(context).textTheme.titleMedium;
  return medium!;
}

TextStyle large(BuildContext context) {
  final large = Theme.of(context).textTheme.titleLarge;
  return large!;
}

loadingFunction(loadingProgress, child) {
  if (loadingProgress == null) return child; // Image fully loaded, show it
  return Container(
    height: 30,
    width: 30,
    child: CircularProgressIndicator(
      strokeWidth: 3,
      color: Colors.red,
      value: loadingProgress.expectedTotalBytes != null
          ? loadingProgress!.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!.toInt()
          : null,
    ),
  );
}

void show_failure_flushbar(BuildContext context, String message) {
  Flushbar(
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
    message: message,
    messageSize: 18,
  ).show(context);
}

// ignore: non_constant_identifier_names
void show_sucess_flushbar(BuildContext context, String message) {
  Flushbar(
    //flushbarPosition: FlushbarPosition.TOP,

    backgroundColor: Colors.green,
    duration: Duration(seconds: 3),
    message: message,
    messageSize: 18,
  ).show(context);
}

Future<List<BidInfo>> getPassengerBidInfo(String userId) async {
  List<BidInfo> bids = [];
  final response = await ApiServices.getResponse(
      '$baseUrl//app/user_active_booking/MOB/$userId');
  return response.fold((l) {
    //showSnackBar(l.message);
    return [];
  }, (r) {
    r.body;
    UserActiveBooking userActiveBooking =
        UserActiveBooking.fromJson(r.body as Map<String, dynamic>);
    for (var element in userActiveBooking.response!) {
      bids = element.bidInfo!;
    }
    return bids;
  });
}

Future<List<BidInfo>> getDriverBidInfo(String userId) async {
  List<BidInfo> bids = [];
  final response = await ApiServices.getResponse(
      '$baseUrl/app/user_requested_booking_view/$userId');
  return response.fold((l) {
    //showSnackBar(l.message);
    return [];
  }, (r) {
    r.body;
    UserActiveBooking userActiveBooking =
        UserActiveBooking.fromJson(r.body as Map<String, dynamic>);
    for (var element in userActiveBooking.response!) {
      bids = element.bidInfo!;
    }
    return bids;
  });
}

void launchDialer(String phoneNumber, BuildContext context) async {
  Uri url = Uri(scheme: "tel", path: phoneNumber);
  // Uri phoneno = Uri.parse(snapshot.data!.phone!,);
  if (await launchUrl(url)) {
    //dialer opened
  } else {
    //dailer is not opened
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: const Text('Please try Again')));
  }
}

double calculatePercentage(double percentage, double total) {
  return (percentage / 100) * total;
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.all(15),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CupertinoActivityIndicator(),
            SizedBox(
              width: 12,
            ),
            Text('Please wait...')
          ],
        ),
      ),
    );
  }
}
