import 'dart:developer';

import 'package:book_rides/Models/UserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserModelNotifier extends StateNotifier<UserModel> {
  UserModelNotifier(super.createFn);

  UserModel updateUserModel(UserModel userModel) {
    state = userModel;
    return state;
  }

  updateName(String name) {
    log('inside updateName $name');
    state = state.copyWith(fname: name);
  }

  updateStatuts(String status) {
    state = state.copyWith(isOnline: status);
    //<issue_comment>username_1: Hi @username_0,;
  }

  updateDrivingLicense(String license) {
    state = state.copyWith(drivingLicenseNumber: license);
  }

  updateInsurance(String insurance) {
    state = state.copyWith(vehicleInsrance: insurance);
  }

  updateId(String id) {
    state = state.copyWith(idConfirmation: id);
  }

  updateIdentificationFile1(String file) {
    state = state.copyWith(identificationFile: file);
  }

  updateIdentificationFile2(String file) {
    state = state.copyWith(identificationFile1: file);
  }

  updateDrivingLicenseFront(String licenseFront) {
    state = state.copyWith(drivingLicenseFront: licenseFront);
  }

  updateDrivingLicenseBack(String licenseBack) {
    state = state.copyWith(drivingLicenseBack: licenseBack);
  }

  updateExpirationDate(String date) {
    state = state.copyWith(dateOfExpiration: date);
  }

  // updateId(String id) {
  //   state = state.copyWith(us: name);
  // }
  updateiD(String id) {
    log('inside updateLastName $id');
    state = state.copyWith(userId: id);
  }

  updateLastName(String lname) {
    log('inside updateLastName $lname');
    state = state.copyWith(lname: lname);
  }

  updateEmail(String email) {
    log('inside updateEmailName $email');
    state = state.copyWith(email: email);
  }

  updateDob(String dob) {
    log('inside updateDobName $dob');
    state = state.copyWith(dob: dob);
  }

  updateRcFront(String rcFront) {
    state = state.copyWith(registrationCertificateFront: rcFront);
  }

  updateNumberPlate(String no) {
    state = state.copyWith(numberPlate: no);
  }

  updateRcBack(String rcBack) {
    state = state.copyWith(registrationCertificateBack: rcBack);
  }

  updatePercentage(String percentage) {
    state = state.copyWith(driver_form_percentage: percentage);
  }

  updateCountryCode(String countryCode) {
    state = state.copyWith(country_code: countryCode);
  }

  updateVehiclePhoto(String vehiclePhoto) {
    state = state.copyWith(vehiclePhoto: vehiclePhoto);
  }

  updatePermit(String permit) {
    state = state.copyWith(pemrit: permit);
  }

  updatePermit2(String permit) {
    state = state.copyWith(pemrit1: permit);
  }

  updateCategoryId(String categoryId) {
    // String prvious
    state = state.copyWith(categoryId: "${state.categoryId},$categoryId");
    // state = state.copyWith(categoryId: categoryId);
    // if (state.categoryId!.isNotEmpty) {
    //state = state.copyWith(categoryId: "${state.categoryId},$categoryId");
    // }
    //print((state.categoryId!.contains(categoryId)));
    // state = state.copyWith(categoryId: categoryId);

    // if (!(state.categoryId!.contains(categoryId))) {
    //   state = state.copyWith(categoryId: "${state.categoryId},$categoryId");
    // } else {
    //   state = state.copyWith(categoryId: categoryId);
    // }
  }

  resetCategoryId(String categoryId) {
    // String prvious
    state = state.copyWith(categoryId: categoryId);
    // state = state.copyWith(categoryId: categoryId);
    // if (state.categoryId!.isNotEmpty) {
    //state = state.copyWith(categoryId: "${state.categoryId},$categoryId");
    // }
    //print((state.categoryId!.contains(categoryId)));
    // state = state.copyWith(categoryId: categoryId);

    // if (!(state.categoryId!.contains(categoryId))) {
    //   state = state.copyWith(categoryId: "${state.categoryId},$categoryId");
    // } else {
    //   state = state.copyWith(categoryId: categoryId);
    // }
  }

  updateCategoryName(String categoryName) {
    state = state.copyWith(categoryName: "${state.categoryName},$categoryName");
  }

  resetCategoryName(String categoryName) {
    state = state.copyWith(categoryName: categoryName);
  }

  updateProfile(String profile) {
    state = state.copyWith(profilePic: profile);
  }

  updateMobile(String mobile) {
    state = state.copyWith(mobile: mobile);
  }
  // updateLastName(String name) {
  //   log('inside updateLastName $name');
  //   state = state.copyWith(lname: name);
  //   log(state.fname!);
  // }
}

//final idProvider = StateProvider.autoDispose((ref) => '');
final userModelProvider = StateNotifierProvider<UserModelNotifier, UserModel>(
    (ref) => UserModelNotifier(const UserModel()));
