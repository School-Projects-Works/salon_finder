// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'address_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  String profilePictureUrl;
  String? password;
  AddressModel? address;
  String status; // e.g., "active", "inactive", "banned"
  DateTime createdAt;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePictureUrl,
    this.password,
    this.address,
    required this.status,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    String? password,
    AddressModel? address,
    String? status,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      password: password ?? this.password,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'password': password,
      'address': address?.toMap(),
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      profilePictureUrl: map['profilePictureUrl'] as String,
      password: map['password'] != null ? map['password'] as String : null,
      address: map['address'] != null ? AddressModel.fromMap(map['address'] as Map<String,dynamic>) : null,
      status: map['status'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, profilePictureUrl: $profilePictureUrl, password: $password, address: $address, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.phoneNumber == phoneNumber &&
      other.profilePictureUrl == profilePictureUrl &&
      other.password == password &&
      other.address == address &&
      other.status == status &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      profilePictureUrl.hashCode ^
      password.hashCode ^
      address.hashCode ^
      status.hashCode ^
      createdAt.hashCode;
  }

  static UserModel initial() {
    return UserModel(
      id: '',
      name: '',
      email: '',
      phoneNumber: '',
      profilePictureUrl: '',
      password: null,
      address: null,
      status: 'active',
      createdAt: DateTime.now(),
    );
  }
}
