import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddressModel {
  String street;
  String city;
  String region;
  String country;
  String latitude;
  String longitude;
  AddressModel({
    required this.street,
    required this.city,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  AddressModel copyWith({
    String? street,
    String? city,
    String? region,
    String? country,
    String? latitude,
    String? longitude,
  }) {
    return AddressModel(
      street: street ?? this.street,
      city: city ?? this.city,
      region: region ?? this.region,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'street': street,
      'city': city,
      'region': region,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      street: map['street'] as String,
      city: map['city'] as String,
      region: map['region'] as String,
      country: map['country'] as String,
      latitude: map['latitude'] as String,
      longitude: map['longitude'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) => AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(street: $street, city: $city, region: $region, country: $country, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.street == street &&
      other.city == city &&
      other.region == region &&
      other.country == country &&
      other.latitude == latitude &&
      other.longitude == longitude;
  }

  @override
  int get hashCode {
    return street.hashCode ^
      city.hashCode ^
      region.hashCode ^
      country.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
  }
}
