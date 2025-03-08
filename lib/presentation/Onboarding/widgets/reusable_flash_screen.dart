import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_color.dart';

/// A reusable flash/splash screen widget that can be customized with
/// different backgrounds, logos, titles, and subtitles.
class ReusableFlashScreen extends StatelessWidget {
  /// Background image asset path
  final String backgroundImagePath;

  /// Logo image asset path
  final String? logoImagePath;

  /// Logo width
  final double logoWidth;

  /// Logo height
  final double logoHeight;

  /// Title text
  final String? title;

  /// Title text style
  final TextStyle? titleStyle;

  /// Subtitle text
  final String? subtitle;

  /// Subtitle text style
  final TextStyle? subtitleStyle;

  /// Space between title and subtitle
  final double spaceBetween;

  /// Additional widgets to display below the subtitle
  final List<Widget>? additionalWidgets;

  const ReusableFlashScreen({
    super.key,
    required this.backgroundImagePath,
    this.logoImagePath,
    this.logoWidth = 160,
    this.logoHeight = 160,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.spaceBetween = 16,
    this.additionalWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildFlashScreenContent(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFlashScreenContent() {
    final List<Widget> widgets = [];

    // Add logo if provided
    if (logoImagePath != null) {
      widgets.add(
        Image.asset(logoImagePath!, width: logoWidth, height: logoHeight),
      );
    }

    // Add title if provided
    if (title != null) {
      widgets.add(
        Text(
          title!,
          style:
              titleStyle ??
              const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: SalatColor.primaryColorDark300,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Add space between title and subtitle
    if (title != null && subtitle != null) {
      widgets.add(SizedBox(height: spaceBetween));
    }

    // Add subtitle if provided
    if (subtitle != null) {
      widgets.add(
        Text(
          subtitle!,
          style:
              subtitleStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: SalatColor.cardSubTitleColorDark,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Add additional widgets if provided
    if (additionalWidgets != null && additionalWidgets!.isNotEmpty) {
      widgets.addAll(additionalWidgets!);
    }

    return widgets;
  }
}

/// A simplified version of the flash screen with predefined styles
class SimpleFlashScreen extends StatelessWidget {
  /// Background image asset path
  final String backgroundImagePath;

  /// Logo image asset path
  final String logoImagePath;

  /// Title text
  final String title;

  /// Subtitle text
  final String subtitle;

  const SimpleFlashScreen({
    super.key,
    required this.backgroundImagePath,
    required this.logoImagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableFlashScreen(
      backgroundImagePath: backgroundImagePath,
      logoImagePath: logoImagePath,
      title: title,
      subtitle: subtitle,
    );
  }
}
