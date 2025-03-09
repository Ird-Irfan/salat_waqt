import 'package:flutter/material.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double width;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final Alignment gradientStart;
  final Alignment gradientEnd;
  final double elevation;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.gradientColors,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 10,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.gradientStart = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: gradientStart,
          end: gradientEnd,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            elevation > 0
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacityInt(30),
                    spreadRadius: 0.5,
                    blurRadius: elevation,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: Padding(
              padding: padding,
              child: Text(
                text,
                style:
                    textStyle ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
