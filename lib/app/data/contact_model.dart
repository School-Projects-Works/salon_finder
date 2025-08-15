// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ContactModel {
  String phoneNumber;
  String whatsappNumber;
  String email;

  ContactModel({
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.email,
  });

  ContactModel copyWith({
    String? phoneNumber,
    String? whatsappNumber,
    String? email,
  }) {
    return ContactModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'whatsappNumber': whatsappNumber,
      'email': email,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      phoneNumber: map['phoneNumber'] as String,
      whatsappNumber: map['whatsappNumber'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) => ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ContactModel(phoneNumber: $phoneNumber, whatsappNumber: $whatsappNumber, email: $email)';

  @override
  bool operator ==(covariant ContactModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.phoneNumber == phoneNumber &&
      other.whatsappNumber == whatsappNumber &&
      other.email == email;
  }

  @override
  int get hashCode => phoneNumber.hashCode ^ whatsappNumber.hashCode ^ email.hashCode;

  static initial() {
    return ContactModel(
      phoneNumber: '',
      whatsappNumber: '',
      email: '',
    );
  }
}
