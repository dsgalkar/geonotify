import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../theme.dart';

class ProjectDetailScreen extends StatelessWidget {
  final CivicProject project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeroCard(),
                _buildProgressSection(),
                _buildImpactSection(),
                _buildBudgetSection(),
                _buildUpdatesSection(),
                _buildDetailsSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primary, AppTheme.accent.withOpacity(0.8)],
            ),
          ),
          child: Stack(
            children: [
              // Pattern overlay
              Opacity(opacity: 0.05, child: GridView.count(crossAxisCount: 12,
                children: List.generate(120, (_) => const Icon(Icons.circle, size: 8, color: Colors.white)),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.category.toUpperCase(), style: const TextStyle(
                      color: Colors.white60, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 6),
                    Text(project.title, style: const TextStyle(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.2,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _InfoChip(icon: '📍', label: project.department.split(' ').take(3).join(' ')),
              const SizedBox(width: 8),
              _StatusChip(project.status),
            ],
          ),
          const SizedBox(height: 16),
          Text(project.description, style: const TextStyle(
            color: AppTheme.textSecondary, fontSize: 14, height: 1.6,
          )),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _MetaItem(icon: Icons.calendar_today_outlined, label: 'Start', value: project.startDate)),
              Expanded(child: _MetaItem(icon: Icons.flag_outlined, label: 'End', value: project.expectedEndDate)),
              Expanded(child: _MetaItem(icon: Icons.business_outlined, label: 'Contractor', value: project.contractor.split(' ').first)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Completion Progress', style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.textPrimary,
          )),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(height: 14, decoration: BoxDecoration(
                color: AppTheme.divider, borderRadius: BorderRadius.circular(7),
              )),
              FractionallySizedBox(
                widthFactor: project.completionPercent / 100,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppTheme.accent, AppTheme.success]),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${project.completionPercent}% Complete', style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppTheme.primary,
              )),
              Text('${100 - project.completionPercent}% Remaining', style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 13,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactSection() {
    if (project.impacts.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.accent],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.people_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Civic Impact', style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16,
            )),
          ]),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2, crossAxisSpacing: 12, mainAxisSpacing: 12,
            children: project.impacts.map((impact) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Text(impact.icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(impact.value, style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15,
                    )),
                    Text(impact.label, style: const TextStyle(
                      color: Colors.white70, fontSize: 11,
                    )),
                  ],
                )),
              ]),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Budget Transparency', style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.textPrimary,
          )),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _BudgetItem(label: 'Sanctioned', value: '₹${project.budget.toStringAsFixed(0)} Cr', color: AppTheme.primary)),
            Expanded(child: _BudgetItem(label: 'Utilized', value: '₹${project.spent.toStringAsFixed(0)} Cr', color: AppTheme.accent)),
            Expanded(child: _BudgetItem(label: 'Utilization', value: '${project.budgetUtilization.toStringAsFixed(1)}%', color: AppTheme.success)),
          ]),
        ],
      ),
    );
  }

  Widget _buildUpdatesSection() {
    if (project.updates.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Updates', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 16),
          ...project.updates.map((u) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(
                    color: AppTheme.accent, shape: BoxShape.circle,
                  )),
                  if (u != project.updates.last)
                    Container(width: 2, height: 40, color: AppTheme.divider),
                ]),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(u.date, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  Text(u.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(u.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ])),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Project Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 16),
          _DetailRow('Department', project.department),
          _DetailRow('Contractor', project.contractor),
          _DetailRow('Category', project.category.toUpperCase()),
          _DetailRow('Geo-fence Radius', '${project.geofenceRadius.toInt()}m around site'),
          _DetailRow('Project ID', '#CP-${project.id.padLeft(4, '0')}'),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon, label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 12)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
    ]),
  );
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  @override
  Widget build(BuildContext context) {
    Color color = status == 'Completed' ? AppTheme.success : status == 'Under Construction' ? AppTheme.warning : AppTheme.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _MetaItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(children: [
    Icon(icon, size: 18, color: AppTheme.accent),
    const SizedBox(height: 4),
    Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
    Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary), textAlign: TextAlign.center),
  ]);
}

class _BudgetItem extends StatelessWidget {
  final String label, value;
  final Color color;
  const _BudgetItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
    Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
  ]);
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 120, child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
      Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textPrimary))),
    ]),
  );
}
