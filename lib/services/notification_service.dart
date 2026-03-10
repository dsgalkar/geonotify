import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background FCM message received: ${message.messageId}');
}

class NotificationService extends ChangeNotifier {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifs = FlutterLocalNotificationsPlugin();

  List<NotificationItem> _notifications = List.from(NotificationItem.sampleNotifications);
  String? _fcmToken;

  List<NotificationItem> get notifications => _notifications;
  String? get fcmToken => _fcmToken;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> initialize() async {
    // Local notifications setup
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _localNotifs.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel
    const androidChannel = AndroidNotificationChannel(
      'nagardrishti_main',
      'NagarDrishti Alerts',
      description: 'Civic project updates and geo-fence alerts',
      importance: Importance.high,
    );
    await _localNotifs
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // FCM setup
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final settings = await _fcm.requestPermission(
      alert: true, badge: true, sound: true,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');

    _fcmToken = await _fcm.getToken();
    debugPrint('FCM Token: $_fcmToken');

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

    await _loadFromPrefs();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    final notification = NotificationItem(
      id: message.messageId ?? DateTime.now().toString(),
      projectId: data['projectId'] ?? '',
      projectTitle: data['projectTitle'] ?? '',
      projectEmoji: data['projectEmoji'] ?? '📌',
      title: message.notification?.title ?? data['title'] ?? 'New Update',
      body: message.notification?.body ?? data['body'] ?? '',
      type: NotificationType.values[int.tryParse(data['type'] ?? '0') ?? 0],
      receivedAt: DateTime.now(),
    );

    _notifications.insert(0, notification);
    notifyListeners();
    _saveToPrefs();

    // Show local notification while app is in foreground
    _showLocalNotification(notification);
  }

  void _handleNotificationOpen(RemoteMessage message) {
    debugPrint('Notification opened: ${message.data}');
    // Navigate to project detail — handled via navigator key in main.dart
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
  }

  Future<void> showGeofenceNotification({
    required String projectId,
    required String projectTitle,
    required String projectEmoji,
    required int distanceMeters,
    required int completionPercent,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'nagardrishti_main',
        'NagarDrishti Alerts',
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFF0A2463),
      ),
      iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
    );

    await _localNotifs.show(
      projectId.hashCode,
      '$projectEmoji $projectTitle',
      '${distanceMeters}m away • $completionPercent% complete. Tap to learn more.',
      details,
      payload: projectId,
    );

    final item = NotificationItem(
      id: '${projectId}_${DateTime.now().millisecondsSinceEpoch}',
      projectId: projectId,
      projectTitle: projectTitle,
      projectEmoji: projectEmoji,
      title: '$projectEmoji $projectTitle',
      body: '${distanceMeters}m away • $completionPercent% complete.',
      type: NotificationType.geofence,
      receivedAt: DateTime.now(),
    );
    _notifications.insert(0, item);
    notifyListeners();
    _saveToPrefs();
  }

  void markAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
      _saveToPrefs();
    }
  }

  void markAllAsRead() {
    for (final n in _notifications) n.isRead = true;
    notifyListeners();
    _saveToPrefs();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final json = _notifications.map((n) => n.toJson()).toList();
    await prefs.setString('notifications', jsonEncode(json));
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('notifications');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _notifications = list.map((e) => NotificationItem.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _showLocalNotification(NotificationItem item) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'nagardrishti_main', 'NagarDrishti Alerts',
        importance: Importance.high, priority: Priority.high,
        color: Color(0xFF0A2463),
      ),
    );
    await _localNotifs.show(item.id.hashCode, item.title, item.body, details, payload: item.projectId);
  }
}
