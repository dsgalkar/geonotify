import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/project_provider.dart';
import '../../theme.dart';
import 'add_project_screen.dart';
import '../citizen/project_detail_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => const AddProjectScreen(),
        )),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Project', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 160,
      backgroundColor: AppTheme.primary,
      title: const Text('GeoNotify Admin'),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
        IconButton(icon: const Icon(Icons.account_circle_outlined, color: Colors.white), onPressed: () {}),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primary, const Color(0xFF1E3A8A)],
            ),
          ),
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'Manage government\nprojects & geo-fences',
                style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final projects = provider.filteredProjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats row
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: _StatCard('Total Projects', '${provider.projects.length}', Icons.folder_outlined, AppTheme.primary)),
            const SizedBox(width: 10),
            Expanded(child: _StatCard('Active', '${provider.activeCount}', Icons.construction, AppTheme.warning)),
            const SizedBox(width: 10),
            Expanded(child: _StatCard('Completed', '${provider.completedCount}', Icons.check_circle_outline, AppTheme.success)),
          ]),
        ),

        // Budget overview
        _buildBudgetCard(context),

        // Search & filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: (q) => provider.setSearch(q),
            decoration: InputDecoration(
              hintText: 'Search projects...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => _showFilterSheet(context),
              ),
            ),
          ),
        ),

        // Project list header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${projects.length} Projects', style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.textPrimary,
              )),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sort, size: 16),
                label: const Text('Sort'),
              ),
            ],
          ),
        ),

        // Project cards
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          itemBuilder: (_, i) => _AdminProjectCard(
            project: projects[i],
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => ProjectDetailScreen(project: projects[i]),
            )),
            onDelete: () => _confirmDelete(context, projects[i].id),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFF064E3B), AppTheme.success]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Budget Overview', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('₹${provider.totalBudget.toStringAsFixed(0)} Cr', style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800, fontSize: 26,
                )),
                const Text('Total Sanctioned', style: TextStyle(color: Colors.white60, fontSize: 12)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('₹${provider.totalSpent.toStringAsFixed(0)} Cr', style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20,
                )),
                const Text('Utilized', style: TextStyle(color: Colors.white60, fontSize: 12)),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: provider.totalBudget > 0 ? provider.totalSpent / provider.totalBudget : 0,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => const _FilterSheet());
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Project?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () {
              context.read<ProjectProvider>().deleteProject(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.divider),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(height: 8),
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
      Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
    ]),
  );
}

class _AdminProjectCard extends StatelessWidget {
  final project;
  final VoidCallback onTap, onDelete;
  const _AdminProjectCard({required this.project, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(project.statusEmoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(child: Text(project.title, style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textPrimary,
              ))),
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'delete') onDelete();
                  if (val == 'edit') onTap(); // open detail for now
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: AppTheme.danger))),
                ],
              ),
            ]),
            const SizedBox(height: 8),
            Text(project.department, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: project.completionPercent / 100,
                  backgroundColor: AppTheme.divider,
                  valueColor: AlwaysStoppedAnimation(project.status == 'Completed' ? AppTheme.success : AppTheme.accent),
                  minHeight: 6,
                ),
              )),
              const SizedBox(width: 10),
              Text('${project.completionPercent}%', style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.primary,
              )),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _Tag('₹${project.budget.toStringAsFixed(0)} Cr'),
              const SizedBox(width: 8),
              _Tag('📍 ${project.geofenceRadius.toInt()}m zone'),
              const SizedBox(width: 8),
              _StatusTag(project.status),
            ]),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
  );
}

class _StatusTag extends StatelessWidget {
  final String status;
  const _StatusTag(this.status);
  @override
  Widget build(BuildContext context) {
    Color c = status == 'Completed' ? AppTheme.success : status == 'Under Construction' ? AppTheme.warning : AppTheme.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(status, style: TextStyle(fontSize: 11, color: c, fontWeight: FontWeight.w700)),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Filter Projects', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 16),
        const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: ['all', ...AppConstants.projectStatuses].map((s) =>
          ChoiceChip(
            label: Text(s == 'all' ? 'All' : s),
            selected: provider.selectedStatus == s,
            onSelected: (_) => provider.setStatus(s),
          ),
        ).toList()),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Apply')),
      ]),
    );
  }
}
