// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:salon_finder/app/data/appointment_model.dart';

class AppointmentDataModel {
  List<AppointmentModel> userApps;
  List<AppointmentModel> salonApps;
  List<AppointmentModel> userFilteredApps;
  List<AppointmentModel> salonFilteredApps; 

  AppointmentDataModel({
    required this.userApps,
    required this.salonApps,
    required this.userFilteredApps,
    required this.salonFilteredApps,
  });

  factory AppointmentDataModel.initial() {
    return AppointmentDataModel(
      userApps: [],
      salonApps: [],
      userFilteredApps: [],
      salonFilteredApps: [],
    );
  }

  AppointmentDataModel copyWith({
    List<AppointmentModel>? userApps,
    List<AppointmentModel>? salonApps,
    List<AppointmentModel>? userFilteredApps,
    List<AppointmentModel>? salonFilteredApps,
  }) {
    return AppointmentDataModel(
      userApps: userApps ?? this.userApps,
      salonApps: salonApps ?? this.salonApps,
      userFilteredApps: userFilteredApps ?? this.userFilteredApps,
      salonFilteredApps: salonFilteredApps ?? this.salonFilteredApps,
    );
  }
}
