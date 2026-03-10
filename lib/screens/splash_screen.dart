import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/project_provider.dart';
import '../services/notification_service.dart';
import '../theme.dart';
import 'role_selector_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));

    _fadeAnim = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeIn));
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );
    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
    );

    _controller.forward();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // Load data while showing splash
    await Future.wait([
      context.read<ProjectProvider>().loadFromPrefs(),
      context.read<NotificationService>().initialize(),
      Future.delayed(const Duration(milliseconds: 2400)), // minimum splash time
    ]);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const RoleSelectorScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 110, height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                        ),
                        child: const Center(
                          child: Text('🏛️', style: TextStyle(fontSize: 56)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // App name
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnim.value),
                      child: Column(children: [
                        const Text('NagarDrishti', style: TextStyle(
                          color: Colors.white, fontSize: 36,
                          fontWeight: FontWeight.w900, letterSpacing: -1,
                        )),
                        const SizedBox(height: 4),
                        const Text('नगर दृष्टि', style: TextStyle(
                          color: Colors.white60, fontSize: 18,
                          fontWeight: FontWeight.w500, letterSpacing: 1,
                        )),
                        const SizedBox(height: 12),
                        Text(
                          'Your Government. Your Progress.',
                          style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 14),
                        ),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 80),

                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SizedBox(
                      width: 32, height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Footer
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: const Text(
                      'Powered by PMIS • Govt. of India',
                      style: TextStyle(color: Colors.white30, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
