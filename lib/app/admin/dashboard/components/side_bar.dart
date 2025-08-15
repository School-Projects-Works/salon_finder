import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import '../../core/styles.dart';
import '../../router/router.dart';
import '../../router/router_items.dart';
import 'side_bar_item.dart';

class SideBar extends ConsumerWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    return Container(
        width: 200,
        height: styles.height,
        color: AppColors.primaryColor,
        child: Column(children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                text: TextSpan(
                    text: 'Hello, \n',
                    style: styles.body(
                      color: Colors.white38,
                    ),
                    children: [
                  TextSpan(
                      text: 'Admin',
                      style: styles.subtitle(
                        fontWeight: FontWeight.bold,
                        fontSize: styles.isDesktop ? 20 : 16,
                        color: Colors.white,
                      ))
                ])),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(child: buildAdminManu(ref, context)),
          // footer
          Text('© 2025 All rights reserved',
              style: styles.body(color: Colors.white38, fontSize: 12)),
        ]));
  }

  Widget buildAdminManu(WidgetRef ref, BuildContext context) {
    return Column(
      children: [
        SideBarItem(
          title: 'Dashboard',
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          icon: Icons.dashboard,
          isActive: ref.watch(routerProvider) == RouterItem.dashboardRoute.name,
          onTap: () {
            MyRouter(context: context, ref: ref)
                .navigateToRoute(RouterItem.dashboardRoute);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Salons',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.person,
            isActive:
                ref.watch(routerProvider) == RouterItem.salonsRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.salonsRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Customers',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.people,
            isActive: ref.watch(routerProvider) == RouterItem.usersRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.usersRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Appointments',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.category,
            isActive:
                ref.watch(routerProvider) == RouterItem.appointmentsRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.appointmentsRoute);
            },
          ),
        ),

        //transactions
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Transactions',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.attach_money,
            isActive:
                ref.watch(routerProvider) == RouterItem.transactionsRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.transactionsRoute);
            },
          ),
        ),
      ],
    );
  }
}
