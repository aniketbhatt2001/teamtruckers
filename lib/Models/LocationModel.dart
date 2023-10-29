// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  final String? currentAdress;
  final String? pickupLocation;
  final String? destinationLocation;
  final LatLng? currentAdressLatlng;
  final LatLng? destinationLatlng;
  final LatLng? pickUpLatlng;

  LocationModel({
    required this.currentAdress,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.currentAdressLatlng,
    required this.destinationLatlng,
    required this.pickUpLatlng,
  });

  @override
  String toString() {
    return 'LocationModel(currentAdress: $currentAdress, pickupLocation: $pickupLocation, destinationLocation: $destinationLocation, currentAdressLatlng: $currentAdressLatlng, destinationLatlng: $destinationLatlng, pickUpLatlng: $pickUpLatlng)';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.currentAdress == currentAdress &&
        other.pickupLocation == pickupLocation &&
        other.destinationLocation == destinationLocation &&
        other.currentAdressLatlng == currentAdressLatlng &&
        other.destinationLatlng == destinationLatlng &&
        other.pickUpLatlng == pickUpLatlng;
  }

  @override
  int get hashCode {
    return currentAdress.hashCode ^
        pickupLocation.hashCode ^
        destinationLocation.hashCode ^
        currentAdressLatlng.hashCode ^
        destinationLatlng.hashCode ^
        pickUpLatlng.hashCode;
  }

  LocationModel copyWith({
    String? currentAdress,
    String? pickupLocation,
    String? destinationLocation,
    LatLng? currentAdressLatlng,
    LatLng? destinationLatlng,
    LatLng? pickUpLatlng,
  }) {
    return LocationModel(
      currentAdress: currentAdress ?? this.currentAdress,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      currentAdressLatlng: currentAdressLatlng ?? this.currentAdressLatlng,
      destinationLatlng: destinationLatlng ?? this.destinationLatlng,
      pickUpLatlng: pickUpLatlng ?? this.pickUpLatlng,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationModel> {
  LocationNotifier(super.state);

  updateCurrentAddres(String currentAddres) {
    state = state.copyWith(currentAdress: currentAddres);
  }

  updateCurrentAddresLatlang(LatLng currentAdressLatlng) {
    state = state.copyWith(currentAdressLatlng: currentAdressLatlng);
  }

  updatePickUpLocation(String pickUpLocation) {
    state = state.copyWith(pickupLocation: pickUpLocation);
  }

  updatePickUpLocationLatlng(LatLng pickUpLatng) {
    state = state.copyWith(pickUpLatlng: pickUpLatng);
  }

  updateDestinationAdress(String destinationAdress) {
    state = state.copyWith(destinationLocation: destinationAdress);
  }

  updateDestinationLatlng(LatLng destinationLatlng) {
    state = state.copyWith(destinationLatlng: destinationLatlng);
  }
}
