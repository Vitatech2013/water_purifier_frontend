import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryColor = Color(0xFF2196F3); // Your base color

  // Custom MaterialColor based on primaryColor
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF2196F3, // Main color (same as primaryColor)
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF2196F3), // Same as primaryColor
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  static const Color secondaryColor = Colors.lightBlue;
  static const Color cardColor = Color(0XFFFFFFFF);
}
