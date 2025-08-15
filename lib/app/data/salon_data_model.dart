import 'package:salon_finder/app/data/salon_model.dart';

class SalonDataModel {
  List<SalonModel> salons;
  List<SalonModel> filteredSalons;

  SalonDataModel({required this.salons, required this.filteredSalons});

  //copy with
  SalonDataModel copyWith({
    List<SalonModel>? salons,
    List<SalonModel>? salonsNearYou,
    List<SalonModel>? topRatedSalons,
    List<SalonModel>? filteredSalons,
  }) {
    return SalonDataModel(
      salons: salons ?? this.salons,

      filteredSalons: filteredSalons ?? this.filteredSalons,
    );
  }

  static SalonDataModel empty() {
    return SalonDataModel(salons: [], filteredSalons: []);
  }
}
