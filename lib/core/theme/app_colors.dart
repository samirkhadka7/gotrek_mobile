import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color primary = Color(0xFF1565C0); // Deep Blue
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF0D47A1);

  // Secondary colors
  static const Color secondary = Color(0xFF2E7D32); // Forest Green
  static const Color secondaryLight = Color(0xFF81C784);
  static const Color secondaryDark = Color(0xFF1B5E20);

  // Accent colors
  static const Color accent = Color(0xFFFF6F00); // Amber/Orange
  static const Color accentLight = Color(0xFFFFB74D);
  static const Color accentDark = Color(0xFFE65100);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFEEEEEE);
  static const Color greyDark = Color(0xFF616161);

  // Background colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F0F0);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Trail difficulty colors
  static const Color difficultyEasy = Color(0xFF4CAF50);
  static const Color difficultyModerate = Color(0xFFFF9800);
  static const Color difficultyHard = Color(0xFFF44336);
  static const Color difficultyExpert = Color(0xFF9C27B0);

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF1565C0),
    Color(0xFF42A5F5),
  ];

  static const List<Color> successGradient = [
    Color(0xFF2E7D32),
    Color(0xFF66BB6A),
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFFFF6F00),
    Color(0xFFFFB74D),
  ];
}
