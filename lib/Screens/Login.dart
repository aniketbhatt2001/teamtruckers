// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:book_rides/Models/userModel.dart';

import 'package:book_rides/Screens/DriverHomeScreen.dart';
import 'package:book_rides/Screens/DriverRegistration.dart';
import 'package:book_rides/Screens/Register.dart';
import 'package:book_rides/Screens/SelectModeScreen.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/main.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/CountryListModel.dart';
import '../Widgets/MydropDown.dart';
import '../providers/BaiscProviders.dart';
import 'PassengerMapScreen.dart';

// final verificationIdProvider = StateProvider.autoDispose
//     .family<String, String>((ref, verificationId) => verificationId);
//final CountryCodeProvider = StateProvider<String?>((ref) => null);

class LoginForm extends ConsumerStatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  List<String> items = [];
  final FocusNode _focusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  // TextEditingController namClr = TextEditingController();
  TextEditingController mobileClr = TextEditingController();
  void _submitForm() async {
    _focusNode.unfocus();
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform login logic
      ref.read(userModelProvider.notifier).updateMobile(mobileClr.text);
      // showLoadUp();
      // requestOtpVerification(mobileClr.text);

      final res = await createUser(mobileClr.text, ref);

      if (res != null) {
        final user =
            await getUserDetail(ref.read(userModelProvider).userId!, ref);

        if (user != null) {
          showLoadUp();
          final res = await updateUserAppInfo(user.userId!, fcmToken!);
          pop();
          if (res) {
            if (user.isMobileVerified == '0') {
              final res = await verifyUser(user, ref);

              if (res != null) {
                final user = await getUserDetail(
                    ref.read(userModelProvider).userId!, ref);
                if (user != null) {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  ref.read(sharedPrefsProvider).setPrefs(sharedPreferences);

                  sharedPreferences.setBool('loggedIn', true);
                  sharedPreferences.setString('userId', user.userId!);

                  if (user.show_user_mode_screen == '1') {
                    Get.offAll(SelectModescreen());
                  } else if (user.showRegisterScreen == '1') {
                    Get.offAll(RegistrationScreen());
                  } else if (user.userMode == 'Customer') {
                    ref.read(modeProvider.notifier).state = Mode.Customer;
                    Get.offAll(UserMapInfo());
                  } else if (user.userMode == 'Driver') {
                    ref.read(modeProvider.notifier).state = Mode.Driver;
                    if (user.show_register_driver_screen == '1') {
                      Get.offAll(DriverRegistration());
                    } else {
                      Get.offAll(DriverHomeScreen());
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = ref
        .read(countryListProvider)
        .response!
        .map((e) => e.dialCode!)
        .toList();
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    final countries = ref.watch(countryListProvider).response;

    return FocusScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (p0, p1) => Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: p1.maxHeight / 4,
                  ),
                  const Text(
                    'Join us via phone number',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    child: Row(
                      //             {
                      //     "name": "Guinea",
                      //     "flag": "🇬🇳",
                      //     "code": "GN",
                      //     "dial_code": "+224",
                      //     "id": "+224",
                      //     "img": "+224"
                      // },
                      children: [
                        CountryCodePicker(
                          //initialSelection: 'India',
                          onChanged: (value) {
                            ref
                                .read(userModelProvider.notifier)
                                .updateCountryCode(value.dialCode!);
                          },
                          countryList: countries!
                              .map((e) => {
                                    'name': e.name!,
                                    'flag': e.flag!,
                                    'code': e.code!,
                                    'dial_code': e.dialCode!,
                                    'id': e.id!
                                  })
                              .toList(),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: mobileClr,
                            focusNode: _focusNode,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter your phone number'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter phone number';
                              }

                              // You can add additional password validation logic here

                              else {
                                mobileClr.text = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: p1.maxWidth * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: roundedRectangleBorder,
                          backgroundColor: primary),
                      onPressed: _submitForm,
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
