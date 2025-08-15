import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:salon_finder/app/admin/provider/admin_provider.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import '../../ui/global_widgets/custom_input.dart';
import '../core/custom_dialog.dart';
import '../core/styles.dart';

class AdminSalonsPage extends ConsumerStatefulWidget {
  const AdminSalonsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminSalonsState();
}

class _AdminSalonsState extends ConsumerState<AdminSalonsPage> {
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var titleStyles = style.title(color: Colors.white, fontSize: 15);
    var rowStyles = style.body(fontSize: 13);
    var salons = ref.watch(salonsFilterProvider).filter;
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registered Salons'.toUpperCase(),
            style: style.title(fontSize: 30, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: style.width * 0.5,
                child: CustomTextFields(
                  hintText: 'Search salon',
                  onChanged: (query) {
                    ref.read(salonsFilterProvider.notifier).filterSalons(query);
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
              empty: Center(child: Text('No Salons found', style: rowStyles)),
              minWidth: 600,
              headingRowColor: WidgetStateColor.resolveWith(
                (states) => AppColors.primaryColor.withOpacity(0.6),
              ),
              headingTextStyle: titleStyles,
              columns: [
                DataColumn2(label: Text('Image'.toUpperCase())),
                DataColumn2(label: Text('Name'.toUpperCase())),
                DataColumn2(label: Text('Services'.toUpperCase())),
                DataColumn2(label: Text('Phone'.toUpperCase())),
                DataColumn2(label: Text('Email'.toUpperCase())),
                DataColumn2(label: Text('Address'.toUpperCase())),

                DataColumn2(label: Text('status'.toUpperCase())),
                DataColumn2(label: Text('Action'.toUpperCase())),
              ],
              rows: List<DataRow>.generate(salons.length, (index) {
                var salon = salons[index];
                return DataRow(
                  cells: [
                    DataCell(
                      salon.imageUrl.isEmpty
                          ? const Icon(Icons.image)
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: ImageNetwork(
                                  image: salon.imageUrl,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ),
                    ),
                    DataCell(Text(salon.name, style: rowStyles)),
                    DataCell(
                      Text(
                        salon.services.map((name) => name.name).join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: rowStyles,
                      ),
                    ),
                    DataCell(Text(salon.contact.phoneNumber, style: rowStyles)),
                    DataCell(Text(salon.contact.email, style: rowStyles)),
                    DataCell(
                      Text(
                        '${salon.address.street}, ${salon.address.city}, ${salon.address.region}, ${salon.address.country}',
                        style: rowStyles,
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: salon.status == 'Active'
                              ? Colors.green
                              : salon.status == 'Inactive'
                              ? Colors.orange
                              : Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          salon.status,
                          style: rowStyles.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 2),
                          if (salon.status == 'Active')
                            IconButton(
                              tooltip: 'Ban Salons',
                              icon: const Icon(Icons.block),
                              onPressed: () {
                                CustomAdminDialog.showInfo(
                                  message:
                                      'Are you sure you want to ban this Salons?',
                                  buttonText: 'Ban',
                                  onPressed: () {
                                    ref
                                        .read(salonsFilterProvider.notifier)
                                        .updateStatus(
                                          salon.copyWith(status: 'Banned'),
                                        );
                                  },
                                );
                              },
                            ),
                          if (salon.status == 'Banned' ||
                              salon.status == 'Inactive')
                            IconButton(
                              tooltip: 'Activate Salons',
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                CustomAdminDialog.showInfo(
                                  message:
                                      'Are you sure you want to activate this Salons?',
                                  buttonText: 'activate',
                                  onPressed: () {
                                    ref
                                        .read(salonsFilterProvider.notifier)
                                        .updateStatus(
                                          salon.copyWith(status: 'Active'),
                                        );
                                  },
                                );
                              },
                            ),
                        ],
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
