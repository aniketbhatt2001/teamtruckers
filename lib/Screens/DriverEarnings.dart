// ignore_for_file: prefer_const_constructors

import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

final earningsProvider = FutureProvider.autoDispose(
    (ref) => getEarnings(ref.read(userModelProvider).userId!));

class MyEarnings extends ConsumerWidget {
  const MyEarnings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(earningsProvider);
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        body: res.when(
          data: (data) {
            if (data != null) {
              return ListView.builder(
                itemCount: data.response!.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: roundedRectangleBorder,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: data.response![index].responseDate!.isEmpty &&
                            data.response![index].responseImg!.isEmpty &&
                            data.response![index].responseMessage!.isEmpty
                        ? ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            // children: [],
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Amount :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          data.response![index]
                                              .finalTotalAmount!,
                                          style: const TextStyle(
                                            //  fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                  Text(data.response![index].orderDateTime!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14))
                                ],
                              ),
                            ),
                            title: Row(
                              children: [
                                const Text(
                                  'ID :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data.response![index].orderNo!,
                                  style: const TextStyle(color: black),
                                ),
                                SizedBox(
                                  width: p1.maxWidth / 3,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  // width: 40,
                                  // height: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: HexColor(
                                          data.response![index].bgColor!)),
                                  child: Text(data.response![index].viewStatus!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: HexColor(
                                              data.response![index].color!))),
                                )
                              ],
                            ),
                          )
                        : ExpansionTile(
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data.response![index].finalFare!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(data.response![index].orderDateTime!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14))
                                ],
                              ),
                            ),
                            title: Row(
                              children: [
                                const Text(
                                  'ID :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data.response![index].orderNo!,
                                  style: const TextStyle(color: black),
                                ),
                                // SizedBox(
                                //   width: 150,
                                // ),
                                // Container(
                                //   padding: EdgeInsets.all(6),
                                //   // width: 40,
                                //   // height: 10,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(10),
                                //       color: HexColor(
                                //           data.response![index].bgColor!)),
                                //   child: Text(data.response![index].viewStatus!,
                                //       style: const TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 14)),
                                // )
                              ],
                            ),
                          ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No Data Found '),
              );
            }
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () {
            return const Center(
              child: RefreshProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
