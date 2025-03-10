import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:salat_waqt/core/services/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salat_waqt/domain/service/notification_service.dart';

class NotificationServiceImpl implements NotificationService {
  final LoggerService _logger;

  // Channel keys
  static const String _prayerTimesChannelKey = 'prayer_times_channel';

  // Channel name and description
  static const String _prayerTimesChannelName = 'Prayer Times Notifications';
  static const String _prayerTimesChannelDescription =
      'Notifications for prayer times';

  // Prayer notification IDs
  static const Map<String, int> _prayerNotificationIds = {
    'Fajr': 1,
    'Dhuhr': 2,
    'Asr': 3,
    'Maghrib': 4,
    'Isha': 5,
  };

  // Preference keys for notification status
  static const String _prefKeyNotificationPrefix = 'notification_enabled_';

  NotificationServiceImpl({required LoggerService logger}) : _logger = logger;

  @override
  Future<void> initialize() async {
    try {
      await AwesomeNotifications().initialize(
        null, // No app icon needed as we'll use our custom icons
        [
          NotificationChannel(
            channelKey: _prayerTimesChannelKey,
            channelName: _prayerTimesChannelName,
            channelDescription: _prayerTimesChannelDescription,
            defaultColor: const Color(0xFF1A2234),
            ledColor: const Color(0xFF1A2234),
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Public,
            defaultRingtoneType: DefaultRingtoneType.Notification,
            enableVibration: true,
          ),
        ],
        debug: true,
      );
      _logger.i('Notification service initialized');
    } catch (e) {
      _logger.e('Error initializing notification service', e);
      throw Exception('Failed to initialize notification service');
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
      _logger.i('Notification permission requested: $isAllowed');
      return isAllowed;
    } catch (e) {
      _logger.e('Error requesting notification permission', e);
      return false;
    }
  }

  @override
  Future<bool> areNotificationsAllowed() async {
    try {
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();
      _logger.i('Notifications allowed: $isAllowed');
      return isAllowed;
    } catch (e) {
      _logger.e('Error checking if notifications are allowed', e);
      return false;
    }
  }

  @override
  Future<bool> schedulePrayerTimeNotification({
    required String prayerName,
    required DateTime prayerTime,
    required String title,
    required String body,
  }) async {
    try {
      // Check if notification for this prayer is already scheduled
      await cancelPrayerTimeNotification(prayerName);

      // Get the notification ID for this prayer
      final notificationId = _getPrayerNotificationId(prayerName);

      // Save notification status in preferences
      await _saveNotificationPreference(prayerName, true);

      // Schedule the notification
      bool success = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: _prayerTimesChannelKey,
          title: title,
          body: body,
          category: NotificationCategory.Alarm,
          wakeUpScreen: true,
          fullScreenIntent: true,
          criticalAlert: true,
          autoDismissible: false,
        ),
        schedule: NotificationCalendar.fromDate(
          date: prayerTime.subtract(const Duration(minutes: 10)),
        ),
      );

      _logger.i(
        'Notification scheduled for $prayerName at ${prayerTime.toString()}: $success',
      );
      return success;
    } catch (e) {
      _logger.e('Error scheduling notification for $prayerName', e);
      return false;
    }
  }

  @override
  Future<void> cancelPrayerTimeNotification(String prayerName) async {
    try {
      final notificationId = _getPrayerNotificationId(prayerName);
      _logger.i('cancelPrayerTimeNotification notificationId: $notificationId');
      await AwesomeNotifications().cancel(notificationId);

      // Save notification status in preferences
      await _saveNotificationPreference(prayerName, false);

      _logger.i('Notification cancelled for $prayerName');
    } catch (e) {
      _logger.e('Error cancelling notification for $prayerName', e);
    }
  }

  @override
  Future<bool> isPrayerTimeNotificationScheduled(String prayerName) async {
    try {
      _logger.i('isPrayerTimeNotificationScheduled prayerName: $prayerName');
      _logger.i(
        'isPrayerTimeNotificationScheduled isScheduled: ${await _getNotificationPreference(prayerName)}',
      );
      return await _getNotificationPreference(prayerName);
    } catch (e) {
      _logger.e(
        'Error checking if notification is scheduled for $prayerName',
        e,
      );
      return false;
    }
  }

  @override
  Future<bool> togglePrayerTimeNotification({
    required String prayerName,
    required DateTime prayerTime,
    required String title,
    required String body,
  }) async {
    try {
      final isScheduled = await isPrayerTimeNotificationScheduled(prayerName);
      _logger.i('togglePrayerTimeNotification isScheduled: $isScheduled');

      if (isScheduled) {
        _logger.i('togglePrayerTimeNotification canceling notification');
        await cancelPrayerTimeNotification(prayerName);
        return false;
      } else {
        _logger.i('togglePrayerTimeNotification scheduling notification');
        return await schedulePrayerTimeNotification(
          prayerName: prayerName,
          prayerTime: prayerTime,
          title: title,
          body: body,
        );
      }
    } catch (e) {
      _logger.e('Error toggling notification for $prayerName', e);
      return false;
    }
  }

  // Private helper methods
  int _getPrayerNotificationId(String prayerName) {
    return _prayerNotificationIds[prayerName] ?? 0;
  }

  // Using SharedPreferences directly
  Future<void> _saveNotificationPreference(
    String prayerName,
    bool value,
  ) async {
    final key = '$_prefKeyNotificationPrefix$prayerName';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> _getNotificationPreference(String prayerName) async {
    final key = '$_prefKeyNotificationPrefix$prayerName';
    final prefs = await SharedPreferences.getInstance();
    _logger.i('key: $key');
    _logger.i('prefs: ${prefs.getBool(key)}');
    await prefs.reload();
    _logger.i('key: $key');
    _logger.i('prefs: ${prefs.getBool(key)}');
    return prefs.getBool(key) ?? false;
  }
}
