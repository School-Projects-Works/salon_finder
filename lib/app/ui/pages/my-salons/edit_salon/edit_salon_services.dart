import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/data/category_data.dart';
import 'package:salon_finder/app/provider/edit_salon_provider.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_button.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_drop_down.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_input.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';
import '../../../../data/services_model.dart';

class EditSalonServices extends ConsumerStatefulWidget {
  const EditSalonServices({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditSalonServicesState();
}

class _EditSalonServicesState extends ConsumerState<EditSalonServices> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editSalonProvider);

    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            _showAddServiceDialog(context, ref);
          },
          icon: const Icon(Icons.add),
          label: const Text('Add service'),
        ),
        const SizedBox(height: 12),
        ...state.salon.services.asMap().entries.map((e) {
          final idx = e.key;
          final svc = e.value;
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(2),
              leading: CircleAvatar(
                backgroundImage: AssetImage(svc.category.imageUrl),
              ),
              title: Text(
                svc.category.name,
                style: AppTextStyles.title(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    svc.name.isEmpty ? 'Unnamed service' : svc.name,
                    style: AppTextStyles.body(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '₵${svc.price.toStringAsFixed(2)}',
                    style: AppTextStyles.body(),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () =>
                    ref.read(editSalonProvider.notifier).removeServiceAt(idx),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showAddServiceDialog(BuildContext ctx, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    CategoryData? selectedCategory;
    showDialog(
      context: ctx,
      builder: (dctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentTextStyle: const TextStyle(fontSize: 16),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        title: const Text('New service'),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDropDown(
                label: 'Category',
                value: selectedCategory,
                items: CategoryData.categories
                    .map(
                      (e) => DropdownMenuItem<CategoryData>(
                        value: e,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value;
                },
              ),
              const SizedBox(height: 18),
              CustomTextFields(controller: nameCtrl, label: 'Service name'),
              const SizedBox(height: 18),
              CustomTextFields(
                controller: priceCtrl,
                isDigitOnly: true,
                label: 'Price',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: const Text('Cancel'),
          ),
          CustomButton(
            color: Colors.green,
            onPressed: () {
              final name = nameCtrl.text.trim();
              final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
              if (name.isEmpty) {
                CustomDialog.showSnackBar(message: 'Service name is required');
                return;
              } else if (price <= 0) {
                CustomDialog.showSnackBar(
                  message: 'Price must be greater than 0',
                );
                return;
              } else if (selectedCategory == null) {
                CustomDialog.showSnackBar(message: 'Please select a category');
                return;
              }
              final svc = ServicesModel(
                category: selectedCategory ?? CategoryData.categories.first,
                name: name,
                price: price,
              );
              ref.read(editSalonProvider.notifier).addOrUpdateService(svc);
              Navigator.pop(dctx);
            },
            text: 'Add',
            radius: 2,
          ),
        ],
      ),
    );
  }
}
