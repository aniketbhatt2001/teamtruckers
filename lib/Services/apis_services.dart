// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:developer';
import 'package:book_rides/Models/CountryListModel.dart';
import 'package:book_rides/Screens/Login.dart';
import 'package:libphonenumber/libphonenumber.dart';

import 'package:book_rides/Models/BookingCancelOption.dart';
import 'package:book_rides/Models/HistoryHeaders.dart';
import 'package:book_rides/Models/UserActiveBooking.dart';
import 'package:book_rides/providers/BaiscProviders.dart';
import 'package:device_info/device_info.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:book_rides/Models/MainCategoryModel.dart';
import 'package:book_rides/Models/SubCategoryScreen.dart';
import 'package:book_rides/Models/UserModel.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import '../Models/BookingHistoryModel.dart';
import '../Models/BookingsViewModel.dart';
import '../Models/DriverSingleBookingModel.dart';
import '../Models/EarningsHistoryModel.dart';
import '../Models/GetChatModel.dart';
import '../Models/PrePostCallModel.dart';
import '../Models/UserAppConfigModel.dart';
import '../Models/UserSingleBookingModel.dart';
import '../Screens/OtpScreen.dart';
import '../Utils/Constatnts.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../response/api_response.dart';

Future<String?> formatPhoneNumber(String phoneNumber, String isoCode) async {
  String? formattedPhoneNumber = phoneNumber;
  try {
    formattedPhoneNumber = await PhoneNumberUtil.normalizePhoneNumber(
      phoneNumber: phoneNumber,
      isoCode: isoCode,
    );
  } catch (e) {
    // Handle any formatting errors.
  }
  return formattedPhoneNumber;
}

Future<bool?> updateUserDetail(
  WidgetRef ref,
) async {
  showLoadUp();

  Map map = {'device_type': 'MOB'};
  map.addAll(ref.read(userModelProvider.notifier).state.toJson());
  final res =
      await ApiServices.postResponse('$baseUrl/user/update_user_detail', map);
  log(map.toString());
  pop();
  return res.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    String message = r.body['message'];

    showsuccesBar(message);
    return true;
  });
}

Future<CountryList?> fetchCountries() async {
  final result = await ApiServices.getResponse(
      '$baseUrl/login/country_list_with_dial_code/MOB');
  return result.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    return CountryList.fromJson(r.body as Map<String, dynamic>);
  });
}

requestOtpVerification(
  String phoneNumber,
) async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: '+91 $phoneNumber',
    verificationCompleted: (PhoneAuthCredential credential) {
      log('verificationCompleted');

      log('token ${credential.token.toString()}');
    },
    verificationFailed: (FirebaseAuthException e) {
      Get.snackbar(e.toString(), '');
      log(e.toString());
    },
    codeSent: (String verificationId, int? resendToken) async {
      Get.snackbar('Otp Sent sucessfuly', '');
      Get.offAll(OtpPage(verificationId: verificationId, number: phoneNumber));
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

Future<bool> verifyOtp(String verificationId, String enteredOtp) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: enteredOtp,
  );

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return T;
    // OTP verification successful, handle userCredential
  } catch (e) {
    // OTP verification failed, handle error
    Get.snackbar(e.toString(), '');
    return F;
  }
}

Future<bool?> verifyUser(UserModel userModel, WidgetRef ref) async {
  log('inside verify');
  showLoadUp();
  final val = await ApiServices.postResponse('$baseUrl/user/verify_user', {
    'device_type': 'MOB',
    'user_id': userModel.userId,
    'mobile': userModel.mobile,
    'country_code': userModel.country_code
  });
  pop();
  return val.fold((l) {
    Get.snackbar("Error", l.message);
  }, (r) async {
    // if (userModel.showRegisterScreen == '0') {
    //   Get.off(UserMapInfo());
    // }else{
    // final user = await getUserDetail(userModel.userId!, ref);
    // if (user != null) {
    //   if (user.showRegisterScreen == '1') {
    //     Get.offAll(RegistrationScreen());
    //   } else {
    //     Get.offAll(UserMapInfo());
    //   }
    // }
    // }
    return true;
  });
}

