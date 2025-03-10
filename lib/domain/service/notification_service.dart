abstract class NotificationService {
  /// Initialize the notification service
  Future<void> initialize();

  /// Request notification permissions from the user
  Future<bool> requestPermission();

  /// Check if notifications are allowed
  Future<bool> areNotificationsAllowed();

  /// Schedule a prayer time notification
  Future<bool> schedulePrayerTimeNotification({
    required String prayerName,
    required DateTime prayerTime,
    required String title,
    required String body,
  });

  /// Cancel a scheduled prayer time notification
  Future<void> cancelPrayerTimeNotification(String prayerName);

  /// Check if a prayer time notification is scheduled
  Future<bool> isPrayerTimeNotificationScheduled(String prayerName);

  /// Toggle prayer time notification
  Future<bool> togglePrayerTimeNotification({
    required String prayerName,
    required DateTime prayerTime,
    required String title,
    required String body,
  });
}
