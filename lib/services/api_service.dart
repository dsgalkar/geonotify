import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer $token', // Add auth token when ready
  };

  // ─── Projects ────────────────────────────────────────────────

  Future<List<CivicProject>> fetchProjects({
    String? category,
    String? status,
    double? lat,
    double? lng,
    double? radiusKm,
  }) async {
    try {
      final params = <String, String>{};
      if (category != null && category != 'all') params['category'] = category;
      if (status != null && status != 'all') params['status'] = status;
      if (lat != null) params['lat'] = lat.toString();
      if (lng != null) params['lng'] = lng.toString();
      if (radiusKm != null) params['radius_km'] = radiusKm.toString();

      final uri = Uri.parse('${AppConstants.baseUrl}/projects').replace(queryParameters: params);
      final response = await _client.get(uri, headers: _headers).timeout(AppConstants.requestTimeout);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        return data.map((e) => CivicProject.fromJson(e)).toList();
      }
      throw ApiException('Failed to fetch projects: ${response.statusCode}');
    } catch (e) {
      // Fallback to sample data when offline / backend not ready
      return sampleProjects;
    }
  }

  Future<CivicProject> fetchProjectById(String id) async {
    try {
      final response = await _client
          .get(Uri.parse('${AppConstants.baseUrl}/projects/$id'), headers: _headers)
          .timeout(AppConstants.requestTimeout);

      if (response.statusCode == 200) {
        return CivicProject.fromJson(jsonDecode(response.body)['data']);
      }
      throw ApiException('Project not found');
    } catch (e) {
      return sampleProjects.firstWhere((p) => p.id == id);
    }
  }

  Future<CivicProject> createProject(CivicProject project) async {
    final response = await _client
        .post(
          Uri.parse('${AppConstants.baseUrl}/projects'),
          headers: _headers,
          body: jsonEncode(project.toJson()),
        )
        .timeout(AppConstants.requestTimeout);

    if (response.statusCode == 201) {
      return CivicProject.fromJson(jsonDecode(response.body)['data']);
    }
    throw ApiException('Failed to create project: ${response.body}');
  }

  Future<CivicProject> updateProject(String id, CivicProject project) async {
    final response = await _client
        .put(
          Uri.parse('${AppConstants.baseUrl}/projects/$id'),
          headers: _headers,
          body: jsonEncode(project.toJson()),
        )
        .timeout(AppConstants.requestTimeout);

    if (response.statusCode == 200) {
      return CivicProject.fromJson(jsonDecode(response.body)['data']);
    }
    throw ApiException('Failed to update project: ${response.body}');
  }

  Future<void> deleteProject(String id) async {
    final response = await _client
        .delete(Uri.parse('${AppConstants.baseUrl}/projects/$id'), headers: _headers)
        .timeout(AppConstants.requestTimeout);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException('Failed to delete project');
    }
  }

  // ─── Geo-fence nearby projects ────────────────────────────────

  Future<List<CivicProject>> fetchNearbyProjects({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    return fetchProjects(lat: lat, lng: lng, radiusKm: radiusKm);
  }

  // ─── FCM Token registration ───────────────────────────────────

  Future<void> registerFcmToken(String token) async {
    try {
      await _client
          .post(
            Uri.parse('${AppConstants.baseUrl}/devices/register'),
            headers: _headers,
            body: jsonEncode({'fcm_token': token, 'platform': 'android'}),
          )
          .timeout(AppConstants.requestTimeout);
    } catch (_) {
      // Silently fail — not critical for hackathon demo
    }
  }

  // ─── Analytics (admin) ───────────────────────────────────────

  Future<Map<String, dynamic>> fetchDashboardStats() async {
    try {
      final response = await _client
          .get(Uri.parse('${AppConstants.baseUrl}/admin/stats'), headers: _headers)
          .timeout(AppConstants.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      }
    } catch (_) {}

    // Fallback computed stats
    return {
      'total_projects': sampleProjects.length,
      'active': sampleProjects.where((p) => p.status == 'Under Construction').length,
      'completed': sampleProjects.where((p) => p.status == 'Completed').length,
      'total_budget': sampleProjects.fold(0.0, (s, p) => s + p.budget),
      'total_spent': sampleProjects.fold(0.0, (s, p) => s + p.spent),
    };
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}
