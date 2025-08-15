import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salon_finder/app/provider/edit_salon_provider.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';

import '../../../global_widgets/custom_input.dart';
import '../../../utils/email_validation.dart';

class EditSalonAddressContact extends ConsumerStatefulWidget {
  const EditSalonAddressContact({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditSalonAddressContactState();
}

class _EditSalonAddressContactState
    extends ConsumerState<EditSalonAddressContact> {
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _countryController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editSalonProvider);
    _streetController.text = state.salon.address.street;
    _cityController.text = state.salon.address.city;
    _regionController.text = state.salon.address.region;
    _countryController.text = state.salon.address.country;
    _latitudeController.text = state.salon.address.latitude;
    _longitudeController.text = state.salon.address.longitude;

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              backgroundColor: Colors.blue.withOpacity(.1),
              foregroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Icon(Icons.location_on),
            onPressed: _getCurrentLocation,
            label: Text("Get Current Location"),
          ),
          const SizedBox(height: 22),
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
                ref.read(editSalonProvider.notifier).setStreet(street: street);
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
                ref.read(editSalonProvider.notifier).setCity(city: city);
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
                ref.read(editSalonProvider.notifier).setRegion(region: region);
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
                    .read(editSalonProvider.notifier)
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
                      ref.read(editSalonProvider.notifier).setLat(lat: lat);
                    }
                  },
                ),
              ),
              const SizedBox(width: 22),
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
                      ref.read(editSalonProvider.notifier).setLng(lng: lng);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text("Contact Information"),
          const SizedBox(height: 12),
          CustomTextFields(
            label: 'Salon Email',
            initialValue: state.salon.contact.email,
            validator: (email) {
              if (email == null || email.trim().isEmpty) {
                return 'Email cannot be empty';
              } else if (validateEmail(email) == false) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            onSaved: (email) {
              if (email != null && email.trim().isNotEmpty) {
                ref.read(editSalonProvider.notifier).setEmail(email: email);
              }
            },
          ),
          const SizedBox(height: 22),
          CustomTextFields(
            label: 'Salon Phone',
            initialValue: state.salon.contact.phoneNumber,
            validator: (phone) {
              if (phone == null || phone.trim().isEmpty) {
                return 'Phone cannot be empty';
              } else if (phone.length != 10) {
                return 'Phone must be 10 digits';
              }
              return null;
            },
            onSaved: (phone) {
              if (phone != null && phone.trim().isNotEmpty) {
                ref.read(editSalonProvider.notifier).setPhone(phone: phone);
              }
            },
          ),
        ],
      ),
    );
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
          .read(editSalonProvider.notifier)
          .setLat(lat: position.latitude.toString());
      ref
          .read(editSalonProvider.notifier)
          .setLng(lng: position.longitude.toString());
      ref
          .read(editSalonProvider.notifier)
          .setCity(city: placemarks.first.locality ?? '');
      ref
          .read(editSalonProvider.notifier)
          .setCountry(country: placemarks.first.country ?? '');
      ref
          .read(editSalonProvider.notifier)
          .setRegion(region: placemarks.first.administrativeArea ?? '');
      ref
          .read(editSalonProvider.notifier)
          .setStreet(street: placemarks.first.street ?? '');

      CustomDialog.closeDialog();
    } catch (e) {
      CustomDialog.closeDialog();
      CustomDialog.showErrorDialog(message: 'Error getting location: $e');
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
