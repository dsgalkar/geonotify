import 'package:google_maps_flutter/google_maps_flutter.dart';

class CivicProject {
  final String id;
  final String title;
  final String category;
  final String description;
  final String status;
  final double latitude;
  final double longitude;
  final double geofenceRadius; // in meters
  final double budget;         // in lakhs (₹)
  final double spent;
  final int completionPercent;
  final String startDate;
  final String expectedEndDate;
  final String department;
  final String contractor;
  final List<String> imageUrls;
  final List<CivicImpact> impacts;
  final List<ProjectUpdate> updates;
  final DateTime createdAt;

  CivicProject({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.geofenceRadius = 500.0,
    required this.budget,
    required this.spent,
    required this.completionPercent,
    required this.startDate,
    required this.expectedEndDate,
    required this.department,
    required this.contractor,
    this.imageUrls = const [],
    this.impacts = const [],
    this.updates = const [],
    required this.createdAt,
  });

  LatLng get location => LatLng(latitude, longitude);

  double get budgetUtilization => budget > 0 ? (spent / budget) * 100 : 0;

  String get statusEmoji {
    switch (status) {
      case 'Completed': return '✅';
      case 'Under Construction': return '🚧';
      case 'Approved': return '📋';
      case 'Planning': return '📐';
      case 'Paused': return '⏸️';
      default: return '📌';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'status': status,
    'latitude': latitude,
    'longitude': longitude,
    'geofenceRadius': geofenceRadius,
    'budget': budget,
    'spent': spent,
    'completionPercent': completionPercent,
    'startDate': startDate,
    'expectedEndDate': expectedEndDate,
    'department': department,
    'contractor': contractor,
    'imageUrls': imageUrls,
    'impacts': impacts.map((e) => e.toJson()).toList(),
    'updates': updates.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory CivicProject.fromJson(Map<String, dynamic> json) => CivicProject(
    id: json['id'],
    title: json['title'],
    category: json['category'],
    description: json['description'],
    status: json['status'],
    latitude: json['latitude'].toDouble(),
    longitude: json['longitude'].toDouble(),
    geofenceRadius: (json['geofenceRadius'] ?? 500.0).toDouble(),
    budget: json['budget'].toDouble(),
    spent: json['spent'].toDouble(),
    completionPercent: json['completionPercent'],
    startDate: json['startDate'],
    expectedEndDate: json['expectedEndDate'],
    department: json['department'],
    contractor: json['contractor'],
    imageUrls: List<String>.from(json['imageUrls'] ?? []),
    impacts: (json['impacts'] as List? ?? [])
        .map((e) => CivicImpact.fromJson(e))
        .toList(),
    updates: (json['updates'] as List? ?? [])
        .map((e) => ProjectUpdate.fromJson(e))
        .toList(),
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class CivicImpact {
  final String icon;
  final String label;
  final String value;

  CivicImpact({required this.icon, required this.label, required this.value});

  Map<String, dynamic> toJson() => {'icon': icon, 'label': label, 'value': value};
  factory CivicImpact.fromJson(Map<String, dynamic> json) =>
      CivicImpact(icon: json['icon'], label: json['label'], value: json['value']);
}

class ProjectUpdate {
  final String date;
  final String title;
  final String description;

  ProjectUpdate({required this.date, required this.title, required this.description});

  Map<String, dynamic> toJson() => {'date': date, 'title': title, 'description': description};
  factory ProjectUpdate.fromJson(Map<String, dynamic> json) =>
      ProjectUpdate(date: json['date'], title: json['title'], description: json['description']);
}

// --- Sample data for demo ---
final List<CivicProject> sampleProjects = [
  CivicProject(
    id: '1',
    title: 'AIIMS Pune Phase 2 Expansion',
    category: 'hospital',
    description: 'Construction of 3 new OPD blocks with 500 additional beds, ICU facility and modern diagnostic labs under PM-ABHIM scheme.',
    status: 'Under Construction',
    latitude: 18.5204,
    longitude: 73.8567,
    budget: 4200,
    spent: 2730,
    completionPercent: 65,
    startDate: 'Jan 2023',
    expectedEndDate: 'Dec 2024',
    department: 'Ministry of Health & Family Welfare',
    contractor: 'L&T Construction Ltd.',
    impacts: [
      CivicImpact(icon: '🏥', label: 'New Beds', value: '500+'),
      CivicImpact(icon: '👨‍⚕️', label: 'Doctors Hired', value: '120'),
      CivicImpact(icon: '👥', label: 'Citizens Benefited', value: '8 Lakh'),
      CivicImpact(icon: '🧪', label: 'New Labs', value: '14'),
    ],
    updates: [
      ProjectUpdate(date: 'Dec 2024', title: 'ICU Block Foundation Complete', description: 'Foundation work for the 120-bed ICU block completed ahead of schedule.'),
      ProjectUpdate(date: 'Oct 2024', title: 'Phase 2 OPD Roof Slab Done', description: 'Roof slab casting completed for OPD Block B.'),
    ],
    createdAt: DateTime(2023, 1, 10),
  ),
  CivicProject(
    id: '2',
    title: 'Pune Metro Line 3 - Hinjewadi Corridor',
    category: 'metro',
    description: 'Underground metro rail connectivity from Hinjewadi IT Park to Shivajinagar station covering 23.3 km with 23 stations.',
    status: 'Under Construction',
    latitude: 18.5913,
    longitude: 73.7389,
    budget: 8313,
    spent: 4990,
    completionPercent: 60,
    startDate: 'Jun 2022',
    expectedEndDate: 'Mar 2026',
    department: 'Pune Metropolitan Region Development Authority',
    contractor: 'Siemens Mobility + ITD Cementation',
    impacts: [
      CivicImpact(icon: '🚇', label: 'Stations', value: '23'),
      CivicImpact(icon: '📏', label: 'Route Length', value: '23.3 km'),
      CivicImpact(icon: '👥', label: 'Daily Riders', value: '3.5 Lakh'),
      CivicImpact(icon: '🌱', label: 'CO₂ Saved/yr', value: '48,000 T'),
    ],
    updates: [
      ProjectUpdate(date: 'Jan 2025', title: 'Tunnel Boring 70% Done', description: 'TBM has covered 16.3 km of the 23.3 km stretch.'),
    ],
    createdAt: DateTime(2022, 6, 1),
  ),
  CivicProject(
    id: '3',
    title: 'Alandi Smart Water Supply Grid',
    category: 'water',
    description: 'End-to-end smart water distribution network with IoT flow sensors, automated billing and leak detection covering Alandi municipality.',
    status: 'Completed',
    latitude: 18.6742,
    longitude: 73.8988,
    budget: 340,
    spent: 312,
    completionPercent: 100,
    startDate: 'Mar 2023',
    expectedEndDate: 'Sep 2024',
    department: 'Pune Municipal Corporation - Water Works',
    contractor: 'Jain Irrigation Systems',
    impacts: [
      CivicImpact(icon: '💧', label: 'Households Connected', value: '18,500'),
      CivicImpact(icon: '📉', label: 'Water Wastage Reduced', value: '34%'),
      CivicImpact(icon: '⏱️', label: 'Supply Hours/Day', value: '16h → 22h'),
      CivicImpact(icon: '📱', label: 'Smart Meters', value: '18,500'),
    ],
    updates: [
      ProjectUpdate(date: 'Sep 2024', title: 'Project Commissioned', description: 'Full network live. All 18,500 smart meters active.'),
    ],
    createdAt: DateTime(2023, 3, 1),
  ),
];
