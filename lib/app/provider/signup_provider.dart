import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:salon_finder/app/data/user_model.dart';
import 'package:salon_finder/app/services/auth_services.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import '../ui/pages/auth_page/login_page.dart';

final signUpProvider = StateNotifierProvider<SignUpNotifier, UserModel>(
  (ref) => SignUpNotifier(ref),
);

class SignUpNotifier extends StateNotifier<UserModel> {
  SignUpNotifier(this.ref) : super(UserModel.initial());
  final Ref ref;

  setName(String name) {
    state = state.copyWith(name: name);
  }

  setEmail(String email) {
    state = state.copyWith(email: email);
  }

  setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void clear() {
    state = UserModel.initial();
  }

  void register({required BuildContext context}) async {
    CustomDialog.loading();
    var registerData = await AuthServices.register(user: state);
    if (registerData.user != null) {
      // Registration successful
      CustomDialog.closeDialog();

      CustomDialog.showSnackBar(message: registerData.message);
      //navigate to the home page or any other page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Registration failed
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: registerData.message);
    }
  }
}
