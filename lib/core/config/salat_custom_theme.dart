import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_color.dart';

class SalatCustomTheme extends ThemeExtension<SalatCustomTheme> {
  final Color primaryColor100;
  final Color primaryColor200;
  final Color primaryColor300;
  final Color primaryColor400;
  final Color primaryColor500;
  final Color primaryColor600;
  final Color primaryColor700;
  final Color primaryColor750;
  final Color primaryColor800;
  final Color primaryColor900;

  final Color bgSurfaceColor;
  final Color cardTitleColor;
  final Color sunIconColor;
  final Color fajrIconColor;
  final Color inputBoxColor;
  final Color asrIconCloudColor;
  final Color magribIconCloudColor;
  final Color switchGlowColor;
  final Color primaryBtnTextColor;
  final Color appBarBgColor;
  final Color cardSubtitleColor;
  final Color collapseBtnColor;
  final Color cardSiblingBottomBorderColor;
  final Color forbiddenInfoIconColor;
  final Color notificationActiveIconColor;
  final Color notificationInactiveIconColor;
  final Color trackerDonuntRingColor;
  final Color meshCircleColor;
  final Color onBProgressPrimaryColor;
  final Color onBProgressSecondaryColor;
  final Color onBIconSecondaryColor;
  final Color iftaarSunColor;
  final Color cardGradientStart;
  final Color cardGradientEnd;

  final Color donutRingGradientStartColor;
  final Color donutRingGradientEndColor;

  final Color donutBottomCircleColor;

  const SalatCustomTheme({
    required this.primaryColor100,
    required this.primaryColor200,
    required this.primaryColor300,
    required this.primaryColor400,
    required this.primaryColor500,
    required this.primaryColor600,
    required this.primaryColor700,
    required this.primaryColor750,
    required this.primaryColor800,
    required this.primaryColor900,
    required this.bgSurfaceColor,
    required this.cardTitleColor,
    required this.sunIconColor,
    required this.fajrIconColor,
    required this.inputBoxColor,
    required this.asrIconCloudColor,
    required this.magribIconCloudColor,
    required this.switchGlowColor,
    required this.primaryBtnTextColor,
    required this.appBarBgColor,
    required this.cardSubtitleColor,
    required this.collapseBtnColor,
    required this.cardSiblingBottomBorderColor,
    required this.forbiddenInfoIconColor,
    required this.notificationActiveIconColor,
    required this.notificationInactiveIconColor,
    required this.trackerDonuntRingColor,
    required this.meshCircleColor,
    required this.onBProgressPrimaryColor,
    required this.onBProgressSecondaryColor,
    required this.onBIconSecondaryColor,
    required this.iftaarSunColor,
    required this.cardGradientStart,
    required this.cardGradientEnd,
    required this.donutRingGradientStartColor,
    required this.donutRingGradientEndColor,
    required this.donutBottomCircleColor,
  });

  // Light Theme
  static SalatCustomTheme get lightTheme => SalatCustomTheme(
    primaryColor100: SalatColor.primaryColorLight100,
    primaryColor200: SalatColor.primaryColorLight200,
    primaryColor300: SalatColor.primaryColorLight300,
    primaryColor400: SalatColor.primaryColorLight400,
    primaryColor500: SalatColor.primaryColorLight500,
    primaryColor600: SalatColor.primaryColorLight600,
    primaryColor700: SalatColor.primaryColorLight700,
    primaryColor750: SalatColor.primaryColorLight700,
    primaryColor800: SalatColor.primaryColorLight800,
    primaryColor900: SalatColor.primaryColorLight900,
    bgSurfaceColor: SalatColor.bgSurfaceColorLight,
    cardTitleColor: SalatColor.cardTitleColorLight,
    sunIconColor: SalatColor.sunIconColorLight,
    fajrIconColor: SalatColor.fajrIconCloudColorLight,
    inputBoxColor: SalatColor.inputBoxColorLight,
    asrIconCloudColor: SalatColor.asrIconCloudColorLight,
    magribIconCloudColor: SalatColor.magribIconCloudColorLight,
    switchGlowColor: SalatColor.switchGlowColorLight,
    primaryBtnTextColor: SalatColor.primaryBTNTextColorLight,
    appBarBgColor: SalatColor.appbarBGColorLight,
    cardSubtitleColor: SalatColor.cardSubtitleColorLight,
    collapseBtnColor: SalatColor.collapseBTNColorLight,
    cardSiblingBottomBorderColor: SalatColor.cardSiblingBottomBorderColorLight,
    forbiddenInfoIconColor: SalatColor.forbiddenInfoIconColorLight,
    notificationActiveIconColor: SalatColor.notificationActiveIconColorLight,
    notificationInactiveIconColor:
        SalatColor.notificationInactiveIconColorLight,
    trackerDonuntRingColor: SalatColor.trackerDonutRingColorLight,
    meshCircleColor: SalatColor.meshCircleColorLight,
    onBProgressPrimaryColor: SalatColor.onBProgressPrimaryColorLight,
    onBProgressSecondaryColor: SalatColor.onBProgressSecondaryColorLight,
    onBIconSecondaryColor: SalatColor.onBIconSecondaryColorLight,
    iftaarSunColor: SalatColor.iftaarSunColorLight,
    cardGradientStart: SalatColor.cardGradientStartLight,
    cardGradientEnd: SalatColor.cardGradientEndLight,
    donutRingGradientStartColor: SalatColor.donutRingGradientStartColorLight,
    donutRingGradientEndColor: SalatColor.donutRingGradientEndColorLight,
    donutBottomCircleColor: SalatColor.donutBottomCircleColorLight,
  );

