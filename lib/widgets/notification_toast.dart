import 'package:flutter/material.dart';
import '../models/project.dart';
import '../theme.dart';

/// Overlay-style toast that slides in from the top when user enters a geo-fence.
/// Usage: wrap your Scaffold body in a Stack and call [NotificationToast.show()].
class NotificationToast extends StatefulWidget {
  final CivicProject project;
  final int distanceMeters;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationToast({
    super.key,
    required this.project,
    required this.distanceMeters,
    required this.onTap,
    required this.onDismiss,
  });

  /// Shows a self-dismissing toast for 5 seconds
  static OverlayEntry show({
    required BuildContext context,
    required CivicProject project,
    required int distanceMeters,
    required VoidCallback onTap,
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(builder: (_) => Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: NotificationToast(
        project: project,
        distanceMeters: distanceMeters,
        onTap: () {
          entry.remove();
          onTap();
        },
        onDismiss: () => entry.remove(),
      ),
    ));
    Overlay.of(context).insert(entry);
    Future.delayed(const Duration(seconds: 5), () {
      if (entry.mounted) entry.remove();
    });
    return entry;
  }

  @override
  State<NotificationToast> createState() => _NotificationToastState();
}

class _NotificationToastState extends State<NotificationToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnim = Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.4),
                    blurRadius: 20, offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(widget.project.statusEmoji,
                    style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.project.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(
                    '${widget.distanceMeters}m away · ${widget.project.completionPercent}% complete · Tap to learn more',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ])),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onDismiss,
                  child: Icon(Icons.close, color: Colors.white.withOpacity(0.6), size: 18),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
