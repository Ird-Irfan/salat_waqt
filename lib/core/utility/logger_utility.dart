import 'package:flutter/foundation.dart';

/// Logs an error message with a tag for better identification.
///
/// This function is used to log error messages throughout the application.
/// It includes a tag parameter to help identify the source of the error.
///
/// Example usage:
///
/// ```dart
/// logErrorStatic('Failed to load data', 'data_loader');
/// ```
void logErrorStatic(String message, String tag) {
  if (kDebugMode) {
    print('[$tag] ERROR: $message');
  }
}
