// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:developer';
import 'package:book_rides/Models/CountryListModel.dart';
import 'package:book_rides/Screens/DirverRequestHistoryScreen.dart';
import 'package:book_rides/Screens/DriverHomeScreen.dart';
import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/Screens/DriverRegistration.dart';
import 'package:book_rides/Screens/ProfileSettings.dart';
import 'package:book_rides/Screens/RequestHistory.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Login.dart';
import '../Screens/SplashScreen.dart';
import '../Screens/web_view.dart';
import '../Services/cameraServices.dart';
import '../Utils/Constatnts.dart';
import '../providers/BaiscProviders.dart';

class DriverDrawer extends ConsumerWidget {
  String? adminApproved;
  DriverDrawer({super.key});
  TextEditingController _mobileClr = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.read(userModelProvider).adminApprovedDriver != null) {
      adminApproved = ref.read(userModelProvider).adminApprovedDriver!;
    }
    return LayoutBuilder(
      builder: (p0, p1) {
        return SafeArea(
          child: Drawer(
            child: Column(
              children: [
                SizedBox(
                  height: p1.maxHeight / 1.25,
                  child: ListView(
                    shrinkWrap: T,
                    children: [
                      Container(
                        color: primary,
                        child: Consumer(
                          builder: (context, ref, child) {
                            final name = ref.watch(userModelProvider
                                .select((value) => value.fname));

                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              onTap: () {
                                Get.to(ProfileSettings());
                              },
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: white,
                              ),
                              title: Text(
                                name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: white),
                              ),
                              subtitle: Text(
                                '${ref.read(userModelProvider).country_code!} ${ref.read(userModelProvider).mobile!}',
                                style: TextStyle(color: white),
                              ),
                              leading: Consumer(
                                builder: (BuildContext context, WidgetRef ref,
                                    Widget? child) {
                                  ref.watch(profileProvider);
                                  return CircleAvatar(
                                      backgroundImage:
                                          ref.read(profileProvider) != null
                                              ? NetworkImage(
                                                  ref.read(profileProvider)!)
                                              : ref
                                                      .read(userModelProvider)
                                                      .profilePic!
                                                      .isNotEmpty
                                                  ? NetworkImage(ref
                                                      .read(userModelProvider)
                                                      .profilePic!)
                                                  : null,
                                      child: ref.read(profileProvider) != null
                                          ? null
                                          : ref
                                                  .read(userModelProvider)
                                                  .profilePic!
                                                  .isNotEmpty
                                              ? null
                                              : Icon((Icons.person)));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(DriverRegistration());
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.person_2_rounded),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Driver Profile',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            if (adminApproved == '1') {
                              Get.to(DirverRequestHistoryScreen());
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.history,
                                  color: adminApproved == '1'
                                      ? Colors.black
                                      : fadedBlack),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Request History',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: adminApproved == '1'
                                        ? Colors.black
                                        : fadedBlack),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: ref
                              .read(userAppConfigProvider)
                              .response![0]
                              .sidebarMenu!
                              .map((e) => e.show == '1'
                                  ? GestureDetector(
                                      onTap: () {
                                        if (e.showOn == 'app_web_view') {
                                          Get.to(
                                            MyWebView(url: e.link!),
                                          );
                                        } else {}
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 10),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.globe),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              e.title!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox())
                              .toList(),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Get.dialog(AlertDialog(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text(
                              'Do you want to use a new phone number?',
                              style: TextStyle(fontSize: 18),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    pop();
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                TextButton(
                                    onPressed: () {
                                      // updatePhoneNumber(number, id)
                                      pop();
                                      showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    CountryCodePicker(
                                                      initialSelection: ref
                                                          .read(
                                                              userModelProvider)
                                                          .country_code,
                                                      onChanged: (value) {
                                                        ref
                                                            .read(
                                                                userModelProvider
                                                                    .notifier)
                                                            .updateCountryCode(
                                                                value
                                                                    .dialCode!);
                                                      },
                                                      countryList: ref
                                                          .read(
                                                              countryListProvider)
                                                          .response!
                                                          .map((e) => {
                                                                'name': e.name!,
                                                                'flag': e.flag!,
                                                                'code': e.code!,
                                                                'dial_code':
                                                                    e.dialCode!,
                                                                'id': e.id!
                                                              })
                                                          .toList(),
                                                    ),
                                                    Expanded(
                                                      child: TextField(
                                                        controller: _mobileClr,
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                'Mobile number'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 15),
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  primary,
                                                              shape:
                                                                  roundedRectangleBorder),
                                                      onPressed: () async {
                                                        pop();
                                                        if (_mobileClr
                                                            .text.isNotEmpty) {
                                                          final res = await updatePhoneNumber(
                                                              _mobileClr.text,
                                                              ref
                                                                  .read(
                                                                      userModelProvider)
                                                                  .userId!,
                                                              ref
                                                                  .read(
                                                                      userModelProvider)
                                                                  .country_code!);
                                                          if (res) {
                                                            ref
                                                                .read(userModelProvider
                                                                    .notifier)
                                                                .updateMobile(
                                                                    _mobileClr
                                                                        .text);
                                                          }
                                                        } else {
                                                          showFailureBar(
                                                              'Enter mobile number');
                                                        }
                                                      },
                                                      child:
                                                          const Text('Update')),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.phone,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Change Number',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: p1.maxHeight / 3,
                      // ),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            TextButton(
                                onPressed: () {
                                  Get.dialog(AlertDialog(
                                    titlePadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    contentPadding: EdgeInsets.all(0),
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Confirmation',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            'Are you sure you want to delete account?'),
                                      ],
                                    ),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              showLoadUp();
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.clear;
                                              deleteUser(ref
                                                      .read(userModelProvider)
                                                      .userId!)
                                                  .then((value) {
                                                if (value) {
                                                  Get.offAll(LoginForm());
                                                }
                                              });
                                            },
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(fontSize: 18),
                                            )),
                                        TextButton(
                                          onPressed: () => pop(),
                                          child: const Text(
                                            'No',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    'Delete Account',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Get.dialog(AlertDialog(
                            title: Text('Are you sure ?'),
                            titlePadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 16),
                            contentPadding: EdgeInsets.all(0),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () => pop(),
                                  child: const Text(
                                    'No',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      await ref
                                          .read(sharedPrefsProvider)
                                          .clearPref();
                                      Get.offAll(LoginForm());
                                      // await ref.read(sharedPrefsProvider)!.clear();
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 18),
                                    ))
                              ],
                            ),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 13),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.logout,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: p1.maxHeight / 3.2,
                // ),
                Divider(
                  color: black,
                  thickness: 0.1,
                ),
                Container(
                    margin: const EdgeInsets.all(8),
                    width: p1.maxWidth,
                    child:
                        //  adminApproved == '1'
                        //     ?
                        ElevatedButton(
                      onPressed: () async {
                        // final mode = ref.read(modeProvider);
                        final res = await changeUserMode(
                            ref.read(userModelProvider).userId!, 'Customer');
                        if (res != null) {
                          final user = await getUserDetail(
                              ref.read(userModelProvider).userId!, ref);
                          if (user != null) {
                            ref.read(modeProvider.notifier).state =
                                Mode.Customer;

                            Get.offAll(UserMapInfo());
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: roundedRectangleBorder),
                      child: Consumer(builder: (context, ref, child) {
                        final mode = ref.watch(modeProvider);

                        return Text(
                          'Customer',
                          style: TextStyle(),
                        );
                      }),
                    )
                    //: SizedBox(),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.facebook,
                      size: 28,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      FontAwesomeIcons.instagram,
                      size: 28,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
