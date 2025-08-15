import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_button.dart';
import 'package:salon_finder/app/ui/global_widgets/salon_item.dart';

import '../../../provider/current_user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import 'new_salon_page.dart';

class MySalonsPage extends ConsumerStatefulWidget {
  const MySalonsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MySalonsPageState();
}

class _MySalonsPageState extends ConsumerState<MySalonsPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(currentUserProvider).user;
    var salons = ref.watch(currentUserProvider).salons;
    return Column(
      children: [
        Container(
          height: 150,
          padding: const EdgeInsets.all(20),
          color: AppColors.primaryColor,
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Salons",
                style: AppTextStyles.title(color: Colors.white),
              ),
              if (salons != null && salons.isNotEmpty)
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                  ),
                  child: Text(
                    "Add Salon",
                    style: AppTextStyles.body(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewSalonWizard(),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        Expanded(
          child: salons == null || salons.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No salons found",
                          style: AppTextStyles.body(color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryColor.withOpacity(
                              .2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5,
                            ),
                          ),
                          child: Text(
                            "Create Salon",
                            style: AppTextStyles.body(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          onPressed: () {
                            // Handle create salon action
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewSalonWizard(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: salons.length,
                    itemBuilder: (context, index) {
                      final salon = salons[index];
                      return SalonItem(salon: salon);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
