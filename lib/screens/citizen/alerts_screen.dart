import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/notification_service.dart';
import '../../services/project_provider.dart';
import '../../models/notification_model.dart';
import '../../theme.dart';
import '../../utils/formatters.dart';
import 'project_detail_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifService = context.watch<NotificationService>();
    final notifications = notifService.notifications;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: Row(children: [
          const Text('Alerts'),
          if (notifService.unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.danger,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${notifService.unreadCount}', style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700,
              )),
            ),
          ],
        ]),
        actions: [
          if (notifService.unreadCount > 0)
            TextButton(
              onPressed: notifService.markAllAsRead,
              child: const Text('Mark all read', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (_, i) => _NotificationTile(
                notification: notifications[i],
                onTap: () {
                  notifService.markAsRead(notifications[i].id);
                  _openProject(context, notifications[i].projectId);
                },
                onDismiss: () => notifService.deleteNotification(notifications[i].id),
              ),
            ),
    );
  }

  void _openProject(BuildContext context, String projectId) {
    final project = context.read<ProjectProvider>().projects
        .where((p) => p.id == projectId)
        .firstOrNull;
    if (project != null) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(project: project),
      ));
    }
  }

  Widget _buildEmpty() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('🔔', style: TextStyle(fontSize: 56)),
      const SizedBox(height: 16),
      const Text('No alerts yet', style: TextStyle(
        fontWeight: FontWeight.w700, fontSize: 18, color: AppTheme.textPrimary,
      )),
      const SizedBox(height: 8),
      Text(
        'Notifications will appear here\nwhen you are near a project site.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
      ),
    ]),
  );
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.danger,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : AppTheme.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead ? AppTheme.divider : AppTheme.primary.withOpacity(0.2),
            ),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Icon
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: notification.typeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(notification.projectEmoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: notification.typeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(notification.typeLabel, style: TextStyle(
                    fontSize: 10, color: notification.typeColor, fontWeight: FontWeight.w700,
                  )),
                ),
                if (!notification.isRead) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 7, height: 7,
                    decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  ),
                ],
              ]),
              const SizedBox(height: 5),
              Text(notification.title, style: TextStyle(
                fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w700,
                fontSize: 14, color: AppTheme.textPrimary,
              )),
              const SizedBox(height: 3),
              Text(notification.body, style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 12, height: 1.4,
              ), maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),

            // Time
            const SizedBox(width: 8),
            Text(notification.timeAgo, style: const TextStyle(
              color: AppTheme.textSecondary, fontSize: 11,
            )),
          ]),
        ),
      ),
    );
  }
}
