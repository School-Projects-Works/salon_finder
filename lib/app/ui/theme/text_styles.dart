// text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
 static TextStyle title({
    double? fontSize = 20,
    Color? color = AppColors.textPrimary,
    FontWeight? fontWeight = FontWeight.bold,
    TextDecoration? decoration = TextDecoration.none,
    double? letterSpacing = 0.5,
    double? wordSpacing = 0.5,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
    );
 }
  static TextStyle subtitle1({
      double? fontSize = 16,
      Color? color = AppColors.textSecondary,
      FontWeight? fontWeight = FontWeight.w500,
      TextDecoration? decoration = TextDecoration.none,
      double? letterSpacing = 0.5,
      double? wordSpacing = 0.5,
    }) {
      return GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      );
    }

  static TextStyle body({
      double? fontSize = 14,
      Color? color = AppColors.textPrimary,
      FontWeight? fontWeight = FontWeight.normal,
      TextDecoration? decoration = TextDecoration.none,
      double? letterSpacing = 0.5,
      double? wordSpacing = 0.5,
    }) {
      return GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      );
    }
  static TextStyle button({
      double? fontSize = 16,
      Color? color = Colors.white,
      FontWeight? fontWeight = FontWeight.bold,
      TextDecoration? decoration = TextDecoration.none,
      double? letterSpacing = 1.0,
      double? wordSpacing = 0.5,
    }) {
      return GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      );
    }
  static TextStyle caption({
      double? fontSize = 12,
      Color? color = AppColors.textSecondary,
      FontWeight? fontWeight = FontWeight.w400,
      TextDecoration? decoration = TextDecoration.none,
      double? letterSpacing = 0.5,
      double? wordSpacing = 0.5,
    }) {
      return GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      );
    }



}