Future<bool?> createUser(
  String number,
  WidgetRef ref,
) async {
  showLoadUp();
  final response = await ApiServices.postResponse('$baseUrl/user/create', {
    'device_type': 'MOB',
    'mobile': number,
    'country_code': ref.read(userModelProvider).country_code
  });
  log({
    'device_type': 'MOB',
    'mobile': number,
    'country_code': ref.read(userModelProvider).country_code
  }.toString());
  pop();

  return response.fold((l) {
    Get.snackbar(l.message, l.status);
  }, (r) {
    final res = r.body;

    final userId = res['response'][0]['user_id'];
    log(res.toString());
    // getUserDetail(userId, ref).then((value) {
    //   if (value != null) {
    //     // ignore: prefer_const_constructors
    //     // Get.off(UserMapInfo());
    //   }
    // });
    ref.read(userModelProvider.notifier).updateiD(userId);

    return true;
  });
}

Future<UserModel?> getUserDetail(String id, WidgetRef ref) async {
  log('inside getUserDetail');
  // showLoadUp();
  final respoonse =
      await ApiServices.getResponse('$baseUrl/user/user_detail/MOB/$id');
  //pop();
  return respoonse.fold((l) {
    Get.snackbar(l.message, 'inside getUserDetail');
    return null;
  }, (r) {
    final res = r.body;
    final user = ref
        .read(userModelProvider.notifier)
        .updateUserModel(UserModel.fromJson(res['response'][0]));

    return user;
  });
}

class ApiServices {
  static Future<Either<Failure, Success>> getResponse(String url) async {
    try {
      http.Response jsonResponse =
          await http.get(Uri.parse(url), headers: headers);
      Map response = jsonDecode(jsonResponse.body);

      if (jsonResponse.statusCode == 200) {
        return Right(Success(response));
      } else {
        return Left(
            Failure(response['message'], jsonResponse.statusCode.toString()));
      }
    } on SocketException {
      return Left(Failure('No internet Connection!!', ''));
    } catch (e) {
      return Left(Failure('$e', ''));
    }
  }

  static Future<Either<Failure, Success>> postResponse(
    String url,
    Map body,
  ) async {
    try {
      http.Response jsonResponse =
          await http.post(Uri.parse(url), body: body, headers: headers);

      Map response = jsonDecode(jsonResponse.body);

      if (jsonResponse.statusCode == 200) {
        return Right(Success(response));
      } else {
        return Left(
            Failure(response['message'], jsonResponse.statusCode.toString()));
      }
    } on SocketException {
      return Left(Failure('No Internet Connection', ''));
    } catch (e) {
      return Left(Failure('$e', ''));
    }
  }
}

Future<bool> updateUserAppInfo(String userId, String fcmToken) async {
  late PackageInfo packageInfo;
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var deviceUniqueId = "";
    var model = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceUniqueId = androidInfo.androidId;
      model = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      deviceUniqueId = iosInfo.identifierForVendor;
      model = iosInfo.utsname.machine;
    }
    packageInfo = await PackageInfo.fromPlatform();

    http.Response response = await http.post(
        Uri.parse('$baseUrl/login/update_app_info'),
        headers: headers,
        body: {
          'user_id': userId,
          "device_type": "MOB",
          'device_id': fcmToken,
          'os_info': Platform.isIOS ? "ios" : "android",
          'model_name': model,
          'app_version': packageInfo.version,
          'more_app_info': DateTime.now().toString()
        });

    print({
      'user_id': userId,
      "device_type": "MOB",
      'device_id': fcmToken,
      'os_info': Platform.isIOS ? "ios" : "android",
      'model_name': model,
      'app_version': packageInfo.version,
      'more_app_info': DateTime.now().toString()
    }.toString());
    if (response.statusCode == 200) {
      log('succesful');
      return true;
    } else {
      Map map = jsonDecode(response.body);
      String message = map['message'];
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  } catch (e) {
    Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    return false;
  }
}

update_user_location_info(Position position, WidgetRef ref) async {
  ApiServices.postResponse('$baseUrl/login/update_user_location_info', {
    'device_type': 'MOB',
    'user_id': ref.read(userModelProvider).userId,
    'latitudes': position.latitude.toString(),
    'longitude': position.longitude.toString(),
  }).then((value) {
    value.fold((l) {
      log(l.message);
    }, (r) {
      print(r.body['message']);
    });
  });
  print({
    'device_type': 'MOB',
    'user_id': ref.read(userModelProvider).userId,
    'latitudes': position.latitude,
    'longitude': position.longitude,
  });
}

