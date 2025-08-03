import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salon_finder/app/data/user_model.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/login_model.dart';

class AuthServices {
  static Future<({User? user,String message})> register({
    required UserModel user,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password!,
          );
      final User? firebaseUser = credential.user;
      if (firebaseUser != null) {
        //send email verification
        await firebaseUser.sendEmailVerification();
        user.id = firebaseUser.uid;
        user.createdAt = DateTime.now();
        user.password = null; // Clear password after registration
        // Here you would typically save the user to your database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set(user.toMap());
        return (user: firebaseUser, message: 'Registration successful');
      } else {
        return (user: null, message: 'Registration failed');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return (user: null, message: 'The password provided is too weak.');
      } else if (e.code == 'invalid-email') {
        return (user: null, message: 'The email address is not valid.');
      } else if (e.code == 'email-already-in-use') {
        return (user: null, message: 'The account already exists for that email.');
      }
    } catch (e) {
      return (user: null, message: e.toString());
    }
    return (user: null, message: 'An unknown error occurred.');
  }

  static Future<({UserModel? user,String message})> login({
    required LoginModel login,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: login.email,
        password: login.password,
      );
      final User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        return (user: null, message: 'Login failed');
      } else if (!firebaseUser.emailVerified) {
        //send email verification
       // await firebaseUser.sendEmailVerification();
        return (user: null, message: 'Please verify your email before logging in.');
      }
      // Fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (!userDoc.exists) {
        return (user: null, message: 'User not found');
      }

      final userData = userDoc.data();
      var user = userData != null ? UserModel.fromMap(userData) : null;
      if (user == null) {
        return (user: null, message: 'User data is null');
      }
      //save user as json in shared preferences or any local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user.toJson());
      return (user: user, message: 'Login successful');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return (user: null, message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return (user: null, message: 'Wrong password provided.');
      }
    } catch (e) {
      return (user: null, message: e.toString());
    }
    return (user: null, message: 'An unknown error occurred.');
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // Clear user data from local storage
  }

  static Future<UserModel?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      return UserModel.fromJson(userJson);
    }
    return null; // No user is logged in
  }

  static Future<void> sendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      CustomDialog.showErrorDialog(
        message: 'Failed to send verification email: ${e.toString()}',
      );
    }
  }
}