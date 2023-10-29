// ignore_for_file: prefer_const_constructors

import 'package:book_rides/Screens/DriverHomeScreen.dart';
import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../Services/apis_services.dart';
import '../providers/BaiscProviders.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _lastName;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform registration logic here
      // createUser(_mobile!, ref);
      //createUser(_mobile!, ref);
      final val = await updateUserDetail(ref);
      if (val != null) {
        final user =
            await getUserDetail(ref.read(userModelProvider).userId!, ref);

        if (user != null) {
          if (user.userMode == 'Driver') {
            ref.read(modeProvider.notifier).state = Mode.Driver;
            Get.offAll(DriverHomeScreen());
          } else {
            ref.read(modeProvider.notifier).state = Mode.Customer;
            Get.offAll(UserMapInfo());
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Welcome!",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Lets\'s get acquainted',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.grey),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter fisrt name';
                    } else {
                      ref.read(userModelProvider.notifier).updateName(value);
                    }
                  },
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last Name';
                    } else {
                      ref
                          .read(userModelProvider.notifier)
                          .updateLastName(value);
                    }
                    // You can add additional password validation logic here
                    return null;
                  },
                  onSaved: (value) {
                    _lastName = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    ref.read(userModelProvider.notifier).updateEmail(value!);

                    // You can add additional password validation logic here
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                // const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: roundedRectangleBorder,
                        backgroundColor: primary),
                    onPressed: _submitForm,
                    child: Container(
                        padding: const EdgeInsets.all(14),
                        width: p1.maxWidth,
                        child: const Center(child: Text('Next'))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
