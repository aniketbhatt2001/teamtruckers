// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Services/cameraServices.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../Utils/Constatnts.dart';

class VehiclePhotoScreen extends ConsumerWidget {
  VehiclePhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Photo of your vehicle'),
        backgroundColor: primary,
      ),
      body: LayoutBuilder(
        builder: (p0, p1) => ListView(
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
                    Consumer(
                      builder: (context, ref, child) {
                        final url = ref.watch(vehicleImgUrlProvider);
                        return url != null
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.network(
                                  ref.read(vehicleImgUrlProvider)!,
                                  height: 300,
                                  width: p1.maxWidth,
                                  fit: BoxFit.fill,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null)
                                      return child; // Image fully loaded, show it
                                    return SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: primary,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress!
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                                    .toInt()
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : ref
                                    .read(userModelProvider)
                                    .vehiclePhoto!
                                    .isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.network(
                                      ref.read(userModelProvider).vehiclePhoto!,
                                      height: 300,
                                      width: p1.maxWidth,
                                      fit: BoxFit.fill,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child; // Image fully loaded, show it
                                        return Container(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: primary,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress!
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                        .toInt()
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Image.asset(
                                    'assets/delivery-truck.png',
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.fitWidth,
                                  );
                      },
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showimgOption(context).then((value) {
                          if (value == 'camera') {
                            openCamera().then((value) async {
                              if (value != null) {
                                showLoadUp();
                                var data =
                                    await getImagePath('vehicle', value, ref);
                                // ignore: use_build_context_synchronously
                                pop();
                                if (data != null) {
                                  ref
                                      .read(userModelProvider.notifier)
                                      .updateVehiclePhoto(
                                          data['response'][0]['path']);
                                  final result = await uploadDriverBasicDetails(
                                      ref.read(userModelProvider).userId!,
                                      ref.read(userModelProvider).toJson());
                                  if (result != null) {
                                    getUserDetail(
                                            ref.read(userModelProvider).userId!,
                                            ref)
                                        .then((value) {
                                      if (value != null) {
                                        ref
                                            .read(userModelProvider.notifier)
                                            .updatePercentage(
                                                value.driver_form_percentage!);
                                        Get.back();
                                      }
                                    });
                                  }
                                  ;
                                  // ignore: use_build_context_synchronously
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showFailureBar('Unable to upload image');
                                }
                              }
                            });
                          }
                          if (value == 'image') {
                            openGallery().then((value) async {
                              if (value != null) {
                                showLoadUp();
                                var data =
                                    await getImagePath('vehicle', value, ref);
                                // ignore: use_build_context_synchronously
                                pop();
                                if (data != null) {
                                  ref
                                      .read(userModelProvider.notifier)
                                      .updateVehiclePhoto(
                                          data['response'][0]['path']);
                                  final result = await uploadDriverBasicDetails(
                                      ref.read(userModelProvider).userId!,
                                      ref.read(userModelProvider).toJson());
                                  if (result != null) {
                                    getUserDetail(
                                            ref.read(userModelProvider).userId!,
                                            ref)
                                        .then((value) {
                                      if (value != null) {
                                        ref
                                            .read(userModelProvider.notifier)
                                            .updatePercentage(
                                                value.driver_form_percentage!);
                                        Get.back();
                                      }
                                    });
                                  }

                                  // ignore: use_build_context_synchronously
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showFailureBar('Unable to upload image');
                                }
                              }
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(color: primary, width: 2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          'Add a Photo',
                          style: TextStyle(
                              color: primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
