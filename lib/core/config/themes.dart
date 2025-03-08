import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salat_waqt/core/config/salat_color.dart';
import 'package:salat_waqt/core/config/salat_custom_theme.dart';
import 'package:salat_waqt/core/config/salat_custom_text_theme.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/salat_waqt.dart';
import 'package:salat_waqt/core/services/logger_service.dart';

/// Extension to help with opacity values similar to the withOpacityInt method used in the original code

class SalatTheme {
  SalatTheme._();

  static ThemeData getTheme(
    String themeName,
    String fontFamily,
    double fontSize,
  ) {
    switch (themeName) {
      case 'Light':
        return lightTheme(fontFamily);
      case 'Dark':
        return darkTheme(fontFamily);
      case 'Green':
        return greenTheme(fontFamily);
      default:
        return lightTheme(fontFamily);
    }
  }

  static final ThemeData _baseTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: AppTextStyles.inter,
    bannerTheme: const MaterialBannerThemeData(
      backgroundColor: Color(0xFF3288ED),
    ),
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xff17B686)),
      ),
      hoverColor: Color(0xff55C595),
    ),
    dividerTheme: const DividerThemeData(thickness: 1),
  );

  static ThemeData lightTheme(String fontFamily) => _baseTheme.copyWith(
    brightness: Brightness.light,
    extensions: [
      SalatCustomTheme(
        primaryColor100: SalatColor.primaryColorLight100,
        primaryColor90: SalatColor.primaryColorLight200,
        primaryColor80: SalatColor.primaryColorLight300,
        primaryColor70: SalatColor.primaryColorLight400,
        primaryColor60: SalatColor.primaryColorLight500,
        primaryColor50: SalatColor.primaryColorLight600,
        primaryColor40: SalatColor.primaryColorLight700,
        primaryColor30: SalatColor.primaryColorLight800,
        primaryColor20: SalatColor.primaryColorLight900,
        primaryColor10: SalatColor.primaryColorLight900.withOpacityInt(10),
        primaryColor5: SalatColor.primaryColorLight900.withOpacityInt(5),
        primaryColor: SalatColor.primaryColorLight500,
      ),
      SalatCustomTextTheme(
        labelExtraSmall: TextStyle(
          fontSize: AppTextStyles.smallSize,
          color: Colors.black87,
          fontFamily: AppTextStyles.inter,
        ),
        title: TextStyle(
          fontSize: AppTextStyles.titleSize,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        arabicText: TextStyle(
          fontFamily: 'Amiri',
          fontSize: AppTextStyles.largeSize,
          fontWeight: FontWeight.w400,
          height: 2,
          color: Colors.black87,
        ),
        buttonText: TextStyle(
          fontSize: AppTextStyles.mediumSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: fontFamily,
        ),
        cardText: TextStyle(
          fontSize: AppTextStyles.mediumSize,
          color: Colors.black87,
          fontFamily: fontFamily,
        ),
      ),
    ],
    checkboxTheme: CheckboxThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return SalatColor.primaryColorLight500;
        }
        return Colors.transparent;
      }),
      side: BorderSide(
        color: SalatColor.primaryColorLight500.withOpacityInt(40),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return SalatColor.primaryColorLight500;
        }
        return SalatColor.primaryColorLight500.withOpacityInt(38);
      }),
    ),
    dialogTheme: const DialogTheme(backgroundColor: Colors.white),
    inputDecorationTheme: const InputDecorationTheme(
      focusColor: Color(0xff55C595),
      labelStyle: TextStyle(color: Color(0xff17B686)),
      fillColor: Color(0xFFEEEEEE),
    ),
    dividerTheme: DividerThemeData(
      color: SalatColor.primaryColorLight500.withOpacityInt(90),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: SalatColor.primaryColorLight500,
      selectionColor: SalatColor.primaryColorLight500.withOpacityInt(20),
      selectionHandleColor: SalatColor.primaryColorLight500,
    ),
    primaryColorLight: Colors.black,
    buttonTheme: const ButtonThemeData(buttonColor: Colors.black87),
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black87),
    primaryColor: SalatColor.primaryColorLight500,
    scaffoldBackgroundColor: Colors.white,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(SalatColor.primaryColorLight500),
    ),
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.white,
      backgroundColor: Color(0xff5ED9A4),
      foregroundColor: Color(0xff477848),
      iconTheme: IconThemeData(color: Colors.black87),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    textTheme: SalatTextTheme.baseTextTheme.apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black87,
      fontFamily: fontFamily,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff55C595),
      secondary: Color(0xff5ED9A4),
      surface: Color(0xff55C595),
      error: Color(0xFFED3535),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFE7DF),
      scrim: Color(0xFFEEEEEE),
      inverseSurface: Colors.white,
      inversePrimary: Colors.black87,
    ),
  );

  static ThemeData greenTheme(String fontFamily) => _baseTheme.copyWith(
    brightness: Brightness.light,
    extensions: [
      SalatCustomTheme(
        primaryColor100: SalatColor.primaryColorLight100,
        primaryColor90: SalatColor.primaryColorLight200,
        primaryColor80: SalatColor.primaryColorLight300,
        primaryColor70: SalatColor.primaryColorLight400,
        primaryColor60: SalatColor.primaryColorLight500,
        primaryColor50: SalatColor.primaryColorLight600,
        primaryColor40: SalatColor.primaryColorLight700,
        primaryColor30: SalatColor.primaryColorLight800,
        primaryColor20: SalatColor.primaryColorLight900,
        primaryColor10: SalatColor.primaryColorLight900.withOpacityInt(10),
        primaryColor5: SalatColor.primaryColorLight900.withOpacityInt(5),
        primaryColor: SalatColor.primaryColorLight600,
      ),
      SalatCustomTextTheme(
        labelExtraSmall: TextStyle(
          fontSize: AppTextStyles.smallSize,
          color: Colors.black87,
          fontFamily: AppTextStyles.inter,
        ),
        title: TextStyle(
          fontSize: AppTextStyles.titleSize,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        arabicText: TextStyle(
          fontFamily: 'Amiri',
          fontSize: AppTextStyles.largeSize,
          fontWeight: FontWeight.w400,
          height: 2,
          color: Colors.black87,
        ),
        buttonText: TextStyle(
          fontSize: AppTextStyles.mediumSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: fontFamily,
        ),
        cardText: TextStyle(
          fontSize: AppTextStyles.mediumSize,
          color: Colors.black87,
          fontFamily: fontFamily,
        ),
      ),
    ],
    checkboxTheme: CheckboxThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return SalatColor.primaryColorLight600;
        }
        return Colors.transparent;
      }),
      side: BorderSide(
        color: SalatColor.primaryColorLight600.withOpacityInt(40),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    dialogTheme: const DialogTheme(backgroundColor: Colors.white),
    inputDecorationTheme: const InputDecorationTheme(
      focusColor: Color(0xff429961),
      labelStyle: TextStyle(color: Color(0xff17B686)),
      fillColor: Color(0xFFEEEEEE),
    ),
    dividerTheme: DividerThemeData(
      color: SalatColor.primaryColorLight600.withOpacityInt(90),
    ),
    radioTheme: RadioThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return SalatColor.primaryColorLight600;
        }
        return SalatColor.primaryColorLight600.withOpacityInt(38);
      }),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: SalatColor.primaryColorLight600,
      selectionColor: SalatColor.primaryColorLight600.withOpacityInt(20),
      selectionHandleColor: SalatColor.primaryColorLight600,
    ),
    primaryColorLight: Colors.black,
    buttonTheme: const ButtonThemeData(buttonColor: Colors.black87),
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black87),
    primaryColor: SalatColor.primaryColorLight600,
    scaffoldBackgroundColor: Colors.white,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(SalatColor.primaryColorLight600),
    ),
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.white,
      backgroundColor: Color(0xff68F2B7),
      foregroundColor: Color(0xff477848),
      iconTheme: IconThemeData(color: Colors.black87),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    textTheme: SalatTextTheme.baseTextTheme.apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black87,
      fontFamily: fontFamily,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff429961),
      secondary: Color(0xff68F2B7),
      surface: Color(0xff429961),
      error: Color(0xFFED3535),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFE7DF),
      scrim: Color(0xFFEEEEEE),
      inverseSurface: Colors.white,
      inversePrimary: Colors.black87,
    ),
  );

  static ThemeData darkTheme(String fontFamily) => _baseTheme.copyWith(
    brightness: Brightness.dark,
    extensions: [
      SalatCustomTheme(
        primaryColor100: SalatColor.primaryColorDark100,
        primaryColor90: SalatColor.primaryColorDark200,
        primaryColor80: SalatColor.primaryColorDark300,
        primaryColor70: SalatColor.primaryColorDark400,
        primaryColor60: SalatColor.primaryColorDark500,
        primaryColor50: SalatColor.primaryColorDark600,
        primaryColor40: SalatColor.primaryColorDark700,
        primaryColor30: SalatColor.primaryColorDark750,
        primaryColor20: SalatColor.primaryColorDark800,
        primaryColor10: SalatColor.primaryColorDark900.withOpacityInt(10),
        primaryColor5: SalatColor.primaryColorDark900.withOpacityInt(5),
        primaryColor: SalatColor.primaryColorDark500,
      ),
      // SalatCustomTheme.darkTheme,
      SalatCustomTextTheme(
        labelExtraSmall: TextStyle(
          fontSize: AppTextStyles.smallSize,
          color: Colors.white,
          fontFamily: AppTextStyles.inter,
        ),
        title: TextStyle(
          fontSize: AppTextStyles.titleSize,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        arabicText: TextStyle(
          fontFamily: 'Amiri',
          fontSize: AppTextStyles.largeSize,
          fontWeight: FontWeight.w400,
          height: 2,
          color: Colors.white,
        ),
        buttonText: TextStyle(
          fontSize: AppTextStyles.mediumSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: fontFamily,
        ),
        cardText: TextStyle(
          fontSize: AppTextStyles.mediumSize,
          color: Colors.white,
          fontFamily: fontFamily,
        ),
      ),
    ],
    checkboxTheme: CheckboxThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return SalatColor.primaryColorDark500.withOpacityInt(50);
        }
        return Colors.transparent;
      }),
      side: BorderSide(
        color: SalatColor.primaryColorDark500.withOpacityInt(40),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return SalatColor.primaryColorDark500;
        }
        return SalatColor.primaryColorDark500.withOpacityInt(38);
      }),
    ),
    bannerTheme: const MaterialBannerThemeData(
      backgroundColor: Color(0xFF3288ED),
    ),
    dialogTheme: const DialogTheme(backgroundColor: Color(0xff122337)),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF585868)),
      ),
      focusColor: Colors.white,
      labelStyle: TextStyle(color: Color(0xff17B686)),
      fillColor: Color(0xff2D2D2D),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: SalatColor.primaryColorDark500,
      selectionColor: SalatColor.primaryColorDark500.withOpacityInt(50),
      selectionHandleColor: SalatColor.primaryColorDark500,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.amber),
    cardColor: Color(0xFF1E1E1E),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xff122337),
      modalBackgroundColor: Color(0xff223449),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.black,
      backgroundColor: Color(0xff235FA6),
      foregroundColor: Color(0xff477848),
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    primaryColor: SalatColor.primaryColorDark500,
    scaffoldBackgroundColor: Color(0xFF121212),
    primaryColorDark: const Color(0xff122337),
    dividerColor: const Color(0xFF585868),
    iconTheme: const IconThemeData(color: Color(0xff7F909F)),
    textTheme: SalatTextTheme.baseTextTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
      fontFamily: fontFamily,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Color(0xff235FA6),
      surface: Colors.white,
      error: Color(0xFFED3535),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      brightness: Brightness.dark,
      errorContainer: Color(0xFF202939),
      scrim: Color(0xFF2D2D2D),
      inverseSurface: Color(0xFF121212),
      inversePrimary: Colors.white70,
    ),
  );
}

Future<SystemUiOverlayStyle?> getSystemUiOverlayStyle({
  bool? isDark,
  BuildContext? context,
}) async {
  final LoggerService logger = LoggerService();
  try {
    final ThemeData theme = Theme.of(context ?? SalatWaqt.globalContext);
    final Color statusBarColor =
        isDark == null
            ? theme.primaryColor
            : (isDark ? const Color(0x00ffffff) : const Color(0xffffffff));

    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness:
          isDark != null && isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: statusBarColor,
      systemNavigationBarIconBrightness:
          isDark != null && isDark ? Brightness.light : Brightness.dark,
    );
  } catch (e) {
    logger.e('Error in getSystemUiOverlayStyle', e);
    return null;
  }
}
