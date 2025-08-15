import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/admin_provider.dart';
import 'components/dashboard_item.dart';

class DashboardHome extends ConsumerStatefulWidget {
  const DashboardHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<DashboardHome> {
  @override
  Widget build(BuildContext context) {
    var users = ref.watch(usersFilterProvider).items;
    var salons = ref.watch(salonsFilterProvider).items;
    var apps = ref.watch(appointmentsFilterProvider).items;
    var transactions = ref.watch(transactionsFilterProvider).items;
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runAlignment: WrapAlignment.center,
            runSpacing: 12,
            children: [
              DashBoardItem(
                  icon: Icons.business,
                  title: 'Salons',
                  itemCount: salons.length,
                  color: Colors.blue,
                  onTap: () {}),
              DashBoardItem(
                  icon: Icons.people,
                  title: 'Customers',
                  itemCount: users.length,
                  color: Colors.orange,
                  onTap: () {}),
              DashBoardItem(
                  icon: Icons.calendar_today,
                  title: 'Appointments',
                  itemCount: apps.length,
                  color: Colors.green,
                  onTap: () {}),
              DashBoardItem(
                  icon: Icons.attach_money,
                  title: 'Transactions',
                  itemCount: transactions.length,
                  text: 'Gh₵${transactions.fold(0.0, (previousValue, element) => previousValue + element.amount)}',
                  color: Colors.purple,
                  onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