  // Dark Theme
  static SalatCustomTheme get darkTheme => SalatCustomTheme(
    primaryColor100: SalatColor.primaryColorDark100,
    primaryColor200: SalatColor.primaryColorDark200,
    primaryColor300: SalatColor.primaryColorDark300,
    primaryColor400: SalatColor.primaryColorDark400,
    primaryColor500: SalatColor.primaryColorDark500,
    primaryColor600: SalatColor.primaryColorDark600,
    primaryColor700: SalatColor.primaryColorDark700,
    primaryColor750: SalatColor.primaryColorDark750,
    primaryColor800: SalatColor.primaryColorDark800,
    primaryColor900: SalatColor.primaryColorDark900,
    bgSurfaceColor: SalatColor.bgSurfaceColorDark,
    cardTitleColor: SalatColor.cardTitleColorDark,
    sunIconColor: SalatColor.sunIconColorDark,
    fajrIconColor: SalatColor.fajrIconCloudColorDark,
    inputBoxColor: SalatColor.inputBoxColorDark,
    asrIconCloudColor: SalatColor.asrIconCloudColorDark,
    magribIconCloudColor: SalatColor.magribIconCloudColorDark,
    switchGlowColor: SalatColor.switchGlowColorDark,
    primaryBtnTextColor: SalatColor.primaryBTNTextColorDark,
    appBarBgColor: SalatColor.appbarBGColorDark,
    cardSubtitleColor: SalatColor.cardSubtitleColorDark,
    collapseBtnColor: SalatColor.collapseBTNColorDark,
    cardSiblingBottomBorderColor: SalatColor.cardSiblingBottomBorderColorDark,
    forbiddenInfoIconColor: SalatColor.forbiddenInfoIconColorDark,
    notificationActiveIconColor: SalatColor.notificationActiveIconColorDark,
    notificationInactiveIconColor: SalatColor.notificationInactiveIconColorDark,
    trackerDonuntRingColor: SalatColor.trackerDonutRingColorDark,
    meshCircleColor: SalatColor.meshCircleColorDark,
    onBProgressPrimaryColor: SalatColor.onBProgressPrimaryColorDark,
    onBProgressSecondaryColor: SalatColor.onBProgressSecondaryColorDark,
    onBIconSecondaryColor: SalatColor.onBIconSecondaryColorDark,
    iftaarSunColor: SalatColor.iftaarSunColorDark,
    cardGradientStart: SalatColor.cardGradientStartDark,
    cardGradientEnd: SalatColor.cardGradientEndDark,
    donutRingGradientStartColor: SalatColor.donutRingGradientStartColorDark,
    donutRingGradientEndColor: SalatColor.donutRingGradientEndColorDark,
    donutBottomCircleColor: SalatColor.donutBottomCircleColorDark,
  );

