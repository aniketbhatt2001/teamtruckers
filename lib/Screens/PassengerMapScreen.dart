// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'dart:async';

import 'package:book_rides/Models/MainCategoryModel.dart';
import 'package:book_rides/Models/vehicleInfo.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:book_rides/Screens/VehicleSubtype.dart';
import 'package:book_rides/Services/NotificationService.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Screens/passengerRideDetails.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:book_rides/Screens/DestinationMap.dart';

import 'package:book_rides/Screens/PickUpLocationMap.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/Widgets/Drawer.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:intl/intl.dart';

import '../Services/mapServices.dart';
import '../Widgets/SelectedRideType.dart';
import '../providers/BaiscProviders.dart';

// TextEditingController whenController = TextEditingController();
// TextEditingController _commentsController = TextEditingController();
// TextEditingController fare = TextEditingController();
// TextEditingController pickUp = TextEditingController();
GlobalKey<FormState> formKey = GlobalKey<FormState>();
late final Provider<GoogleMapController> mapControllerProvider;
MainCategoryModel? mainCategoryModel;

class UserMapInfo extends ConsumerStatefulWidget {
  const UserMapInfo({Key? key}) : super(key: key);

  @override
  ConsumerState<UserMapInfo> createState() => _UserMapInfoState();
}

class _UserMapInfoState extends ConsumerState<UserMapInfo> {
  late GoogleMapController mapController;
  bool active = false;
  LatLng? currentPosition;
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _fare = TextEditingController();
  final TextEditingController _whenController = TextEditingController();
// TextEditingController _commentsController = TextEditingController();
// TextEditingController fare = TextEditingController();
  final TextEditingController _pickUp = TextEditingController();
  // String myAdress = '';

  // LatLng? _destinationLocation;
  @override
  void initState() {
    super.initState();
    // context.read<LocationProvider>().getLocation();
    NotificationService.inItLocalNotification(
        context, ref.read(userModelProvider).userId!, ref);
    getCurrentLocation();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    //controller.animateCamera(CameraUpdate.n)
    mapControllerProvider =
        Provider<GoogleMapController>((ref) => mapController);
  }

