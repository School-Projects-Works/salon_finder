import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:salon_finder/app/admin/router/router.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';


class AdminMain extends ConsumerWidget {
  const AdminMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      builder: FlutterSmartDialog.init(),
      routerConfig: MyRouter(context: context, ref: ref).router(),
    );
  }

 
}
