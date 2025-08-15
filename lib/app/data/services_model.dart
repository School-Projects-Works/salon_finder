// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'category_data.dart';

class ServicesModel {
  CategoryData category;
  String name;
  double price;
  ServicesModel({
    required this.category,
    required this.name,
    required this.price,
  });

  ServicesModel copyWith({
    CategoryData? category,
    String? name,
    double? price,
  }) {
    return ServicesModel(
      category: category ?? this.category,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category.toMap(),
      'name': name,
      'price': price,
    };
  }

  factory ServicesModel.fromMap(Map<String, dynamic> map) {
    return ServicesModel(
      category: CategoryData.fromMap(map['category'] as Map<String,dynamic>),
      name: map['name'] as String,
      price:   double.parse(map['price'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicesModel.fromJson(String source) => ServicesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ServicesModel(category: $category, name: $name, price: $price)';

  @override
  bool operator ==(covariant ServicesModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.category == category &&
      other.name == name &&
      other.price == price;
  }

  @override
  int get hashCode => category.hashCode ^ name.hashCode ^ price.hashCode;
}
