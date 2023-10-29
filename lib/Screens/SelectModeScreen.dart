import 'dart:developer';

import 'package:book_rides/Screens/Register.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/BaiscProviders.dart';

class SelectModescreen extends ConsumerWidget {
  const SelectModescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: p1.maxWidth,
          child: Column(
            children: [
              SizedBox(
                height: p1.maxHeight / 2.5,
              ),
              Text(
                'Are you a Customer ?',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'You can change the mode later',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(
                height: p1.maxHeight * 0.38,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: roundedRectangleBorder,
                        backgroundColor: Colors.green),
                    onPressed: () async {
                      final res = await changeUserMode(
                          ref.read(userModelProvider).userId!, 'Customer');
                      if (res != null) {
                        ref.read(modeProvider.notifier).state = Mode.Customer;
                        final res = await getUserDetail(
                            ref.read(userModelProvider).userId!, ref);

                        if (res != null && res.show_user_mode_screen == "0") {
                          if (res.showRegisterScreen == '1') {
                            Get.offAll(RegistrationScreen());
                          }
                        }
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(14),
                        width: p1.maxWidth,
                        child: const Center(child: Text('Customer')))),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: roundedRectangleBorder),
                    onPressed: () async {
                      final res = await changeUserMode(
                          ref.read(userModelProvider).userId!, 'Driver');
                      if (res != null) {
                        ref.read(modeProvider.notifier).state = Mode.Driver;
                        final res = await getUserDetail(
                            ref.read(userModelProvider).userId!, ref);

                        if (res != null && res.show_user_mode_screen == "0") {
                          if (res.showRegisterScreen == '1') {
                            Get.offAll(RegistrationScreen());
                          }
                        }
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(14),
                        width: p1.maxWidth,
                        child: const Center(child: Text('Transporter')))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
