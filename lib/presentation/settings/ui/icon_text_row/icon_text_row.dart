import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/home/ui/appber/custom_switch.dart';

class IconTextRow extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final double? titleFontSize;
  final String subtitle;
  final String svgIconPath;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;
  final bool hasSwitch;

  const IconTextRow({
    super.key,
    required this.theme,
    required this.title,
    required this.subtitle,
    required this.svgIconPath,
    this.titleFontSize,
    this.hasSwitch = true,
    this.switchValue,
    this.onSwitchChanged,
  }) : assert(
         hasSwitch == false || (switchValue != null && onSwitchChanged != null),
         'If hasSwitch is true, switchValue and onSwitchChanged must not be null',
       );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        gradient: RadialGradient(
          center: Alignment(0.93, 1.20),
          radius: 0.72,
          colors: [
            context.color.cardGradientStart,
            context.color.cardGradientEnd,
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.px),
        ),
      ),
      child: Padding(
        padding:  EdgeInsets.all(18.px),
        child: Row(
          children: [
            SvgPicture.asset(svgIconPath, width: 28.px, height: 28.px),
            SizedBox(width: 16.px),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: AppTextStyles.inter,
                      fontWeight: FontWeight.w500,
                      fontSize: titleFontSize ?? 18.px,
                      color: context.color.cardTitleColor,
                    ),
                  ),
                  SizedBox(height: 8.px),
                  Text(
                    subtitle,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontFamily: AppTextStyles.inter,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.px,
                      color: context.color.cardSubtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            if (hasSwitch)
              Expanded(
                flex: 1,
                child: CustomSwitch(
                  switchValue: switchValue!,
                  onSwitchChanged: onSwitchChanged!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
