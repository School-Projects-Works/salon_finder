// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:salon_finder/app/data/address_model.dart';
import '../../generated/assets.dart';
import 'category_data.dart';
import 'contact_model.dart';
import 'salon_open_close_model.dart';
import 'services_model.dart';

class SalonModel {
  String id;
  String name;
  String imageUrl;
  AddressModel address;
  String description;
  String salonOwnerId;
  List<ServicesModel> services;
  List<SalonOpenCloseModel> openCloseHours;
  ContactModel contact;
  int createdAt;
  SalonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.description,
    required this.salonOwnerId,
    required this.services,
    required this.openCloseHours,
    required this.contact,
    required this.createdAt,
  });

  SalonModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    AddressModel? address,
    String? description,
    String? salonOwnerId,
    List<ServicesModel>? services,
    List<SalonOpenCloseModel>? openCloseHours,
    ContactModel? contact,
    int? createdAt,
  }) {
    return SalonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      description: description ?? this.description,
      salonOwnerId: salonOwnerId ?? this.salonOwnerId,
      services: services ?? this.services,
      openCloseHours: openCloseHours ?? this.openCloseHours,
      contact: contact ?? this.contact,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'address': address.toMap(),
      'description': description,
      'salonOwnerId': salonOwnerId,
      'services': services.map((x) => x.toMap()).toList(),
      'openCloseHours': openCloseHours.map((x) => x.toMap()).toList(),
      'contact': contact.toMap(),
      'createdAt': createdAt,
    };
  }

  factory SalonModel.fromMap(Map<String, dynamic> map) {
    return SalonModel(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      address: AddressModel.fromMap(map['address'] as Map<String, dynamic>),
      description: map['description'] as String,
      salonOwnerId: map['salonOwnerId'] as String,
      services: List<ServicesModel>.from(
        (map['services'] as List<dynamic>).map<ServicesModel>(
          (x) => ServicesModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      openCloseHours: List<SalonOpenCloseModel>.from(
        (map['openCloseHours'] as List<dynamic>).map<SalonOpenCloseModel>(
          (x) => SalonOpenCloseModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      contact: ContactModel.fromMap(map['contact'] as Map<String, dynamic>),
      createdAt: map['createdAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonModel.fromJson(String source) =>
      SalonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SaloonModel(id: $id, name: $name, imageUrl: $imageUrl, address: $address, description: $description, salonOwnerId: $salonOwnerId, services: $services, openCloseHours: $openCloseHours, contact: $contact, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant SalonModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.address == address &&
        other.description == description &&
        other.salonOwnerId == salonOwnerId &&
        listEquals(other.services, services) &&
        listEquals(other.openCloseHours, openCloseHours) &&
        other.contact == contact &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        address.hashCode ^
        description.hashCode ^
        salonOwnerId.hashCode ^
        services.hashCode ^
        openCloseHours.hashCode ^
        contact.hashCode ^
        createdAt.hashCode;
  }

  static SalonModel initial() {
    return SalonModel(
      id: '',
      name: '',
      imageUrl: '',
      address: AddressModel.initial(),
      description: '',
      salonOwnerId: '',
      services: [],
      openCloseHours: [],
      contact: ContactModel.initial(),
      createdAt: 0,
    );
  }

  static List<SalonModel> dummySalons() {
    return [
      SalonModel(
        id: '1MDY4k4UDDgdHcxa41La',
        name: 'Accra Beauty Lounge',
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@accrabeautylounge.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        imageUrl: Assets.imagesSaloon1,
        address: AddressModel(
          street: '12 Independence Ave',
          city: 'Accra',
          region: 'Greater Accra',
          latitude: '5.6037',
          longitude: '-0.1870',
          country: 'Ghana',
        ),
        description: 'Salon in capital city',
        salonOwnerId: 'owner1',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Men\'s Haircut',
            price: 50.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Women\'s Haircut',
            price: 70.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Manicure',
            price: 40.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Bridal Makeup',
            price: 250.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Full Body Massage',
            price: 150.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: '7pxT33zeKEarHxIxwZ6f',
        name: 'Kumasi Style Hub',
        imageUrl: Assets.imagesSaloon2,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@kumasistylehub.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '45 Adum Rd',
          city: 'Kumasi',
          region: 'Ashanti',
          latitude: '6.6666',
          longitude: '-1.6163',
          country: 'Ghana',
        ),
        description: 'Ashanti region salon',
        salonOwnerId: 'owner2',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Buzz Cut',
            price: 35.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Layered Cut',
            price: 60.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Pedicure',
            price: 50.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'AOBas6rwZom4eFhxSn3d',
        name: 'Tamale Tress Trim',
        imageUrl: Assets.imagesSaloon3,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@tamaletresstrim.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '23 Market St',
          city: 'Tamale',
          region: 'Northern',
          latitude: '9.4008',
          longitude: '-0.8393',
          country: 'Ghana',
        ),
        description: 'Northern region salon',
        salonOwnerId: 'owner3',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Crew Cut',
            price: 30.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Bob Cut',
            price: 55.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'French Manicure',
            price: 60.0,
          ),

          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Aromatherapy Massage',
            price: 140.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'EEd0o6BIS4O62KHv46zH',
        name: 'Takoradi Cut & Style',
        imageUrl: Assets.imagesSalon4,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@takoradicutandstyle.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '9 Harbour Way',
          city: 'Takoradi',
          region: 'Western',
          latitude: '4.8910',
          longitude: '-1.7600',
          country: 'Ghana',
        ),
        description: 'Western region salon',
        salonOwnerId: 'owner4',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Fade Cut',
            price: 40.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Pixie Cut',
            price: 65.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Gel Nails',
            price: 70.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Party Makeup',
            price: 150.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'FiToYQI20YIrN8OwTx04',
        name: 'Tema Hair Art',
        imageUrl: Assets.imagesHead1,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@temahairart.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '7 Beach Rd',
          city: 'Tema',
          region: 'Greater Accra',
          latitude: '5.6660',
          longitude: '-0.0167',
          country: 'Ghana',
        ),
        description: 'Tema based salon',
        salonOwnerId: 'owner5',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Undercut',
            price: 45.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Shag Cut',
            price: 55.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Acrylic Nails',
            price: 80.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Photo Shoot Makeup',
            price: 200.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Reflexology Massage',
            price: 150.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'HeFHea2ZzXQv2JvCnGtB',
        name: 'Cape Coast Curls',
        imageUrl: Assets.imagesHead2,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@cape-coast-curls.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '33 Castle St',
          city: 'Cape Coast',
          region: 'Central',
          latitude: '5.1053',
          longitude: '-1.2466',
          country: 'Ghana',
        ),
        description: 'Central region salon',
        salonOwnerId: 'owner6',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Layer Cut',
            price: 60.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Mohawk Cut',
            price: 50.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Classic Pedicure',
            price: 50.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Wedding Makeup',
            price: 280.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Neck & Shoulder Massage',
            price: 130.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'JtyZLhAjiRAxpAftbB9X',
        name: 'Ho Hair Haven',
        imageUrl: Assets.imagesHead3,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@ho-hair-haven.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '50 Market St',
          city: 'Ho',
          region: 'Volta',
          latitude: '6.6000',
          longitude: '0.4700',
          country: 'Ghana',
        ),
        description: 'Volta region salon',
        salonOwnerId: 'owner7',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Pompadour Cut',
            price: 70.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Fringe Cut',
            price: 50.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Gel Pedicure',
            price: 65.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Glam Makeup',
            price: 220.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Sports Massage',
            price: 180.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'VFOcxam5eNEIVYIHSqMa',
        name: 'Sunyani Scissors',
        imageUrl: Assets.imagesHead4,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@sunyaniscissors.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '20 Main Rd',
          city: 'Sunyani',
          region: 'Bono',
          latitude: '7.3397',
          longitude: '-2.3253',
          country: 'Ghana',
        ),
        description: 'Bono region salon',
        salonOwnerId: 'owner8',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Caesar Cut',
            price: 40.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Long Layers',
            price: 75.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Spa Manicure',
            price: 70.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Festival Makeup',
            price: 190.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Deep Tissue Massage',
            price: 200.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'XwIKxRYgKbyg2rVWqN20',
        name: 'Wa Waves',
        imageUrl: Assets.imagesSalon5,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@wawaves.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '15 Station St',
          city: 'Wa',
          region: 'Upper West',
          latitude: '10.0607',
          longitude: '-2.5010',
          country: 'Ghana',
        ),
        description: 'Upper West region salon',
        salonOwnerId: 'owner9',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Flat Top',
            price: 35.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Lob Cut',
            price: 65.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Nail Art',
            price: 85.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Natural Makeup',
            price: 160.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Thai Massage',
            price: 170.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'mz5S2rw9PR8qedPgRbD4',
        name: 'Elmina Elegance',
        imageUrl: Assets.imagesSalon6,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@elmina-elegance.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '5 Bay Rd',
          city: 'Elmina',
          region: 'Central',
          latitude: '5.0833',
          longitude: '-1.3667',
          country: 'Ghana',
        ),
        description: 'Historic coastal salon',
        salonOwnerId: 'owner10',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Taper Cut',
            price: 45.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Choppy Cut',
            price: 60.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Polish Change',
            price: 35.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Photoshoot Glam',
            price: 210.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Head Massage',
            price: 120.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'qdoJ86zsfqTXC11vYRYd',
        name: 'Accra Afro Salon',
        imageUrl: Assets.imagesSalon7,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@accrabeautylounge.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '8 Oxford St',
          city: 'Accra',
          region: 'Greater Accra',
          latitude: '5.6037',
          longitude: '-0.1870',
          country: 'Ghana',
        ),
        description: 'Afro hair specialists in Accra',
        salonOwnerId: 'owner11',
        services: [
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Afro Cut',
            price: 55.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Haircuts',
              imageUrl: Assets.imagesBarber,
            ),
            name: 'Twist Out',
            price: 65.0,
          ),
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Nail Extensions',
            price: 90.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Fashion Makeup',
            price: 230.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Couples Massage',
            price: 300.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      SalonModel(
        id: 'wRg73SMrCKe5vHGMouXU',
        name: 'Kumasi Kinks & Curls',
        imageUrl: Assets.imagesSalon8,
        contact: ContactModel(
          phoneNumber: '0301234567',
          whatsappNumber: '0301234567',
          email: 'info@kumasikinks.com',
        ),
        openCloseHours: [
          SalonOpenCloseModel(
            day: 'Monday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Tuesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Wednesday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Thursday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Friday',
            openTime: '08:00',
            closeTime: '20:00',
          ),
          SalonOpenCloseModel(
            day: 'Saturday',
            openTime: '09:00',
            closeTime: '18:00',
          ),
          SalonOpenCloseModel(
            day: 'Sunday',
            openTime: '10:00',
            closeTime: '16:00',
          ),
        ],
        address: AddressModel(
          street: '10 Central Market Rd',
          city: 'Kumasi',
          region: 'Ashanti',
          latitude: '6.6666',
          longitude: '-1.6163',
          country: 'Ghana',
        ),
        description: 'Specializing in natural hair',
        salonOwnerId: 'owner12',
        services: [
          ServicesModel(
            category: CategoryData(name: 'Nails', imageUrl: Assets.imagesNails),
            name: 'Shellac Nails',
            price: 75.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Makeup',
              imageUrl: Assets.imagesMakeup,
            ),
            name: 'Theatrical Makeup',
            price: 250.0,
          ),
          ServicesModel(
            category: CategoryData(
              name: 'Massage',
              imageUrl: Assets.imagesMassage,
            ),
            name: 'Lymphatic Drainage Massage',
            price: 200.0,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    ];
  }
}
