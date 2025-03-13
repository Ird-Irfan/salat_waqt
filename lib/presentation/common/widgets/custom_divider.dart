import 'package:flutter/material.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: context.color.cardSiblingBottomBorderColor.withOpacityInt(
        0.05,
      ),
    );
  }
}