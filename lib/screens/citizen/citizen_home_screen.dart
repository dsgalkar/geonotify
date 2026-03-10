import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../services/project_provider.dart';
import '../../models/project.dart';
import 'map_screen.dart';
import 'project_detail_screen.dart';

class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [
          _FeedScreen(),
          CitizenMapScreen(),
          _NotificationsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.primary.withOpacity(0.12),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: AppTheme.primary), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map, color: AppTheme.primary), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications, color: AppTheme.primary), label: 'Alerts'),
        ],
      ),
    );
  }
}

class _FeedScreen extends StatelessWidget {
  const _FeedScreen();

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;
    final completed = projects.where((p) => p.status == 'Completed').toList();
    final active = projects.where((p) => p.status == 'Under Construction').toList();

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.primary,
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('GeoNotify', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              Text('Your Government. Your Progress.', style: TextStyle(color: Colors.white60, fontSize: 11)),
            ]),
            actions: [
              IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero banner
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.accent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('📍 Near You', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('${active.length} Active Projects', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                      Text('${completed.length} Completed', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ])),
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                      child: const Icon(Icons.account_balance, color: Colors.white, size: 30),
                    ),
                  ]),
                ),

                // Active projects
                _SectionHeader('🚧 Under Construction', '${active.length}'),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: active.length,
                    itemBuilder: (_, i) => _ProjectCard(active[i]),
                  ),
                ),

                // Completed
                _SectionHeader('✅ Recently Completed', '${completed.length}'),
                ...completed.map((p) => _FeedListItem(p)),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title, count;
  const _SectionHeader(this.title, this.count);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(count, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
        ),
      ],
    ),
  );
}

class _ProjectCard extends StatelessWidget {
  final CivicProject project;
  const _ProjectCard(this.project);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: project))),
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
        const SizedBox(height: 8),
        Text(project.title, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
        const SizedBox(height: 4),
        Text(project.department.split(' ').take(3).join(' '), maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        const Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: project.completionPercent / 100,
            backgroundColor: AppTheme.divider,
            valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 6),
        Text('${project.completionPercent}% Complete', style: const TextStyle(
          fontSize: 12, color: AppTheme.accent, fontWeight: FontWeight.w600,
        )),
      ]),
    ),
  );
}

class _FeedListItem extends StatelessWidget {
  final CivicProject project;
  const _FeedListItem(this.project);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: project))),
    child: Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(children: [
        Text(project.statusEmoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(project.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.people_outline, size: 14, color: AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text(project.impacts.isNotEmpty ? project.impacts.first.value + ' ' + project.impacts.first.label : '',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ]),
        ])),
        const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      ]),
    ),
  );
}

class _NotificationsScreen extends StatelessWidget {
  const _NotificationsScreen();

  @override
  Widget build(BuildContext context) {
    final mockAlerts = [
      {'emoji': '🏥', 'title': 'AIIMS Pune Phase 2', 'body': 'You are 320m from this project. 65% complete.', 'time': '2 min ago'},
      {'emoji': '🚇', 'title': 'Pune Metro Line 3', 'body': 'New update: Tunnel boring reached 70% of total route.', 'time': '1 hr ago'},
      {'emoji': '💧', 'title': 'Alandi Water Supply', 'body': 'Project completed! 18,500 households now connected.', 'time': '3 days ago'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(title: const Text('Alerts & Updates')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockAlerts.length,
        itemBuilder: (_, i) {
          final alert = mockAlerts[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(alert['emoji']!, style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(alert['title']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 4),
                Text(alert['body']!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
              ])),
              Text(alert['time']!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            ]),
          );
        },
      ),
    );
  }
}