  void getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      currentPosition = LatLng(position.latitude, position.longitude);
      final currentAddress = await getAddressFromLatLng(
        currentPosition!,
      );
      if (currentAddress != null) {
        final address =
            "${currentAddress.name}, ${currentAddress.locality}, ${currentAddress.country}";

        ref.read(cityProvider.notifier).state = '${currentAddress.locality}';
        ref
            .read(locationModelStateProvider.notifier)
            .updateCurrentAddresLatlang(currentPosition!);
        ref
            .read(locationModelStateProvider.notifier)
            .updateCurrentAddres(address);
        ref
            .read(locationModelStateProvider.notifier)
            .updatePickUpLocationLatlng(currentPosition!);
        ref
            .read(locationModelStateProvider.notifier)
            .updatePickUpLocation(address);

        final marker = Marker(
          markerId: MarkerId(currentPosition.toString()),
          position: currentPosition!,
        );
        mainCategoryModel =
            await fetchMainCategories(ref.read(userModelProvider).userId!);
        if (mainCategoryModel != null) {
          final res =
              await getActiveBookings(ref.read(userModelProvider).userId!);
          ref
              .read(markerPrvider.notifier)
              .updateCurrentLocationMarker({marker});
          if (res != null) {
            active = T;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ref.invalidate(indexProvider);
  }

  @override
  Widget build(BuildContext context) {
    final myMarker = ref.watch(markerPrvider);
    final myPolylines = ref.watch(polyLineProvider);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: LayoutBuilder(
        builder: (p0, p1) => Scaffold(
            drawer: MyDrawer(),
            body: myMarker.isLoading
                ? const Center(
                    child: RefreshProgressIndicator(),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: active ? p1.maxHeight / 1.3 : p1.maxHeight / 2,
                        child: Stack(
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                return GoogleMap(
                                    polylines: myPolylines.polyines,
                                    onCameraMove: (position) {
                                      //_destinationLocation = position.target;
                                    },
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: ref
                                              .read(locationModelStateProvider)
                                              .pickUpLatlng ??
                                          currentPosition ??
                                          LatLng(0, 0),
                                      zoom: 16.0,
                                    ),
                                    markers: myMarker.markers);
                              },
                            ),
                            Positioned(
                              top: 50,
                              left: 20,
                              child: Builder(builder: (ctx) {
                                return GestureDetector(
                                  onTap: () {
                                    Scaffold.of(ctx).openDrawer();
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //       color: Colors.grey.shade200,
                                        //       spreadRadius: 2,
                                        //       blurRadius: 2)
                                        // ],
                                      ),
                                      height: 50,
                                      width: 50,
                                      child: const Icon(Icons.menu)),
                                );
                              }),
                            ),
                            Positioned(
                                right: p1.maxWidth / 1.2,
                                top: active
                                    ? p1.maxHeight / 1.5
                                    : p1.maxHeight / 2.4,
                                child: FloatingActionButton(
                                  backgroundColor: primary,
                                  onPressed: () {
                                    if (ref
                                            .read(locationModelStateProvider)
                                            .currentAdressLatlng !=
                                        null) {
                                      mapController.animateCamera(
                                        CameraUpdate.newLatLng(ref
                                            .read(locationModelStateProvider)
                                            .currentAdressLatlng!),
                                      );
                                    } else {
                                      mapController.animateCamera(
                                        CameraUpdate.newLatLng(ref
                                            .read(locationModelStateProvider)
                                            .currentAdressLatlng!),
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.my_location),
                                ))
                          ],
                        ),
                      ),
                      (!active)
                          ? SizedBox(
                              height: p1.maxHeight * 0.15,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    mainCategoryModel!.mainCategories!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => RideType(
                                  index: index,
                                  vehicle: VehicleInfo(
                                    icon: mainCategoryModel!
                                        .mainCategories![index].image!,
                                    title: mainCategoryModel!
                                        .mainCategories![index].catName!,
                                    info: mainCategoryModel!
                                        .mainCategories![index].catSlug!,
                                    bgCololor: mainCategoryModel!
                                        .mainCategories![index]
                                        .backgroundColor!,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: p1.maxHeight * 0.03,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Active Booking',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(16),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primary,
                                          shape: roundedRectangleBorder),
                                      onPressed: () {
                                        Get.to(RideDetails());
                                      },
                                      child: Text(
                                        'View',
                                        style: medium(context)
                                            .copyWith(color: Colors.white),
                                      )),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                              ],
                            ),
                      (!active)
                          ? Expanded(
                              child: RideDetailForm(
                                pickUp: _pickUp,
                                whenController: _whenController,
                                commentsController: _commentsController,
                                currentLatlng: currentPosition ?? LatLng(0, 0),
                                fare: _fare,
                              ),
                            )
                          : SizedBox(),
                      (!active)
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ElevatedButton(
                                onPressed: () async {
                                  // openbottomSheet(context);
                                  // _setDestinationLocation(_destinationLocation!);

                                  if (formKey.currentState!.validate()) {
                                    if (ref
                                            .read(indexProvider.notifier)
                                            .state !=
                                        null) {
                                      final res = await findDriver(
                                        ref,
                                        _commentsController.text,
                                      );
                                      if (res) {
                                        Get.offAll(RideDetails());
                                      } else {}
                                    } else {
                                      showFailureBar('Choose ride');
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: roundedRectangleBorder,
                                    backgroundColor: primary),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 110, vertical: 12),
                                  child: Text('Find A Transporter'),
                                ),
                              ),
                            )
                          : SizedBox()
                    ],
                  )),
      ),
    );
  }
}

class RideType extends StatelessWidget {
  final VehicleInfo vehicle;
  final int index;
  const RideType({super.key, required this.vehicle, required this.index});

