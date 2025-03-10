import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class BgBlur extends StatelessWidget {
  final double sigmaX;
  final double sigmaY;
  final double opacity;
  final Widget? child;

  const BgBlur({
    super.key,
    this.sigmaX = 5, // Blur কমানো হয়েছে
    this.sigmaY = 5, // Blur কমানো হয়েছে
    this.opacity = 0.05, // Transparent করা হয়েছে
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
            child: Container(
              color: Colors.white.withOpacityInt(opacity), // Opacity কমিয়ে দেওয়া হয়েছে
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
