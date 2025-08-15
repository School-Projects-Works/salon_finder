// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:salon_finder/app/data/salon_model.dart';
import 'package:salon_finder/app/data/services_model.dart';
import 'package:salon_finder/app/data/user_model.dart';

class AppointmentModel {
  String id;
  UserModel user;
  String userId;
  String salonId;
  int date;
  int time;
  List<ServicesModel> services;
  double totalPrice;
  String paymentMethod;
  String userNote;
  SalonModel saloon;
  int createdAt;
  String status;
  AppointmentModel({
    required this.id,
    required this.user,
    required this.userId,
    required this.salonId,
    required this.date,
    required this.time,
    required this.services,
    required this.totalPrice,
    required this.paymentMethod,
    required this.userNote,
    required this.saloon,
    required this.createdAt,
    required this.status,
  });

  AppointmentModel copyWith({
    String? id,
    UserModel? user,
    String? userId,
    String? salonId,
    int? date,
    int? time,
    List<ServicesModel>? services,
    double? totalPrice,
    String? paymentMethod,
    String? userNote,
    SalonModel? saloon,
    int? createdAt,
    String? status,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      salonId: salonId ?? this.salonId,
      date: date ?? this.date,
      time: time ?? this.time,
      services: services ?? this.services,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      userNote: userNote ?? this.userNote,
      saloon: saloon ?? this.saloon,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'userId': userId,
      'salonId': salonId,
      'date': date,
      'time': time,
      'services': services.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'userNote': userNote,
      'saloon': saloon.toMap(),
      'createdAt': createdAt,
      'status': status,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as String,
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
      userId: map['userId'] as String,
      salonId: map['salonId'] as String,
      date: map['date'] as int,
      time: map['time'] as int,
      services: List<ServicesModel>.from(
        (map['services'] as List<dynamic>).map<ServicesModel>(
          (x) => ServicesModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalPrice: double.parse(map['totalPrice'].toString()),
      paymentMethod: map['paymentMethod'] as String,
      userNote: map['userNote'] as String,
      saloon: SalonModel.fromMap(map['saloon'] as Map<String, dynamic>),
      createdAt: map['createdAt'] as int,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentModel.fromJson(String source) =>
      AppointmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppointmentModel(id: $id, user: $user, userId: $userId, salonId: $salonId, date: $date, time: $time, services: $services, totalPrice: $totalPrice, paymentMethod: $paymentMethod, userNote: $userNote, saloon: $saloon, createdAt: $createdAt, status: $status)';
  }

  @override
  bool operator ==(covariant AppointmentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.userId == userId &&
        other.salonId == salonId &&
        other.date == date &&
        other.time == time &&
        listEquals(other.services, services) &&
        other.totalPrice == totalPrice &&
        other.paymentMethod == paymentMethod &&
        other.userNote == userNote &&
        other.saloon == saloon &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        userId.hashCode ^
        salonId.hashCode ^
        date.hashCode ^
        time.hashCode ^
        services.hashCode ^
        totalPrice.hashCode ^
        paymentMethod.hashCode ^
        userNote.hashCode ^
        saloon.hashCode ^
        createdAt.hashCode ^
        status.hashCode;
  }

  static AppointmentModel initial() {
    return AppointmentModel(
      id: '',
      user: UserModel.initial(),
      date: DateTime.now().millisecondsSinceEpoch,
      time: DateTime.now().millisecondsSinceEpoch,
      services: [],
      totalPrice: 0.0,
      paymentMethod: '',
      userNote: '',
      userId: '',
      salonId: '',
      saloon: SalonModel.initial(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: '',
    );
  }
}
