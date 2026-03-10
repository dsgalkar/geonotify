import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../services/project_provider.dart';
import '../../services/geofence_service.dart';
import '../../theme.dart';
import 'project_detail_screen.dart';

class CitizenMapScreen extends StatefulWidget {
  const CitizenMapScreen({super.key});

  @override
  State<CitizenMapScreen> createState() => _CitizenMapScreenState();
}

class _CitizenMapScreenState extends State<CitizenMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  String _selectedFilter = 'all';

  static const _initialCamera = CameraPosition(
    target: LatLng(18.5204, 73.8567), // Pune
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initMap());
  }

  void _initMap() {
    final projects = context.read<ProjectProvider>().projects;
    final geoService = context.read<GeofenceService>();
    _buildMapOverlays(projects);
    geoService.startTracking(projects);
  }

  void _buildMapOverlays(List<CivicProject> projects) {
    final markers = <Marker>{};
    final circles = <Circle>{};

    for (final project in projects) {
      if (_selectedFilter != 'all' && project.category != _selectedFilter) continue;

      final color = _categoryColor(project.category);

      markers.add(Marker(
        markerId: MarkerId(project.id),
        position: project.location,
        infoWindow: InfoWindow(
          title: project.title,
          snippet: '${project.statusEmoji} ${project.status} • ${project.completionPercent}%',
          onTap: () => _openProjectDetail(project),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(_categoryHue(project.category)),
      ));

      circles.add(Circle(
        circleId: CircleId('${project.id}_geo'),
        center: project.location,
        radius: project.geofenceRadius,
        fillColor: color.withOpacity(0.12),
        strokeColor: color.withOpacity(0.5),
        strokeWidth: 2,
      ));
    }

    setState(() {
      _markers = markers;
      _circles = circles;
    });
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'hospital': return const Color(0xFFEF4444);
      case 'metro': return const Color(0xFFEC4899);
      case 'water': return const Color(0xFF3B82F6);
      case 'road': return const Color(0xFF6B7280);
      case 'college': return const Color(0xFF8B5CF6);
      case 'bridge': return const Color(0xFFF59E0B);
      case 'park': return const Color(0xFF10B981);
      default: return AppTheme.accent;
    }
  }

  double _categoryHue(String cat) {
    switch (cat) {
      case 'hospital': return BitmapDescriptor.hueRed;
      case 'metro': return BitmapDescriptor.hueRose;
      case 'water': return BitmapDescriptor.hueBlue;
      case 'road': return BitmapDescriptor.hueCyan;
      case 'college': return BitmapDescriptor.hueViolet;
      case 'bridge': return BitmapDescriptor.hueYellow;
      case 'park': return BitmapDescriptor.hueGreen;
      default: return BitmapDescriptor.hueAzure;
    }
  }

  void _openProjectDetail(CivicProject project) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ProjectDetailScreen(project: project),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: _initialCamera,
            markers: _markers,
            circles: _circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (ctrl) => _mapController = ctrl,
          ),

          // Top search bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  _buildFilterChips(),
                ],
              ),
            ),
          ),

          // Bottom sheet - nearby projects
          _buildNearbyPanel(),

          // My location FAB
          Positioned(
            right: 16,
            bottom: 280,
            child: FloatingActionButton.small(
              onPressed: _goToMyLocation,
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: TextField(
        onChanged: (q) => context.read<ProjectProvider>().setSearch(q),
        decoration: const InputDecoration(
          hintText: 'Search projects near you...',
          prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final cats = [
      {'id': 'all', 'label': 'All', 'icon': '🗺️'},
      {'id': 'hospital', 'label': 'Health', 'icon': '🏥'},
      {'id': 'metro', 'label': 'Metro', 'icon': '🚇'},
      {'id': 'road', 'label': 'Road', 'icon': '🛣️'},
      {'id': 'water', 'label': 'Water', 'icon': '💧'},
      {'id': 'college', 'label': 'Education', 'icon': '🎓'},
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = cats[i];
          final selected = _selectedFilter == cat['id'];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedFilter = cat['id']!);
              _buildMapOverlays(context.read<ProjectProvider>().projects);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  Text(cat['icon']!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(cat['label']!, style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppTheme.textPrimary,
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyPanel() {
    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.12,
      maxChildSize: 0.65,
      builder: (context, scrollCtrl) {
        final projects = context.watch<ProjectProvider>().filteredProjects;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -4))],
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${projects.length} Projects', style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.textPrimary,
                    )),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(children: [
                        Icon(Icons.circle, size: 8, color: AppTheme.success),
                        SizedBox(width: 4),
                        Text('Live Tracking', style: TextStyle(
                          fontSize: 12, color: AppTheme.success, fontWeight: FontWeight.w600,
                        )),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: projects.length,
                  itemBuilder: (_, i) => _ProjectListTile(
                    project: projects[i],
                    onTap: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(projects[i].location, 15),
                      );
                      _openProjectDetail(projects[i]);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _goToMyLocation() async {
    final geo = context.read<GeofenceService>();
    final pos = geo.currentPosition;
    if (pos != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 14),
      );
    }
  }
}

class _ProjectListTile extends StatelessWidget {
  final CivicProject project;
  final VoidCallback onTap;

  const _ProjectListTile({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.divider),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(project.statusEmoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Row(children: [
                    _StatusBadge(project.status),
                    const SizedBox(width: 8),
                    Text('${project.completionPercent}% done', style: const TextStyle(
                      fontSize: 12, color: AppTheme.textSecondary)),
                  ]),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: project.completionPercent / 100,
                      backgroundColor: AppTheme.divider,
                      valueColor: AlwaysStoppedAnimation(
                        project.status == 'Completed' ? AppTheme.success : AppTheme.accent,
                      ),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'Completed': color = AppTheme.success; break;
      case 'Under Construction': color = AppTheme.warning; break;
      case 'Paused': color = AppTheme.danger; break;
      default: color = AppTheme.accent;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
