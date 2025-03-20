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
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [
           context.color.btnPrimaryStartColor /* Gradient-BTN-Primary-Start */,
                  context.color.btnPrimaryEndColor  /* Gradient-BTN-Primary-End */,
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          splashColor: Colors.transparent,
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
