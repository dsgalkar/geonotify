import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/project_provider.dart';
import '../../models/project.dart';
import '../../theme.dart';
import '../../utils/constants.dart';
import '../citizen/project_detail_screen.dart';

class AdminMapScreen extends StatefulWidget {
  const AdminMapScreen({super.key});

  @override
  State<AdminMapScreen> createState() => _AdminMapScreenState();
}

class _AdminMapScreenState extends State<AdminMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  CivicProject? _selectedProject;

  static const _initialCamera = CameraPosition(
    target: LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
    zoom: AppConstants.defaultZoom,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _buildOverlays());
  }

  void _buildOverlays() {
    final projects = context.read<ProjectProvider>().projects;
    final markers = <Marker>{};
    final circles = <Circle>{};

    for (final p in projects) {
      markers.add(Marker(
        markerId: MarkerId(p.id),
        position: p.location,
        infoWindow: InfoWindow(title: p.title, snippet: '${p.statusEmoji} ${p.status}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(_categoryHue(p.category)),
        onTap: () => setState(() => _selectedProject = p),
      ));
      circles.add(Circle(
        circleId: CircleId('${p.id}_geo'),
        center: p.location,
        radius: p.geofenceRadius,
        fillColor: _categoryColor(p.category).withOpacity(0.10),
        strokeColor: _categoryColor(p.category).withOpacity(0.45),
        strokeWidth: 2,
      ));
    }

    setState(() { _markers = markers; _circles = circles; });
  }

  Color _categoryColor(String cat) {
    final found = AppConstants.projectCategories.firstWhere(
      (c) => c['id'] == cat,
      orElse: () => {'color': AppTheme.accent},
    );
    return found['color'] as Color;
  }

  double _categoryHue(String cat) {
    switch (cat) {
      case 'hospital': return BitmapDescriptor.hueRed;
      case 'metro':    return BitmapDescriptor.hueRose;
      case 'water':    return BitmapDescriptor.hueBlue;
      case 'road':     return BitmapDescriptor.hueCyan;
      case 'college':  return BitmapDescriptor.hueViolet;
      case 'park':     return BitmapDescriptor.hueGreen;
      case 'bridge':   return BitmapDescriptor.hueYellow;
      default:         return BitmapDescriptor.hueAzure;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Projects — Map View')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            markers: _markers,
            circles: _circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (c) => _mapController = c,
            onTap: (_) => setState(() => _selectedProject = null),
          ),

          // Legend
          Positioned(
            top: 12, left: 12,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AppConstants.projectCategories.take(4).map((cat) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(cat['icon'], style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 6),
                    Text(cat['label'], style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ]),
                )).toList(),
              ),
            ),
          ),

          // Selected project card
          if (_selectedProject != null)
            Positioned(
              bottom: 20, left: 16, right: 16,
              child: _ProjectPreviewCard(
                project: _selectedProject!,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ProjectDetailScreen(project: _selectedProject!),
                )),
                onClose: () => setState(() => _selectedProject = null),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProjectPreviewCard extends StatelessWidget {
  final CivicProject project;
  final VoidCallback onTap, onClose;
  const _ProjectPreviewCard({required this.project, required this.onTap, required this.onClose});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(children: [
        Text(project.statusEmoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(project.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('${project.status} · ${project.completionPercent}% · ₹${project.budget} Cr',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: project.completionPercent / 100,
              backgroundColor: AppTheme.divider,
              valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
              minHeight: 4,
            ),
          ),
        ])),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onClose,
          child: const Icon(Icons.close, color: AppTheme.textSecondary, size: 20),
        ),
      ]),
    ),
  );
}
