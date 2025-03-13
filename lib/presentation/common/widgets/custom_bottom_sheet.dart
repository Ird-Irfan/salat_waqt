import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class CustomBottomSheet extends StatelessWidget {
  final BuildContext context;
  final Widget child;
  final double? height;
  const CustomBottomSheet({
    super.key,
    required this.child,
    required this.context,
    this.height,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: height ?? MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CustomBottomSheet(
          context: context,
          height: height,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.93, 1.20),
          radius: 0.72,
          colors: [
            context.color.cardGradientEnd,  
            context.color.cardGradientStart,
            
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.px),
          topRight: Radius.circular(16.px),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.px),
          Container(
            width: 40.px,
            height: 4.px,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacityInt(30),
              borderRadius: BorderRadius.circular(4.px),
            ),
          ),
          SizedBox(height: 16.px),
          child,
          SizedBox(height: 16.px),
        ],
      ),
    );
  }
}
