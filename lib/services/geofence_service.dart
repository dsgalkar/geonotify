import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/project.dart';

class GeofenceService extends ChangeNotifier {
  Position? _currentPosition;
  final Set<String> _notifiedProjects = {};
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notifications.initialize(initSettings);
  }

  Future<bool> requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> startTracking(List<CivicProject> projects) async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) return;

    _isTracking = true;
    notifyListeners();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50, // Update every 50m moved
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _currentPosition = position;
      _checkGeofences(position, projects);
      notifyListeners();
    });
  }

  void stopTracking() {
    _positionStream?.cancel();
    _isTracking = false;
    notifyListeners();
  }

  void _checkGeofences(Position position, List<CivicProject> projects) {
    for (final project in projects) {
      final distance = _calculateDistance(
        position.latitude, position.longitude,
        project.latitude, project.longitude,
      );

      if (distance <= project.geofenceRadius && !_notifiedProjects.contains(project.id)) {
        _notifiedProjects.add(project.id);
        _sendNotification(project, distance.toInt());
      } else if (distance > project.geofenceRadius + 100) {
        // Reset when user leaves the zone (+100m buffer)
        _notifiedProjects.remove(project.id);
      }
    }
  }

  Future<void> _sendNotification(CivicProject project, int distanceMeters) async {
    const androidDetails = AndroidNotificationDetails(
      'civicpulse_geofence',
      'CivicPulse Nearby Projects',
      channelDescription: 'Notifications for government projects near you',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
      color: Color(0xFF0A2463),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(
      project.id.hashCode,
      '${project.statusEmoji} ${project.title}',
      '${distanceMeters}m away • ${project.completionPercent}% complete • ₹${project.budget.toStringAsFixed(0)} Cr project. Tap to learn more.',
      details,
    );
  }

  // Haversine distance formula (meters)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // Earth radius in meters
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final dPhi = (lat2 - lat1) * pi / 180;
    final dLambda = (lon2 - lon1) * pi / 180;
    final a = sin(dPhi / 2) * sin(dPhi / 2) +
        cos(phi1) * cos(phi2) * sin(dLambda / 2) * sin(dLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  /// Returns distance in meters between current position and a project
  double? distanceTo(CivicProject project) {
    if (_currentPosition == null) return null;
    return _calculateDistance(
      _currentPosition!.latitude, _currentPosition!.longitude,
      project.latitude, project.longitude,
    );
  }

  /// Returns projects within range, sorted by distance
  List<CivicProject> getNearbyProjects(List<CivicProject> all) {
    if (_currentPosition == null) return [];
    final nearby = all.where((p) {
      final d = distanceTo(p);
      return d != null && d <= p.geofenceRadius;
    }).toList();
    nearby.sort((a, b) => (distanceTo(a) ?? 0).compareTo(distanceTo(b) ?? 0));
    return nearby;
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
