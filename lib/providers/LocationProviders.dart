import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Models/LocationModel.dart';
import 'LoactionNotifier.dart';

final markerPrvider =
    StateNotifierProvider.autoDispose<MarkerNotifier, MyMarker>(
        (ref) => MarkerNotifier(const MyMarker(isLoading: true, markers: {})));
final polyLineProvider =
    StateNotifierProvider.autoDispose<PolyLineNotifier, MyPolyLine>(
        (ref) => PolyLineNotifier(const MyPolyLine(polyines: {})));

// final currentPositionProvider = StateProvider<LatLng?>((ref) => null);
// final destinationPositionProvider = StateProvider<LatLng?>((ref) => null);
// // final addresProvider = FutureProvider((ref) => getAd)
// final currentAddressProvider = StateProvider<String?>((ref) => null);
// final destinationAddressProvider = StateProvider((ref) => '');
// class SearchedPickuplocationNotifier extends StateNotifier<List<String>> {
//   SearchedPickuplocationNotifier(super.state);

//   updateList(List<String> addreses) {
//     state = addreses;
//   }
// }

enum OutStationSelectedRideTypeEnum { private, shared, parcel }

enum RideTypeChoosen { ride, outstation }

enum Mode { Customer, Driver }
