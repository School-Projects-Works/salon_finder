// theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.surfaceLight,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: AppColors.surfaceLight,
      error: AppColors.errorColor,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    menuBarTheme: MenuBarThemeData(
     style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.surfaceLight),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: AppColors.textMuted, width: 0.5),
          ),
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(buttonColor: AppColors.accentRed),
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 96,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      bodySmall: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      displayLarge: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      labelLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      labelSmall: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textMuted,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: AppColors.surfaceDark,
      error: AppColors.errorColor,
      onPrimary: AppColors.textSecondary,
      onSecondary: AppColors.textSecondary,
      onSurface: AppColors.textSecondary,
      onError: Colors.white,
    ),
   useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.surfaceDark,
    buttonTheme: ButtonThemeData(buttonColor: AppColors.accentRed),
    iconTheme: IconThemeData(color: AppColors.textSecondary),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 96,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      titleSmall: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      labelMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),

    ),
  );
}
