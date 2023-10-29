// import 'package:book_rides/Widgets/Drawer.dart';
// import 'package:book_rides/providers/LocationProviders.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../Models/vehicleInfo.dart';
// import '../Utils/Constatnts.dart';
// import '../Services/mapServices.dart';
// import '../Widgets/SelectedRideType.dart';
// import 'PassengerMapScreen.dart';

// // final privateRideDataProvider = StateProvider<List<String>>((ref) => [
// //       'When',
// //       'Number of Passenger '
// //           'Offer your Fare',
// //       'Comments'
// //     ]);
// // final parcelRideDataProvider = StateProvider<List<String>>(
// //     (ref) => ['When', 'Offer your Fare', 'Comments']);
// final selectedRideTypeProvider =
//     StateProvider((ref) => OutStationSelectedRideTypeEnum.private);

// class NewRide extends StatelessWidget {
//   const NewRide({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       drawer: const MyDrawer(),
//       appBar: AppBar(
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.black),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'City to City',
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: LayoutBuilder(
//         builder: (p0, p1) => SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 decoration: const BoxDecoration(color: Colors.green),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       Icon(FontAwesomeIcons.car),
//                       Text('Enjoy fair prices'),
//                       Icon(FontAwesomeIcons.moneyBill)
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 100,
//                 width: double.infinity,
//                 child: Consumer(
//                   builder: (context, ref, child) {
                  
//                     return ListView(
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       children: [
//                         for (int i = 0; i < 2; i++)
//                           Container(
//                             decoration: BoxDecoration(
//                               color: list[i].title == 'OutStation'
//                                   ? Colors.lightBlueAccent.shade100
//                                   : null,
//                             ),
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 22, horizontal: 8),
//                             padding: const EdgeInsets.all(6),
//                             width: 100,
//                             child: SelectedRideType(
                         
//                               vehicleInfo: list[i],
//                             ),
//                           ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               ListTile(
//                 title: const Text("From"),
//                 subtitle: const Text(
//                   'Palghar,Juna Palghar',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 trailing: IconButton(
//                   onPressed: () {},
//                   icon: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 15,
//                   ),
//                 ),
//               ),
//               ListTile(
//                 title: const Text("To"),
//                 // subtitle: const Text(
//                 //   'To',
//                 //   style: TextStyle(fontWeight: FontWeight.bold),
//                 // ),
//                 trailing: IconButton(
//                   onPressed: () {},
//                   icon: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 15,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 100,
//                 width: double.infinity,
//                 child: Consumer(
//                   builder: (context, ref, child) {
//                     final list = ref.watch(vehiclesListProvider);
//                     return ListView(
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             ref.read(selectedRideTypeProvider.notifier).state =
//                                 OutStationSelectedRideTypeEnum.private;
//                           },
//                           child: RideType(
//                               vehicleInfo: VehicleInfo(
//                                   const Icon(
//                                     FontAwesomeIcons.car,
//                                   ),
//                                   'Private ride',
//                                   'Here you offer your pric and choose the driver by yourself')),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             ref.read(selectedRideTypeProvider.notifier).state =
//                                 OutStationSelectedRideTypeEnum.shared;
//                           },
//                           child: RideType(
//                             vehicleInfo: VehicleInfo(
//                                 const Icon(
//                                   FontAwesomeIcons.peopleGroup,
//                                 ),
//                                 'Shared ride',
//                                 'Here you offer your pric and choose the driver by yourself'),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             ref.read(selectedRideTypeProvider.notifier).state =
//                                 OutStationSelectedRideTypeEnum.parcel;
//                           },
//                           child: RideType(
//                             vehicleInfo: VehicleInfo(
//                                 const Icon(
//                                   FontAwesomeIcons.truckRampBox,
//                                 ),
//                                 'Parcel',
//                                 'Here you offer your pric and choose the driver by yourself'),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               Consumer(
//                 builder: (context, ref, child) {
//                   final selectedRideTpe = ref.watch(selectedRideTypeProvider);

//                   return Column(
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 10),
//                         decoration: myDecoration,
//                         child: ListTile(
//                           title: const Text("When"),
//                           // subtitle: const Text(
//                           //   'To',
//                           //   style: TextStyle(fontWeight: FontWeight.bold),
//                           // ),
//                           trailing: IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               Icons.arrow_forward_ios,
//                               size: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       selectedRideTpe != OutStationSelectedRideTypeEnum.parcel
//                           ? Container(
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 10),
//                               decoration: myDecoration,
//                               child: ListTile(
//                                 title: const Text("Number of Passengser"),
//                                 // subtitle: const Text(
//                                 //   'To',
//                                 //   style: TextStyle(fontWeight: FontWeight.bold),
//                                 // ),
//                                 trailing: IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(
//                                     Icons.arrow_forward_ios,
//                                     size: 15,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : SizedBox(),
//                       Container(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 10),
//                         decoration: myDecoration,
//                         child: ListTile(
//                           title: const Text("Offer Your Fare"),
//                           // subtitle: const Text(
//                           //   'To',
//                           //   style: TextStyle(fontWeight: FontWeight.bold),
//                           // ),
//                           trailing: IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               Icons.arrow_forward_ios,
//                               size: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         decoration: myDecoration,
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 10),
//                         child: ListTile(
//                           title: const Text("Comments"),
//                           // subtitle: const Text(
//                           //   'To',
//                           //   style: TextStyle(fontWeight: FontWeight.bold),
//                           // ),
//                           trailing: IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               Icons.arrow_forward_ios,
//                               size: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 width: p1.maxWidth,
//                 child: ElevatedButton(
//                   style:
//                       ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                   onPressed: () {},
//                   child: const Text("Find a driver"),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RideType extends StatelessWidget {
//   const RideType({
//     super.key,
//     required this.vehicleInfo,
//   });

//   final VehicleInfo vehicleInfo;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 22, horizontal: 8),
//       padding: const EdgeInsets.all(6),
//       width: 100,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [(vehicleInfo.icon), const Icon(Icons.info_outline)],
//           ),
//           const SizedBox(
//             height: 4,
//           ),
//           Text(vehicleInfo.title),
//         ],
//       ),
//     );
//   }
// }
