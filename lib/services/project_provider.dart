import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  List<CivicProject> _projects = List.from(sampleProjects);
  String _selectedCategory = 'all';
  String _selectedStatus = 'all';
  String _searchQuery = '';

  List<CivicProject> get projects => _projects;
  String get selectedCategory => _selectedCategory;
  String get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;

  List<CivicProject> get filteredProjects {
    return _projects.where((p) {
      final matchCategory = _selectedCategory == 'all' || p.category == _selectedCategory;
      final matchStatus = _selectedStatus == 'all' || p.status == _selectedStatus;
      final matchSearch = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.department.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchStatus && matchSearch;
    }).toList();
  }

  Map<String, int> get statusStats {
    final stats = <String, int>{};
    for (final p in _projects) {
      stats[p.status] = (stats[p.status] ?? 0) + 1;
    }
    return stats;
  }

  double get totalBudget => _projects.fold(0, (sum, p) => sum + p.budget);
  double get totalSpent => _projects.fold(0, (sum, p) => sum + p.spent);
  int get completedCount => _projects.where((p) => p.status == 'Completed').length;
  int get activeCount => _projects.where((p) => p.status == 'Under Construction').length;

  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void setStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void addProject(CivicProject project) {
    _projects.insert(0, project);
    notifyListeners();
    _saveToPrefs();
  }

  void updateProject(CivicProject updated) {
    final idx = _projects.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      _projects[idx] = updated;
      notifyListeners();
      _saveToPrefs();
    }
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final json = _projects.map((p) => p.toJson()).toList();
    await prefs.setString('projects', jsonEncode(json));
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('projects');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _projects = list.map((e) => CivicProject.fromJson(e)).toList();
      notifyListeners();
    }
  }
}
