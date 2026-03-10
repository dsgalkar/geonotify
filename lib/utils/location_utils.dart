import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtils {
  LocationUtils._();

  /// Haversine formula — returns distance in meters between two lat/lng points
  static double haversineDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const R = 6371000.0; // Earth's radius in meters
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final dPhi = (lat2 - lat1) * pi / 180;
    final dLambda = (lon2 - lon1) * pi / 180;

    final a = sin(dPhi / 2) * sin(dPhi / 2) +
        cos(phi1) * cos(phi2) * sin(dLambda / 2) * sin(dLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  /// Distance between a [Position] and a [LatLng]
  static double distanceFromPosition(Position position, LatLng target) {
    return haversineDistance(
      position.latitude, position.longitude,
      target.latitude, target.longitude,
    );
  }

  /// Returns true if a position is within [radiusMeters] of a target
  static bool isWithinGeofence(Position position, LatLng target, double radiusMeters) {
    return distanceFromPosition(position, target) <= radiusMeters;
  }

  /// Returns a bounding box [LatLngBounds] that fits all given points
  static LatLngBounds boundsFromLatLngList(List<LatLng> points) {
    assert(points.isNotEmpty);
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Offset a LatLng by [meters] in a given [bearingDegrees]
  static LatLng offsetByMeters(LatLng origin, double meters, double bearingDegrees) {
    const R = 6371000.0;
    final bearing = bearingDegrees * pi / 180;
    final lat1 = origin.latitude * pi / 180;
    final lng1 = origin.longitude * pi / 180;
    final lat2 = asin(sin(lat1) * cos(meters / R) +
        cos(lat1) * sin(meters / R) * cos(bearing));
    final lng2 = lng1 +
        atan2(sin(bearing) * sin(meters / R) * cos(lat1),
            cos(meters / R) - sin(lat1) * sin(lat2));
    return LatLng(lat2 * 180 / pi, lng2 * 180 / pi);
  }

  /// Checks and requests location permission. Returns true if granted.
  static Future<bool> ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Gets current position once (not a stream)
  static Future<Position?> getCurrentPosition() async {
    final hasPermission = await ensureLocationPermission();
    if (!hasPermission) return null;
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns a human-readable compass direction from bearing degrees
  static String compassDirection(double degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) % 360 / 45).floor();
    return directions[index % 8];
  }
}
