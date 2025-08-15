// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:salon_finder/generated/assets.dart';

class CategoryData {
  String name;
  String imageUrl;

  CategoryData({
    required this.name,
    required this.imageUrl,
  });

 static List<CategoryData> get categories => [
        CategoryData(
          name: 'Haircuts',
          imageUrl: Assets.imagesBarber,
        ),
        CategoryData(
          name: 'Nails',
          imageUrl: Assets.imagesNails,
        ),
        CategoryData(
          name: 'Makeup',
          imageUrl: Assets.imagesMakeup,
        ),
        CategoryData(
          name: 'Massage',
          imageUrl: Assets.imagesMassage,
        ),
      ];

  CategoryData copyWith({
    String? name,
    String? imageUrl,
  }) {
    return CategoryData(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory CategoryData.fromMap(Map<String, dynamic> map) {
    return CategoryData(
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryData.fromJson(String source) => CategoryData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoryData(name: $name, imageUrl: $imageUrl)';

  @override
  bool operator ==(covariant CategoryData other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => name.hashCode ^ imageUrl.hashCode;
}