  @override
  ThemeExtension<SalatCustomTheme> copyWith({
    Color? primaryColor100,
    Color? primaryColor200,
    Color? primaryColor300,
    Color? primaryColor400,
    Color? primaryColor500,
    Color? primaryColor600,
    Color? primaryColor700,
    Color? primaryColor750,
    Color? primaryColor800,
    Color? primaryColor900,
    Color? bgSurfaceColor,
    Color? cardTitleColor,
    Color? sunIconColor,
    Color? fajrIconColor,
    Color? inputBoxColor,
    Color? asrIconCloudColor,
    Color? magribIconCloudColor,
    Color? switchGlowColor,
    Color? primaryBtnTextColor,
    Color? appBarBgColor,
    Color? cardSubtitleColor,
    Color? collapseBtnColor,
    Color? cardSiblingBottomBorderColor,
    Color? forbiddenInfoIconColor,
    Color? notificationActiveIconColor,
    Color? notificationInactiveIconColor,
    Color? trackerDonuntRingColor,
    Color? meshCircleColor,
    Color? onBProgressPrimaryColor,
    Color? onBProgressSecondaryColor,
    Color? onBIconSecondaryColor,
    Color? iftaarSunColor,
    Color? cardGradientStart,
    Color? cardGradientEnd,
    Color? donutRingGradientStartColor,
    Color? donutRingGradientEndColor,
    Color? donutBottomCircleColor,
  }) {
    return SalatCustomTheme(
      primaryColor100: primaryColor100 ?? this.primaryColor100,
      primaryColor200: primaryColor200 ?? this.primaryColor200,
      primaryColor300: primaryColor300 ?? this.primaryColor300,
      primaryColor400: primaryColor400 ?? this.primaryColor400,
      primaryColor500: primaryColor500 ?? this.primaryColor500,
      primaryColor600: primaryColor600 ?? this.primaryColor600,
      primaryColor700: primaryColor700 ?? this.primaryColor700,
      primaryColor750: primaryColor750 ?? this.primaryColor750,
      primaryColor800: primaryColor800 ?? this.primaryColor800,
      primaryColor900: primaryColor900 ?? this.primaryColor900,
      bgSurfaceColor: bgSurfaceColor ?? this.bgSurfaceColor,
      cardTitleColor: cardTitleColor ?? this.cardTitleColor,
      sunIconColor: sunIconColor ?? this.sunIconColor,
      fajrIconColor: fajrIconColor ?? this.fajrIconColor,
      inputBoxColor: inputBoxColor ?? this.inputBoxColor,
      asrIconCloudColor: asrIconCloudColor ?? this.asrIconCloudColor,
      magribIconCloudColor: magribIconCloudColor ?? this.magribIconCloudColor,
      switchGlowColor: switchGlowColor ?? this.switchGlowColor,
      primaryBtnTextColor: primaryBtnTextColor ?? this.primaryBtnTextColor,
      appBarBgColor: appBarBgColor ?? this.appBarBgColor,
      cardSubtitleColor: cardSubtitleColor ?? this.cardSubtitleColor,
      collapseBtnColor: collapseBtnColor ?? this.collapseBtnColor,
      cardSiblingBottomBorderColor:
          cardSiblingBottomBorderColor ?? this.cardSiblingBottomBorderColor,
      forbiddenInfoIconColor:
          forbiddenInfoIconColor ?? this.forbiddenInfoIconColor,
      notificationActiveIconColor:
          notificationActiveIconColor ?? this.notificationActiveIconColor,
      notificationInactiveIconColor:
          notificationInactiveIconColor ?? this.notificationInactiveIconColor,
      trackerDonuntRingColor:
          trackerDonuntRingColor ?? this.trackerDonuntRingColor,
      meshCircleColor: meshCircleColor ?? this.meshCircleColor,
      onBProgressPrimaryColor:
          onBProgressPrimaryColor ?? this.onBProgressPrimaryColor,
      onBProgressSecondaryColor:
          onBProgressSecondaryColor ?? this.onBProgressSecondaryColor,
      onBIconSecondaryColor:
          onBIconSecondaryColor ?? this.onBIconSecondaryColor,
      iftaarSunColor: iftaarSunColor ?? this.iftaarSunColor,
      cardGradientStart: cardGradientStart ?? this.cardGradientStart,
      cardGradientEnd: cardGradientEnd ?? this.cardGradientEnd,
      donutRingGradientStartColor:
          donutRingGradientStartColor ?? this.donutRingGradientStartColor,
      donutRingGradientEndColor:
          donutRingGradientEndColor ?? this.donutRingGradientEndColor,
      donutBottomCircleColor:
          donutBottomCircleColor ?? this.donutBottomCircleColor,
    );
  }

