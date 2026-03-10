import 'package:flutter/material.dart';
import '../theme.dart';
import 'citizen/citizen_home_screen.dart';
import 'admin/admin_home_screen.dart';

class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primary, Color(0xFF1E3A8A), Color(0xFF0F2654)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                  ),
                  child: const Center(child: Text('🏛️', style: TextStyle(fontSize: 52))),
                ),
                const SizedBox(height: 24),

                const Text('NagarDrishti', style: TextStyle(
                  color: Colors.white, fontSize: 36,
                  fontWeight: FontWeight.w900, letterSpacing: -1,
                )),
                const SizedBox(height: 4),
                const Text('नगर दृष्टि', style: TextStyle(
                  color: Colors.white60, fontSize: 16, letterSpacing: 1,
                )),
                const SizedBox(height: 12),
                Text(
                  'Your Government. Your Progress.',
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                ),

                const Spacer(flex: 2),

                // Role buttons
                _RoleCard(
                  emoji: '👤',
                  title: "I'm a Citizen",
                  subtitle: 'Explore government projects near me',
                  filled: true,
                  onTap: () => _navigate(context, const CitizenHomeScreen()),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  emoji: '🏛️',
                  title: 'Government Official',
                  subtitle: 'Manage projects & geo-fences',
                  filled: false,
                  onTap: () => _navigate(context, const AdminHomeScreen()),
                ),

                const Spacer(),

                const Text(
                  'Powered by PMIS • Govt. of India Initiative',
                  style: TextStyle(color: Colors.white30, fontSize: 11),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final bool filled;
  final VoidCallback onTap;

  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: filled ? Colors.white : Colors.transparent,
          border: Border.all(
            color: filled ? Colors.white : Colors.white.withOpacity(0.4),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700,
                color: filled ? AppTheme.primary : Colors.white,
              )),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(
                fontSize: 13,
                color: filled ? AppTheme.textSecondary : Colors.white60,
              )),
            ]),
          ),
          Icon(Icons.arrow_forward_ios, size: 16,
            color: filled ? AppTheme.primary : Colors.white60),
        ]),
      ),
    );
  }
}
