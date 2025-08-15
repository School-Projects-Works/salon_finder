import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/provider/edit_salon_provider.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';

import '../../global_widgets/custom_button.dart';
import 'edit_salon/edit_salon_address_contact.dart';
import 'edit_salon/edit_salon_general.dart';
import 'edit_salon/edit_salon_review.dart';
import 'edit_salon/edit_salon_services.dart';
import 'edit_salon/edit_salon_working_hours.dart';

class MySalonDetailPage extends ConsumerStatefulWidget {
  const MySalonDetailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MySalonDetailPageState();
}

class _MySalonDetailPageState extends ConsumerState<MySalonDetailPage> {
  final GlobalKey<FormState> _generalFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editSalonProvider);
    final notifier = ref.read(editSalonProvider.notifier);
    final step = state.step;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Salon Details'),
        actions: [
          TextButton(
            onPressed: () {
              CustomDialog.showConfirmationDialog(
                title: 'Delete Salon',
                content: 'Are you sure you want to delete this salon?',
                onConfirm: () {
                  ref.read(editSalonProvider.notifier).deleteSalon(context:context,ref:ref);
                },
              );
            },
            child: Text(
              'Delete Salon',
              style: AppTextStyles.body(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: Stepper(
        type: StepperType.vertical,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 18.0),
            child: Row(
              children: [
                if (step > 0) ...[
                  TextButton.icon(
                    onPressed: details.onStepCancel,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: CustomButton(
                    radius: 5,
                    onPressed: details.onStepContinue,
                    text: step == 4 ? 'Update Salon' : 'Continue',
                  ),
                ),
              ],
            ),
          );
        },
        currentStep: step < 0 ? 0 : step,
        onStepContinue: () async {
          if (step == 0) {
            if (!_generalFormKey.currentState!.validate()) {
              return;
            } else {
              _generalFormKey.currentState!.save();
            }
          }
          if (state.salon.imageUrl.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select an image')),
            );
            return;
          }
          if (step == 1) {
            if (!_addressFormKey.currentState!.validate()) {
              return;
            } else {
              _addressFormKey.currentState!.save();
            }
          }
          if (step == 3 && state.salon.services.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please add at least one service')),
            );
            return;
          }
          if (step == 4) {
            await notifier.updateSalon(context: context, ref: ref);
          }
          notifier.nextStep();
        },
        onStepCancel: () {
          if (step == 0) return;
          notifier.prevStep();
        },
        steps: [
          Step(
            title: const Text('General'),
            content: EditSalonGeneral(formKey: _generalFormKey),
            isActive: step >= 0,
            state: step > 0 ? StepState.complete : StepState.indexed,
          ),

          Step(
            title: const Text('Address & Contact'),
            content: EditSalonAddressContact(formKey: _addressFormKey),
            isActive: step >= 1,
            state: step > 1 ? StepState.complete : StepState.indexed,
          ),

          Step(
            title: const Text('Working Hours'),
            content: EditSalonWorkingHours(),
            isActive: step >= 2,
            state: step > 2 ? StepState.complete : StepState.indexed,
          ),

          Step(
            title: const Text('Services'),
            content: EditSalonServices(),
            isActive: step >= 3,
            state: step > 3 ? StepState.complete : StepState.indexed,
          ),

          Step(
            title: const Text('Review & Submit'),
            content: EditSalonReview(),
            isActive: step >= 4,
            state: step == 4 ? StepState.indexed : StepState.disabled,
          ),
        ],
      ),
    );
  }
}
