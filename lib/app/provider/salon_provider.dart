import 'package:geolocator/geolocator.dart';
import 'package:riverpod/riverpod.dart';
import 'package:salon_finder/app/data/salon_data_model.dart';
import 'package:salon_finder/app/data/salon_model.dart';
import 'package:salon_finder/app/provider/current_user_provider.dart';
import 'package:salon_finder/app/services/rating_services.dart';
import 'package:salon_finder/app/services/salon_services.dart';


final salonStreamProvider = StreamProvider<List<SalonModel>>((ref) async* {
  final data = SalonServices.getAllSalons();
  // Listen to the stream of salons and yield the data
  await for (var salon in data) {
    //get only active salons
    List<SalonModel> activeSalons = salon.where((s) => s.status.toLowerCase() == 'active').toList();
    ref.read(salonProvider.notifier).setSalons(activeSalons);
    yield activeSalons;
  }
});

final salonProvider = StateNotifierProvider<SalonNotifier, SalonDataModel>((
  ref,
) {
  // var userData = ref.watch(currentUserProvider);
  return SalonNotifier();
});

class SalonNotifier extends StateNotifier<SalonDataModel> {
  SalonNotifier() : super(SalonDataModel.empty());

  void setSalons(List<SalonModel> salons) {
    state = state.copyWith(salons: salons);
  }

  void filterSalons(String value) {
    if (value.isEmpty) {
      state = state.copyWith(filteredSalons: state.salons);
    } else {
      var filtered = state.salons.where((salon) {
        return salon.name.toLowerCase().contains(value.toLowerCase()) ||
            salon.services.any(
              (service) =>
                  service.name.toLowerCase().contains(value.toLowerCase()) ||
                  service.category.name.toLowerCase().contains(
                    value.toLowerCase(),
                  ),
            ) ||
            salon.address.region.toLowerCase().contains(value.toLowerCase()) ||
            salon.address.city.toLowerCase().contains(value.toLowerCase());
      }).toList();
      state = state.copyWith(filteredSalons: filtered);
    }
  }
}

final selectedFilterProvider = StateProvider<String>((ref) {
  return '';
});

final salonsNearYouProvider = FutureProvider<List<SalonModel>>((ref) async {
  var user = ref.watch(currentUserProvider).user;
  var userAddress = user?.address;
  var salons = ref.watch(salonProvider).salons;
  List<SalonModel> salonsNearYou = [];
  // Filter salons based on user's location
  if (userAddress != null) {
    for (var salon in salons) {
      var distance = Geolocator.distanceBetween(
        double.parse(userAddress.latitude),
        double.parse(userAddress.longitude),
        double.parse(salon.address.latitude),
        double.parse(salon.address.longitude),
      );
      if (distance <= 5000) {
        // 5 km radius
        salonsNearYou.add(salon);
      }
    }
  } else {
    salonsNearYou = salons; // If no user address, return all salons
  }

  return salonsNearYou;
});

final topRatedSalonsProvider = FutureProvider<List<SalonModel>>((ref) async {
  List<MapEntry<SalonModel, double>> salonAndRatings = [];
  var allSalons = ref.watch(salonProvider).salons;
  for (var salon in allSalons) {
    double ratingsStream = await RatingServices.getAverageRating(salon.id);
    salonAndRatings.add(MapEntry(salon, ratingsStream));
  }
  salonAndRatings.sort((a, b) => b.value.compareTo(a.value));
  var topRatedSalons = salonAndRatings.take(5).map((e) => e.key).toList();
  return topRatedSalons;
});
