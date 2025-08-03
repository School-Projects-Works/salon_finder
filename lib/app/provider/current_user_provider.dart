import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:salon_finder/app/data/user_model.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import 'package:salon_finder/app/ui/pages/auth_page/welcome_page.dart';

import '../services/auth_services.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, UserModel?>(
      (ref) => CurrentUserNotifier(ref),
    );

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  CurrentUserNotifier(this.ref) : super(null);
  final Ref ref;

  void setCurrentUser(UserModel user) {
    state = user;
  }

  void logout({required BuildContext context}) async {
    CustomDialog.loading();
    await AuthServices.logout();
    CustomDialog.closeDialog();
    state = null; // Clear the current user state
    CustomDialog.showSnackBar(message: 'Logged out successfully');
    // Optionally, navigate to the login page or home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }

  UserModel? get currentUser => state;
}

final checkUserExistsProvider = FutureProvider<UserModel?>((ref) async {
  final user = await AuthServices.getCurrentUser();
  if (user == null) {
    return null; // No user is logged in
  }
  ref.read(currentUserProvider.notifier).setCurrentUser(user);
  return user;
});
