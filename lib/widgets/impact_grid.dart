import 'package:flutter/material.dart';
import '../models/project.dart';
import '../theme.dart';

class ImpactGrid extends StatelessWidget {
  final List<CivicImpact> impacts;
  final bool dark; // true = navy gradient bg, false = white card bg

  const ImpactGrid({super.key, required this.impacts, this.dark = true});

  @override
  Widget build(BuildContext context) {
    if (impacts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: dark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primary, AppTheme.accent],
              )
            : null,
        color: dark ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: dark ? null : Border.all(color: AppTheme.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.people_outline,
            color: dark ? Colors.white : AppTheme.textPrimary, size: 20),
          const SizedBox(width: 8),
          Text('Civic Impact', style: TextStyle(
            color: dark ? Colors.white : AppTheme.textPrimary,
            fontWeight: FontWeight.w700, fontSize: 16,
          )),
        ]),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: impacts.map((imp) => _ImpactTile(impact: imp, dark: dark)).toList(),
        ),
      ]),
    );
  }
}

class _ImpactTile extends StatelessWidget {
  final CivicImpact impact;
  final bool dark;
  const _ImpactTile({required this.impact, required this.dark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: dark ? Colors.white.withOpacity(0.15) : AppTheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: dark ? null : Border.all(color: AppTheme.divider),
    ),
    child: Row(children: [
      Text(impact.icon, style: const TextStyle(fontSize: 22)),
      const SizedBox(width: 8),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(impact.value, style: TextStyle(
            color: dark ? Colors.white : AppTheme.textPrimary,
            fontWeight: FontWeight.w800, fontSize: 15,
          )),
          Text(impact.label, style: TextStyle(
            color: dark ? Colors.white70 : AppTheme.textSecondary,
            fontSize: 10,
          ), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      )),
    ]),
  );
}
