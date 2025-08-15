import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salon_finder/app/admin/provider/admin_provider.dart';

import '../../ui/global_widgets/custom_input.dart';
import '../../ui/theme/colors.dart';
import '../core/styles.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentsPageState();
}

class _AppointmentsPageState extends ConsumerState<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var titleStyles = style.title(color: Colors.white, fontSize: 15);
    var rowStyles = style.body(fontSize: 13);
    var apps = ref.watch(appointmentsFilterProvider).filter;
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment List'.toUpperCase(),
            style: style.title(fontSize: 30, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: style.width * 0.5,
                child: CustomTextFields(
                  hintText: 'Search Appointments',
                  onChanged: (query) {
                    ref
                        .read(appointmentsFilterProvider.notifier)
                        .filterAppointments(query);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: DataTable2(
              columnSpacing: 30,
              horizontalMargin: 12,
              empty: Center(
                child: Text('No Appointments found', style: rowStyles),
              ),
              minWidth: 600,
              headingRowColor: WidgetStateColor.resolveWith(
                (states) => AppColors.primaryColor.withOpacity(0.6),
              ),
              headingTextStyle: titleStyles,
              columns: [
                DataColumn2(
                  label: Text('INDEX', style: titleStyles),
                  fixedWidth: style.largerThanMobile ? 80 : null,
                ),
                DataColumn2(label: Text('Salon'.toUpperCase())),
                DataColumn2(label: Text('Customer'.toUpperCase())),
                DataColumn2(label: Text('Services'.toUpperCase())),
                DataColumn2(label: Text('Date | Time'.toUpperCase())),
                DataColumn2(label: Text('Cost'.toUpperCase())),
                DataColumn2(label: Text('Status'.toUpperCase())),
              ],
              rows: List<DataRow>.generate(apps.length, (index) {
                var app = apps[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}', style: rowStyles)),

                    DataCell(Text(app.saloon.name, style: rowStyles)),
                    DataCell(
                      Text(
                        app.user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: rowStyles,
                      ),
                    ),
                    DataCell(
                      Text(
                        app.services.map((e) => e.name).join(', '),
                        style: rowStyles,
                      ),
                    ),
                    DataCell(
                      Text(
                        '${DateFormat("EEE, MMM d, yyyy").format(DateTime.fromMillisecondsSinceEpoch(app.date))} | ${DateFormat("hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(app.date))}',
                        style: rowStyles,
                      ),
                    ),
                    DataCell(Text('Gh${app.totalPrice}', style: rowStyles)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: app.status.toLowerCase() == 'completed'
                              ? Colors.green
                              : app.status.toLowerCase() == 'accepted'
                              ? Colors.orange
                              : app.status.toLowerCase() == 'pending'
                              ? Colors.grey
                              : Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          app.status,
                          style: rowStyles.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
