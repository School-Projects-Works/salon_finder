import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_finder/app/data/appointment_model.dart';
import 'package:salon_finder/app/data/transactions_model.dart';

class AppointmentServices {
  // Define methods for appointment-related operations here
  static final CollectionReference appointmentsCollection = FirebaseFirestore
      .instance
      .collection('appointments');
  static final CollectionReference transactionCollection = FirebaseFirestore
      .instance
      .collection('transactions');

  static String getAppointmentId() {
    return appointmentsCollection.doc().id;
  }

  static String getTransactionId() {
    return transactionCollection.doc().id;
  }

  static Future<({String message, bool status})> createAppointment({
    required AppointmentModel appointment,
    required TransactionsModel transaction,
  }) async {
    try {
      // Create a new appointment document
      await appointmentsCollection.doc(appointment.id).set(appointment.toMap());

      // Create a new transaction document
      await transactionCollection.doc(transaction.id).set(transaction.toMap());

      return (message: 'Appointment created successfully', status: true);
    } catch (e) {
      return (message: 'Failed to create appointment: $e', status: false);
    }
  }

  //get stream of appointment
  static Stream<List<AppointmentModel>> getAppointmentsForUser(String id) {
    //find user or salon
    return appointmentsCollection
        .where('userId', isEqualTo: id)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => AppointmentModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();
        });
  }

  static Future<List<AppointmentModel>> getAppointmentByUserId(
    String id,
  ) async {
    try {
      var snapshot = await appointmentsCollection
          .where('userId', isEqualTo: id)
          .get();
      return snapshot.docs
          .map(
            (doc) =>
                AppointmentModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<AppointmentModel>> getAppointmentsForSalons(
    String id,
  ) async {
    try {
      var snapshot = await appointmentsCollection
          .where('salonId', isEqualTo: id)
          .get();
      return snapshot.docs
          .map(
            (doc) =>
                AppointmentModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<TransactionsModel?> getTransactionByAppointmentId(
    String appId,
  ) async {
    try {
      var snapshot = await transactionCollection
          .where('appointmentId', isEqualTo: appId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return TransactionsModel.fromMap(
          snapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<AppointmentModel?> getUserPendingAppointmentWithSalon({
    required String userId,
    required String salonId,
  }) async {
    try {
      var snapshot = await appointmentsCollection
          .where('userId', isEqualTo: userId)
          .where('salonId', isEqualTo: salonId)
          .where('status', isEqualTo: 'Pending')
          .get();
      if (snapshot.docs.isNotEmpty) {
        return AppointmentModel.fromMap(
          snapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<bool> updateApp(AppointmentModel app) async {
    try {
      await appointmentsCollection.doc(app.id).update(app.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateTransaction(TransactionsModel newTransaction) async {
    try {
      await transactionCollection.doc(newTransaction.id).update(newTransaction.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasPendingAppointments(String id) async {
    try {
      var snapshot = await appointmentsCollection
          .where('salonId', isEqualTo: id)
          .where('status', whereIn: ['Pending', 'Accepted'])
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getPendingAppsForUserAndSalon(String userId, String salonId) async {
    try {
      var snapshot = await appointmentsCollection
          .where('userId', isEqualTo: userId)
          .where('salonId', isEqualTo: salonId)
          .where('status', whereIn: ['Pending', 'Accepted'])
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

