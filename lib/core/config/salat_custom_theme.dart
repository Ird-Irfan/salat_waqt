import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_color.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class SalatCustomTheme extends ThemeExtension<SalatCustomTheme> {
  final Color primaryColor100;
  final Color primaryColor90;
  final Color primaryColor80;
  final Color primaryColor70;
  final Color primaryColor60;
  final Color primaryColor50;
  final Color primaryColor40;
  final Color primaryColor30;
  final Color primaryColor20;
  final Color primaryColor10;
  final Color primaryColor5;
  final Color primaryColor;

  // Other colors commented out as they don't directly match with salat_color.dart
  /*
  final Color secondary;
  final Color cardShade;
  final Color topShapeBg;
  final Color navInactive;
  final Color topIconHome;
  final Color backgroundColor;
  final Color whiteColor;
  final Color navBgAc;
  final Color blackColor;
  final Color subtitleColor;
  final Color shade1;
  final Color gdTop;
  final Color gdMiddle;
  final Color gdBottom;
  final Color iconDisabledColor;
  final Color iconActiveColor;
  final Color primaryButtonColor;
  final Color primaryButtonTextColor;
  final Color secondaryButtonColor;
  final Color inputFieldColor;
  final Color bottomSheetHeader;
  final Color thumbInactive;
  final Color thumbActive;
  final Color switchInactive;
  final Color switchActive;
  final Color secondaryButtonTextColor;
  final Color gradientTop;
  final Color gradientBottom;
  final Color iconBgColor;
  final Color tabBarShade;
  final Color tabActive;
  final Color chartShade;
  final Color borderColor;
  final Color inputColor;
  */

  const SalatCustomTheme({
    required this.primaryColor100,
    required this.primaryColor90,
    required this.primaryColor80,
    required this.primaryColor70,
    required this.primaryColor60,
    required this.primaryColor50,
    required this.primaryColor40,
    required this.primaryColor30,
    required this.primaryColor20,
    required this.primaryColor10,
    required this.primaryColor5,
    required this.primaryColor,
    /*
    required this.secondary,
    required this.cardShade,
    required this.topShapeBg,
    required this.navInactive,
    required this.topIconHome,
    required this.backgroundColor,
    required this.whiteColor,
    required this.navBgAc,
    required this.blackColor,
    required this.subtitleColor,
    required this.shade1,
    required this.gdTop,
    required this.gdMiddle,
    required this.gdBottom,
    required this.iconDisabledColor,
    required this.iconActiveColor,
    required this.primaryButtonColor,
    required this.primaryButtonTextColor,
    required this.secondaryButtonColor,
    required this.inputFieldColor,
    required this.bottomSheetHeader,
    required this.thumbInactive,
    required this.thumbActive,
    required this.switchInactive,
    required this.switchActive,
    required this.secondaryButtonTextColor,
    required this.gradientTop,
    required this.gradientBottom,
    required this.iconBgColor,
    required this.tabBarShade,
    required this.tabActive,
    required this.chartShade,
    required this.borderColor,
    required this.inputColor,
    */
  });

  // Light Theme
  static SalatCustomTheme get lightTheme => SalatCustomTheme(
    primaryColor100: SalatColor.primaryColorLight100,
    primaryColor90: SalatColor.primaryColorLight200,
    primaryColor80: SalatColor.primaryColorLight300,
    primaryColor70: SalatColor.primaryColorLight400,
    primaryColor60: SalatColor.primaryColorLight500,
    primaryColor50: SalatColor.primaryColorLight600,
    primaryColor40: SalatColor.primaryColorLight700,
    primaryColor30: SalatColor.primaryColorLight800,
    primaryColor20: SalatColor.primaryColorLight900,
    primaryColor10: SalatColor.primaryColorLight900,
    primaryColor5: SalatColor.primaryColorLight900,
    primaryColor: SalatColor.primaryColorLight500,
    /*
        secondary: SalatColor.primaryColorLight400,
        cardShade: Colors.white,
        topShapeBg: SalatColor.primaryColorLight300,
        navInactive: Colors.grey.shade400,
        topIconHome: Colors.white,
        backgroundColor: Colors.white,
        whiteColor: Colors.white,
        navBgAc: SalatColor.primaryColorLight300.withOpacityInt(0.2),
        blackColor: Colors.black,
        subtitleColor: Colors.grey.shade600,
        shade1: Colors.grey.shade100,
        gdTop: SalatColor.primaryColorLight200,
        gdMiddle: SalatColor.primaryColorLight400,
        gdBottom: SalatColor.primaryColorLight600,
        iconDisabledColor: Colors.grey.shade400,
        iconActiveColor: SalatColor.primaryColorLight500,
        primaryButtonColor: SalatColor.primaryColorLight500,
        primaryButtonTextColor: Colors.white,
        secondaryButtonColor: Colors.grey.shade200,
        secondaryButtonTextColor: Colors.black87,
        inputFieldColor: Colors.grey.shade200,
        bottomSheetHeader: Colors.grey.shade200,
        thumbInactive: Colors.grey.shade400,
        thumbActive: SalatColor.primaryColorLight500,
        switchInactive: Colors.grey.shade300,
        switchActive: SalatColor.primaryColorLight300,
        gradientTop: SalatColor.primaryColorLight300,
        gradientBottom: SalatColor.primaryColorLight600,
        iconBgColor: SalatColor.primaryColorLight100,
        tabBarShade: Colors.grey.shade200,
        tabActive: SalatColor.primaryColorLight500,
        chartShade: SalatColor.primaryColorLight100,
        borderColor: Colors.grey.shade300,
        inputColor: Colors.black87,
        */
  );

  // Dark Theme
  static SalatCustomTheme get darkTheme => SalatCustomTheme(
    primaryColor100: SalatColor.primaryColorDark100,
    primaryColor90: SalatColor.primaryColorDark200,
    primaryColor80: SalatColor.primaryColorDark300,
    primaryColor70: SalatColor.primaryColorDark400,
    primaryColor60: SalatColor.primaryColorDark500,
    primaryColor50: SalatColor.primaryColorDark600,
    primaryColor40: SalatColor.primaryColorDark700,
    primaryColor30: SalatColor.primaryColorDark750,
    primaryColor20: SalatColor.primaryColorDark800,
    primaryColor10: SalatColor.primaryColorDark900.withOpacityInt(0.1),
    primaryColor5: SalatColor.primaryColorDark900.withOpacityInt(0.05),
    primaryColor: SalatColor.primaryColorDark500,
    /*
        secondary: SalatColor.primaryColorDark400,
        cardShade: Color(0xFF1E1E1E),
        topShapeBg: SalatColor.primaryColorDark300,
        navInactive: Colors.grey.shade700,
        topIconHome: Colors.white,
        backgroundColor: Color(0xFF121212),
        whiteColor: Colors.white,
        navBgAc: SalatColor.primaryColorDark300.withOpacityInt(0.2),
        blackColor: Colors.black,
        subtitleColor: Colors.grey.shade400,
        shade1: Color(0xFF1D1D1D),
        gdTop: SalatColor.primaryColorDark750,
        gdMiddle: SalatColor.primaryColorDark700,
        gdBottom: SalatColor.primaryColorDark600,
        iconDisabledColor: Colors.grey.shade700,
        iconActiveColor: SalatColor.primaryColorDark500,
        primaryButtonColor: SalatColor.primaryColorDark500,
        primaryButtonTextColor: Colors.white,
        secondaryButtonColor: Color(0xFF2D2D2D),
        secondaryButtonTextColor: Colors.white70,
        inputFieldColor: Color(0xFF2D2D2D),
        bottomSheetHeader: Color(0xFF2D2D2D),
        thumbInactive: Colors.grey.shade700,
        thumbActive: SalatColor.primaryColorDark500,
        switchInactive: Colors.grey.shade800,
        switchActive: SalatColor.primaryColorDark400,
        gradientTop: SalatColor.primaryColorDark750,
        gradientBottom: SalatColor.primaryColorDark600,
        iconBgColor: Color(0xFF2D2D2D),
        tabBarShade: Color(0xFF2D2D2D),
        tabActive: SalatColor.primaryColorDark500,
        chartShade: Color(0xFF2D2D2D),
        borderColor: Colors.grey.shade800,
        inputColor: Colors.white70,
        */
  );

  @override
  ThemeExtension<SalatCustomTheme> copyWith({
    Color? primaryColor100,
    Color? primaryColor90,
    Color? primaryColor80,
    Color? primaryColor70,
    Color? primaryColor60,
    Color? primaryColor50,
    Color? primaryColor40,
    Color? primaryColor30,
    Color? primaryColor20,
    Color? primaryColor10,
    Color? primaryColor5,
    Color? primaryColor,
    /*
    Color? secondary,
    Color? cardShade,
    Color? topShapeBg,
    Color? navInactive,
    Color? topIconHome,
    Color? backgroundColor,
    Color? whiteColor,
    Color? navBgAc,
    Color? blackColor,
    Color? subtitleColor,
    Color? homeDashboardBgColor,
    Color? gdTop,
    Color? gdMiddle,
    Color? gdBottom,
    Color? iconDisabledColor,
    Color? iconActiveColor,
    Color? primaryButtonColor,
    Color? primaryButtonTextColor,
    Color? secondaryButtonColor,
    Color? inputFieldColor,
    Color? bottomSheetHeader,
    Color? thumbInactive,
    Color? thumbActive,
    Color? switchInactive,
    Color? switchActive,
    Color? secondaryButtonTextColor,
    Color? gradientTop,
    Color? gradientBottom,
    Color? iconBgColor,
    Color? tabBarShade,
    Color? tabActive,
    Color? chartShade,
    Color? borderColor,
    Color? inputColor,
    */
  }) {
    return SalatCustomTheme(
      primaryColor100: primaryColor100 ?? this.primaryColor100,
      primaryColor90: primaryColor90 ?? this.primaryColor90,
      primaryColor80: primaryColor80 ?? this.primaryColor80,
      primaryColor70: primaryColor70 ?? this.primaryColor70,
      primaryColor60: primaryColor60 ?? this.primaryColor60,
      primaryColor50: primaryColor50 ?? this.primaryColor50,
      primaryColor40: primaryColor40 ?? this.primaryColor40,
      primaryColor30: primaryColor30 ?? this.primaryColor30,
      primaryColor20: primaryColor20 ?? this.primaryColor20,
      primaryColor10: primaryColor10 ?? this.primaryColor10,
      primaryColor5: primaryColor5 ?? this.primaryColor5,
      primaryColor: primaryColor ?? this.primaryColor,
      /*
      secondary: secondary ?? this.secondary,
      cardShade: cardShade ?? this.cardShade,
      topShapeBg: topShapeBg ?? this.topShapeBg,
      navInactive: navInactive ?? this.navInactive,
      topIconHome: topIconHome ?? this.topIconHome,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      whiteColor: whiteColor ?? this.whiteColor,
      navBgAc: navBgAc ?? this.navBgAc,
      blackColor: blackColor ?? this.blackColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      shade1: homeDashboardBgColor ?? shade1,
      gdTop: gdTop ?? this.gdTop,
      gdMiddle: gdMiddle ?? this.gdMiddle,
      gdBottom: gdBottom ?? this.gdBottom,
      iconDisabledColor: iconDisabledColor ?? this.iconDisabledColor,
      iconActiveColor: iconActiveColor ?? this.iconActiveColor,
      primaryButtonColor: primaryButtonColor ?? this.primaryButtonColor,
      primaryButtonTextColor:
          primaryButtonTextColor ?? this.primaryButtonTextColor,
      secondaryButtonColor: secondaryButtonColor ?? this.secondaryButtonColor,
      inputFieldColor: inputFieldColor ?? this.inputFieldColor,
      bottomSheetHeader: bottomSheetHeader ?? this.bottomSheetHeader,
      thumbInactive: thumbInactive ?? this.thumbInactive,
      thumbActive: thumbActive ?? this.thumbActive,
      switchInactive: switchInactive ?? this.switchInactive,
      switchActive: switchActive ?? this.switchActive,
      secondaryButtonTextColor:
          secondaryButtonTextColor ?? this.secondaryButtonTextColor,
      gradientTop: gradientTop ?? this.gradientTop,
      gradientBottom: gradientBottom ?? this.gradientBottom,
      iconBgColor: iconBgColor ?? this.iconBgColor,
      tabBarShade: tabBarShade ?? this.tabBarShade,
      tabActive: tabActive ?? this.tabActive,
      chartShade: chartShade ?? this.chartShade,
      borderColor: borderColor ?? this.borderColor,
      inputColor: inputColor ?? this.inputColor,
      */
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
      primaryColor90: Color.lerp(primaryColor90, other.primaryColor90, t)!,
      primaryColor80: Color.lerp(primaryColor80, other.primaryColor80, t)!,
      primaryColor70: Color.lerp(primaryColor70, other.primaryColor70, t)!,
      primaryColor60: Color.lerp(primaryColor60, other.primaryColor60, t)!,
      primaryColor50: Color.lerp(primaryColor50, other.primaryColor50, t)!,
      primaryColor40: Color.lerp(primaryColor40, other.primaryColor40, t)!,
      primaryColor30: Color.lerp(primaryColor30, other.primaryColor30, t)!,
      primaryColor20: Color.lerp(primaryColor20, other.primaryColor20, t)!,
      primaryColor10: Color.lerp(primaryColor10, other.primaryColor10, t)!,
      primaryColor5: Color.lerp(primaryColor5, other.primaryColor5, t)!,
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      /*
      secondary: Color.lerp(secondary, other.secondary, t)!,
      cardShade: Color.lerp(cardShade, other.cardShade, t)!,
      topShapeBg: Color.lerp(topShapeBg, other.topShapeBg, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
      topIconHome: Color.lerp(topIconHome, other.topIconHome, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      whiteColor: Color.lerp(whiteColor, other.whiteColor, t)!,
      navBgAc: Color.lerp(navBgAc, other.navBgAc, t)!,
      blackColor: Color.lerp(blackColor, other.blackColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
      shade1: Color.lerp(shade1, other.shade1, t)!,
      gdTop: Color.lerp(gdTop, other.gdTop, t)!,
      gdMiddle: Color.lerp(gdMiddle, other.gdMiddle, t)!,
      gdBottom: Color.lerp(gdBottom, other.gdBottom, t)!,
      iconDisabledColor:
          Color.lerp(iconDisabledColor, other.iconDisabledColor, t)!,
      iconActiveColor: Color.lerp(iconActiveColor, other.iconActiveColor, t)!,
      primaryButtonColor:
          Color.lerp(primaryButtonColor, other.primaryButtonColor, t)!,
      primaryButtonTextColor:
          Color.lerp(primaryButtonTextColor, other.primaryButtonTextColor, t)!,
      secondaryButtonColor:
          Color.lerp(secondaryButtonColor, other.secondaryButtonColor, t)!,
      inputFieldColor: Color.lerp(inputFieldColor, other.inputFieldColor, t)!,
      bottomSheetHeader:
          Color.lerp(bottomSheetHeader, other.bottomSheetHeader, t)!,
      thumbInactive: Color.lerp(thumbInactive, other.thumbInactive, t)!,
      thumbActive: Color.lerp(thumbActive, other.thumbActive, t)!,
      switchInactive: Color.lerp(switchInactive, other.switchInactive, t)!,
      switchActive: Color.lerp(switchActive, other.switchActive, t)!,
      secondaryButtonTextColor: Color.lerp(
          secondaryButtonTextColor, other.secondaryButtonTextColor, t)!,
      gradientTop: Color.lerp(gradientTop, other.gradientTop, t)!,
      gradientBottom: Color.lerp(gradientBottom, other.gradientBottom, t)!,
      iconBgColor: Color.lerp(iconBgColor, other.iconBgColor, t)!,
      tabBarShade: Color.lerp(tabBarShade, other.tabBarShade, t)!,
      tabActive: Color.lerp(tabActive, other.tabActive, t)!,
      chartShade: Color.lerp(chartShade, other.chartShade, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      inputColor: Color.lerp(inputColor, other.inputColor, t)!,
      */
    );
  }
}
