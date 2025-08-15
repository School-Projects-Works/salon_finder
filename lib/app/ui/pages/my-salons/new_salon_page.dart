
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/provider/new_salon_provider.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_button.dart';

import 'my_salon_review.dart';
import 'new_salon_address_contact.dart';
import 'new_salon_general.dart';
import 'new_salon_services.dart';
import 'new_salon_working_hours.dart';

class NewSalonWizard extends ConsumerStatefulWidget {
  const NewSalonWizard({super.key});

  @override
  ConsumerState<NewSalonWizard> createState() => _NewSalonWizardState();
}

class _NewSalonWizardState extends ConsumerState<NewSalonWizard> {
  final GlobalKey<FormState> _generalFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newSalonProvider);
    final notifier = ref.read(newSalonProvider.notifier);
    final step = state.step;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Create Salon')),
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
                    text: step == 4 ? 'Create Salon' : 'Continue',
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
            await notifier.saveSalon(context: context, ref: ref);
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
            content: NewSalonGeneral(formKey: _generalFormKey),
            isActive: step >= 0,
            state: step > 0 ? StepState.complete : StepState.indexed,
          ),

          Step(
            title: const Text('Address & Contact'),
            content: NewSalonAddressContact(formKey: _addressFormKey),
            isActive: step >= 1,
            state: step > 1 ? StepState.complete : StepState.indexed,
          ),

          Step(
            title: const Text('Working Hours'),
            content: NewSalonWorkingHours(),
            isActive: step >= 2,
            state: step > 2 ? StepState.complete : StepState.indexed,
          ),

          Step(
            title: const Text('Services'),
            content: NewSalonServices(),
            isActive: step >= 3,
            state: step > 3 ? StepState.complete : StepState.indexed,
          ),

          Step(
            title: const Text('Review & Submit'),
            content: MySalonReview(),
            isActive: step >= 4,
            state: step == 4 ? StepState.indexed : StepState.disabled,
          ),
        ],
      ),
    );
  }
}
