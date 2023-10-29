// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:book_rides/Screens/VehicleType.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/BaiscProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/UserModelProvider.dart';
import 'VehicleInfo.dart';

final indexProvider = StateProvider<int?>((ref) => null);

class VehicleSubType extends ConsumerWidget {
  final int index;
  String slug;
  VehicleSubType({super.key, required this.slug, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(vehcileSubTypeProvider(slug));
    return value.when(
        data: (data) => ListView.builder(
              // shrinkWrap: true,
              itemBuilder: (context, ind) {
                log(data.response![0].subcategory!.length.toString());
                return GestureDetector(
                  onTap: () async {
                    // ref
                    //     .read(userModelProvider.notifier)
                    //     .updateCategoryId(data.response![0]
                    //         .subcategory![ind].categoryId!);

                    // bool? result =
                    //     await uploadDriverBasicDetails(
                    //         ref
                    //             .read(userModelProvider)
                    //             .userId!,
                    //         ref
                    //             .read(userModelProvider)
                    //             .toJson());
                    // if (result != null) {
                    //   // ref
                    //   //         .read(vehicleDetailProvider
                    //   //             .notifier)
                    //   //         .state =
                    //   //     '${data.response![0].catName!} - ${data.response![0].subcategory![index].catName!}';
                    //   ref
                    //       .read(userModelProvider.notifier)
                    //       .updateCategoryName(data
                    //           .response![0]
                    //           .subcategory![ind]
                    //           .catName!);
                    //   Get.back(closeOverlays: true);
                    // }
                    ref.read(vehicleDetailProvider.notifier).state =
                        data.response![0].subcategory![ind].catName!;
                    ref.read(indexProvider.notifier).state = index;
                    ref.read(categoryIdProvider.notifier).state =
                        data.response![0].subcategory![ind].categoryId!;
                    pop();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: Row(
                      children: [
                        Image.network(
                          data.response![0].subcategory![ind].image!,
                          height: 60,
                          width: 60,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          data.response![0].subcategory![ind].catName!,
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: data!.response![0].subcategory!.length,
            ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => Center(child: const RefreshProgressIndicator()));
  }
}
