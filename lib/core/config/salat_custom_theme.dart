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

  final Color primaryColorDarkSubtitle;

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
    required this.primaryColorDarkSubtitle,
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
    primaryColorDarkSubtitle: SalatColor.primaryColorDarkSubtitle,
   
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
    primaryColorDarkSubtitle: SalatColor.primaryColorDarkSubtitle,
   
       
       

       
       
       
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
    Color? primaryColorDarkSubtitle,
   
   
   
   
   
   
   
   
   
   
   

   
   

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
      primaryColorDarkSubtitle: primaryColorDarkSubtitle ?? this.primaryColorDarkSubtitle,
     
    
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
      primaryColorDarkSubtitle: Color.lerp(primaryColorDarkSubtitle, other.primaryColorDarkSubtitle, t)!,
     

     
     
     
     

     
     

     
     
    );
  }
}
