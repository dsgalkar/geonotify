import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/project_provider.dart';
import '../../theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/project_card.dart';
import '../../widgets/status_badge.dart';
import 'project_detail_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String _selectedCat = 'all';

  static const _categories = [
    {'id': 'all',      'label': 'All',       'emoji': '🗺️'},
    {'id': 'hospital', 'label': 'Health',    'emoji': '🏥'},
    {'id': 'metro',    'label': 'Metro',     'emoji': '🚇'},
    {'id': 'road',     'label': 'Road',      'emoji': '🛣️'},
    {'id': 'water',    'label': 'Water',     'emoji': '💧'},
    {'id': 'college',  'label': 'Education', 'emoji': '🎓'},
    {'id': 'park',     'label': 'Parks',     'emoji': '🌳'},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final all = provider.projects;
    final filtered = _selectedCat == 'all'
        ? all
        : all.where((p) => p.category == _selectedCat).toList();
    final active = filtered.where((p) => p.status == 'Under Construction').toList();
    final completed = filtered.where((p) => p.status == 'Completed').toList();
    final others = filtered.where((p) => p.status != 'Under Construction' && p.status != 'Completed').toList();

    return CustomScrollView(
      slivers: [
        // Hero banner
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('📍 Pune, Maharashtra', style: TextStyle(color: Colors.white60, fontSize: 12)),
                const SizedBox(height: 6),
                Text('${active.length} Active Projects', style: const TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800,
                )),
                Text('${completed.length} Completed · ${Formatters.budget(provider.totalBudget)} total',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ])),
              const Text('🏛️', style: TextStyle(fontSize: 52)),
            ]),
          ),
        ),

        // Category filter chips
        SliverToBoxAdapter(
          child: SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = _selectedCat == cat['id'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCat = cat['id']!),
                  child: AnimatedContainer(
                    duration: AppConstants.animFast,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: selected ? AppTheme.primary : AppTheme.divider,
                      ),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(cat['emoji']!, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(cat['label']!, style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppTheme.textPrimary,
                      )),
                    ]),
                  ),
                );
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Under Construction
        if (active.isNotEmpty) ...[
          _SectionHeader(title: '🚧 Under Construction', count: active.length),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: active.length,
                itemBuilder: (_, i) => ProjectCard(
                  project: active[i],
                  compact: true,
                  onTap: () => _openDetail(context, active[i]),
                ),
              ),
            ),
          ),
        ],

        // Completed
        if (completed.isNotEmpty) ...[
          _SectionHeader(title: '✅ Completed', count: completed.length),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => ProjectCard(
                project: completed[i],
                compact: false,
                onTap: () => _openDetail(context, completed[i]),
              ),
              childCount: completed.length,
            ),
          ),
        ],

        // Others (Planning, Approved etc.)
        if (others.isNotEmpty) ...[
          _SectionHeader(title: '📋 Upcoming & Planning', count: others.length),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => ProjectCard(
                project: others[i],
                compact: false,
                onTap: () => _openDetail(context, others[i]),
              ),
              childCount: others.length,
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  void _openDetail(BuildContext context, project) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ProjectDetailScreen(project: project),
    ));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(
            fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary,
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$count', style: const TextStyle(
              color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13,
            )),
          ),
        ],
      ),
    ),
  );
}
