// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RatingModel {
  String id;
  String userId;
  String salonId;
  double rating;
  String comment;
  int createdAt;

  RatingModel({
    required this.id,
    required this.userId,
    required this.salonId,
    required this.rating,
    required this.comment,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  RatingModel copyWith({
    String? id,
    String? userId,
    String? salonId,
    double? rating,
    String? comment,
    int? createdAt,
  }) {
    return RatingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      salonId: salonId ?? this.salonId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'salonId': salonId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      salonId: map['salonId'] as String,
      rating: map['rating'] as double,
      comment: map['comment'] as String,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : DateTime.now().millisecondsSinceEpoch,
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingModel.fromJson(String source) =>
      RatingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RatingModel(id: $id, userId: $userId, salonId: $salonId, rating: $rating, comment: $comment, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant RatingModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.salonId == salonId &&
      other.rating == rating &&
      other.comment == comment &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      salonId.hashCode ^
      rating.hashCode ^
      comment.hashCode ^
      createdAt.hashCode;
  }

  static RatingModel initial() {
    return RatingModel(
      id: '',
      userId: '',
      salonId: '',
      rating: 0.0,
      comment: '',
      createdAt: 0,
    );
  }

  static List<RatingModel> dummyRatings() {
    return [
  // Accra Beauty Lounge
  RatingModel(id: 'r1', userId: 'u1', salonId: '1', rating: 2.8, comment: 'Great service and friendly staff'),
  RatingModel(id: 'r2', userId: 'u2', salonId: '1', rating: 1.5, comment: 'Loved my haircut'),
  RatingModel(id: 'r3', userId: 'u3', salonId: '1', rating: 3.0, comment: 'Best salon in Accra'),
  RatingModel(id: 'r4', userId: 'u4', salonId: '1', rating: 4.7, comment: 'Very clean and professional'),
  RatingModel(id: 'r5', userId: 'u5', salonId: '1', rating: 3.9, comment: 'Excellent experience'),

  // Kumasi Style Hub
  RatingModel(id: 'r6', userId: 'u6', salonId: '2', rating: 1.6, comment: 'Stylists are skilled'),
  RatingModel(id: 'r7', userId: 'u7', salonId: '2', rating: 4.3, comment: 'Nice atmosphere'),
  RatingModel(id: 'r8', userId: 'u8', salonId: '2', rating: 2.8, comment: 'Always satisfied'),
  RatingModel(id: 'r9', userId: 'u9', salonId: '2', rating: 4.9, comment: 'Highly recommended'),
  RatingModel(id: 'r10', userId: 'u10', salonId: '2', rating: 2.5, comment: 'Affordable prices'),

  // Tamale Tress Trim
  RatingModel(id: 'r11', userId: 'u11', salonId: '3', rating: 4.4, comment: 'Good haircut'),
  RatingModel(id: 'r12', userId: 'u12', salonId: '3', rating: 4.7, comment: 'Friendly service'),
  RatingModel(id: 'r13', userId: 'u13', salonId: '3', rating: 4.6, comment: 'Clean and neat'),
  RatingModel(id: 'r14', userId: 'u14', salonId: '3', rating: 4.9, comment: 'Loved the pedicure'),
  RatingModel(id: 'r15', userId: 'u15', salonId: '3', rating: 4.5, comment: 'Very relaxing'),

  // Takoradi Cut & Style
  RatingModel(id: 'r16', userId: 'u16', salonId: '4', rating: 4.8, comment: 'Excellent haircut'),
  RatingModel(id: 'r17', userId: 'u17', salonId: '4', rating: 4.5, comment: 'Nice staff'),
  RatingModel(id: 'r18', userId: 'u18', salonId: '4', rating: 4.6, comment: 'Clean place'),
  RatingModel(id: 'r19', userId: 'u19', salonId: '4', rating: 4.7, comment: 'Loved the massage'),
  RatingModel(id: 'r20', userId: 'u20', salonId: '4', rating: 4.9, comment: 'Highly skilled'),

  // Tema Hair Art
  RatingModel(id: 'r21', userId: 'u21', salonId: '5', rating: 4.7, comment: 'Professional service'),
  RatingModel(id: 'r22', userId: 'u22', salonId: '5', rating: 3.4, comment: 'Nice hair stylist'),
  RatingModel(id: 'r23', userId: 'u23', salonId: '5', rating: 4.8, comment: 'Great experience'),
  RatingModel(id: 'r24', userId: 'u24', salonId: '5', rating: 3.6, comment: 'Loved the manicure'),
  RatingModel(id: 'r25', userId: 'u25', salonId: '5', rating: 4.9, comment: 'Very clean'),

  // Cape Coast Curls
  RatingModel(id: 'r26', userId: 'u26', salonId: '6', rating: 4.8, comment: 'Great atmosphere'),
  RatingModel(id: 'r27', userId: 'u27', salonId: '6', rating: 4.6, comment: 'Loved the haircut'),
  RatingModel(id: 'r28', userId: 'u28', salonId: '6', rating: 2.5, comment: 'Friendly staff'),
  RatingModel(id: 'r29', userId: 'u29', salonId: '6', rating: 4.7, comment: 'Neat and clean'),
  RatingModel(id: 'r30', userId: 'u30', salonId: '6', rating: 2.9, comment: 'Perfect wedding makeup'),

  // Ho Hair Haven
  RatingModel(id: 'r31', userId: 'u31', salonId: '7', rating: 4.5, comment: 'Good hair stylist'),
  RatingModel(id: 'r32', userId: 'u32', salonId: '7', rating: 3.6, comment: 'Very polite staff'),
  RatingModel(id: 'r33', userId: 'u33', salonId: '7', rating: 4.8, comment: 'Loved the glam makeup'),
  RatingModel(id: 'r34', userId: 'u34', salonId: '7', rating: 3.9, comment: 'Nice pedicure'),
  RatingModel(id: 'r35', userId: 'u35', salonId: '7', rating: 4.4, comment: 'Affordable prices'),

  // Sunyani Scissors
  RatingModel(id: 'r36', userId: 'u36', salonId: '8', rating: 2.6, comment: 'Good barber'),
  RatingModel(id: 'r37', userId: 'u37', salonId: '8', rating: 4.7, comment: 'Loved the manicure'),
  RatingModel(id: 'r38', userId: 'u38', salonId: '8', rating: 1.5, comment: 'Nice environment'),
  RatingModel(id: 'r39', userId: 'u39', salonId: '8', rating: 4.8, comment: 'Skilled staff'),
  RatingModel(id: 'r40', userId: 'u40', salonId: '8', rating: 3.9, comment: 'Great deep tissue massage'),

  // Wa Waves
  RatingModel(id: 'r41', userId: 'u41', salonId: '9', rating: 4.7, comment: 'Professional barber'),
  RatingModel(id: 'r42', userId: 'u42', salonId: '9', rating: 2.6, comment: 'Nice nail art'),
  RatingModel(id: 'r43', userId: 'u43', salonId: '9', rating: 4.8, comment: 'Good customer service'),
  RatingModel(id: 'r44', userId: 'u44', salonId: '9', rating: 3.5, comment: 'Relaxing massage'),
  RatingModel(id: 'r45', userId: 'u45', salonId: '9', rating: 4.9, comment: 'Highly recommended'),

  // Elmina Elegance
  RatingModel(id: 'r46', userId: 'u46', salonId: '10', rating: 2.8, comment: 'Loved the choppy cut'),
  RatingModel(id: 'r47', userId: 'u47', salonId: '10', rating: 4.6, comment: 'Polite staff'),
  RatingModel(id: 'r48', userId: 'u48', salonId: '10', rating: 3.7, comment: 'Great photoshoot glam'),
  RatingModel(id: 'r49', userId: 'u49', salonId: '10', rating: 2.5, comment: 'Nice head massage'),
  RatingModel(id: 'r50', userId: 'u50', salonId: '10', rating: 4.9, comment: 'Perfect service'),


    ];
  }
}
