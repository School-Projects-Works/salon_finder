import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:salon_finder/app/admin/provider/admin_provider.dart';
import '../../ui/global_widgets/custom_input.dart';
import '../../ui/theme/colors.dart';
import '../core/custom_dialog.dart';
import '../core/styles.dart';

class ClientPage extends ConsumerStatefulWidget {
  const ClientPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClientPageState();
}

class _ClientPageState extends ConsumerState<ClientPage> {
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var titleStyles = style.title(color: Colors.white, fontSize: 15);
    var rowStyles = style.body(fontSize: 13);
    var clients = ref.watch(usersFilterProvider).filter;
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customers List'.toUpperCase(),
            style: style.title(fontSize: 30, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: style.width * 0.5,
                child: CustomTextFields(
                  hintText: 'Search customer',
                  onChanged: (query) {
                    ref.read(usersFilterProvider.notifier).filterUsers(query);
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
              empty: Center(child: Text('No Users found', style: rowStyles)),
              minWidth: 600,
              headingRowColor: WidgetStateColor.resolveWith(
                (states) => AppColors.primaryColor.withOpacity(0.6),
              ),
              headingTextStyle: titleStyles,
              columns: [
                DataColumn2(label: Text('Image'.toUpperCase())),
                DataColumn2(label: Text('Name'.toUpperCase())),
                DataColumn2(label: Text('Phone'.toUpperCase())),
                DataColumn2(label: Text('address'.toUpperCase())),
                DataColumn2(label: Text('status'.toUpperCase())),
                DataColumn2(label: Text('Action'.toUpperCase())),
              ],
              rows: List<DataRow>.generate(clients.length, (index) {
                var client = clients[index];
                return DataRow(
                  cells: [
                    DataCell(
                      client.profilePictureUrl.isEmpty
                          ? const Icon(Icons.image)
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: ImageNetwork(
                                  image: client.profilePictureUrl,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ),
                    ),
                    DataCell(Text(client.name, style: rowStyles)),
                    DataCell(Text(client.phoneNumber, style: rowStyles)),
                    DataCell(
                      Text(
                        '${client.address?.street}, ${client.address?.city}, ${client.address?.region}, ${client.address?.country}',
                        style: rowStyles,
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: client.status.toLowerCase() == 'active'
                              ? Colors.green
                              : client.status.toLowerCase() == 'pending'
                              ? Colors.orange
                              : Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          client.status,
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
                          if (client.status.toLowerCase() == 'active')
                            IconButton(
                              tooltip: 'Ban Customer',
                              icon: const Icon(Icons.block),
                              onPressed: () {
                                CustomAdminDialog.showInfo(
                                  message:
                                      'Are you sure you want to ban this customer?',
                                  buttonText: 'Ban',
                                  onPressed: () {
                                    ref
                                        .read(usersFilterProvider.notifier)
                                        .updateStatus(
                                          client.copyWith(status: 'banned'),
                                        );
                                  },
                                );
                              },
                            ),
                          if (client.status.toLowerCase() == 'banned' ||
                              client.status.toLowerCase() == 'pending')
                            IconButton(
                              tooltip: 'Activate Customer',
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                CustomAdminDialog.showInfo(
                                  message:
                                      'Are you sure you want to activate this customer?',
                                  buttonText: 'activate',
                                  onPressed: () {
                                    ref
                                        .read(usersFilterProvider.notifier)
                                        .updateStatus(
                                          client.copyWith(status: 'active'),
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
