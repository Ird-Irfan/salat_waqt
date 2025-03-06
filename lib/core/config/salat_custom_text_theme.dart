import 'package:flutter/material.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';

class SalatCustomTextTheme extends ThemeExtension<SalatCustomTextTheme> {
  final TextStyle? labelExtraSmall;
  final TextStyle? title;
  final TextStyle? arabicText;
  final TextStyle? buttonText;
  final TextStyle? cardText;
  final TextStyle? prayerTime;
  final TextStyle? prayerName;

  const SalatCustomTextTheme({
    this.labelExtraSmall,
    this.title,
    this.arabicText,
    this.buttonText,
    this.cardText,
    this.prayerTime,
    this.prayerName,
  });

  @override
  ThemeExtension<SalatCustomTextTheme> copyWith({
    TextStyle? labelExtraSmall,
    TextStyle? title,
    TextStyle? arabicText,
    TextStyle? buttonText,
    TextStyle? cardText,
    TextStyle? prayerTime,
    TextStyle? prayerName,
  }) {
    return SalatCustomTextTheme(
      labelExtraSmall: labelExtraSmall ?? this.labelExtraSmall,
      title: title ?? this.title,
      arabicText: arabicText ?? this.arabicText,
      buttonText: buttonText ?? this.buttonText,
      cardText: cardText ?? this.cardText,
      prayerTime: prayerTime ?? this.prayerTime,
      prayerName: prayerName ?? this.prayerName,
    );
  }

  @override
  ThemeExtension<SalatCustomTextTheme> lerp(
    ThemeExtension<SalatCustomTextTheme>? other,
    double t,
  ) {
    if (other is! SalatCustomTextTheme) {
      return this;
    }
    return SalatCustomTextTheme(
      labelExtraSmall: TextStyle.lerp(
        labelExtraSmall,
        other.labelExtraSmall,
        t,
      ),
      title: TextStyle.lerp(title, other.title, t),
      arabicText: TextStyle.lerp(arabicText, other.arabicText, t),
      buttonText: TextStyle.lerp(buttonText, other.buttonText, t),
      cardText: TextStyle.lerp(cardText, other.cardText, t),
      prayerTime: TextStyle.lerp(prayerTime, other.prayerTime, t),
      prayerName: TextStyle.lerp(prayerName, other.prayerName, t),
    );
  }
}

class SalatTextTheme {
  static TextTheme baseTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.appTitleSize,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.twentySevenSize,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.twentySixSize,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.twentyFiveSize,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.headingSize,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.titleSize,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.largeSize + 2, // 18
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.largeSize,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.fifteenSize,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.largeSize,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.mediumSize,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.smallSize,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.fifteenSize,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.mediumSize,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontFamily: AppTextStyles.inter,
      fontSize: AppTextStyles.smallSize,
      fontWeight: FontWeight.w500,
    ),
  );
}
