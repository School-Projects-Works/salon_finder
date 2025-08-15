import 'package:riverpod/riverpod.dart';
import 'package:salon_finder/app/data/transactions_model.dart';
import 'package:salon_finder/app/services/appointment_services.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';

import '../data/appointment_model.dart';

final selectedAppointmentProvider =
    StateNotifierProvider<SelectedAppointmentNotifier, AppointmentModel>((ref) {
      return SelectedAppointmentNotifier();
    });

class SelectedAppointmentNotifier extends StateNotifier<AppointmentModel> {
  SelectedAppointmentNotifier() : super(AppointmentModel.initial());

  void selectAppointment(AppointmentModel appointment) {
    state = appointment;
  }

  void clearSelection() {
    state = AppointmentModel.initial();
  }

  void updatePaymentStatus({required TransactionsModel newTransaction}) async{
    CustomDialog.loading();
    var response = await AppointmentServices.updateTransaction(newTransaction);
    if (response) {
      CustomDialog.closeDialog();
      CustomDialog.showSnackBar(message: 'Payment status updated successfully');
    } else {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: 'Failed to update payment status');
    }
  }

  void updateStatus({required String status, required TransactionsModel newTransaction}) async {
    CustomDialog.loading();
    var app = state.copyWith(status: status);
    var response = await AppointmentServices.updateApp(app);
    if(app.status=="Cancelled"){
      //update transaction status
      await AppointmentServices.updateTransaction(newTransaction.copyWith(status: 'Refunded'));
    }else if(app.status=="Completed"){
      //update transaction status
      await AppointmentServices.updateTransaction(newTransaction.copyWith(status: 'Paid'));
    }
    if (response) {
      state = app;
      CustomDialog.closeDialog();
      CustomDialog.showSnackBar(message: 'Status updated successfully');
    } else {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: 'Failed to update status');
    }
  }
}
