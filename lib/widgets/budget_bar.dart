import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/formatters.dart';

class BudgetBar extends StatelessWidget {
  final double budget;
  final double spent;

  const BudgetBar({super.key, required this.budget, required this.spent});

  double get _utilization => budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.account_balance_wallet_outlined, size: 18, color: AppTheme.textSecondary),
          SizedBox(width: 8),
          Text('Budget Transparency', style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textPrimary,
          )),
        ]),
        const SizedBox(height: 16),

        // Three stats
        Row(children: [
          Expanded(child: _BudgetStat(
            label: 'Sanctioned',
            value: Formatters.budget(budget),
            color: AppTheme.primary,
          )),
          Expanded(child: _BudgetStat(
            label: 'Utilized',
            value: Formatters.budget(spent),
            color: AppTheme.accent,
          )),
          Expanded(child: _BudgetStat(
            label: 'Utilization',
            value: Formatters.utilization(spent, budget),
            color: _utilization > 0.9 ? AppTheme.danger : AppTheme.success,
          )),
        ]),

        const SizedBox(height: 14),

        // Visual bar
        Stack(children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _utilization),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => FractionallySizedBox(
              widthFactor: v,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppTheme.accent,
                    _utilization > 0.9 ? AppTheme.danger : AppTheme.success,
                  ]),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ]),

        const SizedBox(height: 6),
        Text(
          '${(_utilization * 100).toStringAsFixed(1)}% of sanctioned budget utilized',
          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ]),
    );
  }
}

class _BudgetStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _BudgetStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(
      fontSize: 15, fontWeight: FontWeight.w800, color: color,
    )),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
  ]);
}
