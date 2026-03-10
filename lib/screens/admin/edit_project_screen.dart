import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../services/project_provider.dart';
import '../../theme.dart';
import '../../utils/constants.dart';

class EditProjectScreen extends StatefulWidget {
  final CivicProject project;
  const EditProjectScreen({super.key, required this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _budgetCtrl;
  late final TextEditingController _spentCtrl;
  late final TextEditingController _deptCtrl;
  late final TextEditingController _contractorCtrl;
  late final TextEditingController _startCtrl;
  late final TextEditingController _endCtrl;

  late String _category;
  late String _status;
  late LatLng _pickedLocation;
  late double _geofenceRadius;
  late int _completionPercent;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _titleCtrl      = TextEditingController(text: p.title);
    _descCtrl       = TextEditingController(text: p.description);
    _budgetCtrl     = TextEditingController(text: p.budget.toString());
    _spentCtrl      = TextEditingController(text: p.spent.toString());
    _deptCtrl       = TextEditingController(text: p.department);
    _contractorCtrl = TextEditingController(text: p.contractor);
    _startCtrl      = TextEditingController(text: p.startDate);
    _endCtrl        = TextEditingController(text: p.expectedEndDate);
    _category         = p.category;
    _status           = p.status;
    _pickedLocation   = p.location;
    _geofenceRadius   = p.geofenceRadius;
    _completionPercent = p.completionPercent;
  }

  @override
  void dispose() {
    for (final c in [_titleCtrl, _descCtrl, _budgetCtrl, _spentCtrl, _deptCtrl, _contractorCtrl, _startCtrl, _endCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Edit Project'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Section('Basic Info', [
              _buildCategoryPicker(),
              const SizedBox(height: 14),
              TextFormField(controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Project Title *'),
                validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3),
              const SizedBox(height: 12),
              TextFormField(controller: _deptCtrl,
                decoration: const InputDecoration(labelText: 'Department')),
              const SizedBox(height: 12),
              TextFormField(controller: _contractorCtrl,
                decoration: const InputDecoration(labelText: 'Contractor')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: AppConstants.projectStatuses.map((s) =>
                  DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _status = v!),
              ),
            ]),

            const SizedBox(height: 20),
            _Section('Location & Geo-fence', [
              SizedBox(
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: _pickedLocation, zoom: 14),
                    markers: {Marker(markerId: const MarkerId('loc'), position: _pickedLocation)},
                    circles: {Circle(
                      circleId: const CircleId('geo'),
                      center: _pickedLocation,
                      radius: _geofenceRadius,
                      fillColor: AppTheme.accent.withOpacity(0.15),
                      strokeColor: AppTheme.accent,
                      strokeWidth: 2,
                    )},
                    onTap: (pos) => setState(() => _pickedLocation = pos),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(children: [
                const Text('Geo-fence Radius: ', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('${_geofenceRadius.toInt()}m', style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700)),
              ]),
              Slider(
                value: _geofenceRadius,
                min: AppConstants.minGeofenceRadius,
                max: AppConstants.maxGeofenceRadius,
                divisions: 19,
                label: '${_geofenceRadius.toInt()}m',
                activeColor: AppTheme.primary,
                onChanged: (v) => setState(() => _geofenceRadius = v),
              ),
            ]),

            const SizedBox(height: 20),
            _Section('Budget & Progress', [
              Row(children: [
                Expanded(child: TextFormField(controller: _budgetCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Budget (₹ Cr)', prefixText: '₹ '))),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(controller: _spentCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Spent (₹ Cr)', prefixText: '₹ '))),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextFormField(controller: _startCtrl,
                  decoration: const InputDecoration(labelText: 'Start Date'))),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(controller: _endCtrl,
                  decoration: const InputDecoration(labelText: 'Expected End'))),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                const Text('Completion: ', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('$_completionPercent%', style: const TextStyle(color: AppTheme.success, fontWeight: FontWeight.w700)),
              ]),
              Slider(
                value: _completionPercent.toDouble(),
                min: 0, max: 100, divisions: 20,
                label: '$_completionPercent%',
                activeColor: AppTheme.success,
                onChanged: (v) => setState(() => _completionPercent = v.toInt()),
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Category', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textSecondary, fontSize: 13)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8, runSpacing: 8,
        children: AppConstants.projectCategories.map((cat) {
          final sel = _category == cat['id'];
          return GestureDetector(
            onTap: () => setState(() => _category = cat['id']),
            child: AnimatedContainer(
              duration: AppConstants.animFast,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? AppTheme.primary : AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: sel ? AppTheme.primary : AppTheme.divider),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(cat['icon'], style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(cat['label'], style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: sel ? Colors.white : AppTheme.textSecondary,
                )),
              ]),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final updated = CivicProject(
      id: widget.project.id,
      title: _titleCtrl.text,
      category: _category,
      description: _descCtrl.text,
      status: _status,
      latitude: _pickedLocation.latitude,
      longitude: _pickedLocation.longitude,
      geofenceRadius: _geofenceRadius,
      budget: double.tryParse(_budgetCtrl.text) ?? widget.project.budget,
      spent: double.tryParse(_spentCtrl.text) ?? widget.project.spent,
      completionPercent: _completionPercent,
      startDate: _startCtrl.text,
      expectedEndDate: _endCtrl.text,
      department: _deptCtrl.text,
      contractor: _contractorCtrl.text,
      impacts: widget.project.impacts,
      updates: widget.project.updates,
      createdAt: widget.project.createdAt,
    );
    context.read<ProjectProvider>().updateProject(updated);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('✅ Project updated!'),
      backgroundColor: AppTheme.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
    Navigator.pop(context);
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, this.children);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppTheme.divider),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textPrimary)),
      const SizedBox(height: 14),
      ...children,
    ]),
  );
}
