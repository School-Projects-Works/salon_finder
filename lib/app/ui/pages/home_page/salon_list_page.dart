import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/ui/global_widgets/salon_item.dart';

import '../../../provider/salon_provider.dart';

class SalonListPage extends ConsumerWidget {
  const SalonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var salons = ref.watch(salonProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      //grid view for salons
      child: salons.filteredSalons.isEmpty
          ? Center(
              child: Text(
                "No salons found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
              ),
              itemCount: salons.filteredSalons.length,
              itemBuilder: (context, index) {
                final salon = salons.filteredSalons[index];
                return SalonItem(salon: salon);
              },
            ),
    );
  }
}
