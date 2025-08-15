import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import 'package:salon_finder/app/ui/pages/home_page/home_page.dart';
import 'app/admin/main/views/admin_main.dart';
import 'app/provider/current_user_provider.dart';
import 'app/ui/pages/auth_page/welcome_page.dart';
import 'app/ui/theme/theme.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     if (kIsWeb) {
      return const AdminMain();
    }
    return MaterialApp(
      title: 'Salon Finder',
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.darkTheme,
      home: ref
          .watch(checkUserExistsProvider)
          .when(
            loading: () => Scaffold(
              body: const Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) =>
                Scaffold(body: Center(child: Text('Error: $error'))),
            data: (data) {
              if (data != null) {
                // User is logged in, navigate to home page
                ref.read(currentUserProvider.notifier).setCurrentUser(data);
                return HomePage(); // or HomePage() if you have one
              }
              return WelcomePage();
            },
          ),
    );
  }
}
