import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:salon_finder/app/data/login_model.dart';

import '../services/auth_services.dart';
import '../ui/global_widgets/custom_dialog.dart';
import '../ui/pages/home_page/home_page.dart';
import 'current_user_provider.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginModel>(
  (ref) => LoginNotifier(ref),
);

class LoginNotifier extends StateNotifier<LoginModel> {
  LoginNotifier(this.ref) : super(LoginModel.initial());
  final Ref ref;

  setEmail(String email) {
    state = state.copyWith(email: email);
  }

  setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void clear() {
    state = LoginModel.initial();
  }

  void login({required BuildContext context}) async {
    CustomDialog.loading();
    var loginData = await AuthServices.login(login: state);
    if (loginData.user != null) {
      // Login successful
      ref.read(currentUserProvider.notifier).setCurrentUser(loginData.user!);
      CustomDialog.closeDialog();
      CustomDialog.showSnackBar(message: loginData.message);
      // Navigate to the home page or any other page
       Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } else {
      // Login failed
      CustomDialog.closeDialog();
      if (loginData.message.contains('verify')) {
        CustomDialog.showConfirmationDialog(
          content: 'Please verify your email before logging in.',
          title: 'Email Verification',
          onConfirm: () async {
            // Optionally, you can send a verification email again
            await AuthServices.sendVerificationEmail();
            CustomDialog.closeDialog();
          },
        );
      } else {
        CustomDialog.showErrorDialog(message: loginData.message);
      }
    }
  }
}
