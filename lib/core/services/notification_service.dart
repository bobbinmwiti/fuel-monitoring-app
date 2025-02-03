import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:logging/logging.dart';

class NotificationService {
  final _logger = Logger('NotificationService');
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  NotificationService();

  Future<void> initialize() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();
      
      // Platform-specific initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      final darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          // Handle iOS foreground notification
        },
      );
      
      final initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) async {
          // Handle notification tap
          _logger.info('Notification tapped: ${details.payload}');
        },
      );

      // Request permissions for iOS and macOS
      if (defaultTargetPlatform == TargetPlatform.iOS || 
          defaultTargetPlatform == TargetPlatform.macOS) {
        await _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      throw Exception('Failed to initialize notifications: ${e.toString()}');
    }
  }

  Future<void> showFuelAlert({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'fuel_alerts',
        'Fuel Alerts',
        channelDescription: 'Notifications for fuel alerts',
        importance: Importance.high,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      throw Exception('Failed to show notification: ${e.toString()}');
    }
  }

  Future<void> scheduleFuelReminder({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'fuel_reminders',
        'Fuel Reminders',
        channelDescription: 'Scheduled reminders for fuel monitoring',
        importance: Importance.high,
        priority: Priority.high,
      );

      const darwinDetails = DarwinNotificationDetails();

      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      await _notifications.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      throw Exception('Failed to schedule notification: ${e.toString()}');
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}