  @override
  ThemeExtension<SalatCustomTheme> lerp(
    ThemeExtension<SalatCustomTheme>? other,
    double t,
  ) {
    if (other is! SalatCustomTheme) {
      return this;
    }
    return SalatCustomTheme(
      primaryColor100: Color.lerp(primaryColor100, other.primaryColor100, t)!,
      primaryColor200: Color.lerp(primaryColor200, other.primaryColor200, t)!,
      primaryColor300: Color.lerp(primaryColor300, other.primaryColor300, t)!,
      primaryColor400: Color.lerp(primaryColor400, other.primaryColor400, t)!,
      primaryColor500: Color.lerp(primaryColor500, other.primaryColor500, t)!,
      primaryColor600: Color.lerp(primaryColor600, other.primaryColor600, t)!,
      primaryColor700: Color.lerp(primaryColor700, other.primaryColor700, t)!,
      primaryColor750: Color.lerp(primaryColor750, other.primaryColor750, t)!,
      primaryColor800: Color.lerp(primaryColor800, other.primaryColor800, t)!,
      primaryColor900: Color.lerp(primaryColor900, other.primaryColor900, t)!,
      bgSurfaceColor: Color.lerp(bgSurfaceColor, other.bgSurfaceColor, t)!,
      cardTitleColor: Color.lerp(cardTitleColor, other.cardTitleColor, t)!,
      sunIconColor: Color.lerp(sunIconColor, other.sunIconColor, t)!,
      fajrIconColor: Color.lerp(fajrIconColor, other.fajrIconColor, t)!,
      inputBoxColor: Color.lerp(inputBoxColor, other.inputBoxColor, t)!,
      asrIconCloudColor:
          Color.lerp(asrIconCloudColor, other.asrIconCloudColor, t)!,
      magribIconCloudColor:
          Color.lerp(magribIconCloudColor, other.magribIconCloudColor, t)!,
      switchGlowColor: Color.lerp(switchGlowColor, other.switchGlowColor, t)!,
      primaryBtnTextColor:
          Color.lerp(primaryBtnTextColor, other.primaryBtnTextColor, t)!,
      appBarBgColor: Color.lerp(appBarBgColor, other.appBarBgColor, t)!,
      cardSubtitleColor:
          Color.lerp(cardSubtitleColor, other.cardSubtitleColor, t)!,
      collapseBtnColor:
          Color.lerp(collapseBtnColor, other.collapseBtnColor, t)!,
      cardSiblingBottomBorderColor:
          Color.lerp(
            cardSiblingBottomBorderColor,
            other.cardSiblingBottomBorderColor,
            t,
          )!,
      forbiddenInfoIconColor:
          Color.lerp(forbiddenInfoIconColor, other.forbiddenInfoIconColor, t)!,
      notificationActiveIconColor:
          Color.lerp(
            notificationActiveIconColor,
            other.notificationActiveIconColor,
            t,
          )!,
      notificationInactiveIconColor:
          Color.lerp(
            notificationInactiveIconColor,
            other.notificationInactiveIconColor,
            t,
          )!,
      trackerDonuntRingColor:
          Color.lerp(trackerDonuntRingColor, other.trackerDonuntRingColor, t)!,
      meshCircleColor: Color.lerp(meshCircleColor, other.meshCircleColor, t)!,
      onBProgressPrimaryColor:
          Color.lerp(
            onBProgressPrimaryColor,
            other.onBProgressPrimaryColor,
            t,
          )!,
      onBProgressSecondaryColor:
          Color.lerp(
            onBProgressSecondaryColor,
            other.onBProgressSecondaryColor,
            t,
          )!,
      onBIconSecondaryColor:
          Color.lerp(onBIconSecondaryColor, other.onBIconSecondaryColor, t)!,
      iftaarSunColor: Color.lerp(iftaarSunColor, other.iftaarSunColor, t)!,
      cardGradientStart: Color.lerp(cardGradientStart, other.cardGradientStart, t)!,
      cardGradientEnd: Color.lerp(cardGradientEnd, other.cardGradientEnd, t)!,
      donutRingGradientStartColor:
          Color.lerp(
            donutRingGradientStartColor,
            other.donutRingGradientStartColor,
            t,
          )!,
      donutRingGradientEndColor:
          Color.lerp(
            donutRingGradientEndColor,
            other.donutRingGradientEndColor,
            t,
          )!,
      donutBottomCircleColor:
          Color.lerp(donutBottomCircleColor, other.donutBottomCircleColor, t)!,
    );
  }
}
