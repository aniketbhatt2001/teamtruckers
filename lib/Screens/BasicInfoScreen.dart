// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

final isBasicDetailVerified = StateProvider((ref) {
  final user = ref.watch(userModelProvider);
  return user.fname!.isNotEmpty &&
      user.lname!.isNotEmpty &&
      user.dob!.isNotEmpty;
});

class BasicInfoScreen extends ConsumerWidget {
  TextEditingController fnmae = TextEditingController();
  TextEditingController lnmae = TextEditingController();
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> globalKeyForm = GlobalKey();
  BasicInfoScreen({super.key});
  Future<void> selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // userModel!.dob =

      // notifyListeners();
      ref.read(userModelProvider.notifier).updateDob(
          DateFormat('yyyy MM dd').format(picked).replaceAll(" ", "-"));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    fnmae = TextEditingController(text: ref.read(userModelProvider).fname);
    lnmae = TextEditingController(text: ref.read(userModelProvider).lname);
    email = TextEditingController(text: ref.read(userModelProvider).email);
    return LayoutBuilder(
      builder: (p0, p1) {
        var boxDecoration = BoxDecoration(
            border: Border.all(width: 0.5, color: black),
            borderRadius: BorderRadius.circular(5));
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            backgroundColor: primary,
            elevation: 0,
            centerTitle: true,
            title: const Text('Baisc Info'),
          ),
          body: ListView(
            children: [
              Container(
                width: p1.maxWidth,
                height: p1.maxHeight * 0.45,
                margin: const EdgeInsets.all(10),
                child: Card(
                  color: Colors.white,
                  child: Form(
                    key: globalKeyForm,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Text('First Name'),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: boxDecoration,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: fnmae,
                              validator: (value) {
                                if (value!.trim().isNotEmpty) {
                                  ref
                                      .read(userModelProvider.notifier)
                                      .updateName(value);
                                } else {
                                  return 'Enter first name';
                                }
                              },
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.grey),
                                  // ),
                                  // border: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.grey),
                                  // ),
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          const Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Text('Last Name'),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: boxDecoration,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: lnmae,
                              validator: (value) {
                                if (value!.trim().isNotEmpty) {
                                  ref
                                      .read(userModelProvider.notifier)
                                      .updateLastName(value);
                                } else {
                                  return 'Enter last name';
                                }
                              },
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.grey),
                                  // ),
                                  // border: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.grey),
                                  // ),
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          const Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Text('Date of birth'),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 50,
                              decoration: boxDecoration,
                              child: ListTile(
                                onTap: () {
                                  selectDate(context, ref);
                                },
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                trailing: Icon(Icons.arrow_drop_down),
                                title: Consumer(
                                  builder: (context, ref, child) {
                                    ref.watch(userModelProvider
                                        .select((value) => value.dob));
                                    return Text(
                                        ref.read(userModelProvider).dob!);
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          const Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Text('Email'),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: boxDecoration,
                            child: TextFormField(
                              controller: email,
                              validator: (value) {
                                ref
                                    .read(userModelProvider.notifier)
                                    .updateEmail(value!);
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Enter email',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.grey),
                                  // ),
                                  // border: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.grey),
                                  // ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: roundedRectangleBorder,
                        backgroundColor: primary),
                    onPressed: () async {
                      if (globalKeyForm.currentState!.validate()) {
                        if (ref.read(userModelProvider).dob!.isNotEmpty) {
                          await updateUserDetail(ref);
                        } else {
                          showFailureBar('Enter date of birth');
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text('Save'),
                    )),
              )
            ],
          ),
        );
      },
    );
  }
}
