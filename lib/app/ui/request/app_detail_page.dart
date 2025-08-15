import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_finder/app/data/transactions_model.dart';
import 'package:salon_finder/app/provider/current_user_provider.dart';
import 'package:salon_finder/app/services/appointment_services.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_button.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';
import '../../data/appointment_model.dart';
import '../../data/services_model.dart';
import '../../provider/selected_appointment_provider.dart';
import '../../services/helper_functions.dart';

class AppointmentDetailsPage extends ConsumerStatefulWidget {
  const AppointmentDetailsPage({super.key});

  @override
  ConsumerState<AppointmentDetailsPage> createState() =>
      _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState
    extends ConsumerState<AppointmentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var appt = ref.watch(selectedAppointmentProvider);
    final isSalon = appt.userId != ref.watch(currentUserProvider).user?.id;
    return FutureBuilder<TransactionsModel?>(
      future: _getAppTransaction(appt.id),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (asyncSnapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${asyncSnapshot.error}')),
          );
        }
        final transaction = asyncSnapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Appointment Details'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: _statusChip(status: appt.status),
              ),
            ],
          ),
          bottomNavigationBar: _actionBar(
            appt: appt,
            isSalon: isSalon,
            transaction: transaction,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _salonCard(appt: appt, isSalon: isSalon),
                // const SizedBox(height: 10),
                _clientCard(appt: appt, isSalon: isSalon),
                // const SizedBox(height: 10),
                _servicesCard(services: appt.services, total: appt.totalPrice),
                // const SizedBox(height: 12),
                _paymentCard(
                  appointment: appt,
                  transaction: transaction ?? TransactionsModel.initial(),
                  isSalon: isSalon,
                ),
                _dateCard(appointment: appt),
                // if ((appt.userNote ?? '').trim().isNotEmpty) ...[
                // const SizedBox(height: 12),
                _userNoteCard(note: appt.userNote.trim()),
              ],
              // ],
            ),
          ),
        );
      },
    );
  }

  void _handleStatusChange(String newStatus) {}
  Future<TransactionsModel?> _getAppTransaction(String appId) async {
    try {
      final data = await AppointmentServices.getTransactionByAppointmentId(
        appId,
      );
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Widget _clientCard({required AppointmentModel appt, required bool isSalon}) {
    var user = appt.user;
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(appt.saloon.imageUrl),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Client", style: AppTextStyles.subtitle1()),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(user.email),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(user.phoneNumber)),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => launchTel(user.phoneNumber),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.phone,
                                color: AppColors.primaryColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Text('$dateStr • $timeStr'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _salonCard({required AppointmentModel appt, required bool isSalon}) {
    // final dateStr = DateFormat(
    //   'EEE, MMM d, yyyy',
    // ).format(DateTime.fromMillisecondsSinceEpoch(appt.date));
    // final timeStr = DateFormat(
    //   'h:mm a',
    // ).format(DateTime.fromMillisecondsSinceEpoch(appt.date));
    // var user = appt.user;
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(appt.saloon.imageUrl),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt.saloon.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${appt.saloon.address.city}, ${appt.saloon.address.region}',
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (!isSalon)
                            InkWell(
                              onTap: () => launchMap(
                                appt.saloon.address.latitude,
                                appt.saloon.address.longitude,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.pin_drop,
                                  color: AppColors.primaryColor,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              appt.saloon.contact.phoneNumber.toString(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () =>
                                launchTel(appt.saloon.contact.phoneNumber),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.phone,
                                color: AppColors.primaryColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentCard({
    required AppointmentModel appointment,
    required TransactionsModel transaction,
    required bool isSalon,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Payment', style: Theme.of(context).textTheme.titleMedium),
                _statusChip(status: transaction.status),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Method: ${labelize(transaction.paymentMethod)} |'),
                if (!isSalon &&
                    !transaction.paymentMethod.contains('Online') &&
                    appointment.status != 'Cancelled') ...[
                  const SizedBox(width: 5),
                  Text(
                    "Mark:",
                    style: AppTextStyles.body(color: AppColors.primaryColor),
                  ),
                  if (transaction.status == 'Pending' ||
                      transaction.status == 'Unpaid')
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 5,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        CustomDialog.showConfirmationDialog(
                          title: 'Update Payment Status',
                          content:
                              'Are you sure you want to mark this payment as paid?',
                          onConfirm: () {
                            ref
                                .read(selectedAppointmentProvider.notifier)
                                .updatePaymentStatus(
                                  newTransaction: transaction.copyWith(
                                    status: 'Paid',
                                  ),
                                );
                          },
                        );
                      },
                      child: Text("Paid"),
                    ),
                  if (transaction.status == 'Paid') ...[
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 5,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          CustomDialog.showConfirmationDialog(
                            title: 'Update Payment Status',
                            content:
                                'Are you sure you want to mark this payment as unpaid?',
                            onConfirm: () {
                              ref
                                  .read(selectedAppointmentProvider.notifier)
                                  .updatePaymentStatus(
                                    newTransaction: transaction.copyWith(
                                      status: 'Pending',
                                    ),
                                  );
                            },
                          );
                        },
                        child: Text("UnPaid"),
                      ),
                    ),
                    const Text(" | "),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 5,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          CustomDialog.showConfirmationDialog(
                            title: 'Update Payment Status',
                            content:
                                'Are you sure you want to mark this payment as refunded?',
                            onConfirm: () {
                              ref
                                  .read(selectedAppointmentProvider.notifier)
                                  .updatePaymentStatus(
                                    newTransaction: transaction.copyWith(
                                      status: 'Refunded',
                                    ),
                                  );
                            },
                          );
                        },
                        child: Text("Refund"),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateCard({required AppointmentModel appointment}) {
    final dateStr = DateFormat(
      'EEE, MMM d, yyyy',
    ).format(DateTime.fromMillisecondsSinceEpoch(appointment.date));
    final timeStr = DateFormat(
      'h:mm a',
    ).format(DateTime.fromMillisecondsSinceEpoch(appointment.date));
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Appointment Date',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$dateStr • $timeStr',
              style: AppTextStyles.body(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userNoteCard({required String note}) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Client note',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.isEmpty ? 'No note provided' : note,
              style: AppTextStyles.body(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _servicesCard({
    required List<ServicesModel> services,
    required double total,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Services', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...services.map(
              (s) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(s.category.imageUrl),
                ),
                title: Text(s.name),
                trailing: Text('₵${s.price.toStringAsFixed(2)}'),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Gh₵${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip({required String status}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status == "Pending"
            ? Colors.grey.withValues(alpha: .5)
            : status == "Accepted"
            ? Colors.amber.withValues(alpha: .5)
            : status == "Completed" || status == "Paid"
            ? Colors.green.withValues(alpha: .5)
            : Colors.red.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Text(status),
    );
  }

  Widget _actionBar({
    required AppointmentModel appt,
    required bool isSalon,
    required TransactionsModel? transaction,
  }) {
    List<Widget> buttons = [];
    if (transaction == null) {
      return const SizedBox.shrink();
    }
    if (isSalon) {
      if (appt.status == 'Pending') {
        buttons.addAll([
          CustomButton(
            radius: 5,
            text: 'Accept',
            onPressed: () => onUpdateStatus('Accepted', transaction),
          ),
          CustomButton(
            radius: 5,
            color: AppColors.accentRed,
            text: 'Cancel',
            onPressed: () => onUpdateStatus('Cancelled', transaction),
          ),
        ]);
      } else if (appt.status == 'Accepted') {
        buttons.addAll([
          CustomButton(
            radius: 5,
            text: 'Complete',
            onPressed: () => onUpdateStatus('Completed', transaction),
          ),
          CustomButton(
            radius: 5,
            color: AppColors.accentRed,
            text: 'Cancel',
            onPressed: () => onUpdateStatus('Cancelled', transaction),
          ),
        ]);
      }
    } else {
      if (appt.status == 'Pending' || appt.status == 'Accepted') {
        buttons.add(
          CustomButton(
            radius: 5,
            color: AppColors.accentRed,
            text: 'Cancel appointment',
            onPressed: () => onUpdateStatus('Cancelled', transaction),
          ),
        );
      }
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            for (int i = 0; i < buttons.length; i++) ...[
              Expanded(child: buttons[i]),
              if (i != buttons.length - 1) const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    );
  }

  void onUpdateStatus(String s, TransactionsModel transaction) {
    CustomDialog.showConfirmationDialog(
      title: 'Update Appointment Status',
      content: 'Are you sure you want to $s the appointment?',
      onConfirm: () {
        ref
            .read(selectedAppointmentProvider.notifier)
            .updateStatus(status: s, newTransaction: transaction);
      },
    );
  }
}
