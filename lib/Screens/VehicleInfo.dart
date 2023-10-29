// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:book_rides/Screens/PermitScreen.dart';
import 'package:book_rides/Screens/RegistrationCertificateScreen.dart';
import 'package:book_rides/Screens/VehiclePhotoScreen.dart';
import 'package:book_rides/Screens/VehicleType.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../Utils/Constatnts.dart';

const textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
final numberPlateProvider = StateProvider<String?>((ref) => null);

class VehicleInfoScreen extends ConsumerWidget {
  TextEditingController numberPlate = TextEditingController();
  VehicleInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    numberPlate =
        TextEditingController(text: ref.read(userModelProvider).numberPlate);
    return LayoutBuilder(
      builder: (p0, p1) {
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: primary,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Vehicle Info',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: ListView(
            children: [
              Container(
                width: p1.maxWidth,
                //height: p1.maxHeight * 0.41,
                margin: const EdgeInsets.all(10),
                child: Card(
                  shape: roundedRectangleBorder.copyWith(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => Get.to(() => const VehicleType()),
                        title: Consumer(
                          builder: (context, ref, child) {
                            final vehicle = ref.watch(userModelProvider
                                .select((value) => value.categoryName));
                            return Text(
                              vehicle!.isEmpty ? "Vehicle type" : vehicle,
                              style: textStyle,
                            );
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ref.read(userModelProvider).categoryName!.isNotEmpty
                                ? Icon(
                                    Icons.verified_rounded,
                                    color: primary,
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primary,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: T,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        'Number Plate',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: TextField(
                                          controller: numberPlate,
                                          decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              border: InputBorder.none),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(width: 0)),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Container(
                                        width: p1.maxWidth,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: roundedRectangleBorder,
                                                backgroundColor: primary),
                                            onPressed: () async {
                                              // if (globalKeyForm.currentState!.validate()) {
                                              //   if (ref.read(userModelProvider).dob!.isNotEmpty) {
                                              //     await updateUserDetail(ref);
                                              //     Get.back(closeOverlays: true);
                                              //   } else {
                                              //     showSnackBar('Enter date of birth');
                                              //   }
                                              // }
                                              ref
                                                  .read(userModelProvider
                                                      .notifier)
                                                  .updateNumberPlate(
                                                      numberPlate.text);
                                              if (numberPlate.text.isNotEmpty) {
                                                uploadDriverBasicDetails(
                                                        ref
                                                            .read(
                                                                userModelProvider)
                                                            .userId!,
                                                        ref
                                                            .read(
                                                                userModelProvider)
                                                            .toJson())
                                                    .then((value) async {
                                                  if (value != null) {
                                                    await getUserDetail(
                                                            ref
                                                                .read(
                                                                    userModelProvider)
                                                                .userId!,
                                                            ref)
                                                        .then((value) {
                                                      if (value != null) {
                                                        ref
                                                            .read(
                                                                userModelProvider
                                                                    .notifier)
                                                            .updatePercentage(value
                                                                .driver_form_percentage!);
                                                        Get.back(
                                                            closeOverlays:
                                                                true);
                                                      }
                                                    });
                                                  }
                                                });

                                                // pop();
                                              } else {
                                                showFailureBar(
                                                    'Enter number plate');
                                              }
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12),
                                              child: Text('Done'),
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          title: const Text(
                            "Number plate",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          trailing: Consumer(
                            builder: (context, ref, child) {
                              ref.watch(userModelProvider).numberPlate;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ref
                                          .read(userModelProvider)
                                          .numberPlate!
                                          .isNotEmpty
                                      ? Icon(
                                          Icons.verified,
                                          color: primary,
                                        )
                                      : const SizedBox(),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: primary,
                                  )
                                ],
                              );
                            },
                          )),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        onTap: () => Get.to(() => VehiclePhotoScreen()),
                        title: const Text(
                          "Photo of your vehicle",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        trailing: Consumer(
                          builder: (context, ref, child) {
                            final photo = ref.watch(userModelProvider
                                .select((value) => value.vehiclePhoto));
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                photo!.isNotEmpty
                                    ? Icon(
                                        Icons.verified,
                                        color: primary,
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primary,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(const RcScreen());
                        },
                        title: const Text(
                          "Registration Certificate",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        trailing: Consumer(
                          builder: (context, ref, child) {
                            final front = ref.watch(userModelProvider.select(
                                (value) => value.registrationCertificateFront));
                            final back = ref.watch(userModelProvider.select(
                                (value) => value.registrationCertificateBack));
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                front!.isNotEmpty && back!.isNotEmpty
                                    ? Icon(
                                        Icons.verified,
                                        color: primary,
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primary,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(() => PermitScreen());
                        },
                        title: const Text(
                          "Permit",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        trailing: Consumer(
                          builder: (context, ref, child) {
                            final permit = ref.watch(userModelProvider
                                .select((value) => value.pemrit));
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                permit!.isNotEmpty
                                    ? Icon(
                                        Icons.verified,
                                        color: primary,
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: primary,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    ;
  }
}
