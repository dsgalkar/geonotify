import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/project.dart';
import '../../services/project_provider.dart';
import '../../theme.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Form data
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  final _contractorCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();

  String _category = 'hospital';
  String _status = 'Planning';
  LatLng _pickedLocation = const LatLng(18.5204, 73.8567);
  double _geofenceRadius = 500;
  int _completionPercent = 0;

  // Impact fields
  final List<Map<String, TextEditingController>> _impactControllers = [];

  @override
  void initState() {
    super.initState();
    _addImpactRow();
  }

  void _addImpactRow() {
    _impactControllers.add({
      'icon': TextEditingController(text: '👥'),
      'label': TextEditingController(),
      'value': TextEditingController(),
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Add New Project'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepTapped: (s) => setState(() => _currentStep = s),
          onStepContinue: () {
            if (_currentStep < 3) setState(() => _currentStep++);
            else _submit();
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          controlsBuilder: (ctx, details) => Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(_currentStep == 3 ? 'Save Project' : 'Next'),
              ),
              if (_currentStep > 0) ...[
                const SizedBox(width: 12),
                OutlinedButton(onPressed: details.onStepCancel, child: const Text('Back')),
              ],
            ]),
          ),
          steps: [
            Step(
              title: const Text('Basic Info'),
              isActive: _currentStep >= 0,
              content: _buildBasicInfoStep(),
            ),
            Step(
              title: const Text('Location & Geo-fence'),
              isActive: _currentStep >= 1,
              content: _buildLocationStep(),
            ),
            Step(
              title: const Text('Budget & Progress'),
              isActive: _currentStep >= 2,
              content: _buildBudgetStep(),
            ),
            Step(
              title: const Text('Civic Impact'),
              isActive: _currentStep >= 3,
              content: _buildImpactStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Column(children: [
      // Category picker
      const Align(alignment: Alignment.centerLeft, child: Text('Category', style: TextStyle(fontWeight: FontWeight.w600))),
      const SizedBox(height: 8),
      SizedBox(
        height: 110,
        child: GridView.count(
          crossAxisCount: 4, shrinkWrap: true,
          crossAxisSpacing: 8, mainAxisSpacing: 8,
          children: AppConstants.projectCategories.map((cat) {
            final selected = _category == cat['id'];
            return GestureDetector(
              onTap: () => setState(() => _category = cat['id']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.primary : AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected ? AppTheme.primary : AppTheme.divider, width: selected ? 2 : 1),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(cat['icon'], style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 2),
                  Text(cat['label'], style: TextStyle(
                    fontSize: 10, color: selected ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.w600,
                  )),
                ]),
              ),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _titleCtrl,
        decoration: const InputDecoration(labelText: 'Project Title *'),
        validator: (v) => v!.isEmpty ? 'Required' : null,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _descCtrl,
        decoration: const InputDecoration(labelText: 'Description *'),
        maxLines: 3,
        validator: (v) => v!.isEmpty ? 'Required' : null,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _deptCtrl,
        decoration: const InputDecoration(labelText: 'Department *'),
        validator: (v) => v!.isEmpty ? 'Required' : null,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _contractorCtrl,
        decoration: const InputDecoration(labelText: 'Contractor / Agency'),
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        value: _status,
        decoration: const InputDecoration(labelText: 'Status'),
        items: AppConstants.projectStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => setState(() => _status = v!),
      ),
    ]);
  }

  Widget _buildLocationStep() {
    return Column(children: [
      const Text('Tap on map to place project location', style: TextStyle(color: AppTheme.textSecondary)),
      const SizedBox(height: 12),
      SizedBox(
        height: 280,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: _pickedLocation, zoom: 13),
            markers: {Marker(markerId: const MarkerId('picked'), position: _pickedLocation)},
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
      const SizedBox(height: 16),
      Row(children: [
        const Icon(Icons.location_pin, color: AppTheme.accent),
        const SizedBox(width: 8),
        Text(
          'Lat: ${_pickedLocation.latitude.toStringAsFixed(4)}, Lng: ${_pickedLocation.longitude.toStringAsFixed(4)}',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        const Text('Geo-fence Radius:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Text('${_geofenceRadius.toInt()} m', style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700)),
      ]),
      Slider(
        value: _geofenceRadius,
        min: 100, max: 2000, divisions: 19,
        label: '${_geofenceRadius.toInt()}m',
        activeColor: AppTheme.primary,
        onChanged: (v) => setState(() => _geofenceRadius = v),
      ),
      const Text('Drag slider to set the notification zone around the project site', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
    ]);
  }

  Widget _buildBudgetStep() {
    return Column(children: [
      TextFormField(
        controller: _budgetCtrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Budget (₹ Crore) *', prefixText: '₹ '),
        validator: (v) => v!.isEmpty ? 'Required' : null,
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: TextFormField(
          controller: _startCtrl,
          decoration: const InputDecoration(labelText: 'Start Date', hintText: 'e.g. Jan 2024'),
        )),
        const SizedBox(width: 12),
        Expanded(child: TextFormField(
          controller: _endCtrl,
          decoration: const InputDecoration(labelText: 'Expected End', hintText: 'e.g. Dec 2025'),
        )),
      ]),
      const SizedBox(height: 20),
      Row(children: [
        const Text('Completion: ', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('$_completionPercent%', style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700)),
      ]),
      Slider(
        value: _completionPercent.toDouble(),
        min: 0, max: 100, divisions: 20,
        label: '$_completionPercent%',
        activeColor: AppTheme.success,
        onChanged: (v) => setState(() => _completionPercent = v.toInt()),
      ),
    ]);
  }

  Widget _buildImpactStep() {
    return Column(children: [
      const Text('Add key civic impact metrics (e.g. beneficiaries, beds, etc.)',
        style: TextStyle(color: AppTheme.textSecondary)),
      const SizedBox(height: 16),
      ..._impactControllers.asMap().entries.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.divider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          SizedBox(width: 50, child: TextFormField(
            controller: e.value['icon'],
            decoration: const InputDecoration(labelText: 'Icon', border: InputBorder.none),
          )),
          const SizedBox(width: 8),
          Expanded(child: TextFormField(
            controller: e.value['label'],
            decoration: const InputDecoration(labelText: 'Label', border: InputBorder.none),
          )),
          const SizedBox(width: 8),
          SizedBox(width: 80, child: TextFormField(
            controller: e.value['value'],
            decoration: const InputDecoration(labelText: 'Value', border: InputBorder.none),
          )),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: AppTheme.danger),
            onPressed: () { _impactControllers.removeAt(e.key); setState(() {}); },
          ),
        ]),
      )),
      TextButton.icon(
        onPressed: _addImpactRow,
        icon: const Icon(Icons.add),
        label: const Text('Add Impact Metric'),
      ),
    ]);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final impacts = _impactControllers
        .where((c) => c['label']!.text.isNotEmpty)
        .map((c) => CivicImpact(
          icon: c['icon']!.text,
          label: c['label']!.text,
          value: c['value']!.text,
        ))
        .toList();

    final project = CivicProject(
      id: const Uuid().v4(),
      title: _titleCtrl.text,
      category: _category,
      description: _descCtrl.text,
      status: _status,
      latitude: _pickedLocation.latitude,
      longitude: _pickedLocation.longitude,
      geofenceRadius: _geofenceRadius,
      budget: double.tryParse(_budgetCtrl.text) ?? 0,
      spent: 0,
      completionPercent: _completionPercent,
      startDate: _startCtrl.text,
      expectedEndDate: _endCtrl.text,
      department: _deptCtrl.text,
      contractor: _contractorCtrl.text,
      impacts: impacts,
      createdAt: DateTime.now(),
    );

    context.read<ProjectProvider>().addProject(project);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Project added successfully!'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    [_titleCtrl, _descCtrl, _budgetCtrl, _deptCtrl, _contractorCtrl, _startCtrl, _endCtrl]
        .forEach((c) => c.dispose());
    super.dispose();
  }
}
