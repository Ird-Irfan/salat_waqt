import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/presentation/salat_waqt.dart';

void main() async {
  await _initServiceLocator();

  runApp( SalatWaqt());
}

// Future<void> _initServiceLocator() async {
//   // Ensure Flutter is initialized
//   WidgetsFlutterBinding.ensureInitialized();
//   // Optimize app rendering
//   // Set preferred orientations to portrait only to avoid unnecessary rebuilds
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   // Optimize UI rendering by setting system UI overlays once at startup
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       systemNavigationBarColor: Colors.white,
//       systemNavigationBarIconBrightness: Brightness.dark,
//     ),
//   );

//   await ServiceLocator.setUp();
// }
Future<void> _initServiceLocator() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Optimize UI rendering by setting system UI overlays once at startup
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness: Brightness.light, // Use light icons for dark background
      systemNavigationBarColor: Colors.transparent, // Make navigation bar transparent
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await ServiceLocator.setUp();
}