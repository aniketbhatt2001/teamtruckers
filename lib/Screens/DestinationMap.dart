import 'dart:developer';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/Services/mapServices.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../providers/BaiscProviders.dart';

class DestinationMap extends ConsumerStatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<DestinationMap> {
  GoogleMapController? _mapController;
  Marker? currentLocationMarker;
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    //pop();
    return LayoutBuilder(
      builder: (p0, p1) => Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          title: const Text('Select Destination'),
        ),
        body: Stack(children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: ref.read(locationModelStateProvider).destinationLatlng ??
                  ref.read(locationModelStateProvider).currentAdressLatlng!,
              zoom: 16,
            ),
            markers: currentLocationMarker != null
                ? <Marker>{currentLocationMarker!}
                : {
                    Marker(
                        markerId: MarkerId(ref
                            .read(locationModelStateProvider)
                            .currentAdress!),
                        position: ref
                            .read(locationModelStateProvider)
                            .currentAdressLatlng!),
                  },
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
            top: p1.maxHeight / 1.25,
            child: ElevatedButton(
              onPressed: () async {
                showLoadUp();
                final destinationPlacemark = await getAddressFromLatLng(
                  currentLocationMarker!.position,
                );
                if (destinationPlacemark != null) {
                  final address =
                      "${destinationPlacemark.name}, ${destinationPlacemark.locality}, ${destinationPlacemark.country}";
                  ref.read(destinationCityProvider.notifier).state =
                      destinationPlacemark.locality!;
                  ref
                      .read(locationModelStateProvider.notifier)
                      .updateDestinationLatlng(currentLocationMarker!.position);

                  ref
                      .read(locationModelStateProvider.notifier)
                      .updateDestinationAdress(address);

                  ref.read(markerPrvider.notifier).updateCurrentLocationMarker(
                      ref.read(locationModelStateProvider).pickUpLatlng != null
                          ? {
                              Marker(
                                  markerId: const MarkerId('1'),
                                  position: ref
                                      .read(locationModelStateProvider)
                                      .pickUpLatlng!,
                                  infoWindow: const InfoWindow(
                                      title: 'Pickup Location')),
                              Marker(
                                  markerId: const MarkerId('2'),
                                  position: currentLocationMarker!.position,
                                  infoWindow:
                                      const InfoWindow(title: 'Destination'))
                            }
                          : {
                              Marker(
                                  markerId: const MarkerId('1'),
                                  position: currentLocationMarker!.position,
                                  infoWindow:
                                      const InfoWindow(title: 'Destination'))
                            });

                  if (ref.read(locationModelStateProvider).pickUpLatlng !=
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
                          color: primary,
                          width: 5)
                    });
                  }
                  Get.back(closeOverlays: true);
                  pop();
                }

                //log(destinationAdress);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(horizontal: 60)),
              child: const Text('Done'),
            ),
          )
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              backgroundColor: primary,
              onPressed: () {
                _getCurrentLocation();
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    currentLocationMarker = Marker(
        markerId: MarkerId(ref.read(locationModelStateProvider).currentAdress!),
        position: ref.read(locationModelStateProvider).currentAdressLatlng!);
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    if (mounted) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        if (currentLocation != null) {
          currentLocationMarker = Marker(
            markerId: const MarkerId('currentLocation'),
            position: ref.read(locationModelStateProvider).destinationLatlng ??
                currentLocation!,
            draggable: true,
            onDragEnd: (LatLng newPosition) {
              setState(() {
                currentLocation = newPosition;
                currentLocationMarker = Marker(
                    markerId: MarkerId(newPosition.toString()),
                    position: newPosition);
              });
            },
          );
        }
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
              ref.read(locationModelStateProvider).destinationLatlng ??
                  currentLocation!),
        );
      });
    }
  }
}
