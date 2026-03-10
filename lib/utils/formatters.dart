import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  // ─── Currency ─────────────────────────────────────────────────

  /// Formats budget in Indian numbering: ₹4,200 Cr
  static String budget(double crore) {
    if (crore >= 1000) {
      return '₹${(crore / 1000).toStringAsFixed(1)}K Cr';
    }
    final formatted = NumberFormat('#,##,###').format(crore.toInt());
    return '₹$formatted Cr';
  }

  /// Short budget for chips: ₹4.2K Cr or ₹340 Cr
  static String budgetShort(double crore) {
    if (crore >= 10000) return '₹${(crore / 1000).toStringAsFixed(0)}K Cr';
    if (crore >= 1000) return '₹${(crore / 1000).toStringAsFixed(1)}K Cr';
    return '₹${crore.toStringAsFixed(0)} Cr';
  }

  /// Budget utilization percentage
  static String utilization(double spent, double budget) {
    if (budget == 0) return '0%';
    return '${((spent / budget) * 100).toStringAsFixed(1)}%';
  }

  // ─── Distance ─────────────────────────────────────────────────

  /// Formats meters to human-readable: "320m" or "1.2 km"
  static String distance(double meters) {
    if (meters < 1000) return '${meters.toInt()}m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  /// Returns short distance label for map overlays
  static String distanceShort(double meters) {
    if (meters < 1000) return '${meters.toInt()}m';
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }

  // ─── Dates ────────────────────────────────────────────────────

  /// Formats DateTime to "Jan 2024"
  static String monthYear(DateTime dt) => DateFormat('MMM yyyy').format(dt);

  /// Formats DateTime to "15 Jan 2024"
  static String fullDate(DateTime dt) => DateFormat('d MMM yyyy').format(dt);

  /// Relative time: "2 min ago", "3 days ago"
  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return fullDate(dt);
  }

  // ─── Numbers ──────────────────────────────────────────────────

  /// Indian number formatting: 1,00,000 → "1 Lakh", 10,00,000 → "10 Lakh"
  static String indianNumber(int n) {
    if (n >= 10000000) return '${(n / 10000000).toStringAsFixed(1)} Cr';
    if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)} Lakh';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  /// Completion percentage: "65%" or "100% ✅"
  static String completion(int percent) {
    if (percent == 100) return '100% ✅';
    return '$percent%';
  }

  // ─── Project ──────────────────────────────────────────────────

  /// Returns a project ID string for display: "#CP-0001"
  static String projectId(String id) {
    final num = int.tryParse(id) ?? id.hashCode.abs() % 10000;
    return '#ND-${num.toString().padLeft(4, '0')}';
  }
}
