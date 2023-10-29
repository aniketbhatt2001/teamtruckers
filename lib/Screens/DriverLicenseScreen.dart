// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

import '../Services/cameraServices.dart';
import '../Utils/Constatnts.dart';

class DriverLicenseScreen extends ConsumerStatefulWidget {
  DriverLicenseScreen({super.key});

  @override
  ConsumerState<DriverLicenseScreen> createState() =>
      _DriverLicenseScreenState();
}

class _DriverLicenseScreenState extends ConsumerState<DriverLicenseScreen> {
  String formatteddate = '';

  TextEditingController drivingLicecnse = TextEditingController();

  TextEditingController dateOfExpiration = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    drivingLicecnse = TextEditingController(
        text: ref.read(userModelProvider).drivingLicenseNumber);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    //pop();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primary));
    return WillPopScope(
      onWillPop: () async {
        return T;
      },
      child: LayoutBuilder(
        builder: (p0, p1) => Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
            title: const Text(
              'Driving license',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: primary,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: p1.maxHeight,
                  margin:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Driving license number',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 0)),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final number = ref.watch(userModelProvider.select(
                                  (value) => value.drivingLicenseNumber));
                              // drivingLicecnse.text = number!;
                              return TextField(
                                onEditingComplete: () {},
                                onChanged: (value) {
                                  ref
                                      .read(userModelProvider.notifier)
                                      .updateDrivingLicense(
                                          drivingLicecnse.text);
                                },
                                onSubmitted: (value) {
                                  //  print(value);
                                  // drivingLicecnse =
                                  //     TextEditingController(text: value);
                                  // ref
                                  //     .read(userModelProvider.notifier)
                                  //     .updateDrivingLicense(value);
                                },
                                keyboardType: TextInputType.number,
                                controller: drivingLicecnse,
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Date of expiration',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 0)),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final number = ref.watch(userModelProvider
                                  .select((value) => value.dateOfExpiration));
                              dateOfExpiration =
                                  TextEditingController(text: number);
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onSubmitted: (value) {},
                                      controller: dateOfExpiration,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now().subtract(
                                              Duration(days: 365 * 200)),
                                          lastDate: DateTime.now()
                                              .add(Duration(days: 365 * 200)),
                                        ).then((value) {
                                          if (value != null) {
                                            DateTime dateTime =
                                                value; // Replace with your DateTime object

                                            formatteddate =
                                                DateFormat('dd MMMM yyyy')
                                                    .format(dateTime);
                                            ref
                                                .read(
                                                    userModelProvider.notifier)
                                                .updateExpirationDate(
                                                    formatteddate);
                                            // Output: 05 June 2023
                                          }
                                        });
                                      },
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down)
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          width: p1.maxWidth,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              // ref
                              //     .read(userModelProvider.notifier)
                              //     .updateExpirationDate(formatteddate);
                              uploadDriverBasicDetails(
                                      ref.read(userModelProvider).userId!,
                                      ref.read(userModelProvider).toJson())
                                  .then((value) {
                                if (value != null) {
                                  getUserDetail(
                                          ref.read(userModelProvider).userId!,
                                          ref)
                                      .then((value) {
                                    if (value != null) {
                                      pop();
                                      ref
                                          .read(userModelProvider.notifier)
                                          .updatePercentage(
                                              value.driver_form_percentage!);
                                    }
                                  });
                                }
                              });
                              // showLoadUp();
                              // final result = await ApiServices.postResponse(
                              //     '$baseUrl/user/update_user_driver_detail',
                              //     ref.read(userModelProvider).toJson());
                              // pop();
                              // result.fold((l) {
                              //   showSnackBar(l.message);
                              // }, (r) {
                              //   showSnackBar(r.body['message'] ?? 'invalid key');
                              // });
                            },
                            style: ElevatedButton.styleFrom(
                                shape: roundedRectangleBorder,
                                backgroundColor: primary),
                            child: Text('Submit'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: p1.maxHeight,
                  margin: const EdgeInsets.all(12),
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Driver license front",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final drivingLicenseFront =
                                ref.watch(licenseFrontProvider);
                            return drivingLicenseFront != null
                                ? Image.network(
                                    drivingLicenseFront,
                                    height: p1.maxHeight / 4,
                                    width: p1.maxWidth,
                                    fit: BoxFit.cover,
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
                                  )
                                : ref
                                        .read(userModelProvider)
                                        .drivingLicenseFront!
                                        .isNotEmpty
                                    ? Image.network(
                                        ref
                                            .read(userModelProvider)
                                            .drivingLicenseFront!,
                                        height: p1.maxHeight / 4,
                                        width: p1.maxWidth,
                                        fit: BoxFit.cover,
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
                                      )
                                    : Image.asset(
                                        'assets/license.png',
                                        height: p1.maxHeight / 4,
                                        width: p1.maxWidth,
                                        fit: BoxFit.cover,
                                      );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showimgOption(context).then((value) {
                              if (value == 'camera') {
                                openCamera().then((value) async {
                                  if (value != null) {
                                    showLoadUp();
                                    var data = await getLicenseFrontImgUrl(
                                        'licenseFront', value, ref);
                                    // ignore: use_build_context_synchronously
                                    pop();
                                    if (data != null) {
                                      ref
                                          .read(userModelProvider.notifier)
                                          .updateDrivingLicenseFront(
                                              data['response'][0]['path']);

                                      await uploadDriverBasicDetails(
                                              ref
                                                  .read(userModelProvider)
                                                  .userId!,
                                              ref
                                                  .read(userModelProvider)
                                                  .toJson())
                                          .then((value) {
                                        if (value != null) {
                                          updatePercentage(ref);
                                        }
                                      });

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
                                    var data = await getLicenseFrontImgUrl(
                                        'licenseFront', value, ref);
                                    // ignore: use_build_context_synchronously
                                    pop();
                                    if (data != null) {
                                      ref
                                          .read(userModelProvider.notifier)
                                          .updateDrivingLicenseFront(
                                              data['response'][0]['path']);

                                      await uploadDriverBasicDetails(
                                              ref
                                                  .read(userModelProvider)
                                                  .userId!,
                                              ref
                                                  .read(userModelProvider)
                                                  .toJson())
                                          .then((value) {
                                        if (value != null) {
                                          updatePercentage(ref);
                                        }
                                      });

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
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "Upload front photo of driving license \nDriving license should be clear ",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: p1.maxHeight,
                  margin: const EdgeInsets.all(12),
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Driver license back",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final img = ref.watch(licenseBackProvider);
                            return img != null
                                ? Image.network(img,
                                    height: p1.maxHeight / 4,
                                    width: p1.maxWidth,
                                    fit: BoxFit.cover, loadingBuilder:
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
                                  })
                                : ref
                                        .read(userModelProvider)
                                        .drivingLicenseBack!
                                        .isNotEmpty
                                    ? Image.network(
                                        ref
                                            .read(userModelProvider)
                                            .drivingLicenseBack!,
                                        height: p1.maxHeight / 4,
                                        width: p1.maxWidth,
                                        fit: BoxFit.cover,
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
                                      )
                                    : Image.asset(
                                        'assets/license.png',
                                        height: p1.maxHeight / 4,
                                        width: p1.maxWidth,
                                        fit: BoxFit.cover,
                                      );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showimgOption(context).then((value) {
                              if (value == 'camera') {
                                openCamera().then((value) async {
                                  if (value != null) {
                                    showLoadUp();
                                    var data = await getLicenseBackImgUrl(
                                        'licenseBack', value, ref);
                                    // ignore: use_build_context_synchronously
                                    pop();
                                    if (data != null) {
                                      ref
                                          .read(userModelProvider.notifier)
                                          .updateDrivingLicenseBack(
                                              data['response'][0]['path']);

                                      await uploadDriverBasicDetails(
                                              ref
                                                  .read(userModelProvider)
                                                  .userId!,
                                              ref
                                                  .read(userModelProvider)
                                                  .toJson())
                                          .then((value) {
                                        if (value != null) {
                                          updatePercentage(ref);
                                        }
                                      });
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
                                    var data = await getLicenseBackImgUrl(
                                        'licenseBack', value, ref);
                                    // ignore: use_build_context_synchronously
                                    pop();
                                    if (data != null) {
                                      ref
                                          .read(userModelProvider.notifier)
                                          .updateDrivingLicenseBack(
                                              data['response'][0]['path']);

                                      await uploadDriverBasicDetails(
                                              ref
                                                  .read(userModelProvider)
                                                  .userId!,
                                              ref
                                                  .read(userModelProvider)
                                                  .toJson())
                                          .then((value) {
                                        if (value != null) {
                                          updatePercentage(ref);
                                        }
                                      });
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
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Upload back photo of driving license \nDriving license should be clear',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: p1.maxHeight,
                  margin: const EdgeInsets.all(12),
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "ID confirmation",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final img = ref.watch(idProvider);
                            return img != null
                                ? Image.network(
                                    img,
                                    height: p1.maxHeight / 4,
                                    width: p1.maxWidth,
                                    fit: BoxFit.cover,
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
                                  )
                                : ref
                                        .read(userModelProvider)
                                        .idConfirmation!
                                        .isNotEmpty
                                    ? Image.network(
                                        ref
                                            .read(userModelProvider)
                                            .idConfirmation!,
                                        height: p1.maxHeight / 4,
                                        width: p1.maxWidth,
                                        fit: BoxFit.cover,
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
                                      )
                                    : Image.asset(
                                        'assets/id.png',
                                        height: p1.maxHeight / 4,
                                        width: p1.maxWidth,
                                        fit: BoxFit.cover,
                                      );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showimgOption(context).then((value) {
                              if (value == 'camera') {
                                openCamera().then((value) async {
                                  if (value != null) {
                                    showLoadUp();
                                    var data = await getId('ID', value, ref);
                                    // ignore: use_build_context_synchronously
                                    pop();
                                    if (data != null) {
                                      ref
                                          .read(userModelProvider.notifier)
                                          .updateId(
                                              data['response'][0]['path']);

                                      await uploadDriverBasicDetails(
                                              ref
                                                  .read(userModelProvider)
                                                  .userId!,
                                              ref
                                                  .read(userModelProvider)
                                                  .toJson())
                                          .then((value) {
                                        if (value != null) {
                                          getUserDetail(
                                                  ref
                                                      .read(userModelProvider)
                                                      .userId!,
                                                  ref)
                                              .then((value) {
                                            if (value != null) {
                                              ref
                                                  .read(userModelProvider
                                                      .notifier)
                                                  .updatePercentage(value
                                                      .driver_form_percentage!);
                                              pop();
                                            }
                                          });
                                        }
                                      });
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
                                    var data = await getId('ID', value, ref);
                                    // ignore: use_build_context_synchronously
                                    pop();
                                    if (data != null) {
                                      ref
                                          .read(userModelProvider.notifier)
                                          .updateId(
                                              data['response'][0]['path']);

                                      await uploadDriverBasicDetails(
                                              ref
                                                  .read(userModelProvider)
                                                  .userId!,
                                              ref
                                                  .read(userModelProvider)
                                                  .toJson())
                                          .then((value) {
                                        if (value != null) {
                                          getUserDetail(
                                                  ref
                                                      .read(userModelProvider)
                                                      .userId!,
                                                  ref)
                                              .then((value) {
                                            if (value != null) {
                                              ref
                                                  .read(userModelProvider
                                                      .notifier)
                                                  .updatePercentage(value
                                                      .driver_form_percentage!);
                                              pop();
                                            }
                                          });
                                        }
                                      });
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
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: const Text(
                            'Upload driving license with your face and\n driving license clealry visible.\n photo should not have sunglasses,mask or hat',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
