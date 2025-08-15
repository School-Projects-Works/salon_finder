import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/data/address_model.dart';
import 'package:salon_finder/app/data/salon_model.dart';
import 'package:salon_finder/app/data/user_model.dart';
import 'package:salon_finder/app/services/salon_services.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import 'package:salon_finder/app/ui/pages/auth_page/welcome_page.dart';
import '../services/auth_services.dart';

final currentUserProvider =
    StateNotifierProvider<
      CurrentUserNotifier,
      ({UserModel? user, List<SalonModel>? salons})
    >((ref) => CurrentUserNotifier(ref));

class CurrentUserNotifier
    extends StateNotifier<({UserModel? user, List<SalonModel>? salons})> {
  CurrentUserNotifier(this.ref) : super((user: null, salons: null));
  final Ref ref;

  void setCurrentUser(UserModel user) async {
    var salons = await SalonServices.getSalonsByOwnerId(user.id);
    state = (user: user, salons: salons);
  }

  void logout({required BuildContext context}) async {
    CustomDialog.loading();
    await AuthServices.logout();
    CustomDialog.closeDialog();
    state = (user: null, salons: null); // Clear the current user state
    CustomDialog.showSnackBar(message: 'Logged out successfully');
    // Optionally, navigate to the login page or home page
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomePage()),
      (route) => false,
    );
  }

  UserModel? get currentUser => state.user;
  List<SalonModel> get currentSalons => state.salons ?? [];

  void setWhatsApp(String whatsapp) {
    var user = state.user;
    if (user != null) {
      user.whatsapp = whatsapp;
      state = (user: user, salons: state.salons);
    }
  }

  void setPhone(String phone) {
    var user = state.user;
    if (user != null) {
      user.phoneNumber = phone;
      state = (user: user, salons: state.salons);
    }
  }

  void setName(String name) {
    var user = state.user;
    if (user != null) {
      user.name = name;
      state = (user: user, salons: state.salons);
    }
  }

  void setStreet({required String street}) {
    var user = state.user;
    if (user != null) {
      var userAddress = user.address ?? AddressModel.initial();
      userAddress = userAddress.copyWith(street: street);
      state = (user: user.copyWith(address: userAddress), salons: state.salons);
    }
  }

  void setCity({required String city}) {
    var user = state.user;
    if (user != null) {
      var userAddress = user.address ?? AddressModel.initial();
      userAddress = userAddress.copyWith(city: city);
      state = (user: user.copyWith(address: userAddress), salons: state.salons);
    }
  }

  void setRegion({required String region}) {
    var user = state.user;
    if (user != null) {
      var userAddress = user.address ?? AddressModel.initial();
      userAddress = userAddress.copyWith(region: region);
      state = (user: user.copyWith(address: userAddress), salons: state.salons);
    }
  }

  void setCountry({required String country}) {
    var user = state.user;
    if (user != null) {
      var userAddress = user.address ?? AddressModel.initial();
      userAddress = userAddress.copyWith(country: country);
      state = (user: user.copyWith(address: userAddress), salons: state.salons);
    }
  }

  void setLat({required String lat}) {
    var user = state.user;
    if (user != null) {
      var userAddress = user.address ?? AddressModel.initial();
      userAddress = userAddress.copyWith(latitude: lat);
      state = (user: user.copyWith(address: userAddress), salons: state.salons);
    }
  }

  void setLng({required String lng}) {
    var user = state.user;
    if (user != null) {
      var userAddress = user.address ?? AddressModel.initial();
      userAddress = userAddress.copyWith(longitude: lng);
      state = (user: user.copyWith(address: userAddress), salons: state.salons);
    }
  }

  void updateUser({File? image, required WidgetRef ref}) async {
    CustomDialog.loading();
    var response = await AuthServices.updateUser(
      user: state.user,
      image: image,
    );

    if (response.status) {
      state = (user: response.user, salons: state.salons);
      CustomDialog.closeDialog();
      CustomDialog.showSnackBar(message: response.message);
    } else {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: response.message);
    }
  }
}

final checkUserExistsProvider = FutureProvider<UserModel?>((ref) async {
  final user = await AuthServices.getCurrentUser();
  if (user == null) {
    return null; // No user is logged in
  }
  // var salonList = SaloonModel.dummySalons();
  // for (var salon in salonList) {
  //   // var id = SalonServices.generateSalonId();
  //   // salon.id = id;
  //   // salon.salonOwnerId = user.id;
  //   await SalonServices.createSalon(salon);
  // }
  ref.read(currentUserProvider.notifier).setCurrentUser(user);
  return user;
});
