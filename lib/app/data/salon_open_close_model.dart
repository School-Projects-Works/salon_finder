import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SalonOpenCloseModel {
  String day;
  String openTime;
  String closeTime;

  SalonOpenCloseModel({
    required this.day,
    required this.openTime,
    required this.closeTime,
  });

  SalonOpenCloseModel copyWith({
    String? day,
    String? openTime,
    String? closeTime,
  }) {
    return SalonOpenCloseModel(
      day: day ?? this.day,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'day': day,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }

  factory SalonOpenCloseModel.fromMap(Map<String, dynamic> map) {
    return SalonOpenCloseModel(
      day: map['day'] as String,
      openTime: map['openTime'] as String,
      closeTime: map['closeTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonOpenCloseModel.fromJson(String source) =>
      SalonOpenCloseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static SalonOpenCloseModel initial() {
    return SalonOpenCloseModel(day: '', openTime: '', closeTime: '');
  }

  static List<SalonOpenCloseModel> defaultData() {
    return [
      SalonOpenCloseModel(day: 'Monday', openTime: '08:00', closeTime: '20:00'),
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
      SalonOpenCloseModel(day: 'Friday', openTime: '08:00', closeTime: '20:00'),
      SalonOpenCloseModel(
        day: 'Saturday',
        openTime: '09:00',
        closeTime: '18:00',
      ),
      SalonOpenCloseModel(day: 'Sunday', openTime: '10:00', closeTime: '16:00'),
    ];
  }
}
