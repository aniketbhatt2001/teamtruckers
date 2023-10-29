import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../Services/apis_services.dart';
import '../Services/cameraServices.dart';
import '../Utils/Constatnts.dart';
import '../providers/UserModelProvider.dart';

class IdentificationFileScreen extends ConsumerWidget {
  const IdentificationFileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          title: const Text(
            'Identification File',
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
                margin: const EdgeInsets.all(12),
                child: Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Identification file 1 ",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final file = ref.watch(identificationFile1);
                          return file != null
                              ? Image.network(
                                  file,
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
                                      .identificationFile!
                                      .isNotEmpty
                                  ? Image.network(
                                      ref
                                          .read(userModelProvider)
                                          .identificationFile!,
                                      height: p1.maxHeight / 4,
                                      width: p1.maxWidth,
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
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                        .toInt()
                                                : null,
                                          ),
                                        );
                                      },
                                      fit: BoxFit.cover,
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
                                  var data = await getIdentificatinFile1(
                                      'IdentificatinFile1', value, ref);
                                  // ignore: use_build_context_synchronously
                                  pop();
                                  if (data != null) {
                                    ref
                                        .read(userModelProvider.notifier)
                                        .updateIdentificationFile1(
                                            data['response'][0]['path']);

                                    await uploadDriverBasicDetails(
                                            ref.read(userModelProvider).userId!,
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
                                  var data = await getIdentificatinFile1(
                                      'IdentificatinFile1', value, ref);
                                  // ignore: use_build_context_synchronously
                                  pop();
                                  if (data != null) {
                                    ref
                                        .read(userModelProvider.notifier)
                                        .updateIdentificationFile1(
                                            data['response'][0]['path']);

                                    await uploadDriverBasicDetails(
                                            ref.read(userModelProvider).userId!,
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
                          "Identification file 2",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final img = ref.watch(identificationFile2);
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
                                      .identificationFile1!
                                      .isNotEmpty
                                  ? Image.network(
                                      ref
                                          .read(userModelProvider)
                                          .identificationFile1!,
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
                                  var data = await getIddentificatinFile2(
                                      'IdentificationFile2', value, ref);
                                  // ignore: use_build_context_synchronously
                                  pop();
                                  if (data != null) {
                                    ref
                                        .read(userModelProvider.notifier)
                                        .updateIdentificationFile2(
                                            data['response'][0]['path']);

                                    await uploadDriverBasicDetails(
                                            ref.read(userModelProvider).userId!,
                                            ref
                                                .read(userModelProvider)
                                                .toJson())
                                        .then((value) {
                                      if (value != null) {
                                        pop();
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
                                  var data = await getIddentificatinFile2(
                                      'IdentificationFile2', value, ref);
                                  // ignore: use_build_context_synchronously
                                  pop();
                                  if (data != null) {
                                    ref
                                        .read(userModelProvider.notifier)
                                        .updateIdentificationFile2(
                                            data['response'][0]['path']);

                                    await uploadDriverBasicDetails(
                                            ref.read(userModelProvider).userId!,
                                            ref
                                                .read(userModelProvider)
                                                .toJson())
                                        .then((value) {
                                      if (value != null) {
                                        pop();
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