Future<bool?> changeUserMode(String userId, String mode) async {
  showLoadUp();
  final res = await ApiServices.postResponse('$baseUrl/user/change_user_mode',
      {'device_type': 'MOB', 'user_id': userId, 'user_mode': mode});
  pop();
  return res.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    return true;
  });
}

Future<bool?> uploadDriverBasicDetails(String userId, Map userMap) async {
  Map map = {'device_type': 'MOB', 'user_id': userId};
  map.addAll(userMap);
  showLoadUp();
  final res = await ApiServices.postResponse(
      '$baseUrl/user/update_user_driver_detail', map);
  pop();
  return res.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    showsuccesBar(r.body['message']);
    return true;
  });
}

Future<bool?> uploadDriverDetails(String userId, Map userMap) async {
  Map map = {'device_type': 'MOB', 'user_id': userId};
  map.addAll(userMap);

  final res = await ApiServices.postResponse(
      '$baseUrl/user/update_user_driver_detail', map);

  return res.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    showsuccesBar(r.body['message']);
    return true;
  });
}

Future<MainCategoryModel?> fetchMainCategories(String userId) async {
  final resposne =
      await ApiServices.getResponse('$baseUrl/app/main_categories/MOB/$userId');

  return resposne.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    MainCategoryModel mainCategoryModel =
        MainCategoryModel.fromJson(r.body as Map<String, dynamic>);
    return mainCategoryModel;
  });
}

Future<SubCategoryModel?> fetchSubCategories(
    String userId, String catSlug) async {
  final resposne = await ApiServices.getResponse(
      '$baseUrl/app/main_categories_view_with_subcategory/MOB/$userId/$catSlug');

  return resposne.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    SubCategoryModel subCategoryModel =
        SubCategoryModel.fromJson(r.body as Map<String, dynamic>);

    return subCategoryModel;
  });
}

updatePercentage(WidgetRef ref) {
  getUserDetail(ref.read(userModelProvider).userId!, ref).then((value) {
    if (value != null) {
      ref
          .read(userModelProvider.notifier)
          .updatePercentage(value.driver_form_percentage!);
      Get.back();
    }
  });
}

Future<bool> findDriver(
  WidgetRef ref,
  String comment,
) async {
  final user = ref.read(userModelProvider);
  final locationInfo = ref.read(locationModelStateProvider);
  showLoadUp();
  final response = await ApiServices.postResponse(
      '$baseUrl/app/user_near_by_driver_request', {
    'device_type': 'MOB',
    'user_id': user.userId,
    'source_latitude': locationInfo.pickUpLatlng!.latitude.toString(),
    'source_longitude': locationInfo.pickUpLatlng!.longitude.toString(),
    'destination_latitude': locationInfo.destinationLatlng!.latitude.toString(),
    'destination_longitude':
        locationInfo.destinationLatlng!.longitude.toString(),
    'source_city': ref.read(cityProvider),
    'destination_city': ref.read(destinationCityProvider),
    'source_location_address': locationInfo.pickupLocation,
    'destination_location_address': locationInfo.destinationLocation,
    'category_id': ref.read(categoryIdProvider),
    'booking_date': ref.read(dateProvider),
    'booking_time': ref.read(timeProvider),
    'comments': comment
  });
  log({
    'device_type': 'MOB',
    'user_id': user.userId,
    'source_latitude': locationInfo.pickUpLatlng!.latitude.toString(),
    'source_longitude': locationInfo.pickUpLatlng!.longitude.toString(),
    'destination_latitude': locationInfo.destinationLatlng!.latitude.toString(),
    'destination_longitude':
        locationInfo.destinationLatlng!.longitude.toString(),
    'source_city': ref.read(cityProvider),
    'destination_city': ref.read(destinationCityProvider),
    'source_location_address': locationInfo.pickupLocation,
    'destination_location_address': locationInfo.destinationLocation,
    'category_id': ref.read(categoryIdProvider),
    'booking_date': ref.read(dateProvider),
    'booking_time': ref.read(timeProvider),
    'comments': comment
  }.toString());
  pop();

  return response.fold((l) {
    showFailureBar(l.message);
    return false;
  }, (r) => true);
}

Future<UserActiveBooking?> getActiveBookings(String userId) async {
  final response = await ApiServices.getResponse(
      '$baseUrl/app/user_active_booking/MOB/$userId');
  return response.fold((l) {
    if (l.message != 'User active booking not found!') {
      showFailureBar(l.message);
    }
  }, (r) {
    r.body;
    UserActiveBooking userActiveBooking =
        UserActiveBooking.fromJson(r.body as Map<String, dynamic>);
    return userActiveBooking;
  });
}

