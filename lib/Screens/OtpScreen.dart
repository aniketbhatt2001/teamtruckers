// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/apis_services.dart';
import '../Utils/Constatnts.dart';
import '../providers/BaiscProviders.dart';
import '../providers/LocationProviders.dart';
import 'DriverHomeScreen.dart';
import 'DriverRegistration.dart';
import 'PassengerMapScreen.dart';
import 'Register.dart';
import 'SelectModeScreen.dart';

class OtpPage extends ConsumerStatefulWidget {
  String verificationId;
  String number;
  OtpPage({super.key, required this.verificationId, required this.number});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  bool resendOtpClicked = false;
  bool hasError = false;
  String currentText = "";

  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> mobileFormKey = GlobalKey<FormFieldState>();
  int _counter = 59;
  Timer? _timer;
  String resendOtp = "Resend Again";
  TextEditingController mobileClr = TextEditingController();

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          debugPrint("Countdown started");
          if (_counter > 0) {
            _counter--;
            debugPrint("$_counter");
          } else {
            _timer!.cancel();
            resendOtpClicked = !resendOtpClicked;
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileClr = TextEditingController(text: widget.number);
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          // backgroundColor: HexColor(primary),
          title: const Text('Verification Code'),
        ),
        // backgroundColor: primaryColor,
        body: SizedBox(
          child: Builder(builder: (scaffoldContxet) {
            return ListView(
              children: <Widget>[
                const SizedBox(height: 50),
                const Text(
                  'We have sent the verification code to the',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'registered mobile number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final number = ref.watch(
                            userModelProvider.select((value) => value.mobile));
                        return Text(
                          number!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400),
                        );
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                    height: 550,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Update Phone Number",
                                                // style: boldtext,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    pop();
                                                  },
                                                  icon: const Icon(
                                                      FontAwesomeIcons.xmark))
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          child: Text(
                                            "This new phone number has to be verified for that an otp will be sent to new phone number",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: TextFormField(
                                            controller: mobileClr,
                                            key: mobileFormKey,
                                            onChanged: (value) {},
                                            validator: (value) {
                                              String val = value!.trim();
                                              if (val!.isEmpty) {
                                                return 'Enter Mobile number';
                                              } else {
                                                return null;
                                              }
                                            },
                                            //controller: editcontroller,
                                            keyboardType: TextInputType.name,
                                            style:
                                                const TextStyle(fontSize: 14.0),

                                            decoration: InputDecoration(
                                              hintText: 'Mobile no.',
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                if (mobileFormKey.currentState!
                                                    .validate()) {
                                                  ref
                                                      .read(userModelProvider
                                                          .notifier)
                                                      .updateMobile(
                                                          mobileClr.text);
                                                  Get.back();
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(),
                                              child: const Text("Update")),
                                        )
                                      ],
                                    )),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 18,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formkey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,

                        // obscuringWidget: const FlutterLogo(
                        //   size: 24,
                        // ),
                        blinkWhenObscuring: true,
                        //animationType: AnimationType.fade,
                        validator: (v) {
                          if (v!.length < 6) {
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          inactiveFillColor: Colors.white,
                          inactiveColor: Colors.white,
                          activeColor: Colors.white,
                          selectedFillColor: Colors.white,
                          selectedColor: Colors.white,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,

                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          debugPrint("Completed");
                        },
                        // onTap: () {
                        //   print("Pressed");
                        // },
                        onChanged: (value) {
                          debugPrint(value);

                          currentText = value;
                        },
                        beforeTextPaste: (text) {
                          debugPrint("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    hasError == true
                        ? "Please fill up all the cells properly"
                        : "",
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 110),
                  decoration: BoxDecoration(
                    color: HexColor('#ED1C24'),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ButtonTheme(
                    child: TextButton(
                      onPressed: () async {
                        //ApiSerices.postResponse('$baseUrl/', body)
                        // conditions for validating
                        log('currentText $currentText');
                        log('id ${widget.verificationId}');
                        verifyOtp(widget.verificationId, currentText)
                            .then((value) async {
                          final res = await createUser(mobileClr.text, ref);

                          if (res != null) {
                            final user = await getUserDetail(
                                ref.read(userModelProvider).userId!, ref);

                            if (user != null) {
                              showLoadUp();
                              final res = await updateUserAppInfo(
                                  user.userId!, fcmToken!);
                              pop();
                              if (res) {
                                if (user.isMobileVerified == '0') {
                                  final res = await verifyUser(user, ref);

                                  if (res != null) {
                                    final user = await getUserDetail(
                                        ref.read(userModelProvider).userId!,
                                        ref);
                                    if (user != null) {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();

                                      sharedPreferences.setBool(
                                          'loggedIn', true);
                                      sharedPreferences.setString(
                                          'userId', user.userId!);

                                      // if (user.show_user_mode_screen == '1') {
                                      //   Get.offAll(SelectModescreen());
                                      // } else {
                                      //   if (user.showRegisterScreen == '1') {
                                      //     Get.offAll(RegistrationScreen());
                                      //   } else {
                                      //     Get.offAll(UserMapInfo());
                                      //   }
                                      // }

                                      if (user.show_user_mode_screen == '1') {
                                        Get.offAll(SelectModescreen());
                                      } else if (user.showRegisterScreen ==
                                          '1') {
                                        Get.offAll(RegistrationScreen());
                                      } else if (user.userMode == 'Customer') {
                                        ref.read(modeProvider.notifier).state =
                                            Mode.Customer;
                                        Get.offAll(UserMapInfo());
                                      } else if (user.userMode == 'Driver') {
                                        ref.read(modeProvider.notifier).state =
                                            Mode.Driver;
                                        if (user.show_register_driver_screen ==
                                            '1') {
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
                        });
                      },
                      child: const Center(
                          child: Text(
                        "Verify",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                resendOtpClicked
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Didn't receive the OTP?"),
                            TextButton(
                                onPressed: () async {
                                  showLoadUp();

                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber:
                                        '+91 ${ref.read(userModelProvider).mobile}',
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) {
                                      log('verificationCompleted');

                                      log('token ${credential.token.toString()}');
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      Get.snackbar(e.toString(), '');
                                      log(e.toString());
                                    },
                                    codeSent: (String verificationId,
                                        int? resendToken) async {
                                      Get.snackbar('Otp Sent sucessfuly', '');
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {},
                                  );
                                  pop();
                                  resendOtpClicked = !resendOtpClicked;
                                  _counter = 60;
                                  _startTimer();
                                },
                                child: Text(
                                  resendOtp,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              " Resend Again ",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("00:${_counter.toString().padLeft(2, '0')}")
                          ],
                        ),
                      )
                // TextButton(
                //   onPressed: () {
                //     ApiSerices.postResponse('$baseUrl/otp/validate/1', {
                //       'device_type': 'MOB',
                //       'mobile': basicDetailProvider.userModel!.mobile,
                //       'user_id': basicDetailProvider.userModel!.userId,
                //     }).then((value) {
                //       print('inside response');
                //       value.fold((l) {
                //         print('error${l.message}');
                //         show_Icon_Flushbar(context, l.message, warning);
                //       }, (r) {
                //         print(r.body);
                //         Map userMap = r.body;
                //         List list = userMap['response'];
                //         basicDetailProvider.otp = list[0]['otp'];
                //         show_Icon_Flushbar(context, 'otp sent successfully',
                //             const Icon(Icons.thumb_up));
                //       });
                //     });
                //   },
                //   child: const Text(
                //     "Resend OTP",
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16,
                //         color: Colors.black54),
                //   ),
                // ),
                ,
                const SizedBox(
                  height: 14,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
