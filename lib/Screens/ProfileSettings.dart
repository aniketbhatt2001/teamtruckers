// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:developer';

import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Services/cameraServices.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class ProfileSettings extends ConsumerWidget {
  TextEditingController nameClr = TextEditingController();
  TextEditingController lastNameClr = TextEditingController();
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  ProfileSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    nameClr = TextEditingController(text: ref.read(userModelProvider).fname);
    lastNameClr =
        TextEditingController(text: ref.read(userModelProvider).lname);
    email = TextEditingController(text: ref.read(userModelProvider).email);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primary,
        title: const Text(
          "Profile Edit",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (p0, p1) => SizedBox(
          width: double.infinity,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          showimgOption(context).then((value) {
                            if (value == 'camera') {
                              openCamera().then((value) async {
                                if (value != null) {
                                  showLoadUp();
                                  var data = await getProfileUrl(
                                      'profile', value, ref);
                                  // ignore: use_build_context_synchronously
                                  pop();
                                  if (data != null) {
                                    ref
                                        .read(userModelProvider.notifier)
                                        .updateProfile(
                                            data['response'][0]['path']);
                                    final result = await updateUserDetail(ref);
                                    if (result != null) {}

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
                                  var data = await getProfileUrl(
                                      'profile', value, ref);
                                  // ignore: use_build_context_synchronously
                                  pop();
                                  if (data != null) {
                                    ref
                                        .read(userModelProvider.notifier)
                                        .updateProfile(
                                            data['response'][0]['path']);
                                    final result = await updateUserDetail(ref);
                                    if (result != null) {}

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
                        child: Consumer(
                          builder: (context, ref, child) {
                            final pic = ref.watch(profileProvider);
                            return CircleAvatar(
                              child: pic == null
                                  ? null
                                  : ref
                                          .read(userModelProvider)
                                          .profilePic!
                                          .isNotEmpty
                                      ? null
                                      : Icon(
                                          Icons.person,
                                          size: 40,
                                        ),
                              radius: 50,
                              backgroundImage: pic != null
                                  ? NetworkImage(pic)
                                  : ref
                                          .read(userModelProvider)
                                          .profilePic!
                                          .isNotEmpty
                                      ? NetworkImage(ref
                                          .read(userModelProvider)
                                          .profilePic!)
                                      : null,
                            );
                          },
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        ref.watch(
                            userModelProvider.select((value) => value.fname));

                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: TextFormField(
                            controller: nameClr,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Enter First name';
                              } else {
                                ref
                                    .read(userModelProvider.notifier)
                                    .updateName(value);
                                // log(ref
                                //     .read(userModelProvider)
                                //     .fname
                                //     .toString());

                                // updateUserDetail(ref);
                              }
                            },
                            decoration:
                                const InputDecoration(hintText: 'First name'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Consumer(
                        builder: (context, ref, child) {
                          ref.watch(
                              userModelProvider.select((value) => value.lname));
                          return TextFormField(
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Enter Last name';
                              } else {
                                ref
                                    .read(userModelProvider.notifier)
                                    .updateLastName(value);
                                log(ref
                                    .read(userModelProvider)
                                    .fname
                                    .toString());
                              }
                            },
                            controller: lastNameClr,
                            decoration:
                                const InputDecoration(hintText: 'Last name'),
                          );
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Consumer(
                        builder: (context, ref, child) {
                          ref.watch(
                              userModelProvider.select((value) => value.email));
                          return TextFormField(
                            validator: (value) {
                              ref
                                  .read(userModelProvider.notifier)
                                  .updateEmail(value!);
                              log(ref.read(userModelProvider).email.toString());
                            },
                            controller: email,
                            decoration:
                                const InputDecoration(hintText: 'Your email'),
                          );
                        },
                      ),
                    ),
                  ],
                )
                // ListTile(
                //   leading: Icon(Icons.email),
                //   title: TextFormField(
                //     decoration: InputDecoration(hintText: 'Your email'),
                //   ),
                // ),
                ,
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    width: p1.maxWidth / 1.1,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          updateUserDetail(ref);
                        }
                      },
                      child: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                          shape: roundedRectangleBorder,
                          backgroundColor: primary),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
