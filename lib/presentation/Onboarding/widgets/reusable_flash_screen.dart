import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_color.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/presentation/Onboarding/widgets/gradient_button.dart';

/// A reusable flash/splash screen widget that can be customized with
/// different backgrounds, logos, titles, and subtitles.
class ReusableFlashScreen extends StatelessWidget {
  // Background
  final String? backgroundImagePath;
  final BoxFit backgroundFit;

  // Primary Logo
  final String? logoImagePath;
  final double logoWidth;
  final double logoHeight;

  // Title
  final String? title;
  final TextStyle? titleStyle;

  // Subtitle
  final String? subtitle;
  final TextStyle? subtitleStyle;

  // Secondary Logo
  final String? secondLogoImagePath;
  final double secondLogoWidth;
  final double secondLogoHeight;

  // Secondary Subtitle
  final String? secondSubtitle;
  final TextStyle? secondSubtitleStyle;

  // Spacing
  final double spaceBetween;
  final double primaryToSecondarySpacing;
  final double secondaryLogoToSubtitleSpacing;
  final double subtitleToButtonSpacing;

  // Button
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final ButtonStyle? buttonStyle;
  final List<Color>? buttonGradientColors;
  final double buttonWidth;
  final double buttonHeight;
  final double buttonBorderRadius;
  final TextStyle? buttonTextStyle;
  final EdgeInsetsGeometry buttonPadding;

  // Additional content
  final List<Widget>? additionalWidgets;
  final MainAxisAlignment contentAlignment;
  final EdgeInsetsGeometry contentPadding;

  const ReusableFlashScreen({
    super.key,
    required this.backgroundImagePath,
    this.backgroundFit = BoxFit.cover,
    // Primary logo
    this.logoImagePath,
    this.logoWidth = 160,
    this.logoHeight = 160,
    // Title
    this.title,
    this.titleStyle,
    // Subtitle
    this.subtitle,
    this.subtitleStyle,
    // Secondary logo
    this.secondLogoImagePath,
    this.secondLogoWidth = 160,
    this.secondLogoHeight = 160,
    // Secondary subtitle
    this.secondSubtitle,
    this.secondSubtitleStyle,
    // Spacing
    this.spaceBetween = 16,
    this.primaryToSecondarySpacing = 100,
    this.secondaryLogoToSubtitleSpacing = 32,
    this.subtitleToButtonSpacing = 32,
    // Button
    this.buttonText,
    this.onButtonPressed,
    this.buttonStyle,
    this.buttonGradientColors,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 50,
    this.buttonBorderRadius = 10,
    this.buttonTextStyle,
    this.buttonPadding = const EdgeInsets.symmetric(horizontal: 20),
    // Additional
    this.additionalWidgets,
    this.contentAlignment = MainAxisAlignment.center,
    this.contentPadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath ?? AppConstant.bgflashScreen),
            fit: backgroundFit,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: contentPadding,
            child: Center(
              child: Column(
                mainAxisAlignment: contentAlignment,
                children: _buildFlashScreenContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFlashScreenContent() {
    final List<Widget> widgets = [];

    // Primary section (logo, title, subtitle)
    _buildPrimarySection(widgets);

    // Add spacing between primary and secondary sections if both exist
    if ((title != null || subtitle != null) &&
        (secondLogoImagePath != null || secondSubtitle != null)) {
      widgets.add(SizedBox(height: primaryToSecondarySpacing));
    }

    // Secondary section (second logo, second subtitle)
    _buildSecondarySection(widgets);

    // Button section
    _buildButtonSection(widgets);

    // Add additional widgets if provided
    if (additionalWidgets != null && additionalWidgets!.isNotEmpty) {
      widgets.addAll(additionalWidgets!);
    }

    return widgets;
  }

  void _buildPrimarySection(List<Widget> widgets) {
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
  }

  void _buildSecondarySection(List<Widget> widgets) {
    // Add second logo if provided
    if (secondLogoImagePath != null) {
      widgets.add(
        Image.asset(
          secondLogoImagePath!,
          width: secondLogoWidth,
          height: secondLogoHeight,
        ),
      );
    }

    // Add space between second logo and second subtitle
    if (secondLogoImagePath != null && secondSubtitle != null) {
      widgets.add(SizedBox(height: secondaryLogoToSubtitleSpacing));
    }

    // Add second subtitle if provided
    if (secondSubtitle != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            secondSubtitle!,
            style:
                secondSubtitleStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: SalatColor.cardSubTitleColorDark,
                  fontFamily: AppTextStyles.inter,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void _buildButtonSection(List<Widget> widgets) {
    // Add space before button if needed
    if ((secondSubtitle != null || subtitle != null) &&
        buttonText != null &&
        onButtonPressed != null) {
      widgets.add(SizedBox(height: subtitleToButtonSpacing));
    }

    // Add button if text and callback are provided
    if (buttonText != null && onButtonPressed != null) {
      // If gradient colors are provided, use GradientButton
      if (buttonGradientColors != null && buttonGradientColors!.isNotEmpty) {
        widgets.add(
          Padding(
            padding: buttonPadding,
            child: GradientButton(
              text: buttonText!,
              onPressed: onButtonPressed!,
              gradientColors: buttonGradientColors!,
              width: buttonWidth,
              height: buttonHeight,
              borderRadius: buttonBorderRadius,
              textStyle: buttonTextStyle,
            ),
          ),
        );
      } else {
        // Use regular ElevatedButton
        widgets.add(
          Padding(
            padding: buttonPadding,
            child: SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: buttonStyle,
                child: Text(buttonText!, style: buttonTextStyle),
              ),
            ),
          ),
        );
      }
    }
  }
}
