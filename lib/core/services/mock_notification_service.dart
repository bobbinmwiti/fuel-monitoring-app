import 'package:logging/logging.dart';

/// A mock implementation of the notification service that doesn't rely on the 
/// flutter_local_notifications plugin. This is a temporary solution to allow the app
/// to build while we resolve the issues with the plugin.
class NotificationService {
  final _logger = Logger('MockNotificationService');
  
  NotificationService() {
    _logger.info('Using mock notification service');
  }

  Future<void> initialize() async {
    _logger.info('Mock notification service initialized');
  }

  Future<void> showFuelAlert({
    required String title,
    required String body,
    String? payload,
  }) async {
    _logger.info('Mock notification would show: $title - $body');
  }

  Future<void> scheduleFuelReminder({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    _logger.info('Mock notification would schedule: $title - $body for ${scheduledDate.toString()}');
  }

  Future<void> cancelAllNotifications() async {
    _logger.info('Mock notification would cancel all notifications');
  }

  Future<void> cancelNotification(int id) async {
    _logger.info('Mock notification would cancel notification with id: $id');
  }
}
