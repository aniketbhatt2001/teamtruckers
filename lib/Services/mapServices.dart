import 'dart:async';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

import 'package:book_rides/Screens/PassengerMapScreen.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/providers/LocationProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Models/vehicleInfo.dart';
import '../Utils/Constatnts.dart';
import '../providers/BaiscProviders.dart';

Future<Placemark?> getAddressFromLatLng(
  LatLng latLng,
) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    latLng.latitude,
    latLng.longitude,
  );
  // for (var element in placemarks) {
  //   log(element.name.toString());
  // }

  if (placemarks.isNotEmpty) {
    Placemark placemark = placemarks[0];
    // final address =
    //     "${placemark.name}, ${placemark.locality}, ${placemark.country}";

    return placemark;
  } else {
    return null;
  }
}

void openGoogleMaps(String sourceAdress) async {
  showLoadUp();
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );
  pop();
  showLoadUp();
  final placemark =
      await getAddressFromLatLng(LatLng(position.latitude, position.longitude));
  pop();
  final city = placemark!.locality;
  //final currentLocation = LatLng(position.latitude, position.longitude);

  // final desLat = destinationLocation.latitude;
  // final desLng = destinationLocation.longitude;
  // Implement your method to get the current location
  // Replace with your desired destination location
  // const url =
  //     'https://www.google.com/maps/dir/?api=1&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate';
  final url =
      "https://www.google.com/maps/dir/?api=1&origin=${Uri.encodeComponent(city!)}&destination=${Uri.encodeComponent(sourceAdress)}";

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

// Future<List<String>> searchAddress(String address) async {
//   log('inside searchAddress');
//   showLoadUp();

//   try {
//     List<String> adressList = [];
//     List<Location> locations = await locationFromAddress(address);

//     pop();
//     log('inside if');
//     if (locations.isNotEmpty) {
//       for (var location in locations) {
//         String addressFound = await getAddressFromLatLng(LatLng(
//             location.latitude,
//             location.longitude)); // Use latitude and longitude separately

//         adressList.add(addressFound);
//       }

//       return adressList;
//     } else {
//       log('inside else');
//       Get.snackbar("failed", '');
//       return []; // Return an empty list when no locations are found
//     }
//   } catch (e) {
//     log('inside catch');
//     pop();
//     Get.snackbar(e.toString(), '');
//     return []; // Return an empty list in case of an error
//   }
// }
Future<double?> calculateDistance(
    String startAddress, String endAddress) async {
  List<Location> startLocations = await locationFromAddress(startAddress);
  List<Location> endLocations = await locationFromAddress(endAddress);

  if (startLocations.isNotEmpty && endLocations.isNotEmpty) {
    Location startLocation = startLocations.first;
    Location endLocation = endLocations.first;

    double distanceInMeters = Geolocator.distanceBetween(startLocation.latitude,
        startLocation.longitude, endLocation.latitude, endLocation.longitude);

    return distanceInMeters / 1000; // Convert meters to kilometers
  }

  return null;
}

final foundPickupLocationAdressProvider =
    FutureProvider.autoDispose((ref) async {
  String adress = ref.watch(
      locationModelStateProvider.select((value) => value.pickupLocation ?? ''));
  List<Location>? locations = await geocodeAddress(adress);
  List<Placemark>? placemarks = [];
  //Location location = locations!.first;
  if (locations != null) {
    //int lenght = locations!.length;

    for (int i = 0; i < locations.length; i++) {
      placemarks =
          await reverseGeocode(locations[i].latitude, locations[i].longitude);
    }
  }

  // Placemark placemark = placemarks!.first;

  // List<Location> foundLocations =
  //     await locationFromAddress(adress.isEmpty ? 'xyz' : adress);
  return placemarks;
});

final foundDestinationaddressesProvider =
    FutureProvider.autoDispose((ref) async {
  final adress = ref.watch(
      locationModelStateProvider.select((value) => value.destinationLocation));
  List<Location>? locations = await geocodeAddress(adress ?? '');
  List<Placemark>? placemarks = [];
  //Location location = locations!.first;
  if (locations != null) {
    //int lenght = locations!.length;

    for (int i = 0; i < locations.length; i++) {
      placemarks =
          await reverseGeocode(locations[i].latitude, locations[i].longitude);
    }
  }

  // Placemark placemark = placemarks!.first;

  // List<Location> foundLocations =
  //     await locationFromAddress(adress.isEmpty ? 'xyz' : adress);
  return placemarks;
});

Future<List<Location>?> geocodeAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);

    for (var location in locations) {
      log('Geocoded Address: ${location.latitude}, ${location.longitude}');
    }
    return locations;
  } catch (e) {
    log('Geocoding Error: $e');
    return null;
  }
}

Future<List<Placemark>?> reverseGeocode(
    double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    for (var placemark in placemarks) {
      log('Reverse Geocoded Address: ${placemark.street}, ${placemark.locality}, ${placemark.country}');
    }
    return placemarks;
  } catch (e) {
    log('Reverse Geocoding Error: $e');
    return null;
  }
}

StreamSubscription<Position>? updateUserLocation(WidgetRef ref) {
  const locationOptions =
      LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 3
          // In meters, only update if the user moves 3 meters or more
          );

  final streamSubscription =
      Geolocator.getPositionStream(locationSettings: locationOptions).listen(
          (Position position) {
    // Update the position on the map
    // Get.snackbar('mobile was moved', '');
    update_user_location_info(position, ref);
  }, onError: (error) {
    // Handle any errors that occur during position retrieval
    showFailureBar(error.toString());
  });
  return streamSubscription;
}