  @override
  Widget build(BuildContext context) {
    return SelectedRideType(
      index: index,
      vehicleInfo: vehicle,
    );
  }
}

class RideDetailForm extends StatefulWidget {
  TextEditingController commentsController;
  TextEditingController fare;
  TextEditingController whenController;
  TextEditingController pickUp;
  final LatLng currentLatlng;
  RideDetailForm(
      {super.key,
      required this.currentLatlng,
      required this.commentsController,
      required this.fare,
      required this.whenController,
      required this.pickUp});

  @override
  State<RideDetailForm> createState() => _RadiosState();
}

class _RadiosState extends State<RideDetailForm> {
  int groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: SizedBox(
          child: Column(
            children: [
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                title: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors
                        .grey[200], // Set your desired background color here
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final adress = ref.watch(locationModelStateProvider
                          .select((value) => value.pickupLocation));
                      // fromClr = TextEditingController(
                      //     text: ref.read(currentAddressProvider.notifier).state ??
                      //         'Pickup location');
                      widget.pickUp = TextEditingController(
                          text: ref
                              .read(locationModelStateProvider)
                              .pickupLocation);
                      return TextFormField(
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Enter Pickup location';
                          }
                        },
                        controller: widget.pickUp,
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) {
                          //     return PickupLocationMap();
                          //   },
                          // ));
                          showPickUpModalbottomsheet(context, ref);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: adress ?? 'Pickup location',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10)),
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                title: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors
                        .grey[200], // Set your desired background color here
                    borderRadius: BorderRadius.circular(
                        10), // Set the border radius if needed
                  ),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final address = ref.watch(locationModelStateProvider
                          .select((value) => value.destinationLocation));
                      return TextFormField(
                        controller: TextEditingController(
                            text: ref
                                .read(locationModelStateProvider)
                                .destinationLocation),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Enter destination';
                          }
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: address ?? 'Destination',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10)),
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) {
                          //     return DestinationMap();
                          //   },
                          // ));

                          showDestinationModalBottomSheet(context, ref);
                        },
                      );
                    },
                  ),
                ),
              ),

              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                title: Consumer(
                  builder: (context, ref, child) {
                    final date = ref.watch(dateProvider);
                    final time = ref.watch(timeProvider);

                    widget.whenController = date.isNotEmpty
                        ? TextEditingController(
                            text: '$date  $time',
                          )
                        : TextEditingController(text: null);
                    myDecoration;
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[
                            200], // Set your desired background color here
                        borderRadius: BorderRadius.circular(
                            10), // Set the border radius if needed
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter date ';
                          }
                        },
                        controller: widget.whenController,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(Duration(days: 365 * 200)),
                            lastDate:
                                DateTime.now().add(Duration(days: 365 * 200)),
                          ).then((value) {
                            if (value != null) {
                              DateTime dateTime =
                                  value; // Replace with your DateTime object
                              //  log(value.toString());
                              String formattedDate =
                                  DateFormat('dd MMMM yyyy').format(dateTime);
                              ref.read(dateProvider.notifier).state =
                                  formattedDate;
                              showTimePicker(
                                      cancelText: 'Skip',
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                  .then((value) {
                                if (value != null) {
                                  final result =
                                      "${value.hour}:${value.minute}";
                                  ref.read(timeProvider.notifier).state =
                                      result;
                                  //final date = ref.read(dateProvider);
                                  // ref.read(dateProvider.notifier).state =
                                  //     "$date,$time";
                                }
                              });
                            }
                          });
                        },
                        readOnly: true,
                        decoration: const InputDecoration(
                            hintText: 'When',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10)),
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                title: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors
                        .grey[200], // Set your desired background color here
                    borderRadius: BorderRadius.circular(
                        10), // Set the border radius if needed
                  ),
                  child: TextFormField(
                    controller: widget.commentsController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter comments';
                      }
                    },
                    onTap: () {
                      //  showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate)
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Comments',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: widget.commentsController,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 18),
                                        hintText:
                                            'Breifly describe the parcel and specify\n its size',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            width: 1.0,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            width: 1.0,
                                          ),
                                        ),
                                        // Other InputDecoration properties (e.g., labelText, hintText, etc.)
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: primary,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5)),
                                        onPressed: () {
                                          if (widget.commentsController.text
                                              .isNotEmpty) {
                                            Get.back(closeOverlays: T);
                                          } else {
                                            showFailureBar('Enter comments');
                                          }
                                        },
                                        child: Text("Done"))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                        hintText: 'Comments',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  ),
                ),
              )
              // Row(
              //   children: [
              //     Radio(
              //       value: 1,
              //       groupValue: groupValue,
              //       onChanged: (value) {
              //         groupValue = value!;
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDestinationModalBottomSheet(
      BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return const DestinationSearchWidget();
      },
    );
  }

  Future<dynamic> showPickUpModalbottomsheet(
      BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => const SizedBox(
        height: 800,
        child: PickupSearchLocation(),
      ),
    );
  }
}