Future<bool> cancelRide(
    String id, String book_driver_id, String userReason, String comment) async {
  showLoadUp();
  final response =
      await ApiServices.postResponse('$baseUrl/app/user_cancel_booking', {
    'device_type': 'MOB',
    'user_id': id,
    'book_driver_id': book_driver_id,
    'user_reason': userReason,
    'user_reason_comment': comment
  });
  pop();
  return response.fold((l) {
    showFailureBar(l.message);
    return F;
  }, (r) {
    showsuccesBar(r.body['message']);
    //Future.delayed(Duration(seconds: 1));
    return T;
  });
}

Future<BookingCancelOptions?> bookingCancelOptions() async {
  final response = await ApiServices.getResponse(
      '$baseUrl/app/booking_cancel_options/MOB/user');

  return response.fold((l) {
    return null;
  }, (r) {
    final res = BookingCancelOptions.fromJson(r.body as Map<String, dynamic>);
    log(res.response.toString());
    return res;
  });
}

Future<BookingsViewModel?> user_requested_booking_view(String id) async {
  final response = await ApiServices.getResponse(
      '$baseUrl/app/user_requested_booking_view/MOB/$id');

  return response.fold((l) {
    if (l.message != 'Booking not found!' && l.message != 'You are offline.') {
      showFailureBar(l.message);
    }
    return null;
  }, (r) {
    log('inside sucess');
    final response = BookingsViewModel.fromJson(r.body as Map<String, dynamic>);

    return response;
  });
}

Future<HistoryHeaders?> bookingsHistoryHeaders(String id) async {
  final response = await ApiServices.getResponse(
      '$baseUrl/app/booking_history_headers/MOB/user/$id');
  return response.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    return HistoryHeaders.fromJson(r.body as Map<String, dynamic>);
  });
}

Future<BookingHistoryModel?> getBookingHistories(
    String id, String? slug) async {
  final response = await ApiServices.getResponse(
      '$baseUrl/app/all_booking_req_user/MOB/$id/${slug ?? ''}');

  return response.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    return BookingHistoryModel.fromJson(r.body as Map<String, dynamic>);
  });
}

Future<bool?> bidOnUserBooking(String id, String bookId, String bookingTime,
    String bookingDate, String fare, String comments) async {
  showLoadUp();
  final response = await ApiServices.postResponse(
      '$baseUrl/app/driver_bid_on_user_booking_request', {
    'device_type': 'MOB',
    'user_id': id,
    'book_driver_id': bookId,
    'booking_date': bookingDate,
    'booking_time': bookingTime,
    'fare': fare,
    'comments': comments
  });
  pop();
  return response.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    showsuccesBar(r.body['message']);
    return true;
  });
}

Future<bool> userAcceptBid(
    String userId, String book_driver_bid_id, String book_driver_id) async {
  showLoadUp();
  final response = await ApiServices.postResponse(
      '$baseUrl/app/accept_bid_from_driver_user', {
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': book_driver_id,
    'book_driver_bid_id': book_driver_bid_id
  });
  pop();
  log({
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': book_driver_id,
    'book_driver_bid_id': book_driver_bid_id
  }.toString());
  return response.fold((l) {
    showFailureBar(l.message);
    return false;
  }, (r) {
    showsuccesBar(r.body['message']);
    return true;
  });
}

Future<bool> userDeclineBid(String userId, String book_driver_bid_id,
    String book_driver_id, String userReason) async {
  showLoadUp();
  final response = await ApiServices.postResponse(
      '$baseUrl/app/reject_bid_from_driver_user', {
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': book_driver_id,
    'book_driver_bid_id': book_driver_bid_id,
    'user_reason': userReason
  });
  pop();
  log({
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': book_driver_id,
    'book_driver_bid_id': book_driver_bid_id
  }.toString());
  return response.fold((l) {
    showFailureBar(l.message);
    return false;
  }, (r) {
    showsuccesBar(r.body['message']);
    return true;
  });
}

Future<bool> deleteUser(String userId) async {
  final response = await ApiServices.postResponse(
      '$baseUrl/user/delete_user', {'device_type': 'MOB', 'user_id': userId});

  return response.fold((l) {
    showFailureBar(l.message);
    return F;
  }, (r) {
    return T;
  });
}

