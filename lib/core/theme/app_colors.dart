// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF1E88E5);       // Modern blue
  static const primaryLight = Color(0xFF64B5F6);
  static const primaryDark = Color(0xFF1565C0);

  // Secondary Colors
  static const secondary = Color(0xFF26A69A);     // Teal
  static const secondaryLight = Color(0xFF4DB6AC);
  static const secondaryDark = Color(0xFF00897B);

  // Background Colors
  static const surface = Colors.white;
  static const background = Color(0xFFF5F7FA);
  static const cardBackground = Colors.white;

  // Text Colors
  static const textPrimary = Color(0xFF2C3E50);   // Dark blue-gray
  static const textSecondary = Color(0xFF78909C);
  static const textHint = Color(0xFFB0BEC5);

  // Status Colors
  static const success = Color(0xFF66BB6A);       // Green
  static const error = Color(0xFFEF5350);         // Red
  static const warning = Color(0xFFFFCA28);       // Amber
  static const info = Color(0xFF29B6F6);          // Light Blue

  // Fuel Level Colors
  static const fuelHigh = Color(0xFF66BB6A);      // Green
  static const fuelMedium = Color(0xFFFFB74D);    // Orange
  static const fuelLow = Color(0xFFEF5350);       // Red

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF1E88E5),
    Color(0xFF64B5F6),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF26A69A),
    Color(0xFF4DB6AC),
  ];

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF1E88E5),
    Color(0xFF26A69A),
    Color(0xFFFFB74D),
    Color(0xFFEF5350),
    Color(0xFF9575CD),
  ];

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}