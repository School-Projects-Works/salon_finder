import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon_finder/app/provider/edit_salon_provider.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_input.dart';

class EditSalonGeneral extends ConsumerStatefulWidget {
  const EditSalonGeneral({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditSalonGeneralState();
}

class _EditSalonGeneralState extends ConsumerState<EditSalonGeneral> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pick = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
    );
    if (pick == null) return;
    ref.read(editSalonProvider.notifier).updateImage(pick.path);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editSalonProvider);
    final notifier = ref.read(editSalonProvider.notifier);
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: state.salon.imageUrl.isEmpty
                ? Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    child: const Icon(Icons.camera_alt, size: 36),
                  )
                : Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      image: DecorationImage(
                        image: state.salon.imageUrl.contains('http')
                            ? NetworkImage(state.salon.imageUrl)
                            : FileImage(File(state.salon.imageUrl)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 22),
          CustomTextFields(
            label: 'Salon Name',
            hintText: 'Enter salon name',
            initialValue: state.salon.name,
            validator: (name) {
              if (name == null || name.isEmpty) return 'Salon name is required';
              return null;
            },
            onSaved: (v) {
              if (v == null || v.isEmpty) return;
              notifier.updateName(v);
            },
          ),
          const SizedBox(height: 22),
          CustomTextFields(
            label: 'Description',
            hintText: 'Enter salon description',
            initialValue: state.salon.description,
            maxLines: 3,
            validator: (description) {
              if (description == null || description.isEmpty) {
                return 'Description is required';
              }
              return null;
            },
            onSaved: (v) {
              if (v == null || v.isEmpty) return;
              notifier.updateDescription(v);
            },
          ),
        ],
      ),
    );
  }
}
