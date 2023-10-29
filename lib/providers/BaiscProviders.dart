import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/LocationModel.dart';
import '../Models/UserAppConfigModel.dart';
import 'LocationProviders.dart';

final bidInfoDetailIndex = StateProvider<int?>((ref) => null);
final filterSlugSelected = StateProvider.autoDispose<String?>((ref) => null);
//final rideTypeProvider = StateProvider.autoDispose((ref) => null);
final rideTypeChoosenProvider = StateProvider((ref) => RideTypeChoosen.ride);
final modeProvider = StateProvider<Mode>((ref) => Mode.Driver);
final locationModelStateProvider =
    StateNotifierProvider<LocationNotifier, LocationModel>((ref) =>
        LocationNotifier(LocationModel(
            currentAdress: null,
            pickupLocation: null,
            destinationLocation: null,
            currentAdressLatlng: null,
            destinationLatlng: null,
            pickUpLatlng: null)));
final dateProvider = StateProvider<String>((ref) => '');
final timeProvider = StateProvider<String>((ref) => '');
final cityProvider = StateProvider<String>((ref) => '');
final destinationCityProvider = StateProvider<String>((ref) => '');
final categoryIdProvider = StateProvider((ref) => '');
// final timeProvider = StateProvider.autoDispose<String>((
//   ref,
// ) =>
//     '');
final sharedPrefsProvider =
    StateProvider<SharedPfNotifier>((ref) => SharedPfNotifier(null));

class SharedPfNotifier extends StateNotifier<SharedPreferences?> {
  SharedPfNotifier(super.state);

  setPrefs(SharedPreferences sharedPreferences) {
    state = sharedPreferences;
  }

  clearPref() async {
    state!.clear();
  }
}

class UserAppConfigModelNotifier extends StateNotifier<UserAppConfigModel> {
  UserAppConfigModelNotifier(super.state);

  setState(UserAppConfigModel userAppConfigModel) {
    state = userAppConfigModel;
  }
}
// class VehicleType extends StateNotifier<List<String>> {
//   VehicleType(super.state);

//   setid(String userAppConfigModel) {
    
//   }
// }

