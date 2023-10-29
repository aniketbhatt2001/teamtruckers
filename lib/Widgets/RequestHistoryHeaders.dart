// ignore_for_file: prefer_const_constructors

import 'package:book_rides/Screens/RequestHistory.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/Constatnts.dart';

final filterHeadersProvider = FutureProvider.autoDispose(
    (ref) => bookingsHistoryHeaders(ref.read(userModelProvider).userId!));

class RequestHistoryHeadersList extends ConsumerWidget {
  const RequestHistoryHeadersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(filterHeadersProvider);

    return provider.when(
      data: (data) {
        return ListView.builder(
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              // purchaseHistoryProvider.updateHistoryValue(
              //     widget.purchaseHistoryHeadersModel.response![index].value!,
              //     index);
              ref.read(passengerSlugProvider.notifier).state =
                  data.response![index].value!;
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border:
                    Border.all(color: HexColor(data.response![index].bgColor!)
                        //  index == purchaseHistoryProvider.currentIndex
                        //     ?
                        //     :
                        ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor(data.response![index].bgColor!)
                        // color: widget.purchaseHistoryHeadersModel.response![index]
                        //         .color!.isEmpty
                        //     ? Colors.white
                        //     : HexColor(widget.purchaseHistoryHeadersModel
                        //         .response![index].color!)
                        ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Center(child: Text(data.response![index].title!)),
                  SizedBox(
                    width: 8,
                  ),
                  Text('(${data.response![index].count!})')
                ],
              ),
            ),
          ),
          scrollDirection: Axis.horizontal,
          itemCount: data!.response!.length,
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return Center(
          child: RefreshProgressIndicator(),
        );
      },
    );
  }
}
