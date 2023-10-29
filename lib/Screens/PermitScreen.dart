import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../Services/apis_services.dart';
import '../Services/cameraServices.dart';
import '../Utils/Constatnts.dart';

class PermitScreen extends ConsumerWidget {
  const PermitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Permit',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: primary,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                          "Permit ",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final result = ref.watch(permit1ImgUrlProvider);
                          return result != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    result,
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
                              : ref.read(userModelProvider).pemrit!.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        ref.read(userModelProvider).pemrit!,
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
                                  : const Icon(
                                      FontAwesomeIcons.idCard,
                                      size: 150,
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
                                  var data = await getPermit1ImagePath(
                                      'permit', value, ref);
                                  // ignore: use_build_context_synchronously
                                  pop();
                                  if (data != null) {
                                    ref
                                        .read(userModelProvider.notifier)
                                        .updatePermit(
                                            data['response'][0]['path']);

                                    await uploadDriverBasicDetails(
                                            ref.read(userModelProvider).userId!,
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
                                                .read(
                                                    userModelProvider.notifier)
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
                                  if (value != null) {
                                    showLoadUp();
                                    var data = await getPermit1ImagePath(
                                        'permit', value, ref);
                                    // ignore: use_build_context_synchronously
                                    pop();
                                    if (data != null) {
                                      ref
                                          .read(userModelProvider.notifier)
                                          .updatePermit(
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
                          "Permit ",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final result = ref.watch(permit2ImgUrlProvider);
                          return result != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    result,
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
                              : ref.read(userModelProvider).pemrit1!.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        ref.read(userModelProvider).pemrit1!,
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
                                  : const Icon(
                                      FontAwesomeIcons.idCard,
                                      size: 150,
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
                                  var data = await getPermit2ImagePath(
                                      'permit', value, ref);
                                  // ignore: use_build_context_synchronously
                                  pop();
                                  if (data != null) {
                                    ref
                                        .read(userModelProvider.notifier)
                                        .updatePermit2(
                                            data['response'][0]['path']);

                                    await uploadDriverBasicDetails(
                                            ref.read(userModelProvider).userId!,
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
                                                .read(
                                                    userModelProvider.notifier)
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
                                  var data = await getPermit2ImagePath(
                                      'permit', value, ref);
                                  // ignore: use_build_context_synchronously
                                  pop();
                                  if (data != null) {
                                    ref
                                        .read(userModelProvider.notifier)
                                        .updatePermit2(
                                            data['response'][0]['path']);

                                    await uploadDriverBasicDetails(
                                            ref.read(userModelProvider).userId!,
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
                                                .read(
                                                    userModelProvider.notifier)
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
