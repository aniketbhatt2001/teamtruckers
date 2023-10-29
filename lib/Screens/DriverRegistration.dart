// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:book_rides/Screens/BasicInfoScreen.dart';
import 'package:book_rides/Screens/DriverHomeScreen.dart';
import 'package:book_rides/Screens/DriverLicenseScreen.dart';
import 'package:book_rides/Screens/VehicleInfo.dart';
import 'package:book_rides/Screens/IdentificationFileScreen.dart';
import 'package:book_rides/Screens/VehicleInsurance.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/UserModelProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class DriverRegistration extends StatefulWidget {
  const DriverRegistration({super.key});

  @override
  State<DriverRegistration> createState() => _DriverRegistrationState();
}

class _DriverRegistrationState extends State<DriverRegistration> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Get.back(closeOverlays: true);
        } else {
          Get.offAll(DriverHomeScreen());
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: primary,
          automaticallyImplyLeading: true,
          actions: [
            TextButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Get.back(closeOverlays: true);
                  } else {
                    Get.offAll(DriverHomeScreen());
                  }
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
          ],
          centerTitle: true,
          elevation: 0,
          title: const Text('Registration'),
        ),
        body: Column(
          children: [
            Card(
              elevation: 2,
              shape: roundedRectangleBorder,
              margin: EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Get.to(BasicInfoScreen());
                      },
                      leading: const Text(
                        "Basic info",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                      trailing: Consumer(
                        builder: (context, ref, child) {
                          final val = ref.watch(isBasicDetailVerified);
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              val
                                  ? Icon(
                                      Icons.verified_rounded,
                                      color: primary,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: primary,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        Get.to(VehicleInfoScreen());
                      },
                      leading: const Text(
                        "Vehicle info",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                      trailing: Consumer(
                        builder: (context, ref, child) {
                          final numberPlate =
                              ref.watch(userModelProvider).numberPlate;
                          final vehiclePhoto =
                              ref.watch(userModelProvider).vehiclePhoto;
                          final registrationCertificateBack = ref
                              .watch(userModelProvider)
                              .registrationCertificateBack;
                          final registrationCertificateFront = ref
                              .watch(userModelProvider)
                              .registrationCertificateFront;
                          final permit = ref.watch(userModelProvider).pemrit;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              numberPlate!.isNotEmpty &&
                                      vehiclePhoto!.isNotEmpty &&
                                      registrationCertificateFront!
                                          .isNotEmpty &&
                                      registrationCertificateFront.isNotEmpty &&
                                      permit!.isNotEmpty
                                  ? Icon(
                                      Icons.verified_rounded,
                                      color: primary,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: primary,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        Get.to(DriverLicenseScreen());
                      },
                      leading: const Text(
                        "Driving license",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                      trailing: Consumer(
                        builder: (context, ref, child) {
                          final drivingLicenseNumber =
                              ref.watch(userModelProvider).drivingLicenseNumber;
                          final drivingLicenseBack =
                              ref.watch(userModelProvider).drivingLicenseBack;
                          final drivingLicenseFront =
                              ref.watch(userModelProvider).drivingLicenseFront;
                          final id =
                              ref.watch(userModelProvider).idConfirmation;

                          final permit = ref.watch(userModelProvider).pemrit;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              drivingLicenseNumber!.isNotEmpty &&
                                      drivingLicenseBack!.isNotEmpty &&
                                      drivingLicenseFront!.isNotEmpty &&
                                      id!.isNotEmpty
                                  ? Icon(
                                      Icons.verified_rounded,
                                      color: primary,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: primary,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        Get.to(IdentificationFileScreen());
                      },
                      title: const Text(
                        "Identification File",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      trailing: Consumer(
                        builder: (context, ref, child) {
                          final id1 =
                              ref.watch(userModelProvider).identificationFile;
                          final id2 =
                              ref.watch(userModelProvider).identificationFile1;

                          final permit = ref.watch(userModelProvider).pemrit;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              id1!.isNotEmpty && id2!.isNotEmpty
                                  ? Icon(
                                      Icons.verified_rounded,
                                      color: primary,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: primary,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(VehicleInsurance());
                      },
                      title: const Text(
                        "Vehicle insurance",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      subtitle: Text(
                        'Optonal',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                      ),
                      trailing: Consumer(
                        builder: (context, ref, child) {
                          final insurance =
                              ref.watch(userModelProvider).vehicleInsrance;

                          final permit = ref.watch(userModelProvider).pemrit;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              insurance!.isNotEmpty
                                  ? Icon(
                                      Icons.verified_rounded,
                                      color: primary,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: primary,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              color: Colors.white,
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            //   width: double.infinity,
            //   height: 40,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     child: Text('Done'),
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.grey.shade400,
            //         shape: roundedRectangleBorder),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
