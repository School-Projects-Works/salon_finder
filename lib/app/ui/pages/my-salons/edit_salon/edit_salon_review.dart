import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/data/new_salon_state.dart';
import 'package:salon_finder/app/provider/edit_salon_provider.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';
import 'package:salon_finder/generated/assets.dart';

class EditSalonReview extends ConsumerWidget {
  const EditSalonReview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editSalonProvider);

    return Column(
      children: [
        _buildGeneralCard(state),
        _buildAddressCard(state),
        _buildServicesCard(state),
        _buildWorkingHoursCard(state),
      ],
    );
  }

  Widget _buildGeneralCard(NewSalonState state) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.all(5.0),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: state.salon.imageUrl.isNotEmpty
                  ? state.salon.imageUrl.contains('http')
                        ? NetworkImage(state.salon.imageUrl)
                        : state.salon.imageUrl.contains('assets/images')
                        ? const AssetImage(Assets.imagesSalon4) as ImageProvider
                        : FileImage(File(state.salon.imageUrl))
                  : const AssetImage(Assets.imagesSalon4) as ImageProvider,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.salon.name,
                    style: AppTextStyles.body(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${state.salon.description}\n',
                    style: const TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Location:\n\n',
                style: const TextStyle(color: Colors.black54),
              ),
              TextSpan(
                text:
                    '${state.salon.address.street}, | ${state.salon.address.city} | ${state.salon.address.country}\n',
                style: AppTextStyles.body(color: Colors.black),
              ),
              TextSpan(
                text:
                    'Lat: ${state.salon.address.latitude}, Long: ${state.salon.address.longitude}\n',
                style: AppTextStyles.body(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(NewSalonState state) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          //email and phone
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                //icon
                const Icon(Icons.email, size: 16),
                const SizedBox(width: 5),
                Text(' ${state.salon.contact.email}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                //icon
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 5),
                Text(' ${state.salon.contact.phoneNumber}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCard(NewSalonState state) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: state.salon.services.map((service) {
          return ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage(service.category.imageUrl),
            ),
            title: Row(
              children: [
                Expanded(child: Text(service.category.name)),
                Text(
                  '₵${service.price.toStringAsFixed(2)}',
                  style: AppTextStyles.body(),
                ),
              ],
            ),
            subtitle: Text(
              service.name.isEmpty ? 'Unnamed service' : service.name,
              style: AppTextStyles.body(fontWeight: FontWeight.w600),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWorkingHoursCard(NewSalonState state) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: state.salon.openCloseHours.map((openClose) {
          return ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            title: Text(
              openClose.day,
              style: AppTextStyles.body(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${openClose.openTime} - ${openClose.closeTime}',
              style: AppTextStyles.body(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