Future<bool> updatePhoneNumber(
    String number, String id, String country_code) async {
  showLoadUp();
  final res = await ApiServices.postResponse(
      '$baseUrl/user/update_user_mobile_number', {
    'device_type': 'MOB',
    'user_id': id,
    'mobile': number,
    'country_code': country_code
  });

  pop();
  return res.fold((l) {
    showFailureBar(l.message);
    return F;
  }, (r) {
    showsuccesBar(r.body['message']);
    return T;
  });
}

Future<HistoryHeaders?> getDriverHistoryHeaders(String id) async {
  final response = await ApiServices.getResponse(
      '$baseUrl/app/booking_history_headers/MOB/driver/$id');

  return response.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    return HistoryHeaders.fromJson(r.body as Map<String, dynamic>);
  });
}

Future<bool> updateDriverOnlineStatus(String id) async {
  showLoadUp();
  final response = await ApiServices.postResponse(
      '$baseUrl/user/update_user_available_status',
      {'device_type': 'MOB', 'user_id': id, 'status': '1'});
  pop();
  return response.fold((l) {
    showFailureBar(l.message);
    return false;
  }, (r) => T);
}

Future<bool> updateDriverOfflineStatus(String id) async {
  showLoadUp();
  final response = await ApiServices.postResponse(
      '$baseUrl/user/update_user_available_status',
      {'device_type': 'MOB', 'user_id': id, 'status': '0'});
  pop();
  return response.fold((l) {
    showFailureBar(l.message);
    return false;
  }, (r) {
    return T;
  });
}

Future<BookingHistoryModel?> getDriverBookingHistories(
    String id, String? filter) async {
  print('getDriverBookingHistories');
  final response = await ApiServices.getResponse(
      '$baseUrl/app/all_booking_driver_user/MOB/$id/${filter ?? ''}');

  return response.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    return BookingHistoryModel.fromJson(r.body as Map<String, dynamic>);
  });
}

Future addDriverReview(
    String userId, String bookDriverId, String rating, String review) async {
  final response = await ApiServices.postResponse(
      "$baseUrl/app/driver_booking_review_rating", {
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': bookDriverId,
    'user_rating': rating,
    'user_review': review
  });
  log({
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': bookDriverId,
    'user_rating': rating,
    'user_review': review
  }.toString());
  response.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    showsuccesBar(r.body['message']);
  });
}

Future addPassengerReview(
    String userId, String bookDriverId, String rating, String review) async {
  final response = await ApiServices.postResponse(
      "$baseUrl/app/user_booking_review_rating", {
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': bookDriverId,
    'driver_user_rating': rating,
    'driver_user_review': review
  });
  log({
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': bookDriverId,
    'driver_user_rating': rating,
    'driver_user_review': review
  }.toString());
  response.fold((l) {
    showFailureBar(l.message);
    return F;
  }, (r) {
    showsuccesBar(r.body['message']);
    return T;
  });
}

Future<PrePostCallModel?> preCall(String userId, String bookDriverId,
    String book_driver_bid_id, String? couponValue) async {
  showLoadUp();
  final response =
      await ApiServices.postResponse('$baseUrl/payment_call/payment_pre_post', {
    'device_type': 'MOB',
    'app_version': '1',
    'user_id': userId,
    'payment_method': 'online',
    'payment_source': 'razorpay',
    'book_driver_id': bookDriverId,
    'book_driver_bid_id': book_driver_bid_id,
    'coupon_code': couponValue ?? ''
  });
  log({
    'device_type': 'MOB',
    'app_version': '1',
    'user_id': userId,
    'payment_method': 'online',
    'payment_source': 'razorpay',
    'book_driver_id': bookDriverId,
    'book_driver_bid_id': book_driver_bid_id,
  }.toString());
  Get.back();
  return response.fold((l) {
    showFailureBar(
      l.message,
    );
  }, (r) {
    log(r.body['message'].toString());
    return PrePostCallModel.fromJson(r.body as Map<String, dynamic>);
  });
}

