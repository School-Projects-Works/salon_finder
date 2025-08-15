import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import '../../../generated/assets.dart';
import '../core/styles.dart';
import '../provider/admin_provider.dart';
import '../router/router.dart';
import '../router/router_items.dart';
import 'components/app_bar_item.dart';
import 'components/side_bar.dart';

class DashboardMain extends ConsumerStatefulWidget {
  const DashboardMain({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<DashboardMain> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var users = ref.watch(userStream);
    var salons = ref.watch(salonsStream);
    var appointments = ref.watch(appointmentsStream);
    var transactions = ref.watch(transactionsStream);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Row(
            children: [
              Image.asset(Assets.imagesIconWhite, height: 40),
              const SizedBox(width: 10),
              if (styles.smallerThanTablet)
                //manu button
                buildAdminManu(ref, context),
            ],
          ),
        ),
        body: Container(
          color: Colors.white60,
          padding: const EdgeInsets.all(4),
          child: styles.smallerThanTablet
              ? widget.child
              : Row(
                  children: [
                    const SideBar(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        color: Colors.grey[100],
                        padding: const EdgeInsets.all(10),
                        child: users.when(
                          data: (user) {
                            return salons.when(
                              data: (salon) {
                                return appointments.when(
                                  data: (appointment) {
                                    return transactions.when(
                                      data: (transaction) {
                                        return widget.child;
                                      },
                                      loading: () => const Center(
                                          child: CircularProgressIndicator()),
                                      error: (error, stack) {
                                        return Center(child: Text(error.toString()));
                                      },
                                    );
                                  },
                                  loading: () =>
                                      const Center(child: CircularProgressIndicator()),
                                  error: (error, stack) {
                                    return Center(child: Text(error.toString()));
                                  },
                                );
                              },
                              loading: () =>
                                  const Center(child: CircularProgressIndicator()),
                              error: (error, stack) {
                                return Center(child: Text(error.toString()));
                              },
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stack) {
                            return Center(child: Text(error.toString()));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget buildAdminManu(WidgetRef ref, BuildContext context) {
    return PopupMenuButton(
      color: AppColors.primaryColor,
      offset: const Offset(0, 70),
      child: const Icon(Icons.menu, color: Colors.white),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: BarItem(
              padding: const EdgeInsets.only(
                right: 40,
                top: 10,
                bottom: 10,
                left: 10,
              ),
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () {
                MyRouter(
                  context: context,
                  ref: ref,
                ).navigateToRoute(RouterItem.dashboardRoute);
                Navigator.of(context).pop();
              },
            ),
          ),
          PopupMenuItem(
            child: BarItem(
              padding: const EdgeInsets.only(
                right: 40,
                top: 10,
                bottom: 10,
                left: 10,
              ),
              icon: Icons.location_on,
              title: 'Salons',
              onTap: () {
                MyRouter(
                  context: context,
                  ref: ref,
                ).navigateToRoute(RouterItem.salonsRoute);
                Navigator.of(context).pop();
              },
            ),
          ),
          PopupMenuItem(
            child: BarItem(
              padding: const EdgeInsets.only(
                right: 40,
                top: 10,
                bottom: 10,
                left: 10,
              ),
              icon: Icons.warning,
              title: 'Customers',
              onTap: () {
                MyRouter(
                  context: context,
                  ref: ref,
                ).navigateToRoute(RouterItem.usersRoute);
                Navigator.of(context).pop();
              },
            ),
          ),
          PopupMenuItem(
            child: BarItem(
              padding: const EdgeInsets.only(
                right: 40,
                top: 10,
                bottom: 10,
                left: 10,
              ),
              icon: Icons.category,
              title: 'Appointments',
              onTap: () {
                MyRouter(
                  context: context,
                  ref: ref,
                ).navigateToRoute(RouterItem.appointmentsRoute);
                Navigator.of(context).pop();
              },
            ),
          ),
          //transactions
          PopupMenuItem(
            child: BarItem(
              padding: const EdgeInsets.only(
                right: 40,
                top: 10,
                bottom: 10,
                left: 10,
              ),
              icon: Icons.attach_money,
              title: 'Transactions',
              onTap: () {
                MyRouter(
                  context: context,
                  ref: ref,
                ).navigateToRoute(RouterItem.transactionsRoute);
                Navigator.of(context).pop();
              },
            ),
          ),
        ];
      },
    );
  }
}
