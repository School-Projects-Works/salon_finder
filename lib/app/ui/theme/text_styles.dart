// text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle headline1 = GoogleFonts.montserrat(
    fontSize: 96,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static TextStyle headline2 = GoogleFonts.montserrat(
    fontSize: 60,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static TextStyle headline3 = GoogleFonts.montserrat(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle headline4 = GoogleFonts.montserrat(
    fontSize: 34,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static TextStyle headline5 = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static TextStyle headline6 = GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // Body Text
  static TextStyle bodyText1 = GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  static TextStyle bodyText2 = GoogleFonts.openSans(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Button Text
  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // Caption (for small secondary info)
  static TextStyle caption = GoogleFonts.openSans(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
  );

  // Subtitle Text
  static TextStyle subtitle1 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static TextStyle subtitle2 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}
