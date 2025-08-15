import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/data/appointment_data_model.dart';
import 'package:salon_finder/app/data/appointment_model.dart';
import 'package:salon_finder/app/provider/current_user_provider.dart';
import 'package:salon_finder/app/services/appointment_services.dart';

final appointmentStream = StreamProvider.autoDispose<List<AppointmentModel>>((ref)async* {
  var user = ref.watch(currentUserProvider).user;
  var salons = ref.watch(currentUserProvider).salons;
  List<AppointmentModel> appointments = [];
  if(user != null) {
   List<AppointmentModel> userList = await AppointmentServices.getAppointmentByUserId(user.id);
   ref.read(appointmentProvider.notifier).setUserAppointments(userList);
   appointments.addAll(userList);
  }
  if (salons != null && salons.isNotEmpty) {
    for (var salon in salons) {
      List<AppointmentModel> salonAppointments = await AppointmentServices.getAppointmentsForSalons(salon.id);
      ref.read(appointmentProvider.notifier).setSalonAppointments(salonAppointments);
      appointments.addAll(salonAppointments);
    }
  }
  yield appointments;
});


final appointmentProvider = StateNotifierProvider<AppointmentNotifier, AppointmentDataModel>(
  (ref) => AppointmentNotifier(),
);


class AppointmentNotifier extends StateNotifier<AppointmentDataModel> {
  AppointmentNotifier() : super(AppointmentDataModel.initial());

  void setUserAppointments(List<AppointmentModel> appointments) {
    state = state.copyWith(userApps: appointments);
  }

  void setSalonAppointments(List<AppointmentModel> appointments) {
    state = state.copyWith(salonApps: appointments);
  }
 
}
