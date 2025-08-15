// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransactionsModel {
  String id;
  String appointmentId;
  String userId;
  String salonId;
  String status;
  String reference;
  double amount;
  String paymentMethod;
  int createdAt;
  TransactionsModel({
    required this.id,
    required this.appointmentId,
    required this.userId,
    required this.salonId,
    required this.status,
    required this.reference,
    required this.amount,
    required this.paymentMethod,
    required this.createdAt,
  });

  TransactionsModel copyWith({
    String? id,
    String? appointmentId,
    String? userId,
    String? salonId,
    String? status,
    String? reference,
    double? amount,
    String? paymentMethod,
    int? createdAt,
  }) {
    return TransactionsModel(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      userId: userId ?? this.userId,
      salonId: salonId ?? this.salonId,
      status: status ?? this.status,
      reference: reference ?? this.reference,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'appointmentId': appointmentId,
      'userId': userId,
      'salonId': salonId,
      'status': status,
      'reference': reference,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt,
    };
  }

  factory TransactionsModel.fromMap(Map<String, dynamic> map) {
    return TransactionsModel(
      id: map['id'] as String,
      appointmentId: map['appointmentId'] as String,
      userId: map['userId'] as String,
      salonId: map['salonId'] as String,
      status: map['status'] as String,
      reference: map['reference'] as String,
      amount: map['amount'] as double,
      paymentMethod: map['paymentMethod'] as String,
      createdAt: map['createdAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionsModel.fromJson(String source) => TransactionsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransactionsModel(id: $id, appointmentId: $appointmentId, userId: $userId, salonId: $salonId, status: $status, reference: $reference, amount: $amount, paymentMethod: $paymentMethod, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant TransactionsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.appointmentId == appointmentId &&
      other.userId == userId &&
      other.salonId == salonId &&
      other.status == status &&
      other.reference == reference &&
      other.amount == amount &&
      other.paymentMethod == paymentMethod &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      appointmentId.hashCode ^
      userId.hashCode ^
      salonId.hashCode ^
      status.hashCode ^
      reference.hashCode ^
      amount.hashCode ^
      paymentMethod.hashCode ^
      createdAt.hashCode;
  }

  static TransactionsModel initial() {
    return TransactionsModel(
      id: '',
      appointmentId: '',
      userId: '',
      salonId: '',
      status: 'pending',
      reference: '',
      amount: 0.0,
      paymentMethod: '',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
