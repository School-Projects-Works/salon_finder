import 'package:salon_finder/app/data/salon_model.dart';

class NewSalonState {
  final SalonModel salon;
  final int step;

  NewSalonState({required this.salon, this.step = 0});

  NewSalonState copyWith({SalonModel? salon, int? step}) {
    return NewSalonState(salon: salon ?? this.salon, step: step ?? this.step);
  }
}
