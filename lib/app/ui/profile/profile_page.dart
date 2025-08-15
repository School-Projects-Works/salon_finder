import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:salon_finder/app/data/user_model.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_button.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_input.dart';
import 'package:salon_finder/app/ui/profile/info_chip.dart';
import 'package:salon_finder/generated/assets.dart';

import '../../provider/current_user_provider.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImageFile; // local temp image before upload
  //controller for address fields
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _countryController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).user;
    if (user == null) {
      return Scaffold(body: Center(child: Text('No user data available')));
    }
    ImageProvider avatarProvider = _pickedImageFile != null
        ? FileImage(_pickedImageFile!) as ImageProvider
        : (user.profilePictureUrl.isNotEmpty
              ? NetworkImage(user.profilePictureUrl) as ImageProvider
              : const AssetImage(Assets.imagesUser));
    if (user.address != null) {
      _streetController.text = user.address?.street ?? '';
      _cityController.text = user.address?.city ?? '';
      _regionController.text = user.address?.region ?? '';
      _countryController.text = user.address?.country ?? '';
      _latitudeController.text = user.address?.latitude ?? '';
      _longitudeController.text = user.address?.longitude ?? '';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(radius: 48, backgroundImage: avatarProvider),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _changeProfileImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              //logout
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(currentUserProvider.notifier)
                          .logout(context: context);
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _readOnlyChips(user),
              const SizedBox(height: 20),

              // Editable fields
              CustomTextFields(
                label: 'Full name',
                initialValue: user.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                onSaved: (name) {
                  if (name == null || name.trim().isEmpty) {
                    return; // clear if empty
                  }
                  ref.read(currentUserProvider.notifier).setName(name.trim());
                },
              ),
              const SizedBox(height: 22),
              CustomTextFields(
                label: 'Phone number',
                keyboardType: TextInputType.phone,
                initialValue: user.phoneNumber,
                validator: (p0) {
                  if (p0 == null || p0.trim().isEmpty) {
                    return 'Enter a valid phone number';
                  } else if (p0.length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  return null;
                },
                onSaved: (phone) {
                  if (phone == null || phone.trim().isEmpty) {
                    return; // clear if empty
                  }
                  ref.read(currentUserProvider.notifier).setPhone(phone);
                },
              ),
              const SizedBox(height: 22),
              CustomTextFields(
                label: 'WhatsApp number',
                initialValue: user.whatsapp,
                keyboardType: TextInputType.phone,
                onSaved: (whatsapp) {
                  if (whatsapp == null || whatsapp.trim().isEmpty) {
                    return; // clear if empty
                  }
                  ref.read(currentUserProvider.notifier).setWhatsApp(whatsapp);
                },
              ),
              const SizedBox(height: 22),

              // Address section
              Text('Address', style: Theme.of(context).textTheme.titleMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _getCurrentLocation();
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Pick on map'),
                  ),
                ],
              ),

              CustomTextFields(
                label: 'Street',
                controller: _streetController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Street cannot be empty';
                  }
                  return null;
                },
                onSaved: (street) {
                  if (street != null && street.trim().isNotEmpty) {
                    ref
                        .read(currentUserProvider.notifier)
                        .setStreet(street: street);
                  }
                },
              ),
              const SizedBox(height: 22),
              CustomTextFields(
                label: 'City',
                controller: _cityController,
                validator: (city) {
                  if (city == null || city.trim().isEmpty) {
                    return 'City cannot be empty';
                  }
                  return null;
                },
                onSaved: (city) {
                  if (city != null && city.trim().isNotEmpty) {
                    ref.read(currentUserProvider.notifier).setCity(city: city);
                  }
                },
              ),
              const SizedBox(height: 22),
              CustomTextFields(
                label: 'Region/State',
                controller: _regionController,
                validator: (region) {
                  if (region == null || region.trim().isEmpty) {
                    return 'Region/State cannot be empty';
                  }
                  return null;
                },
                onSaved: (region) {
                  if (region != null && region.trim().isNotEmpty) {
                    ref
                        .read(currentUserProvider.notifier)
                        .setRegion(region: region);
                  }
                },
              ),
              const SizedBox(height: 22),
              CustomTextFields(
                label: 'Country',
                controller: _countryController,
                validator: (country) {
                  if (country == null || country.trim().isEmpty) {
                    return 'Country cannot be empty';
                  }
                  return null;
                },
                onSaved: (country) {
                  if (country != null && country.trim().isNotEmpty) {
                    ref
                        .read(currentUserProvider.notifier)
                        .setCountry(country: country);
                  }
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFields(
                      controller: _latitudeController,
                      label: 'Latitude',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      validator: (lat) {
                        if (lat == null || lat.trim().isEmpty) {
                          return 'Latitude cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (lat) {
                        if (lat != null && lat.trim().isNotEmpty) {
                          ref
                              .read(currentUserProvider.notifier)
                              .setLat(lat: lat);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFields(
                      controller: _longitudeController,
                      label: 'Longitude',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      validator: (lng) {
                        if (lng == null || lng.trim().isEmpty) {
                          return 'Longitude cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (lng) {
                        if (lng != null && lng.trim().isNotEmpty) {
                          ref
                              .read(currentUserProvider.notifier)
                              .setLng(lng: lng);
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    CustomDialog.showConfirmationDialog(
                      title: 'Confirm Changes',
                      content: 'Are you sure you want to save these changes?',
                      onConfirm: () {
                        ref
                            .read(currentUserProvider.notifier)
                            .updateUser(image: _pickedImageFile, ref: ref);
                      },
                    );
                  }
                },
                radius: 5,
                text: 'Save Changes',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _readOnlyChips(UserModel user) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        InfoChip(label: 'Email', value: user.email),
        InfoChip(label: 'Status', value: user.status),
      ],
    );
  }

  Future<void> _changeProfileImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      final file = File(picked.path);
      setState(() => _pickedImageFile = file);
      // let parent upload and set new URL later
    }
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      CustomDialog.loading();
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) {
        CustomDialog.closeDialog();
        CustomDialog.showErrorDialog(
          message: 'No address found for this location',
        );
        return;
      }
      ref
          .read(currentUserProvider.notifier)
          .setLat(lat: position.latitude.toString());
      ref
          .read(currentUserProvider.notifier)
          .setLng(lng: position.longitude.toString());
      ref
          .read(currentUserProvider.notifier)
          .setCity(city: placemarks.first.locality ?? '');
      ref
          .read(currentUserProvider.notifier)
          .setCountry(country: placemarks.first.country ?? '');
      ref
          .read(currentUserProvider.notifier)
          .setRegion(region: placemarks.first.administrativeArea ?? '');
      ref
          .read(currentUserProvider.notifier)
          .setStreet(street: placemarks.first.street ?? '');
      // setState(() {});
      print("Address: ${placemarks.first}");
      CustomDialog.closeDialog();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle case where location services are disabled
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle case where permission is denied
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle case where permission is permanently denied
      return false;
    }
    return true;
  }
}
