// colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary & Secondary
  static const Color primaryColor = Colors.deepPurple;
  static const Color secondaryColor = Colors.white;

  // Accent Colors
  static const Color accentRed = Color(0xFFFF1E1E); // Deep Red
  static const Color accentBlue = Color(0xFF03A9F4); // Cool Blue

  // Background Colors
  static const Color backgroundLight = Color.fromARGB(
    255,
    237,
    235,
    235,
  ); // Light Background
  static const Color backgroundDark = Color(0xFF121212); // Dark Background

  // Surface Colors
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF212121); // Dark Surface

  // Text Colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.white;
  static const Color textMuted = Color(0xFFB0B0B0); // Muted Text

  // Error & Success
  static const Color errorColor = Color(0xFFFF5252); // Error Color
  static const Color successColor = Color(0xFF4CAF50); // Success Color
}