class PickupSearchLocation extends ConsumerStatefulWidget {
  const PickupSearchLocation({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PickupSearchLocation> createState() =>
      _PickupSearchLocationState();
}

class _PickupSearchLocationState extends ConsumerState<PickupSearchLocation> {
  TextEditingController fromClr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromClr = TextEditingController(
        text: ref.read(locationModelStateProvider).pickupLocation);
  }

  @override
  Widget build(BuildContext context) {
    final adress = ref.watch(foundPickupLocationAdressProvider);
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.radio_button_checked),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GooglePlaceAutoCompleteTextField(
                textEditingController: fromClr,
                googleAPIKey: mapKey,
                inputDecoration: const InputDecoration(),
                debounceTime: 800, // default 600 ms,
                // countries: ["in","fr"],// optional by default null is set
                isLatLngRequired:
                    true, // if you required coordinates from place detail
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  // this method will return latlng with place detail
                  print("placeDetails" + prediction.lng.toString());
                }, // this callback is called when isLatLngRequired is true
                itmClick: (Prediction prediction) async {
                  // print(prediction.description);
                  // _controller.text = prediction.description ?? '';
                  // setState(() {});
                  ;
                  //  controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length));
                  List<Location>? locations =
                      await geocodeAddress(prediction.description!);
                  if (locations != null && locations.isNotEmpty) {
                    Location location = locations.first;
                    ref
                        .read(locationModelStateProvider.notifier)
                        .updatePickUpLocation(prediction.description!);
                    ref.read(cityProvider.notifier).state =
                        prediction.description!;
                    ref
                        .read(locationModelStateProvider.notifier)
                        .updatePickUpLocationLatlng(
                            LatLng(location.latitude, location.longitude));
                    ref
                        .read(markerPrvider.notifier)
                        .updateCurrentLocationMarker(ref
                                    .read(locationModelStateProvider)
                                    .destinationLatlng ==
                                null
                            ? {
                                Marker(
                                    infoWindow:
                                        const InfoWindow(title: 'Pickup'),
                                    markerId: const MarkerId('1'),
                                    position: ref
                                        .read(locationModelStateProvider)
                                        .pickUpLatlng!),
                              }
                            : {
                                Marker(
                                    infoWindow:
                                        const InfoWindow(title: 'Pickup'),
                                    markerId: const MarkerId('1'),
                                    position: ref
                                        .read(locationModelStateProvider)
                                        .pickUpLatlng!),
                                Marker(
                                    infoWindow:
                                        const InfoWindow(title: 'Destination'),
                                    markerId: const MarkerId('2'),
                                    position: ref
                                        .read(locationModelStateProvider)
                                        .destinationLatlng!),
                              });
                    if (ref
                            .read(locationModelStateProvider)
                            .destinationLatlng !=
                        null) {
                      ref.read(polyLineProvider.notifier).updatePolyLine({
                        Polyline(
                            polylineId: const PolylineId('1'),
                            width: 5,
                            color: Colors.blue,
                            points: [
                              ref
                                  .read(locationModelStateProvider)
                                  .pickUpLatlng!,
                              ref
                                  .read(locationModelStateProvider)
                                  .destinationLatlng!
                            ]),
                      });
                    }
                    Get.back(closeOverlays: true);

                    pop();
                  }
                  // ref.read(destinationCityProvider.notifier).state =
                  //     prediction.description;
                  // Get.offAll(const HomeScreen());
                }),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.location_on_rounded,
            color: Colors.blue,
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return PickupLocationMap();
                    },
                  ));
                },
                child: const Text('Choose on map')),
          ),
        ),
