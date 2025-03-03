import 'package:flutter/material.dart';
import 'package:salat_waqt/core/utility/logger_utility.dart';
import 'package:salat_waqt/presentation/salat_waqt.dart';

/// Utility class for retrieving the screen dimensions of the device.
///
/// The `SalatWaqtScreen` class provides static methods and properties to access
/// the width and height of the device's screen. It relies on MediaQuery
/// to obtain the screen dimensions.
///
/// Example usage:
///
/// ```dart
/// SalatWaqtScreen.setUp(context);
/// double screenWidth = SalatWaqtScreen.width;
/// double screenHeight = SalatWaqtScreen.height;
/// ```
///
/// Rationale:
///
/// - The `SalatWaqtScreen` class provides a convenient way to access the screen dimensions
/// of the device. By centralizing the screen dimension retrieval logic within a class,
/// it promotes code re-usability and improves code readability.
///
/// - The class utilizes MediaQuery, which is a core Flutter API for accessing device metrics.
///
/// - The `setUp` method allows for explicit initialization of the screen dimensions. This
/// ensures that the dimensions are retrieved only when needed and avoids unnecessary
/// calculations or potential errors caused by accessing uninitialized values.
///
/// - The `_resetIfInvalid` method checks if the screen dimensions are valid. If the dimensions
/// are less than 10 pixels in either width or height, an error is logged, and the dimensions
/// are set to `null`. This prevents the usage of invalid or unreliable screen dimensions
/// throughout the application.
class SalatWaqtScreen {
  SalatWaqtScreen._();

  static void setUp(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    _height = size.height;
    _width = size.width;
    _resetIfInvalid();
  }

  static double? _width;
  static double? _height;

  static Size get _size => MediaQuery.sizeOf(SalatWaqt.globalContext);

  static double get width {
    _width ??= _size.width;
    return _width!;
  }

  static double get height {
    _height ??= _size.height;
    return _height!;
  }

  static void _resetIfInvalid() {
    if (_width! < 10 || _height! < 10) {
      logErrorStatic(
        'SalatWaqtScreen size not initialized. Please initialize SalatWaqtScreen and try again.',
        "salat_waqt_screen",
      );
      _width = null;
      _height = null;
    }
  }
}

extension SalatWaqtScreenExtensions on Widget {
  // Percentage-based sizes
  double get onePercentWidth => 1.percentWidth;
  double get twoPercentWidth => 2.percentWidth;
  double get threePercentWidth => 3.percentWidth;
  double get fourPercentWidth => 4.percentWidth;
  double get fivePercentWidth => 5.percentWidth;
  double get sixPercentWidth => 6.percentWidth;
  double get sevenPercentWidth => 7.percentWidth;
  double get eightPercentWidth => 8.percentWidth;
  double get tenPercentWidth => 10.percentWidth;
  double get twentyPercentWidth => 20.percentWidth;
  double get twentyFivePercentWidth => 25.percentWidth;
  double get thirtyPercentWidth => 30.percentWidth;
  double get fortyPercentWidth => 40.percentWidth;
  double get fiftyPercentWidth => 50.percentWidth;
  double get fiftyFivePercentWidth => 55.percentWidth;
  double get sixtySixPercentWidth => 66.percentWidth;
  double get seventyPercentWidth => 70.percentWidth;

  double get tenPercentHeight => 10.percentHeight;
  double get twelvePercentHeight => 12.percentHeight;
  double get fourteenPercentHeight => 14.percentHeight;
  double get twentyPercentHeight => 20.percentHeight;
  double get fiftyPercentHeight => 50.percentHeight;
}

extension DeviceExt on num {
  double get px {
    _widthPercent ??= _calculateSalatWaqtScreenWidthQuarterPercentage();
    return this * (_widthPercent ?? 0);
  }

  double get percentHeight {
    _heightPercent ??= SalatWaqtScreen.height / 100;
    return this * (_heightPercent ?? 0);
  }

  double get percentWidth {
    _widthPercent ??= SalatWaqtScreen.width / 100;
    return this * (_widthPercent ?? 0);
  }
}

double? _heightPercent;
double? _widthPercent;

double _calculateSalatWaqtScreenWidthQuarterPercentage() {
  return (SalatWaqtScreen.width / 3.9) / 100;
}

// Common pixel sizes
class Sizes {
  static double get onePx => 1.px;
  static double get twoPx => 2.px;
  static double get threePx => 3.px;
  static double get fourPx => 4.px;
  static double get fivePx => 5.px;
  static double get sixPx => 6.px;
  static double get sevenPx => 7.px;
  static double get eightPx => 8.px;
  static double get ninePx => 9.px;
  static double get tenPx => 10.px;
  static double get elevenPx => 11.px;
  static double get twelvePx => 12.px;
  static double get thirteenPx => 13.px;
  static double get fourteenPx => 14.px;
  static double get fifteenPx => 15.px;
  static double get sixteenPx => 16.px;
  static double get seventeenPx => 17.px;
  static double get eighteenPx => 18.px;
  static double get nineteenPx => 19.px;
  static double get twentyPx => 20.px;
  static double get twentyOnePx => 21.px;
  static double get twentyTwoPx => 22.px;
  static double get twentyThreePx => 23.px;
  static double get twentyFourPx => 24.px;
  static double get twentyFivePx => 25.px;
  static double get twentySixPx => 26.px;
  static double get twentySevenPx => 27.px;
  static double get twentyEightPx => 28.px;
  static double get twentyNinePx => 29.px;
  static double get thirtyPx => 30.px;
  static double get thirtyOnePx => 31.px;
  static double get thirtyTwoPx => 32.px;
  static double get thirtyThreePx => 33.px;
  static double get thirtyFourPx => 34.px;
  static double get thirtyFivePx => 35.px;
  static double get thirtySixPx => 36.px;
  static double get thirtySevenPx => 37.px;
  static double get thirtyEightPx => 38.px;
  static double get thirtyNinePx => 39.px;
  static double get fortyPx => 40.px;
  static double get fortyOnePx => 41.px;
  static double get fortyTwoPx => 42.px;
  static double get fortyThreePx => 43.px;
  static double get fortyFourPx => 44.px;
  static double get fortyFivePx => 45.px;
  static double get fortySixPx => 46.px;
  static double get fortySevenPx => 47.px;
  static double get fortyEightPx => 48.px;
  static double get fortyNinePx => 49.px;
  static double get fiftyPx => 50.px;
  static double get sixtyPx => 60.px;
  static double get seventyPx => 70.px;
  static double get eightyPx => 80.px;
  static double get ninetyPx => 90.px;
  static double get hundredPx => 100.px;
  static double get twoHundredPx => 200.px;
}
