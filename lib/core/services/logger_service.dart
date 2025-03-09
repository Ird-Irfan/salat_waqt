import 'package:logger/logger.dart';

/// A service class that provides logging capabilities throughout the app.
/// Uses the logger package for better log formatting and filtering.
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  late final Logger _logger;

  /// Factory constructor to return the singleton instance
  factory LoggerService() {
    return _instance;
  }

  /// Private constructor
  LoggerService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // Number of method calls to be displayed
        errorMethodCount: 8, // Number of method calls if stacktrace is provided
        lineLength: 120, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        dateTimeFormat: DateTimeFormat.onlyTime, // Format for timestamps
      ),
      // In production, only show warnings and errors
      level:
          bool.fromEnvironment('dart.vm.product')
              ? Level
                  .warning // Production: only warnings and errors
              : Level.trace, // Development: all logs
    );
  }

  /// Log a debug message
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log an info message
  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log an error message
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a fatal error message
  void f(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