Future<bool> postfinalCall(
    String userId,
    String orderNo,
    String order_total_cost,
    String order_status,
    String paymentResponseJson) async {
  showLoadUp();
  final response = await ApiServices.postResponse(
      '$baseUrl/payment_call/payment_final_status', {
    'device_type': 'MOB',
    'user_id': userId,
    'order_total_cost': order_total_cost,
    'order_no': orderNo,
    'order_status': order_status,
    'payment_response': paymentResponseJson,
  });
  log({
    'device_type': 'MOB',
    'user_id': userId,
    'order_total_cost': order_total_cost,
    'order_no': orderNo,
    'order_status': order_status,
    'payment_response': paymentResponseJson,
  }.toString());
  Get.back();
  return response.fold((l) {
    showFailureBar(
      l.message,
    );
    return F;
  }, (r) {
    showsuccesBar(
      r.body['message'].toString(),
    );
    return true;
  });
}

Future<EarningsHistoryModel?> getEarnings(String id) async {
  final res = await ApiServices.getResponse(
      '$baseUrl/app/driver_user_earnings_history/MOB/$id');
  print(id);
  return res.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    return EarningsHistoryModel.fromJson(r.body as Map<String, dynamic>);
  });
}

Future<GetChatModel?> getPassengerMessage(
    String userId, String book_driver_id) async {
  final response = await ApiServices.getResponse(
    '$baseUrl/app/message_send_booking/user/MOB/$userId/$book_driver_id',
  );

  return response.fold((l) {
    if (true) {
      //showFailureBar(l.message);
    }
  }, (r) {
    return GetChatModel.fromJson(r.body as Map<String, dynamic>);
  });
}

Future<GetChatModel?> getDriverMessage(
    String userId, String book_driver_id) async {
  final response = await ApiServices.getResponse(
    '$baseUrl/app/message_send_booking/driver/MOB/$userId/$book_driver_id',
  );

  return response.fold((l) {
    // if (l.message != 'No message found!') {
    //   // showFailureBar(l.message);
    // }
  }, (r) {
    return GetChatModel.fromJson(r.body as Map<String, dynamic>);
  });
}

Future<DriverSingleBookingModel?> driverSingleBooking(
    String id, String book_driver_id) async {
  final response = await ApiServices.getResponse(
      '$baseUrl//app/driver_user_single_booking_view/MOB/$id/$book_driver_id');

  return response.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    return DriverSingleBookingModel.fromJson(r.body as Map<String, dynamic>);
  });
}

Future<UserSingleBookingModel?> userSingleBooking(
    String id, String book_driver_id) async {
  final response = await ApiServices.getResponse(
      '$baseUrl/app/user_single_booking/MOB/$id/$book_driver_id');

  return response.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    return UserSingleBookingModel.fromJson(r.body as Map<String, dynamic>);
  });
}

Future<bool> completeBooking(
    String code, String userId, String book_driver_id) async {
  showLoadUp();
  final response = await ApiServices.postResponse(
      '$baseUrl/app/complete_booking_from_driver_user', {
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': book_driver_id,
    'verify_code': code,
  });
  log({
    'device_type': 'MOB',
    'user_id': userId,
    'book_driver_id': book_driver_id,
    'verify_code': code
  }.toString());
  pop();
  return response.fold((l) {
    showFailureBar(l.message);
    return F;
  }, (r) {
    showsuccesBar(r.body['message']);
    return T;
  });
}

Future<bool> passengerSendMessage(
    String id, String bookDriverId, String message) async {
  final response =
      await ApiServices.postResponse('$baseUrl/app/user_message_send_booking', {
    'device_type': 'MOB',
    'user_id': id,
    'book_driver_id': bookDriverId,
    'message': message
//attachment:
  });
  return response.fold((l) {
    showFailureBar(l.message);
    return F;
  }, (r) {
    return true;
  });
}

Future<bool> driverSendMessage(
    String id, String bookDriverId, String message) async {
  final response = await ApiServices.postResponse(
      '$baseUrl/app/driver_message_send_booking', {
    'device_type': 'MOB',
    'user_id': id,
    'book_driver_id': bookDriverId,
    'message': message
//attachment:
  });
  return response.fold((l) {
    showFailureBar(l.message);
    return F;
  }, (r) {
    return true;
  });
}

Future<UserAppConfigModel?> userAppConfig() async {
  final res = await ApiServices.getResponse('$baseUrl/app/user_app_config/MOB');
  return res.fold((l) {
    showFailureBar(l.message);
  }, (r) {
    log(r.body.toString());
    return UserAppConfigModel.fromJson(r.body as Map<String, dynamic>);
  });
}
