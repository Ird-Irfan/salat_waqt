import 'package:flutter/material.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/presentation/salat_waqt.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.setUp();
  runApp(const SalatWaqt());
}
