import 'package:flutter/material.dart';

class AppTextStyles {
  // Font families
  static const String kalpurush = 'kalpurush';
  static const String inter = 'Inter';
  static const String notoSerif = 'NotoSerif';

  // Common text sizes
  static const double smallSize = 12.0;
  static const double mediumSize = 14.0;
  static const double fifteenSize = 15.0;
  static const double largeSize = 16.0;
  static const double titleSize = 18.0;

  static const double twentyFiveSize = 25.0;
  static const double twentySixSize = 26.0;
  static const double twentySevenSize = 27.0;
  static const double headingSize = 20.0;
  static const double appTitleSize = 40.0;

  // Base text styles
  static const TextStyle small = TextStyle(
    fontSize: smallSize,
    fontWeight: FontWeight.w400,
    fontFamily: kalpurush,
  );

  static const TextStyle medium = TextStyle(
    fontSize: mediumSize,
    fontWeight: FontWeight.w400,
    fontFamily: kalpurush,
  );

  static const TextStyle large = TextStyle(
    fontSize: largeSize,
    fontWeight: FontWeight.w400,
    fontFamily: kalpurush,
  );

  static const TextStyle title = TextStyle(
    fontSize: twentySixSize,
    fontWeight: FontWeight.w700,
    fontFamily: notoSerif,
  );

  static const TextStyle heading = TextStyle(
    fontSize: headingSize,
    fontWeight: FontWeight.bold,
    fontFamily: kalpurush,
  );

  // Specific styles used in the app
  static TextStyle appTitle({Color? color}) => TextStyle(
    fontSize: appTitleSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'alinur-prottoyoee',
    color: color,
  );

  static TextStyle cardTitle({Color? color}) => TextStyle(
    fontSize: titleSize,
    fontWeight: FontWeight.bold,
    fontFamily: notoSerif,
    color: color,
  );

  static TextStyle subtitle({Color? color}) => TextStyle(
    fontSize: mediumSize,
    fontWeight: FontWeight.w400,
    fontFamily: kalpurush,
    color: color,
  );

  static TextStyle body({Color? color, double? height}) => TextStyle(
    fontSize: fifteenSize,
    fontWeight: FontWeight.w400,
    fontFamily: kalpurush,
    color: color,
    height: height,
  );

  static TextStyle notificationTitle({Color? color}) => TextStyle(
    fontSize: largeSize,
    fontWeight: FontWeight.w500,
    fontFamily: kalpurush,
    color: color,
  );

  static TextStyle button({Color? color}) => TextStyle(
    fontSize: largeSize,
    fontWeight: FontWeight.w500,
    fontFamily: kalpurush,
    color: color,
  );

  static TextStyle chip({Color? color}) => TextStyle(
    fontSize: smallSize + 2, // 14
    fontWeight: FontWeight.w500,
    fontFamily: kalpurush,
    color: color,
  );

  static TextStyle customAppBarTitle({Color? color}) => TextStyle(
    fontSize: largeSize,
    fontWeight: FontWeight.w500,
    fontFamily: notoSerif,
    color: color,
  );

  static TextStyle customAppBarSubtitle({Color? color}) =>
      TextStyle(fontSize: smallSize, fontFamily: kalpurush, color: color);

}
