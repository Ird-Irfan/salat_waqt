import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomBottomSheet extends StatelessWidget {
  final BuildContext context;
  final Widget child;
  const CustomBottomSheet({
    super.key,
    required this.child,
    required this.context,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CustomBottomSheet(context: context, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.px, left: 8.px, right: 8.px),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
              color: Colors.grey.withOpacity(0.3),
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
