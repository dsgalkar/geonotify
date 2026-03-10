import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // ─── App Info ─────────────────────────────────────────────────
  static const String appName = 'NagarDrishti';
  static const String appNameHindi = 'नगर दृष्टि';
  static const String tagline = 'Your Government. Your Progress.';
  static const String version = '1.0.0';

  // ─── API ──────────────────────────────────────────────────────
  // Replace with your actual backend URL before demo
  static const String baseUrl = 'https://api.nagardrishti.gov.in/v1';
  static const Duration requestTimeout = Duration(seconds: 10);

  // ─── Maps ─────────────────────────────────────────────────────
  // Add your Google Maps API key in AndroidManifest.xml and AppDelegate.swift
  // DO NOT store the key here — use .env or gradle secrets
  static const double defaultLat = 18.5204; // Pune, Maharashtra
  static const double defaultLng = 73.8567;
  static const double defaultZoom = 12.0;
  static const double detailZoom = 15.0;

  // ─── Geo-fence ────────────────────────────────────────────────
  static const double defaultGeofenceRadius = 500.0;   // meters
  static const double minGeofenceRadius = 100.0;
  static const double maxGeofenceRadius = 2000.0;
  static const int locationUpdateDistance = 50;          // meters between GPS updates

  // ─── SharedPreferences Keys ───────────────────────────────────
  static const String keyProjects = 'nd_projects';
  static const String keyNotifications = 'nd_notifications';
  static const String keyUserRole = 'nd_user_role';
  static const String keyOnboarded = 'nd_onboarded';
  static const String keyFcmToken = 'nd_fcm_token';

  // ─── Project Categories ───────────────────────────────────────
  static const List<Map<String, dynamic>> projectCategories = [
    {'id': 'hospital',  'label': 'Hospital',      'icon': '🏥', 'color': Color(0xFFEF4444)},
    {'id': 'college',   'label': 'College',        'icon': '🎓', 'color': Color(0xFF8B5CF6)},
    {'id': 'bridge',    'label': 'Bridge',         'icon': '🌉', 'color': Color(0xFFF59E0B)},
    {'id': 'road',      'label': 'Road',           'icon': '🛣️', 'color': Color(0xFF6B7280)},
    {'id': 'water',     'label': 'Water Supply',   'icon': '💧', 'color': Color(0xFF3B82F6)},
    {'id': 'park',      'label': 'Park',           'icon': '🌳', 'color': Color(0xFF10B981)},
    {'id': 'metro',     'label': 'Metro/Transit',  'icon': '🚇', 'color': Color(0xFFEC4899)},
    {'id': 'power',     'label': 'Power Grid',     'icon': '⚡', 'color': Color(0xFFF97316)},
  ];

  // ─── Project Statuses ─────────────────────────────────────────
  static const List<String> projectStatuses = [
    'Planning',
    'Approved',
    'Under Construction',
    'Completed',
    'Paused',
  ];

  // ─── Status Colors ────────────────────────────────────────────
  static const Map<String, Color> statusColors = {
    'Planning':             Color(0xFF64748B),
    'Approved':             Color(0xFF3E92CC),
    'Under Construction':   Color(0xFFFFB703),
    'Completed':            Color(0xFF06D6A0),
    'Paused':               Color(0xFFEF233C),
  };

  // ─── Animation Durations ──────────────────────────────────────
  static const Duration animFast   = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow   = Duration(milliseconds: 600);

  // ─── Notification Channel ─────────────────────────────────────
  static const String notifChannelId   = 'nagardrishti_main';
  static const String notifChannelName = 'NagarDrishti Alerts';
}
