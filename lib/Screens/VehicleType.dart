import 'dart:developer';

import 'package:book_rides/Models/MainCategoryModel.dart';
import 'package:book_rides/Models/SubCategoryScreen.dart';
import 'package:book_rides/Screens/VehicleInfo.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

final vehicleDetailProvider = StateProvider.autoDispose<String?>((ref) => null);
final vehcileTypeProvider = FutureProvider.autoDispose
    .family<MainCategoryModel?, String>((ref, userId) {
  return fetchMainCategories(userId);
});
final vehcileSubTypeProvider =
    FutureProvider.autoDispose.family<SubCategoryModel?, String>((
  ref,
  slug,
) {
  return fetchSubCategories(ref.read(userModelProvider).userId!, slug);
});

class VehicleType extends ConsumerWidget {
  const VehicleType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //pop();
    final value =
        ref.watch(vehcileTypeProvider(ref.read(userModelProvider).userId!));
    return Scaffold(
      // floatingActionButton:   Align(
      //   alignment: Alignment.bottomCenter,
      //   child: ElevatedButton(
      //     onPressed: () {},
      //     child: Text('Save'),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 1,
        centerTitle: T,
        title: const Text("Vehicle Type"),
      ),
      body: value.when(
        data: (data) => ListView.builder(
          itemBuilder: (context, index) {
            return Consumer(
              builder: (context, ref, child) {
                final value = ref.watch(vehcileSubTypeProvider(
                    data.mainCategories![index].catSlug!));
                return ExpansionTile(
                    maintainState: true,
                    initiallyExpanded: T,
                    title: Text(
                      data.mainCategories![index].catName!,
                      style: textStyle,
                    ),
                    // trailing: const Icon(
                    //   Icons.arrow_forward_ios,
                    //   color: Colors.green,
                    // ),
                    children: [
                      value.when(
                          data: (data) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, ind) {
                                int myindex = ind;
                                // log(data.response![0].subcategory!.length
                                //     .toString());
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                  child: Row(
                                    children: [
                                      VehicleTypeChexkBox(
                                        ind: ind,
                                        isChecked: ref
                                            .read(userModelProvider)
                                            .categoryId!
                                            .contains(data.response![0]
                                                .subcategory![ind].categoryId!),
                                        data: data,
                                      ),
                                      Text(
                                        data.response![0].subcategory![ind]
                                            .catName!,
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: data!.response![0].subcategory!.length,
                            );
                          },
                          error: (error, stackTrace) => Text(error.toString()),
                          loading: () => const RefreshProgressIndicator())
                    ]);
              },
            );
          },
          itemCount: data!.mainCategories!.length,
          // separatorBuilder: (BuildContext context, int index) {
          //   return const Divider(
          //     color: Colors.black,
          //   );
          // },
        ),
        error: (error, stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () => const Center(
          child: RefreshProgressIndicator(),
        ),
      ),
    );
  }
}

class VehicleTypeChexkBox extends ConsumerStatefulWidget {
  final SubCategoryModel data;

  final int ind;
  bool isChecked;
  VehicleTypeChexkBox({
    required this.ind,
    required this.isChecked,
    required this.data,
    super.key,
  });

  @override
  ConsumerState<VehicleTypeChexkBox> createState() =>
      _VehicleTypeChexkBoxState();
}

class _VehicleTypeChexkBoxState extends ConsumerState<VehicleTypeChexkBox> {
  @override
  Widget build(BuildContext context) {
    // print(ref.read(userModelProvider).categoryId!.contains(
    //     widget.data.response![0].subcategory![widget.ind].categoryId!));
    // print(
    //     'category id${widget.data.response![0].subcategory![widget.ind].categoryId!}');
    return Checkbox(
        value: widget.isChecked,
        onChanged: (value) async {
          setState(() {
            // print(ref.read(userModelProvider).categoryId!.contains(
            //     widget.data.response![0].subcategory![widget.ind].categoryId!));
            //print(widget.index);
            widget.isChecked = value!;
          });
          if (value == T) {
            ref.read(userModelProvider.notifier).updateCategoryId(
                widget.data.response![0].subcategory![widget.ind].categoryId!);

            bool? result = await uploadDriverBasicDetails(
                ref.read(userModelProvider).userId!,
                ref.read(userModelProvider).toJson());
            // pop();
            pop();
            if (result != null) {
              // ref
              //         .read(vehicleDetailProvider
              //             .notifier)
              //         .state =
              //     '${data.response![0].catName!} - ${data.response![0].subcategory![index].catName!}';
              ref.read(userModelProvider.notifier).updateCategoryName(
                  widget.data.response![0].subcategory![widget.ind].catName!);
              //   //Get.back(closeOverlays: true);
              // }
            }
          } else {
            List<String> myList =
                stringToList(ref.read(userModelProvider).categoryId!);
            myList.remove(
                widget.data.response![0].subcategory![widget.ind].categoryId!);
            // ref.read(userModelProvider).categoryId;
            if (myList.isNotEmpty) {
              ref
                  .read(userModelProvider.notifier)
                  .resetCategoryId(listToString(myList));
            }

            List<String> catNames =
                stringToList(ref.read(userModelProvider).categoryName!);
            catNames.remove(
                widget.data.response![0].subcategory![widget.ind].catName!);
            if (catNames.isNotEmpty) {
              ref
                  .read(userModelProvider.notifier)
                  .resetCategoryName(listToString(catNames));
            }
            if (myList.isNotEmpty) {
              bool? result = await uploadDriverBasicDetails(
                  ref.read(userModelProvider).userId!,
                  ref.read(userModelProvider).toJson());
              pop();
              // Future.delayed(Duration(seconds: 2), () {

              // });
              if (result != null) {
                // ref
                //         .read(vehicleDetailProvider
                //             .notifier)
                //         .state =
                //     '${data.response![0].catName!} - ${data.response![0].subcategory![index].catName!}';
                // ref.read(userModelProvider.notifier).updateCategoryName(
                //     widget.data.response![0].subcategory![widget.ind].catName!);
                //   //Get.back(closeOverlays: true);
                // }
              }
            }
          }
        });
  }
}
// TextButton(
//                                     onPressed: () async {
//                                       // print(ref
//                                       //     .read(userModelProvider)
//                                       //     .categoryId);
//                                       // print(stringToList(ref
//                                       //     .read(userModelProvider)
//                                       //     .categoryId!));
//                                       List<String> categoryIds = stringToList(
//                                           ref
//                                               .read(userModelProvider)
//                                               .categoryId!);
//                                       if (categoryIds.isEmpty) {
//                                       } else {
//                                         String ids = listToString(categoryIds);
//                                         bool? result =
//                                             await uploadDriverBasicDetails(
//                                                 ref
//                                                     .read(userModelProvider)
//                                                     .userId!,
//                                                 ref
//                                                     .read(userModelProvider)
//                                                     .toJson());
//                                         if (result != null) {
//                                           // ref
//                                           //         .read(vehicleDetailProvider
//                                           //             .notifier)
//                                           //         .state =
//                                           //     '${data.response![0].catName!} - ${data.response![0].subcategory![index].catName!}';
//                                           ref
//                                               .read(userModelProvider.notifier)
//                                               .updateCategoryName(data
//                                                   .response![0]
//                                                   .subcategory![myin]
//                                                   .catName!);
//                                           //Get.back(closeOverlays: true);
//                                         }
//                                         // print(ref
//                                         //     .read(userModelProvider)
//                                         //     .categoryId);
//                                       }
//                                     },
//                                     child: Text('Save'))