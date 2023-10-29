// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MyLocation {
//   Set<Marker>? markers;
//   Set<Polyline>? polylines;
//   MyLocation({required this.markers, required this.polylines});

//   // updateMarker(Marker marker) {
//   //   markers.add(marker);
//   // }

//   MyLocation copyWith({
//     Set<Marker>? markers,
//     Set<Polyline>? polylines,
//   }) {
//     return MyLocation(
//       markers: markers ?? this.markers,
//       polylines: polylines ?? this.polylines,
//     );
//   }
// }

// class LocationNotifier extends StateNotifier<MyLocation> {
//   LocationNotifier(super.state);

//   updateMarker(Marker marker) {
//     state = state.copyWith(markers: );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod/riverpod.dart';

@immutable
class MyMarker {
  const MyMarker({required this.isLoading, required this.markers});
  final Set<Marker> markers;
  final bool isLoading;
}

class MarkerNotifier extends StateNotifier<MyMarker> {
  MarkerNotifier(super.state);

  void updateCurrentLocationMarker(Set<Marker> markers) {
    state = MyMarker(isLoading: false, markers: markers);
  }

  Set<Marker> getMarkser() {
    return state.markers;
  }
}

@immutable
class MyPolyLine {
  const MyPolyLine({required this.polyines});
  final Set<Polyline> polyines;
}

class PolyLineNotifier extends StateNotifier<MyPolyLine> {
  PolyLineNotifier(super.state);

  void updatePolyLine(Set<Polyline> polyline) {
    state = MyPolyLine(polyines: polyline);
  }

  Set<Polyline> getPolyLines() {
    return state.polyines;
  }
}
