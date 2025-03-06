import 'package:flutter/material.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class SalatColor {
  // Dark Colors
  static const Color primaryColorDark100 = Color(0xFFF4FAFC);
  static const Color primaryColorDark200 = Color(0xFFE9F7FC);
  static const Color primaryColorDark300 = Color(0xFFC1DBFA);
  static const Color primaryColorDark400 = Color(0xFF8CC1FF);
  static const Color primaryColorDark500 = Color(0xFF6FACF2);
  static const Color primaryColorDark600 = Color(0xFF3288ED);
  static const Color primaryColorDark700 = Color(0xFF235FA6);
  static const Color primaryColorDark750 = Color(0xFF1C4D87);
  static const Color primaryColorDark800 = Color(0xFF101B45);
  static const Color primaryColorDark900 = Color(0xFF0D0D0D);
  // Gradient Colors dark mode
  static final List<Color> dateDisplayGradient = [
    primaryColorDark400.withOpacityInt(15),
    primaryColorDark750.withOpacityInt(15),
  ];

  //----------------------Light Mode Colors----------------------//

  // Light Colors
  static const Color primaryColorLight100 = Color(0xFFE5FFF4);
  static const Color primaryColorLight200 = Color(0xFFA1FFD7);
  static const Color primaryColorLight300 = Color(0xFF68F2B7);
  static const Color primaryColorLight400 = Color(0xFF5ED9A4);
  static const Color primaryColorLight500 = Color(0xFF55C595);
  static const Color primaryColorLight600 = Color(0xFF429961);
  static const Color primaryColorLight700 = Color(0xFF378051);
  static const Color primaryColorLight800 = Color(0xFF214D31);
  static const Color primaryColorLight900 = Color(0xFF163320);
}
