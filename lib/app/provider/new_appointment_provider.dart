import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:salon_finder/app/data/appointment_model.dart';
import 'package:salon_finder/app/data/services_model.dart';
import 'package:salon_finder/app/data/transactions_model.dart';
import 'package:salon_finder/app/provider/current_user_provider.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import 'package:salon_finder/app/ui/pages/auth_page/login_page.dart';

import '../data/salon_model.dart';
import '../services/appointment_services.dart';

final newAppointmentProvider =
    StateNotifierProvider<NewAppointmentNotifier, AppointmentModel>(
      (ref) => NewAppointmentNotifier(),
    );

class NewAppointmentNotifier extends StateNotifier<AppointmentModel> {
  NewAppointmentNotifier() : super(AppointmentModel.initial());

  void setSalon(SalonModel salon) {
    state = state.copyWith(saloon: salon);
  }

  void clear() {
    state = AppointmentModel.initial();
  }

  void toggleService(ServicesModel service) {
    if (state.services.contains(service)) {
      state = state.copyWith(
        services: List.from(state.services)..remove(service),
      );
    } else {
      state = state.copyWith(services: List.from(state.services)..add(service));
    }
    var totalAmount = state.services.fold<double>(
      0,
      (previousValue, service) => previousValue + service.price,
    );
    state = state.copyWith(totalPrice: totalAmount);
  }

  void setDate(int millisecondsSinceEpoch) {
    state = state.copyWith(date: millisecondsSinceEpoch);
  }

  void setTime(int millisecondsSinceEpoch) {
    state = state.copyWith(time: millisecondsSinceEpoch);
  }

  void setNotes(String value) {
    state = state.copyWith(userNote: value);
  }

  void bookAppointment({
    required SalonModel salon,
    required WidgetRef ref,
    required String payType,
    required BuildContext context,
  }) async {
    CustomDialog.loading();
    try {
      setSalon(salon);
      var user = ref.watch(currentUserProvider).user;
      if (user == null) {
        CustomDialog.closeDialog();
        CustomDialog.showErrorDialog(message: 'User not found, please log in.');
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LoginPage()));
        return;
      }
      if (salon.salonOwnerId == user.id) {
        CustomDialog.closeDialog();
        CustomDialog.showErrorDialog(
          message: 'You cannot book an appointment for your own salon.',
        );
        return;
      }

      if (user.address == null) {
        CustomDialog.closeDialog();
        CustomDialog.showErrorDialog(
          message:
              'Please set your address first to be able to book an appointment.',
        );
        return;
      }

      if (user.profilePictureUrl.isEmpty) {
        CustomDialog.closeDialog();
        CustomDialog.showErrorDialog(
          message:
              'Please set your profile picture first to be able to book an appointment.',
        );
        return;
      }
      //check if user has a pending appointment with same salon
      AppointmentModel? userAppWithSalon =
          await AppointmentServices.getUserPendingAppointmentWithSalon(
            userId: user.id,
            salonId: salon.id,
          );
      if (userAppWithSalon != null) {
        CustomDialog.closeDialog();
        CustomDialog.showErrorDialog(
          message: 'You have a pending appointment with this salon.',
        );
        return;
      }

      if (payType == "Pay Online") {
        // Handle online payment
        final uniqueTransRef = PayWithPayStack().generateUuidV4();
        CustomDialog.closeDialog();
        PayWithPayStack().now(
          context: context,
          secretKey: "sk_test_422a72101187d3e0229adc06b4e8d9ece30c6d36",
          customerEmail: user.email,
          reference: uniqueTransRef.isEmpty
              ? DateTime.now().millisecondsSinceEpoch.toString()
              : uniqueTransRef,
          currency: "GHS",
          amount: state.totalPrice, // Convert to smallest currency unit
          callbackUrl: "https://google.com",
          transactionCompleted: (paymentData) async {
            var transaction = TransactionsModel.initial();
            var appId = AppointmentServices.getAppointmentId();
            var newAppointment = state.copyWith(
              paymentMethod: paymentData.channel,
              id: appId,
              saloon: salon,
              userId: user.id,
              salonId: salon.id,
              user: user,
              status: "Pending",
              createdAt: DateTime.now().millisecondsSinceEpoch,
            );
            transaction = transaction.copyWith(
              id: AppointmentServices.getTransactionId(),
              appointmentId: appId,
              amount: state.totalPrice,
              paymentMethod: paymentData.channel,
              userId: user.id,
              salonId: salon.id,
              reference: paymentData.reference,
              status: "Completed",
              createdAt: DateTime.now().millisecondsSinceEpoch,
            );
            var result = await AppointmentServices.createAppointment(
              appointment: newAppointment,
              transaction: transaction,
            );
            if (result.status) {
              clear();
              Navigator.of(context).pop();
              CustomDialog.closeDialog();
              CustomDialog.showSuccessDialog(message: result.message);
            } else {
              CustomDialog.closeDialog();
              CustomDialog.showErrorDialog(message: result.message);
            }
          },
          transactionNotCompleted: (reason) {
            debugPrint("==> Transaction failed reason $reason");

            CustomDialog.closeDialog();
            CustomDialog.showErrorDialog(message: 'Payment failed: $reason');
            return;
          },
        );
      } else {
        var transaction = TransactionsModel.initial();
        var appId = AppointmentServices.getAppointmentId();
        var newAppointment = state.copyWith(
          paymentMethod: 'Cash',
          id: appId,
          saloon: salon,
          userId: user.id,
          salonId: salon.id,
          user: user,
          status: "Pending",
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        transaction = transaction.copyWith(
          id: AppointmentServices.getTransactionId(),
          appointmentId: appId,
          amount: state.totalPrice,
          paymentMethod: 'Cash',
          userId: user.id,
          salonId: salon.id,
          reference: 'Cash Payment',
          status: "Pending",
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        var result = await AppointmentServices.createAppointment(
          appointment: newAppointment,
          transaction: transaction,
        );
        if (result.status) {
          clear();
          Navigator.of(context).pop();
          CustomDialog.closeDialog();
          CustomDialog.showSuccessDialog(message: result.message);
        } else {
          CustomDialog.closeDialog();
          CustomDialog.showErrorDialog(message: result.message);
        }
      }
    } catch (e) {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: 'Failed to book appointment: $e');
    }
  }
}
