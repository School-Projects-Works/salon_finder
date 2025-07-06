import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/ui/theme/theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Salon Finder',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      enableLog: true,
      logWriterCallback: (String text, {bool isError = false}) {
        if (isError) {
          print('Error: $text');
        } else {
          print('Log: $text');
        }
      },

      darkTheme: AppTheme.darkTheme,
      
    );
  }
}

