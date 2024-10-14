import 'package:flutter/material.dart';
import 'package:water_purifier/app/core/app_config/app_colors.dart';

class AppTheme {

  static ThemeData getWaterPurifierTheme() {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: AppColors.primarySwatch,
      brightness: Brightness.light,
      fontFamily: 'Montserrat',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primarySwatch.shade400,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primarySwatch.shade400,
        onPrimary: Colors.white,
        secondary: AppColors.secondaryColor, // Secondary color
        onSecondary: Colors.white,
      ),
      textTheme: _buildTextTheme(),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: 'Montserrat',
      ),
    );
  }
}
