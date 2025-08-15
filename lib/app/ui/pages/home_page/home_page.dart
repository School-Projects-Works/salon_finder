import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:salon_finder/app/ui/request/appointments_page.dart';
import '../../../provider/salon_provider.dart';
import '../../profile/profile_page.dart';
import '../my-salons/my_salons_page.dart';
import 'home_content_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      hideOnScrollSettings: const HideOnScrollSettings(
        hideNavBarOnScroll: true,
      ),
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.grey.shade900,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      ref
          .watch(salonStreamProvider)
          .when(
            error: (error, stack) {
              return Center(child: Text('Error: $error'));
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            data: (data) {
              return HomeContentPage();
            },
          ),

      const AppointmentsPage(),
      const MySalonsPage(),
      const UserProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_today),
        title: "My App",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      // my salons
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.business),
        title: "My Salons",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
