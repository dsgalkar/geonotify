import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../services/notification_service.dart';
import 'admin_dashboard_screen.dart';
import 'admin_map_screen.dart';
import 'add_project_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final unread = context.watch<NotificationService>().unreadCount;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: IndexedStack(
        index: _tab,
        children: const [
          AdminDashboardScreen(),
          AdminMapScreen(),
        ],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const AddProjectScreen(),
              )),
              backgroundColor: AppTheme.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Project',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.primary.withOpacity(0.12),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppTheme.primary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.map_outlined),
            ),
            selectedIcon: const Icon(Icons.map, color: AppTheme.primary),
            label: 'Map View',
          ),
        ],
      ),
    );
  }
}
