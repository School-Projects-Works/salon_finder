import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/data/salon_model.dart';
import 'package:salon_finder/app/provider/current_user_provider.dart';
import 'package:salon_finder/app/provider/edit_salon_provider.dart';

import '../../provider/new_appointment_provider.dart';
import '../../provider/rating_provider.dart';
import '../pages/my-salons/my_salon_detail_page.dart';
import '../pages/salon/salon_detail_page.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class SalonItem extends ConsumerStatefulWidget {
  const SalonItem({super.key, required this.salon, this.width = 200});
  final SalonModel salon;
  final double width;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalonItemState();
}

class _SalonItemState extends ConsumerState<SalonItem> {
  @override
  Widget build(BuildContext context) {
    var salon = widget.salon;
    var rating = ref.watch(ratingAverageStreamProvider(salon.id));
    var salons = ref.watch(currentUserProvider).salons ?? [];
    return SizedBox(
      width: widget.width,
      child: InkWell(
        onTap: () {
          if (salons.any((s) => s.id == salon.id)) {
            ref.read(editSalonProvider.notifier).setSalon(salon);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MySalonDetailPage()),
            );
            return;
          }
          ref.read(newAppointmentProvider.notifier).clear();
          ref.read(newAppointmentProvider.notifier).setSalon(salon);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalonDetailPage(salon: salon),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      salon.imageUrl.isNotEmpty &&
                          salon.imageUrl.contains('assets/images')
                      ? AssetImage(salon.imageUrl)
                      : NetworkImage(salon.imageUrl),
                ),
              ),
            ),
            // const SizedBox(height: 8),
            Text(
              salon.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.title(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            //const SizedBox(height: 4),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${salon.address.region}-${salon.address.city}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      color: AppColors.textPrimary,

                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                //const Spacer(),
                const SizedBox(width: 8),
                // Display average rating
                SizedBox(
                  width: 40,
                  child: rating.when(
                    data: (data) {
                      //stars
                      return Padding(
                        padding: const EdgeInsets.only(right: .0),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              data.rating.toStringAsFixed(1),
                              style: AppTextStyles.body(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stack) {
                      print('Error fetching rating: $error');
                      return Text(
                        'Error: $error',
                        style: AppTextStyles.body(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
