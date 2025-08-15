import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_finder/app/data/appointment_model.dart';
import 'package:salon_finder/app/data/transactions_model.dart';
import 'package:salon_finder/app/data/user_model.dart';

import '../../data/salon_model.dart';

class AdminServices {
  static final CollectionReference users = FirebaseFirestore.instance
      .collection('users');
  static final CollectionReference transactions = FirebaseFirestore.instance
      .collection('transactions');
  static final CollectionReference appointments = FirebaseFirestore.instance
      .collection('appointments');
  static final CollectionReference salons = FirebaseFirestore.instance
      .collection('salons');
  static Stream<List<UserModel>> getUsers() {
    try {
      return users.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;

          return UserModel.fromMap(data);
        }).toList(),
      );
    } catch (e) {
      return const Stream.empty();
    }
  }

  static Stream<List<TransactionsModel>> getTransactions() {
    return transactions.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                TransactionsModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  //get stream of appointments
  static Stream<List<AppointmentModel>> getAppointments() {
    return appointments.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                AppointmentModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  //get stream of salons
  static Stream<List<SalonModel>> getSalons() {
    return salons.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                SalonModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  //update user
  static Future<bool> updateUser(UserModel user) async {
    try {
      await users.doc(user.id).update(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }


  static String getUserId() {
    return users.doc().id;
  }

  static createUser(UserModel user) async {
    await users.doc(user.id).set(user.toMap());
  }

  static Future<bool> updateSalon(SalonModel copyWith) async {
    try {
      await salons.doc(copyWith.id).update(copyWith.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
