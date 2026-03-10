import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF0A2463);      // Deep Navy Blue (govt trust)
  static const Color accent = Color(0xFF3E92CC);        // Civic Blue
  static const Color success = Color(0xFF06D6A0);       // Progress Green
  static const Color warning = Color(0xFFFFB703);       // Alert Amber
  static const Color danger = Color(0xFFEF233C);        // Red
  static const Color surface = Color(0xFFF8F9FC);       // Off-white bg
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0D1B2A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color divider = Color(0xFFE2E8F0);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      secondary: accent,
      surface: surface,
    ),
    scaffoldBackgroundColor: surface,
    // fontFamily: 'SpaceGrotesk', // uncomment after adding font files
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        // fontFamily: 'SpaceGrotesk', // uncomment after adding font files
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: divider, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          // fontFamily: 'SpaceGrotesk', // uncomment after adding font files
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      labelStyle: const TextStyle(color: textSecondary),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surface,
      selectedColor: primary.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

class AppConstants {
  static const String appName = 'CivicPulse';
  static const String tagline = 'Your Government. Your Progress.';

  // Geofence radius in meters
  static const double geofenceRadius = 500.0;  // 500m default

  // Project categories
  static const List<Map<String, dynamic>> projectCategories = [
    {'id': 'hospital', 'label': 'Hospital', 'icon': '🏥', 'color': 0xFFEF4444},
    {'id': 'college', 'label': 'College', 'icon': '🎓', 'color': 0xFF8B5CF6},
    {'id': 'bridge', 'label': 'Bridge', 'icon': '🌉', 'color': 0xFFF59E0B},
    {'id': 'road', 'label': 'Road', 'icon': '🛣️', 'color': 0xFF6B7280},
    {'id': 'water', 'label': 'Water Supply', 'icon': '💧', 'color': 0xFF3B82F6},
    {'id': 'park', 'label': 'Park', 'icon': '🌳', 'color': 0xFF10B981},
    {'id': 'metro', 'label': 'Metro/Transit', 'icon': '🚇', 'color': 0xFFEC4899},
    {'id': 'power', 'label': 'Power Grid', 'icon': '⚡', 'color': 0xFFF97316},
  ];

  // Project statuses
  static const List<String> projectStatuses = [
    'Planning',
    'Approved',
    'Under Construction',
    'Completed',
    'Paused',
  ];
}
