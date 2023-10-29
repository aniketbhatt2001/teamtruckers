import 'dart:developer';

import 'package:book_rides/Models/vehicleInfo.dart';
import 'package:book_rides/Screens/VehicleSubtype.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Screens/OutStation.dart';
import '../Screens/VehicleType.dart';
import '../Utils/Constatnts.dart';

class SelectedRideType extends ConsumerWidget {
  final int index;
  final VehicleInfo vehicleInfo;
  const SelectedRideType({
    required this.index,
    required this.vehicleInfo,
    // required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(vehicleDetailProvider);

    return LayoutBuilder(
      builder: (p0, p1) => GestureDetector(
        onTap: () {
          // if (vehicleInfo.title == 'OutStation') {
          //   Get.to(OutStation());
          // }

          showModalBottomSheet(
            context: context,
            builder: (context) {
              return VehicleSubType(
                slug: vehicleInfo.info,
                index: index,
              );
            },
          );
        },
        child: Container(
          width: 80,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              border: ref.read(indexProvider) != null &&
                      ref.read(indexProvider) == index
                  ? Border.all(color: Colors.blue, width: 2)
                  : Border.all(color: Colors.black),
              color: vehicleInfo.bgCololor.isNotEmpty
                  ? HexColor(vehicleInfo.bgCololor)
                  : null,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.network(
                  vehicleInfo.icon,
                  height: 40,
                  fit: BoxFit.fill,
                  width: 40,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              ref.read(indexProvider) != null &&
                      ref.read(indexProvider) == index
                  ? vehicle != null
                      ? Column(
                          children: [
                            Text(
                              vehicle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              vehicleInfo.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          ],
                        )
                      : Text(
                          vehicleInfo.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                  : Text(
                      vehicleInfo.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
