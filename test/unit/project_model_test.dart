import 'package:flutter_test/flutter_test.dart';
import 'package:nagardrishti/models/project.dart';

void main() {
  final testProject = CivicProject(
    id: '42',
    title: 'Test Hospital',
    category: 'hospital',
    description: 'A test hospital project',
    status: 'Under Construction',
    latitude: 18.5204,
    longitude: 73.8567,
    geofenceRadius: 500,
    budget: 1000,
    spent: 650,
    completionPercent: 65,
    startDate: 'Jan 2023',
    expectedEndDate: 'Dec 2025',
    department: 'Ministry of Health',
    contractor: 'L&T Construction',
    impacts: [CivicImpact(icon: '🏥', label: 'Beds', value: '200')],
    updates: [ProjectUpdate(date: 'Jan 2025', title: 'Foundation Done', description: 'Foundation complete.')],
    createdAt: DateTime(2023, 1, 1),
  );

  group('CivicProject — properties', () {
    test('location returns correct LatLng', () {
      expect(testProject.location.latitude, 18.5204);
      expect(testProject.location.longitude, 73.8567);
    });

    test('budgetUtilization calculates correctly', () {
      expect(testProject.budgetUtilization, closeTo(65.0, 0.01));
    });

    test('budgetUtilization returns 0 when budget is 0', () {
      final p = CivicProject(
        id: '0', title: '', category: '', description: '',
        status: '', latitude: 0, longitude: 0,
        budget: 0, spent: 100, completionPercent: 0,
        startDate: '', expectedEndDate: '', department: '', contractor: '',
        createdAt: DateTime.now(),
      );
      expect(p.budgetUtilization, 0.0);
    });

    test('statusEmoji returns correct emoji', () {
      expect(testProject.statusEmoji, '🚧');
      final completed = CivicProject(
        id: '1', title: '', category: '', description: '',
        status: 'Completed', latitude: 0, longitude: 0,
        budget: 0, spent: 0, completionPercent: 100,
        startDate: '', expectedEndDate: '', department: '', contractor: '',
        createdAt: DateTime.now(),
      );
      expect(completed.statusEmoji, '✅');
    });
  });

  group('CivicProject — serialization', () {
    test('toJson produces correct keys', () {
      final json = testProject.toJson();
      expect(json['id'], '42');
      expect(json['title'], 'Test Hospital');
      expect(json['category'], 'hospital');
      expect(json['completionPercent'], 65);
      expect(json['budget'], 1000.0);
    });

    test('fromJson reconstructs project correctly', () {
      final json = testProject.toJson();
      final reconstructed = CivicProject.fromJson(json);
      expect(reconstructed.id, testProject.id);
      expect(reconstructed.title, testProject.title);
      expect(reconstructed.budget, testProject.budget);
      expect(reconstructed.completionPercent, testProject.completionPercent);
      expect(reconstructed.latitude, testProject.latitude);
    });

    test('fromJson → toJson round-trip is lossless', () {
      final json1 = testProject.toJson();
      final json2 = CivicProject.fromJson(json1).toJson();
      expect(json2['id'], json1['id']);
      expect(json2['budget'], json1['budget']);
      expect(json2['impacts'].length, json1['impacts'].length);
    });
  });

  group('CivicImpact — serialization', () {
    test('toJson and fromJson are symmetric', () {
      final impact = CivicImpact(icon: '👥', label: 'Citizens', value: '5 Lakh');
      final json = impact.toJson();
      final back = CivicImpact.fromJson(json);
      expect(back.icon, impact.icon);
      expect(back.label, impact.label);
      expect(back.value, impact.value);
    });
  });

  group('Sample data', () {
    test('sampleProjects is non-empty', () {
      expect(sampleProjects, isNotEmpty);
    });

    test('all sample projects have valid budgets', () {
      for (final p in sampleProjects) {
        expect(p.budget, greaterThan(0));
      }
    });

    test('all sample projects have valid coordinates', () {
      for (final p in sampleProjects) {
        expect(p.latitude, inInclusiveRange(-90.0, 90.0));
        expect(p.longitude, inInclusiveRange(-180.0, 180.0));
      }
    });
  });
}
