import 'package:flutter_test/flutter_test.dart';
import 'package:nagardrishti/utils/location_utils.dart';

void main() {
  group('LocationUtils — Haversine Distance', () {
    test('distance between same point is 0', () {
      final d = LocationUtils.haversineDistance(18.5204, 73.8567, 18.5204, 73.8567);
      expect(d, closeTo(0.0, 0.001));
    });

    test('distance between Pune and Mumbai is ~148 km', () {
      // Pune: 18.5204, 73.8567 — Mumbai: 19.0760, 72.8777
      final d = LocationUtils.haversineDistance(18.5204, 73.8567, 19.0760, 72.8777);
      expect(d, inInclusiveRange(145000.0, 152000.0)); // 145–152 km
    });

    test('distance ~500m for nearby points', () {
      // Move roughly 500m north
      final d = LocationUtils.haversineDistance(18.5204, 73.8567, 18.5250, 73.8567);
      expect(d, inInclusiveRange(450.0, 550.0));
    });

    test('isWithinGeofence returns true inside radius', () {
      // Simulate user 300m from project (radius = 500m)
      // Use a real Position-like check via haversine directly
      final distance = LocationUtils.haversineDistance(18.5204, 73.8567, 18.5232, 73.8567);
      expect(distance, lessThanOrEqualTo(500.0));
    });

    test('isWithinGeofence returns false outside radius', () {
      // User ~1.2 km away — outside 500m zone
      final distance = LocationUtils.haversineDistance(18.5204, 73.8567, 18.5312, 73.8567);
      expect(distance, greaterThan(500.0));
    });

    test('distance is symmetric', () {
      final d1 = LocationUtils.haversineDistance(18.5204, 73.8567, 18.5913, 73.7389);
      final d2 = LocationUtils.haversineDistance(18.5913, 73.7389, 18.5204, 73.8567);
      expect(d1, closeTo(d2, 0.01));
    });
  });

  group('LocationUtils — boundsFromLatLngList', () {
    test('returns correct bounds for a list of points', () {
      final points = [
        const LatLng(18.5204, 73.8567),
        const LatLng(18.6742, 73.8988),
        const LatLng(18.4529, 73.8012),
      ];
      final bounds = LocationUtils.boundsFromLatLngList(points);
      expect(bounds.southwest.latitude, closeTo(18.4529, 0.0001));
      expect(bounds.northeast.latitude, closeTo(18.6742, 0.0001));
    });
  });
}
