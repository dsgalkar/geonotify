import 'package:flutter/material.dart';
import '../models/project.dart';
import '../theme.dart';
import '../utils/formatters.dart';
import 'progress_bar.dart';
import 'status_badge.dart';

/// Universal project card — use [compact] for horizontal scrolling lists,
/// [compact: false] for full-width list items.
class ProjectCard extends StatelessWidget {
  final CivicProject project;
  final bool compact;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return compact ? _CompactCard(project: project, onTap: onTap)
                   : _FullCard(project: project, onTap: onTap);
  }
}

/// Horizontal scroll card (210px wide)
class _CompactCard extends StatelessWidget {
  final CivicProject project;
  final VoidCallback onTap;
  const _CompactCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(project.statusEmoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 10),
        Text(project.title,
          maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary, height: 1.3)),
        const SizedBox(height: 4),
        Text(project.department.split(' ').take(3).join(' '),
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        const Spacer(),
        AppProgressBar(value: project.completionPercent / 100),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(Formatters.completion(project.completionPercent),
            style: const TextStyle(fontSize: 12, color: AppTheme.accent, fontWeight: FontWeight.w600)),
          Text(Formatters.budgetShort(project.budget),
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ]),
      ]),
    ),
  );
}

/// Full-width list card
class _FullCard extends StatelessWidget {
  final CivicProject project;
  final VoidCallback onTap;
  const _FullCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(project.statusEmoji, style: const TextStyle(fontSize: 24))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(project.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(children: [
            StatusBadge(status: project.status),
            const SizedBox(width: 8),
            Text(Formatters.budgetShort(project.budget),
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ]),
          const SizedBox(height: 6),
          AppProgressBar(value: project.completionPercent / 100),
          const SizedBox(height: 4),
          Text('${project.completionPercent}% complete',
            style: const TextStyle(fontSize: 11, color: AppTheme.accent, fontWeight: FontWeight.w600)),
        ])),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      ]),
    ),
  );
}
