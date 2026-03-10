import 'package:flutter/material.dart';
import '../theme.dart';

class AppProgressBar extends StatelessWidget {
  final double value;         // 0.0 – 1.0
  final double height;
  final Color? color;
  final bool showLabel;
  final bool animated;

  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color,
    this.showLabel = false,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ??
        (value >= 1.0 ? AppTheme.success : AppTheme.accent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: animated
              ? TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (_, animValue, __) => _Bar(animValue, height, effectiveColor),
                )
              : _Bar(value.clamp(0.0, 1.0), height, effectiveColor),
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            '${(value * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: effectiveColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double value;
  final double height;
  final Color color;
  const _Bar(this.value, this.height, this.color);

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Container(height: height, color: AppTheme.divider),
      FractionallySizedBox(
        widthFactor: value,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: value >= 1.0
                  ? [AppTheme.success, const Color(0xFF10B981)]
                  : [AppTheme.accent, AppTheme.success],
            ),
          ),
        ),
      ),
    ],
  );
}

/// Thick progress bar used on the project detail screen
class DetailProgressBar extends StatelessWidget {
  final int completionPercent;
  const DetailProgressBar({super.key, required this.completionPercent});

  @override
  Widget build(BuildContext context) => Column(children: [
    Stack(children: [
      Container(
        height: 14,
        decoration: BoxDecoration(color: AppTheme.divider, borderRadius: BorderRadius.circular(7)),
      ),
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: completionPercent / 100),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutCubic,
        builder: (_, v, __) => FractionallySizedBox(
          widthFactor: v,
          child: Container(
            height: 14,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.success]),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ),
    ]),
    const SizedBox(height: 8),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('$completionPercent% Complete',
        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary)),
      Text('${100 - completionPercent}% Remaining',
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
    ]),
  ]);
}
