import 'package:flutter/material.dart';

class CategorySwitch extends StatefulWidget {
  const CategorySwitch({super.key, required this.title, required this.image,
    required this.activeImage,
  });
  final String title;
  final String image;
  final String activeImage;

  @override
  State<CategorySwitch> createState() => _CategorySwitchState();
}

class _CategorySwitchState extends State<CategorySwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(child: Container());
  }
}
