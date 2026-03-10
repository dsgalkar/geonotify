import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/formatters.dart';

/// Info banner shown at the bottom of a project detail card
/// explaining the active geo-fence zone to the citizen
class GeofenceInfoBanner extends StatelessWidget {
  final double radiusMeters;
  final double? distanceMeters; // null if user location unknown

  const GeofenceInfoBanner({
    super.key,
    required this.radiusMeters,
    this.distanceMeters,
  });

  bool get _isInside =>
      distanceMeters != null && distanceMeters! <= radiusMeters;

  @override
  Widget build(BuildContext context) {
    final color = _isInside ? AppTheme.success : AppTheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(_isInside ? '📡' : '🔔',
              style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            _isInside ? 'You are inside the geo-fence!' : 'Geo-fence Zone Active',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            _isInside && distanceMeters != null
                ? 'You\'re ${Formatters.distance(distanceMeters!)} from this site. Notifications enabled.'
                : 'You\'ll be notified when within ${Formatters.distance(radiusMeters)} of this project.',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
        ])),
        if (_isInside)
          const Icon(Icons.check_circle, color: AppTheme.success, size: 22),
      ]),
    );
  }
}

/// Small chip shown on project list tiles
class GeofenceChip extends StatelessWidget {
  final double radiusMeters;
  const GeofenceChip({super.key, required this.radiusMeters});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: AppTheme.divider),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Text('📡', style: TextStyle(fontSize: 11)),
      const SizedBox(width: 4),
      Text(Formatters.distance(radiusMeters),
        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
    ]),
  );
}
