import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';

import '../../provider/appointment_provider.dart';
import '../global_widgets/appointment_item.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentsPageState();
}

class _AppointmentsPageState extends ConsumerState<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 150,
          padding: const EdgeInsets.all(20),
          color: AppColors.primaryColor,
          alignment: Alignment.bottomLeft,
          child: Text(
            "My Appointments",
            style: AppTextStyles.title(color: Colors.white),
          ),
        ),
        Expanded(
          child: ref
              .watch(appointmentStream)
              .when(
                data: (apps) {
                  var appointments = ref.watch(appointmentProvider).userApps;
                  if (appointments.isEmpty) {
                    return Center(
                      child: Text(
                        "No appointments found",
                        style: AppTextStyles.body(color: AppColors.textMuted),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return AppointmentItem(appointment: appointment);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Center(child: Text("Error loading appointments: $error")),
              ),
        ),
      ],
    );
  }
}
