// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_this
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class UserModel {
  final String? userId;
  final String? country_code;
  final String? isOnline;
  final String? is_driver_form_done;
  final String? userSlug;
  final String? userMode;
  final String? name;
  final String? driver_form_percentage;
  final String? fname;
  final String? lname;
  final String? mobile;
  final String? email;
  final String? address;
  final String? country;
  final String? show_user_mode_screen;
  final String? show_register_driver_screen;
  final String? state;
  final String? city;
  final String? pincode;
  final String? profilePic;
  final String? dob;
  final String? gender;
  final String? latitudes;
  final String? longitude;
  final String? refCode;
  final String? registerType;
  final String? isMobileVerified;
  final String? showRegisterScreen;
  final String? adminApproved;
  final String? adminMessage;
  final String? categoryId;
  final String? categoryName;
  final String? drivingLicenseNumber;
  final String? drivingLicenseFront;
  final String? drivingLicenseBack;
  final String? dateOfExpiration;
  final String? idConfirmation;
  final String? identificationFile;
  final String? identificationFile1;
  final String? numberPlate;
  final String? vehiclePhoto;
  final String? registrationCertificateFront;
  final String? registrationCertificateBack;
  final String? pemrit;
  final String? pemrit1;
  final String? vehicleInsrance;
  final String? adminApprovedDriver;
  final String? adminMessageDriver;

  const UserModel(
      {this.userId,
      this.country_code,
      this.isOnline,
      this.userSlug,
      this.driver_form_percentage,
      this.is_driver_form_done,
      this.userMode,
      this.name,
      this.fname,
      this.lname,
      this.show_register_driver_screen,
      this.show_user_mode_screen,
      this.mobile,
      this.email,
      this.address,
      this.country,
      this.state,
      this.city,
      this.pincode,
      this.profilePic,
      this.dob,
      this.gender,
      this.latitudes,
      this.longitude,
      this.refCode,
      this.registerType,
      this.isMobileVerified,
      this.showRegisterScreen,
      this.adminApproved,
      this.adminMessage,
      this.adminApprovedDriver,
      this.adminMessageDriver,
      this.categoryId,
      this.categoryName,
      this.dateOfExpiration,
      this.drivingLicenseBack,
      this.drivingLicenseFront,
      this.drivingLicenseNumber,
      this.idConfirmation,
      this.identificationFile,
      this.identificationFile1,
      this.numberPlate,
      this.pemrit,
      this.pemrit1,
      this.registrationCertificateBack,
      this.registrationCertificateFront,
      this.vehicleInsrance,
      this.vehiclePhoto});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      isOnline: json['is_online'],
      driver_form_percentage: json['driver_form_percentage'],
      is_driver_form_done: json['is_driver_form_done'],
      userId: json['user_id'],
      userSlug: json['user_slug'],
      name: json['name'],
      userMode: json['user_mode'],
      show_user_mode_screen: json['show_user_mode_screen'],
      fname: json['fname'],
      lname: json['lname'],
      mobile: json['mobile'],
      email: json['email'],
      address: json['address'],
      country: json['country'],
      country_code: json['country_code'],
      state: json['state'],
      city: json['city'],
      pincode: json['pincode'],
      profilePic: json['profile_pic'],
      dob: json['dob'],
      gender: json['gender'],
      latitudes: json['latitudes'],
      longitude: json['longitude'],
      refCode: json['ref_code'],
      show_register_driver_screen: json['show_register_driver_screen'],
      registerType: json['register_type'],
      isMobileVerified: json['is_mobile_verified'],
      showRegisterScreen: json['show_register_screen'],
      adminApproved: json['admin_approved'],
      adminMessage: json['admin_message'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      drivingLicenseNumber: json['driving_license_number'],
      drivingLicenseFront: json['driving_license_front'],
      drivingLicenseBack: json['driving_license_back'],
      dateOfExpiration: json['date_of_expiration'],
      idConfirmation: json['id_confirmation'],
      identificationFile: json['identification_file'],
      identificationFile1: json['identification_file1'],
      numberPlate: json['number_plate'],
      vehiclePhoto: json['vehicle_photo'],
      registrationCertificateFront: json['registration_certificate_front'],
      registrationCertificateBack: json['registration_certificate_back'],
      pemrit: json['pemrit'],
      pemrit1: json['pemrit1'],
      vehicleInsrance: json['vehicle_insrance'],
      adminApprovedDriver: json['admin_approved_driver'],
      adminMessageDriver: json['admin_message_driver'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = userId ?? '';
    data['is_driver_form_done'] = is_driver_form_done ?? '';
    data['driver_form_percentage'] = driver_form_percentage ?? '';
    data['user_slug'] = userSlug ?? '';
    data['user_mode'] = userMode ?? '';
    data['name'] = name ?? '';
    data['fname'] = fname ?? '';
    data['show_register_driver_screen'] = show_register_driver_screen ?? '';
    data['show_user_mode_screen'] = show_user_mode_screen ?? '';
    data['lname'] = lname ?? '';
    data['mobile'] = mobile ?? '';
    data['email'] = email ?? '';
    data['address'] = address ?? '';
    data['country'] = country ?? '';
    data['state'] = state ?? '';
    data['city'] = city ?? '';
    data['pincode'] = pincode ?? '';
    data['profile_pic'] = profilePic ?? '';
    data['dob'] = dob ?? '';
    data['gender'] = gender ?? '';
    data['latitudes'] = latitudes ?? '';
    data['longitude'] = longitude ?? '';
    data['ref_code'] = refCode ?? '';
    data['register_type'] = registerType ?? '';
    data['is_mobile_verified'] = isMobileVerified ?? '';
    data['show_register_screen'] = showRegisterScreen ?? '';
    data['admin_approved'] = adminApproved ?? '';
    data['admin_message'] = adminMessage ?? '';
    data['category_id'] = categoryId ?? '';
    data['category_name'] = categoryName ?? '';
    data['driving_license_number'] = drivingLicenseNumber ?? '';
    data['driving_license_front'] = drivingLicenseFront ?? '';
    data['driving_license_back'] = drivingLicenseBack ?? '';
    data['date_of_expiration'] = dateOfExpiration ?? '';
    data['id_confirmation'] = idConfirmation ?? '';
    data['identification_file'] = identificationFile ?? '';
    data['identification_file1'] = identificationFile1 ?? '';
    data['number_plate'] = numberPlate ?? '';
    data['vehicle_photo'] = vehiclePhoto ?? '';
    data['registration_certificate_front'] = registrationCertificateFront ?? '';
    data['registration_certificate_back'] = registrationCertificateBack ?? '';
    data['pemrit'] = pemrit ?? '';
    data['pemrit1'] = pemrit1 ?? '';
    data['vehicle_insrance'] = vehicleInsrance ?? '';
    data['admin_approved_driver'] = adminApprovedDriver ?? '';
    data['admin_message_driver'] = adminMessageDriver ?? '';
    return data;
  }

  UserModel copyWith({
    String? isOnline,
    String? userId,
    String? is_driver_form_done,
    String? driver_form_percentage,
    String? userSlug,
    String? name,
    String? country_code,
    String? fname,
    String? userMode,
    String? lname,
    String? mobile,
    String? email,
    String? address,
    String? country,
    String? state,
    String? city,
    String? pincode,
    String? profilePic,
    String? dob,
    String? gender,
    String? latitudes,
    String? longitude,
    String? refCode,
    String? registerType,
    String? isMobileVerified,
    String? showRegisterScreen,
    String? adminApproved,
    String? adminMessage,
    String? categoryId,
    String? categoryName,
    String? drivingLicenseNumber,
    String? drivingLicenseFront,
    String? drivingLicenseBack,
    String? dateOfExpiration,
    String? idConfirmation,
    String? identificationFile,
    String? identificationFile1,
    String? show_user_mode_screen,
    String? show_register_driver_screen,
    String? numberPlate,
    String? vehiclePhoto,
    String? registrationCertificateFront,
    String? registrationCertificateBack,
    String? pemrit,
    String? pemrit1,
    String? vehicleInsrance,
    String? adminApprovedDriver,
    String? adminMessageDriver,
  }) {
    return UserModel(
      country_code: country_code ?? this.country_code,
      isOnline: isOnline ?? this.isOnline,
      userMode: userMode ?? this.userMode,
      userId: userId ?? this.userId,
      is_driver_form_done: is_driver_form_done ?? this.is_driver_form_done,
      driver_form_percentage:
          driver_form_percentage ?? this.driver_form_percentage,
      userSlug: userSlug ?? this.userSlug,
      name: name ?? this.name,
      fname: fname ?? this.fname,
      lname: lname ?? this.lname,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      show_user_mode_screen:
          show_user_mode_screen ?? this.show_user_mode_screen,
      show_register_driver_screen:
          show_register_driver_screen ?? this.show_register_driver_screen,
      pincode: pincode ?? this.pincode,
      profilePic: profilePic ?? this.profilePic,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      latitudes: latitudes ?? this.latitudes,
      longitude: longitude ?? this.longitude,
      refCode: refCode ?? this.refCode,
      registerType: registerType ?? this.registerType,
      isMobileVerified: isMobileVerified ?? this.isMobileVerified,
      showRegisterScreen: showRegisterScreen ?? this.showRegisterScreen,
      adminApproved: adminApproved ?? this.adminApproved,
      adminMessage: adminMessage ?? this.adminMessage,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      drivingLicenseNumber: drivingLicenseNumber ?? this.drivingLicenseNumber,
      drivingLicenseFront: drivingLicenseFront ?? this.drivingLicenseFront,
      drivingLicenseBack: drivingLicenseBack ?? this.drivingLicenseBack,
      dateOfExpiration: dateOfExpiration ?? this.dateOfExpiration,
      idConfirmation: idConfirmation ?? this.idConfirmation,
      identificationFile: identificationFile ?? this.identificationFile,
      identificationFile1: identificationFile1 ?? this.identificationFile1,
      numberPlate: numberPlate ?? this.numberPlate,
      vehiclePhoto: vehiclePhoto ?? this.vehiclePhoto,
      registrationCertificateFront:
          registrationCertificateFront ?? this.registrationCertificateFront,
      registrationCertificateBack:
          registrationCertificateBack ?? this.registrationCertificateBack,
      pemrit: pemrit ?? this.pemrit,
      pemrit1: pemrit1 ?? this.pemrit1,
      vehicleInsrance: vehicleInsrance ?? this.vehicleInsrance,
      adminApprovedDriver: adminApprovedDriver ?? this.adminApprovedDriver,
      adminMessageDriver: adminMessageDriver ?? this.adminMessageDriver,
    );
  }
}
