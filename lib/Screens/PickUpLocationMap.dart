import 'dart:developer';

import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Utils/Constatnts.dart';
import '../Services/mapServices.dart';
import '../providers/BaiscProviders.dart';

class PickupLocationMap extends ConsumerStatefulWidget {
  PickupLocationMap({super.key});

  @override
  ConsumerState<PickupLocationMap> createState() => _PickupLocationMapState();
}

class _PickupLocationMapState extends ConsumerState<PickupLocationMap> {
  GoogleMapController? _mapController;

  Marker? currentLocationMarker;

  LatLng? currentLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    //pop();
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        body: Stack(children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: ref.read(locationModelStateProvider).pickUpLatlng!,
              zoom: 16,
            ),
            markers: currentLocationMarker != null
                ? <Marker>{currentLocationMarker!}
                : {},
            onCameraMove: (CameraPosition position) {
              if (currentLocationMarker != null) {
                if (mounted) {
                  setState(() {
                    currentLocationMarker = currentLocationMarker!.copyWith(
                      positionParam: position.target,
                    );
                  });
                }
              }
            },
          ),
          Positioned(
            left: p1.maxWidth / 3,
            top: p1.maxHeight / 1.1,
            child: ElevatedButton(
              onPressed: () async {
                showLoadUp();
                final pickUpLocationAdress =
                    await getAddressFromLatLng(currentLocationMarker!.position);

                if (pickUpLocationAdress != null) {
                  final address =
                      "${pickUpLocationAdress.name}, ${pickUpLocationAdress.locality}, ${pickUpLocationAdress.country}";
                  final city = ref.read(cityProvider.notifier).state =
                      '${pickUpLocationAdress.locality}';
                  ref.read(cityProvider.notifier).state = city;

                  ref
                      .read(locationModelStateProvider.notifier)
                      .updatePickUpLocationLatlng(
                          currentLocationMarker!.position);

                  ref
                      .read(locationModelStateProvider.notifier)
                      .updatePickUpLocation(address);

                  ref.read(markerPrvider.notifier).updateCurrentLocationMarker(
                      ref.read(locationModelStateProvider).destinationLatlng ==
                              null
                          ? {
                              Marker(
                                  markerId: const MarkerId('1'),
                                  position: ref
                                      .read(locationModelStateProvider)
                                      .pickUpLatlng!),
                            }
                          : {
                              Marker(
                                  markerId: const MarkerId('1'),
                                  position: ref
                                      .read(locationModelStateProvider)
                                      .pickUpLatlng!),
                              Marker(
                                  markerId: const MarkerId('2'),
                                  position: ref
                                      .read(locationModelStateProvider)
                                      .destinationLatlng!),
                            });

                  ref.read(mapControllerProvider).animateCamera(
                      CameraUpdate.newLatLng(
                          ref.read(locationModelStateProvider).pickUpLatlng!));
                  if (ref.read(locationModelStateProvider).destinationLatlng !=
                      null) {
                    ref.read(polyLineProvider.notifier).updatePolyLine({
                      Polyline(
                          polylineId: const PolylineId('route'),
                          points: [
                            ref.read(locationModelStateProvider).pickUpLatlng!,
                            ref
                                .read(locationModelStateProvider)
                                .destinationLatlng!
                          ],
                          color: Colors.blue,
                          width: 5)
                    });
                  }

                  Get.back(closeOverlays: true);
                  pop();
                }

                // //     _polylines.clear();
                // // _polylines.add(
                // //   Polyline(
                // //     polylineId: PolylineId('route'),
                // //     points: [_currentPosition!, destination],
                // //     color: Colors.blue,
                // //     width: 5,
                // //   ),
                // ref.read(polyLineProvider.notifier).updatePolyLine({
                //   Polyline(
                //       polylineId: PolylineId('route'),
                //       points: [currentLocation!, currentLocationMarker!.position],
                //       color: Colors.blue,
                //       width: 5)
                // });
                // Get.back(closeOverlays: true);
                //log(destinationAdress);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(horizontal: 60)),
              child: const Text('Done'),
            ),
          )
        ]),
      ),
    );
  }

  void _getCurrentLocation() async {
    if (mounted) {
      setState(() {
        currentLocation = ref.read(locationModelStateProvider).pickUpLatlng;
        if (currentLocation != null) {
          currentLocationMarker = Marker(
            markerId: const MarkerId('currentLocation'),
            position: currentLocation!,
            draggable: true,
            onDragEnd: (LatLng newPosition) {
              if (mounted) {
                setState(() {
                  currentLocation = newPosition;
                });
              }
            },
          );
        }
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(currentLocation!),
        );
      });
    }
  }
}
