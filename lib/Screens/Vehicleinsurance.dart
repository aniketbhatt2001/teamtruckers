import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Services/apis_services.dart';
import '../Services/cameraServices.dart';
import '../Utils/Constatnts.dart';
import '../providers/UserModelProvider.dart';

class VehicleInsurance extends ConsumerWidget {
  const VehicleInsurance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          title: const Text(
            'Vehicle Insurance',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primary,
        ),
        body: Container(
          width: p1.maxHeight,
          margin: const EdgeInsets.all(12),
          child: Card(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Vehicle Insurance Photo",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final file = ref.watch(vehicleInsurance);
                    return file != null
                        ? Image.network(
                            file,
                            height: p1.maxHeight / 4,
                            width: p1.maxWidth,
                            fit: BoxFit.cover,
                          )
                        : ref
                                .read(userModelProvider)
                                .vehicleInsrance!
                                .isNotEmpty
                            ? Image.network(
                                ref.read(userModelProvider).vehicleInsrance!,
                                height: p1.maxHeight / 4,
                                width: p1.maxWidth,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/insurance.jpg',
                                height: p1.maxHeight / 3,
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
                            var data = await getVehicleInsurance(
                                'VehicleInsurance', value, ref);
                            // ignore: use_build_context_synchronously
                            pop();
                            if (data != null) {
                              ref
                                  .read(userModelProvider.notifier)
                                  .updateInsurance(data['response'][0]['path']);

                              await uploadDriverBasicDetails(
                                  ref.read(userModelProvider).userId!,
                                  ref.read(userModelProvider).toJson());

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
                            var data = await getVehicleInsurance(
                                'VehicleInsurance', value, ref);
                            // ignore: use_build_context_synchronously
                            pop();
                            if (data != null) {
                              ref
                                  .read(userModelProvider.notifier)
                                  .updateInsurance(data['response'][0]['path']);

                              await uploadDriverBasicDetails(
                                      ref.read(userModelProvider).userId!,
                                      ref.read(userModelProvider).toJson())
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
                const Text(
                  '''Do not upload photo of printout or
                      photocopy .
                      ''',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
