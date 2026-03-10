import 'package:flutter/material.dart';

enum NotificationType { geofence, update, completion, announcement }

class NotificationItem {
  final String id;
  final String projectId;
  final String projectTitle;
  final String projectEmoji;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime receivedAt;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.projectEmoji,
    required this.title,
    required this.body,
    required this.type,
    required this.receivedAt,
    this.isRead = false,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(receivedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Color get typeColor {
    switch (type) {
      case NotificationType.geofence: return const Color(0xFF3E92CC);
      case NotificationType.update: return const Color(0xFFFFB703);
      case NotificationType.completion: return const Color(0xFF06D6A0);
      case NotificationType.announcement: return const Color(0xFF0A2463);
    }
  }

  String get typeLabel {
    switch (type) {
      case NotificationType.geofence: return '📡 Nearby';
      case NotificationType.update: return '🔄 Update';
      case NotificationType.completion: return '✅ Completed';
      case NotificationType.announcement: return '📢 Announcement';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'projectTitle': projectTitle,
    'projectEmoji': projectEmoji,
    'title': title,
    'body': body,
    'type': type.index,
    'receivedAt': receivedAt.toIso8601String(),
    'isRead': isRead,
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json['id'],
    projectId: json['projectId'],
    projectTitle: json['projectTitle'],
    projectEmoji: json['projectEmoji'],
    title: json['title'],
    body: json['body'],
    type: NotificationType.values[json['type']],
    receivedAt: DateTime.parse(json['receivedAt']),
    isRead: json['isRead'] ?? false,
  );

  // Sample notifications for demo
  static List<NotificationItem> get sampleNotifications => [
    NotificationItem(
      id: 'n1',
      projectId: '1',
      projectTitle: 'AIIMS Pune Phase 2 Expansion',
      projectEmoji: '🏥',
      title: 'You are near AIIMS Pune Phase 2',
      body: '320m away • 65% complete • ₹4200 Cr project. Tap to learn more.',
      type: NotificationType.geofence,
      receivedAt: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    NotificationItem(
      id: 'n2',
      projectId: '2',
      projectTitle: 'Pune Metro Line 3',
      projectEmoji: '🚇',
      title: 'Metro Line 3 — New Update',
      body: 'Tunnel boring has reached 70% of the total 23.3 km route.',
      type: NotificationType.update,
      receivedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationItem(
      id: 'n3',
      projectId: '3',
      projectTitle: 'Alandi Smart Water Supply',
      projectEmoji: '💧',
      title: 'Project Completed! 🎉',
      body: 'Alandi Smart Water Grid is now live. 18,500 households connected.',
      type: NotificationType.completion,
      receivedAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationItem(
      id: 'n4',
      projectId: '4',
      projectTitle: 'NH-48 Expressway Widening',
      projectEmoji: '🛣️',
      title: 'New Project in Your Area',
      body: 'NH-48 Pune–Mumbai Expressway widening project approved. Work begins Mar 2025.',
      type: NotificationType.announcement,
      receivedAt: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
    ),
  ];
}
