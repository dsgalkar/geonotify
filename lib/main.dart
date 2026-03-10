import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'services/project_provider.dart';
import 'services/geofence_service.dart';
import 'screens/citizen/citizen_home_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final geoService = GeofenceService();
  await geoService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()..loadFromPrefs()),
        ChangeNotifierProvider(create: (_) => geoService),
      ],
      child: const GeoNotifyApp(),
    ),
  );
}

class GeoNotifyApp extends StatelessWidget {
  const GeoNotifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoNotify',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const RoleSelectorScreen(),
    );
  }
}

class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo
              Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🏛️', style: TextStyle(fontSize: 48)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('GeoNotify', style: TextStyle(
                color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -1,
              )),
              const SizedBox(height: 8),
              const Text('Your Government. Your Progress.', style: TextStyle(
                color: Colors.white60, fontSize: 16,
              )),
              const Spacer(),
              // Role buttons
              _RoleButton(
                icon: '👤',
                label: 'I\'m a Citizen',
                subtitle: 'Explore projects near me',
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CitizenHomeScreen())),
              ),
              const SizedBox(height: 16),
              _RoleButton(
                icon: '🏛️',
                label: 'Government Official',
                subtitle: 'Manage projects & geo-fences',
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen())),
                outlined: true,
              ),
              const SizedBox(height: 48),
              const Text('Powered by PMIS • Govt. of India Initiative',
                style: TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String icon, label, subtitle;
  final VoidCallback onTap;
  final bool outlined;

  const _RoleButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : Colors.white,
          border: Border.all(color: Colors.white.withOpacity(outlined ? 0.5 : 1), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w700,
              color: outlined ? Colors.white : AppTheme.primary,
            )),
            Text(subtitle, style: TextStyle(
              fontSize: 13, color: outlined ? Colors.white60 : AppTheme.textSecondary,
            )),
          ]),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: outlined ? Colors.white60 : AppTheme.primary),
        ]),
      ),
    );
  }
}
