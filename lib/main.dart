import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/domain/service/notification_service.dart';
import 'package:salat_waqt/presentation/salat_waqt.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await _initServiceLocator();

  // Request notification permissions
  await _requestNotificationPermission();

  runApp(const SalatWaqt());
}

Future<void> _initServiceLocator() async {
  // Optimize app rendering
  // Set preferred orientations to portrait only to avoid unnecessary rebuilds
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Optimize UI rendering by setting system UI overlays once at startup
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await ServiceLocator.setUp();
}

Future<void> _requestNotificationPermission() async {
  // Request notification permissions
  final isAllowed = await locator<NotificationService>().requestPermission();
  debugPrint('Notification permission granted: $isAllowed');

  // Set notification action handlers
  await AwesomeNotifications().setListeners(
    onActionReceivedMethod: _onNotificationActionReceived,
    onNotificationCreatedMethod: _onNotificationCreated,
    onNotificationDisplayedMethod: _onNotificationDisplayed,
    onDismissActionReceivedMethod: _onDismissActionReceived,
  );
}

// Notification action handlers
@pragma('vm:entry-point')
Future<void> _onNotificationActionReceived(
  ReceivedAction receivedAction,
) async {
  debugPrint('Notification action received: ${receivedAction.id}');
  // Handle notification action here
}

@pragma('vm:entry-point')
Future<void> _onNotificationCreated(
  ReceivedNotification receivedNotification,
) async {
  debugPrint('Notification created: ${receivedNotification.id}');
}

@pragma('vm:entry-point')
Future<void> _onNotificationDisplayed(
  ReceivedNotification receivedNotification,
) async {
  debugPrint('Notification displayed: ${receivedNotification.id}');
}

@pragma('vm:entry-point')
Future<void> _onDismissActionReceived(ReceivedAction receivedAction) async {
  debugPrint('Notification dismissed: ${receivedAction.id}');
}
