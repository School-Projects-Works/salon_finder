import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salon_finder/app/data/appointment_model.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';

import '../../provider/selected_appointment_provider.dart';
import '../request/app_detail_page.dart';
import '../theme/colors.dart';

class AppointmentItem extends ConsumerWidget {
  const AppointmentItem({super.key, required this.appointment});
  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var salon = appointment.saloon;
    var user = appointment.user;
    var services = appointment.services;
    return InkWell(
      onTap: () {
        // Handle double tap if needed
        ref
            .read(selectedAppointmentProvider.notifier)
            .selectAppointment(appointment);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AppointmentDetailsPage()),
        );
      },
      child: Card(
        elevation: 3,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              if (salon.imageUrl.isNotEmpty &&
                  salon.imageUrl.contains('assets/images/'))
                Image.asset(
                  salon.imageUrl,
                  width: double.infinity,
                  height: 80,
                  fit: BoxFit.cover,
                )
              else
                Image.network(
                  appointment.saloon.imageUrl,
                  width: double.infinity,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat("EEE, dd MMM, yyyy").format(
                          DateTime.fromMillisecondsSinceEpoch(
                            appointment.createdAt,
                          ),
                        ),
                        style: AppTextStyles.body(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    //total cost
                    Text(
                      'Total: Gh₵ ${appointment.totalPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.body(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              //salon name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      "Salon:",
                      style: AppTextStyles.body(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        salon.name,
                        style: AppTextStyles.title(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              //customer name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      "Customer:",
                      style: AppTextStyles.body(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.name,
                                overflow: TextOverflow.ellipsis,

                                style: AppTextStyles.title(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            //whats app
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.chat,
                                  size: 16,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //services
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      "Services:",
                      style: AppTextStyles.body(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        services.map((service) => service.name).join(", "),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              //date and time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      "Date & Time:",
                      style: AppTextStyles.body(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${(DateFormat("dd MMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(appointment.date)))} at ${DateFormat("hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(appointment.date))}",
                        style: AppTextStyles.body(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //status
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      "Status:",
                      style: AppTextStyles.body(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.status,
                        style: AppTextStyles.body(
                          color: appointment.status == "Pending"
                              ? AppColors.textPrimary
                              : appointment.status == "Cancelled"
                              ? AppColors.accentRed
                              : AppColors.successColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
