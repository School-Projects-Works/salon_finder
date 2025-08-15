import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/data/contact_model.dart';
import 'package:salon_finder/app/data/new_salon_state.dart';
import 'package:salon_finder/app/data/salon_model.dart';
import 'package:salon_finder/app/data/salon_open_close_model.dart';
import 'package:salon_finder/app/provider/current_user_provider.dart';
import 'package:salon_finder/app/services/appointment_services.dart';
import 'package:salon_finder/app/services/salon_services.dart';

import '../data/services_model.dart';
import '../ui/global_widgets/custom_dialog.dart';

final editSalonProvider =
    StateNotifierProvider<EditSalonNotifier, NewSalonState>(
      (ref) => EditSalonNotifier(),
    );

class EditSalonNotifier extends StateNotifier<NewSalonState> {
  EditSalonNotifier() : super(NewSalonState(salon: SalonModel.initial()));
  void setSalon(SalonModel salon) {
    state = state.copyWith(salon: salon);
  }

  void updateImage(String imagePath) {
    state = state.copyWith(salon: state.salon.copyWith(imageUrl: imagePath));
  }

  void updateName(String name) {
    state = state.copyWith(salon: state.salon.copyWith(name: name));
  }

  void updateDescription(String description) {
    state = state.copyWith(
      salon: state.salon.copyWith(description: description),
    );
  }

  void updateContact(ContactModel contact) {
    state = state.copyWith(salon: state.salon.copyWith(contact: contact));
  }

  void nextStep() {
    state = state.copyWith(step: state.step + 1);
  }

  void prevStep() {
    state = state.copyWith(step: state.step - 1);
  }

  void setOpenClose(List<SalonOpenCloseModel> list) {
    state = state.copyWith(salon: state.salon.copyWith(openCloseHours: list));
  }

  void removeServiceAt(int idx) {
    var services = List<ServicesModel>.from(state.salon.services);
    if (idx < 0 || idx >= services.length) return;
    services.removeAt(idx);
    state = state.copyWith(salon: state.salon.copyWith(services: services));
  }

  void addOrUpdateService(ServicesModel svc) {
    //check if service with same name do not exist
    var services = List<ServicesModel>.from(state.salon.services);
    var existingService = services.where((s) => s.name == svc.name).firstOrNull;
    if (existingService != null) {
      // Update existing service
      services[services.indexOf(existingService)] = svc;
    } else {
      // Add new service
      services.add(svc);
    }
    state = state.copyWith(salon: state.salon.copyWith(services: services));
  }

  void setLat({required String lat}) {
    var address = state.salon.address.copyWith(latitude: lat);
    state = state.copyWith(salon: state.salon.copyWith(address: address));
  }

  void setLng({required String lng}) {
    var address = state.salon.address.copyWith(longitude: lng);
    state = state.copyWith(salon: state.salon.copyWith(address: address));
  }

  void setCity({required String city}) {
    var address = state.salon.address.copyWith(city: city);
    state = state.copyWith(salon: state.salon.copyWith(address: address));
  }

  void setCountry({required String country}) {
    var address = state.salon.address.copyWith(country: country);
    state = state.copyWith(salon: state.salon.copyWith(address: address));
  }

  void setRegion({required String region}) {
    var address = state.salon.address.copyWith(region: region);
    state = state.copyWith(salon: state.salon.copyWith(address: address));
  }

  void setStreet({required String street}) {
    var address = state.salon.address.copyWith(street: street);
    state = state.copyWith(salon: state.salon.copyWith(address: address));
  }

  void setEmail({required String email}) {
    var contact = state.salon.contact.copyWith(email: email);
    state = state.copyWith(salon: state.salon.copyWith(contact: contact));
  }

  void setPhone({required String phone}) {
    var contact = state.salon.contact.copyWith(phoneNumber: phone);
    state = state.copyWith(salon: state.salon.copyWith(contact: contact));
  }

  Future<void> updateSalon({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    CustomDialog.loading();
    var user = ref.watch(currentUserProvider).user;
    if (user == null) {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: 'User not found');
      return;
    }
    if (state.salon.openCloseHours.isEmpty) {
      var defaultOpenAndClose = SalonOpenCloseModel.defaultData();
      state = state.copyWith(
        salon: state.salon.copyWith(openCloseHours: defaultOpenAndClose),
      );
    }
    var response = await SalonServices.updateSalon(state.salon);
    if (response.success) {
      CustomDialog.closeDialog();
      CustomDialog.showSnackBar(message: response.message);
      ref.read(currentUserProvider.notifier).setCurrentUser(user);
      state = NewSalonState(salon: SalonModel.initial(), step: 0);
      Navigator.pop(context);
    } else {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: response.message);
    }
  }

  void deleteSalon({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    CustomDialog.loading();
     var user = ref.watch(currentUserProvider).user;
    if (user == null) {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: 'User not found');
      return;
    }
    //check if salon has a pending or accepted appointment 
    var hasPendingAppointments = await AppointmentServices.hasPendingAppointments(
      state.salon.id,
    );
    if (hasPendingAppointments) {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(
        message: 'Cannot delete salon with pending appointments',
      );
      return;
    }

    var response = await SalonServices.deleteSalon(state.salon.id);
   
    if (response.success) {
      CustomDialog.closeDialog();
      CustomDialog.showSnackBar(message: response.message);
      ref.read(currentUserProvider.notifier).setCurrentUser(user);
      state = NewSalonState(salon: SalonModel.initial(), step: 0);
      Navigator.pop(context);
    } else {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: response.message);
    }
  }
}
