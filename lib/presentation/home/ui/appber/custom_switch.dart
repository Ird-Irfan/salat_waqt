import 'package:flutter/material.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class CustomSwitch extends StatelessWidget {
  final bool switchValue;
  final Function(bool) onSwitchChanged;
  final Duration animationDuration;

  const CustomSwitch({
    super.key,
    required this.switchValue,
    required this.onSwitchChanged,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    const double inactiveThumbSize = 12.0;
    const double activeThumbSize = 16.0;

    final double thumbSize = switchValue ? activeThumbSize : inactiveThumbSize;

    final double activePosition = 42 - thumbSize - 4.0;
    final double inactivePosition = 4.0;

    return InkWell(
      onTap: () => onSwitchChanged(!switchValue),
      child: Container(
        width: 44,
        height: 25,
        decoration: ShapeDecoration(
          color: context.color.appBarBgColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.35,
              color:
                  switchValue
                      ? context.color.notificationActiveIconColor
                      : context.color.cardSubtitleColor,
            ),
            borderRadius: BorderRadius.circular(28 / 2),
          ),
          shadows:
              switchValue
                  ? [
                    const BoxShadow(
                      color: Color(0x663288ED),
                      blurRadius: 16,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ]
                  : [],
        ),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: animationDuration,
              // curve: Curves.easeInOut,
              curve: Curves.easeIn,
              // curve: Curves.decelerate,
              // curve: Curves.linear,
              margin: EdgeInsets.only(
                left: switchValue ? activePosition : inactivePosition,
                top: (22 - thumbSize) / 2,
              ),
              width: thumbSize,
              height: thumbSize,
              decoration: ShapeDecoration(
                color:
                    switchValue
                        ? context.color.notificationActiveIconColor
                        : context.color.cardSubtitleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(thumbSize / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