//         adress.when(
//           data: (data) {
//             return data!.isNotEmpty
//                 ? ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: data.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 10),
//                         child: GestureDetector(
//                           onTap: () async {
// //  ref.read(mapControllerProvider).animateCamera(CameraUpdate.)

//                             List<Location>? locations = await geocodeAddress(
//                                 '${data[index].street}, ${data[index].locality}, ${data[index].country}');
//                             if (locations != null && locations.isNotEmpty) {
//                               Location location = locations.first;
//                               ref
//                                   .read(locationModelStateProvider.notifier)
//                                   .updatePickUpLocation(
//                                       '${data[index].street}, ${data[index].locality}, ${data[index].country}');
//                               ref.read(cityProvider.notifier).state =
//                                   data[index].locality!;
//                               ref
//                                   .read(locationModelStateProvider.notifier)
//                                   .updatePickUpLocationLatlng(LatLng(
//                                       location.latitude, location.longitude));
//                               ref
//                                   .read(markerPrvider.notifier)
//                                   .updateCurrentLocationMarker(ref
//                                               .read(locationModelStateProvider)
//                                               .destinationLatlng ==
//                                           null
//                                       ? {
//                                           Marker(
//                                               infoWindow: const InfoWindow(
//                                                   title: 'Pickup'),
//                                               markerId: const MarkerId('1'),
//                                               position: ref
//                                                   .read(
//                                                       locationModelStateProvider)
//                                                   .pickUpLatlng!),
//                                         }
//                                       : {
//                                           Marker(
//                                               infoWindow: const InfoWindow(
//                                                   title: 'Pickup'),
//                                               markerId: const MarkerId('1'),
//                                               position: ref
//                                                   .read(
//                                                       locationModelStateProvider)
//                                                   .pickUpLatlng!),
//                                           Marker(
//                                               infoWindow: const InfoWindow(
//                                                   title: 'Destination'),
//                                               markerId: const MarkerId('2'),
//                                               position: ref
//                                                   .read(
//                                                       locationModelStateProvider)
//                                                   .destinationLatlng!),
//                                         });
//                               if (ref
//                                       .read(locationModelStateProvider)
//                                       .destinationLatlng !=
//                                   null) {
//                                 ref
//                                     .read(polyLineProvider.notifier)
//                                     .updatePolyLine({
//                                   Polyline(
//                                       polylineId: const PolylineId('1'),
//                                       width: 5,
//                                       color: Colors.blue,
//                                       points: [
//                                         ref
//                                             .read(locationModelStateProvider)
//                                             .pickUpLatlng!,
//                                         ref
//                                             .read(locationModelStateProvider)
//                                             .destinationLatlng!
//                                       ]),
//                                 });
//                               }
//                               Get.back(closeOverlays: true);

//                               pop();
//                             }
//                           },
//                           child: Text(
//                               '${data[index].street}, ${data[index].locality}, ${data[index].country}'),
//                         ),
//                       );
//                     },
//                   )
//                 : const Text('Address not found');
//           },
//           error: (error, stackTrace) {
//             return Center(
//               child: Text(error.toString()),
//             );
//           },
//           loading: () {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//         )
      ],
    );
  }
}

class DestinationSearchWidget extends ConsumerStatefulWidget {
  const DestinationSearchWidget({
    super.key,
  });

  @override
  ConsumerState<DestinationSearchWidget> createState() =>
      _DestinationSearchWidgetState();
}

class _DestinationSearchWidgetState
    extends ConsumerState<DestinationSearchWidget> {
  TextEditingController toClr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toClr = TextEditingController(
        text: ref.read(locationModelStateProvider).destinationLocation);
  }

  @override
  Widget build(BuildContext context) {
    final address = ref.watch(foundDestinationaddressesProvider);

    return Column(
      children: [
        ListTile(
            leading: const Icon(Icons.radio_button_checked),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GooglePlaceAutoCompleteTextField(
                  textEditingController: toClr,
                  googleAPIKey: mapKey,
                  inputDecoration:
                      const InputDecoration(hintText: 'Destination Location'),
                  debounceTime: 800, // default 600 ms,
                  // countries: ["in","fr"],// optional by default null is set
                  isLatLngRequired:
                      true, // if you required coordinates from place detail
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    // this method will return latlng with place detail
                    print("placeDetails" + prediction.lng.toString());
                  }, // this callback is called when isLatLngRequired is true
                  itmClick: (Prediction prediction) async {
                    // print(prediction.description);
                    // _controller.text = prediction.description ?? '';
                    // setState(() {});
                    //  controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length));
                    // ref.read(destinationCityProvider.notifier).state =
                    //     prediction.description;
                    // Get.offAll(const HomeScreen());
                    List<Location>? locations =
                        await geocodeAddress(prediction.description!);
                    if (locations != null && locations.isNotEmpty) {
                      Location location = locations.first;
                      ref.read(destinationCityProvider.notifier).state =
                          prediction.description!;
                      ref
                          .read(locationModelStateProvider.notifier)
                          .updateDestinationAdress(prediction.description!);
                      ref
                          .read(locationModelStateProvider.notifier)
                          .updateDestinationLatlng(
                              LatLng(location.latitude, location.longitude));
                      ref
                          .read(markerPrvider.notifier)
                          .updateCurrentLocationMarker(ref
                                      .read(locationModelStateProvider)
                                      .pickUpLatlng ==
                                  null
                              ? {
                                  Marker(
                                      infoWindow: const InfoWindow(
                                          title: 'Destination'),
                                      markerId: const MarkerId('1'),
                                      position: ref
                                          .read(locationModelStateProvider)
                                          .destinationLatlng!),
                                }
                              : {
                                  Marker(
                                      infoWindow:
                                          const InfoWindow(title: 'Pickup'),
                                      markerId: const MarkerId('1'),
                                      position: ref
                                          .read(locationModelStateProvider)
                                          .pickUpLatlng!),
                                  Marker(
                                      infoWindow: const InfoWindow(
                                          title: 'Destination'),
                                      markerId: const MarkerId('2'),
                                      position: ref
                                          .read(locationModelStateProvider)
                                          .destinationLatlng!),
                                });
                      ref.read(polyLineProvider.notifier).updatePolyLine({
                        Polyline(
                            polylineId: const PolylineId('1'),
                            width: 5,
                            color: Colors.blue,
                            points: [
                              ref
                                  .read(locationModelStateProvider)
                                  .pickUpLatlng!,
                              ref
                                  .read(locationModelStateProvider)
                                  .destinationLatlng!
                            ]),
                      });
                      ref.read(mapControllerProvider).animateCamera(
                          CameraUpdate.newLatLng(ref
                              .read(locationModelStateProvider)
                              .destinationLatlng!));
                      pop();
                    }
                  }),
            )
            // TextFormField(
            //   controller: toClr,
            //   onChanged: (value) {
            //     if (toClr.text.trim().isNotEmpty) {
            //       ref
            //           .read(locationModelStateProvider.notifier)
            //           .updateDestinationAdress(toClr.text);
            //     }
            //   },
            //   onEditingComplete: () {
            //     // if (toClr.text.trim().isNotEmpty) {
            //     //   ref
            //     //       .read(locationModelStateProvider.notifier)
            //     //       .updateDestinationAdress(toClr.text);
            //     // }
            //   },
            //   decoration: const InputDecoration(hintText: 'Destination Location'),
            //   // controller:
            //   //     TextEditingController(text: adress),
            // ),
            ),
        ListTile(
          leading: const Icon(
            Icons.location_on_rounded,
            color: Colors.blue,
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return DestinationMap();
                    },
                  ));
                },
                child: const Text('Choose on map')),
          ),
        ),
        // address.when(
        //   data: (data) {
        //     return data!.isNotEmpty
        //         ? ListView.builder(
        //             shrinkWrap: true,
        //             itemCount: data!.length,
        //             itemBuilder: (context, index) {
        //               return Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                     horizontal: 16, vertical: 10),
        //                 child: GestureDetector(
        //                   onTap: () async {
        //                     List<Location>? locations = await geocodeAddress(
        //                         '${data[index].street}, ${data[index].locality}, ${data[index].country}');
        //                     if (locations != null && locations.isNotEmpty) {
        //                       Location location = locations.first;
        //                       ref.read(destinationCityProvider.notifier).state =
        //                           data[index].locality!;
        //                       ref
        //                           .read(locationModelStateProvider.notifier)
        //                           .updateDestinationAdress(
        //                               '${data[index].street}, ${data[index].locality}, ${data[index].country}');
        //                       ref
        //                           .read(locationModelStateProvider.notifier)
        //                           .updateDestinationLatlng(LatLng(
        //                               location.latitude, location.longitude));
        //                       ref
        //                           .read(markerPrvider.notifier)
        //                           .updateCurrentLocationMarker(ref
        //                                       .read(locationModelStateProvider)
        //                                       .pickUpLatlng ==
        //                                   null
        //                               ? {
        //                                   Marker(
        //                                       infoWindow: const InfoWindow(
        //                                           title: 'Destination'),
        //                                       markerId: const MarkerId('1'),
        //                                       position: ref
        //                                           .read(
        //                                               locationModelStateProvider)
        //                                           .destinationLatlng!),
        //                                 }
        //                               : {
        //                                   Marker(
        //                                       infoWindow: const InfoWindow(
        //                                           title: 'Pickup'),
        //                                       markerId: const MarkerId('1'),
        //                                       position: ref
        //                                           .read(
        //                                               locationModelStateProvider)
        //                                           .pickUpLatlng!),
        //                                   Marker(
        //                                       infoWindow: const InfoWindow(
        //                                           title: 'Destination'),
        //                                       markerId: const MarkerId('2'),
        //                                       position: ref
        //                                           .read(
        //                                               locationModelStateProvider)
        //                                           .destinationLatlng!),
        //                                 });
        //                       ref
        //                           .read(polyLineProvider.notifier)
        //                           .updatePolyLine({
        //                         Polyline(
        //                             polylineId: const PolylineId('1'),
        //                             width: 5,
        //                             color: Colors.blue,
        //                             points: [
        //                               ref
        //                                   .read(locationModelStateProvider)
        //                                   .pickUpLatlng!,
        //                               ref
        //                                   .read(locationModelStateProvider)
        //                                   .destinationLatlng!
        //                             ]),
        //                       });
        //                       ref.read(mapControllerProvider).animateCamera(
        //                           CameraUpdate.newLatLng(ref
        //                               .read(locationModelStateProvider)
        //                               .destinationLatlng!));
        //                       pop();
        //                     }
        //                   },
        //                   child: Text(
        //                       '${data[index].street}, ${data[index].locality}, ${data[index].country}'),
        //                 ),
        //               );
        //             },
        //           )
        //         : const Text('Address not found');
        //   },
        //   error: (error, stackTrace) {
        //     return Center(
        //       child: Text(error.toString()),
        //     );
        //   },
        //   loading: () {
        //     return const Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   },
        // )
      ],
    );
  }
}
