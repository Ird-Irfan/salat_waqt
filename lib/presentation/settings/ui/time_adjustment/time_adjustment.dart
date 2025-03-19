import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/home/ui/appber/custom_switch.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_presenter.dart';

class TimeAdjustments extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final double? titleFontSize;
  final String subtitle;
  final String svgIconPath;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;
  final bool hasSwitch;

  const TimeAdjustments({
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
    final SettingsPresenter presenter = locator<SettingsPresenter>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(18.px),
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
          if (hasSwitch && switchValue == true) ...[
            Divider(
              color: context.color.cardSubtitleColor.withOpacity(0.3),
              thickness: 1.px,
              height: 1.px,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 28.px, horizontal: 16.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      presenter.incrementTimeAdjustment();
                    },
                    child: Container(
                      width: 104.px,
                      height: 40.px,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.50, -0.00),
                          end: Alignment(0.50, 1.00),
                          colors: [
                            context.color.btnPrimaryStartColor,
                            context.color.btnPrimaryEndColor,
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(32.px),
                            bottomRight: Radius.circular(32.px),
                            topLeft: Radius.circular(4.px),
                            bottomLeft: Radius.circular(4.px),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20.px,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${presenter.currentUiState.timeAdjustmentValue} Minutes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: AppTextStyles.inter,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.px,
                      color: context.color.cardTitleColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      presenter.decrementTimeAdjustment();
                    },
                    child: Container(
                      width: 104.px,
                      height: 40.px,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.50, -0.00),
                          end: Alignment(0.50, 1.00),
                          colors: [
                            context.color.btnPrimaryStartColor,
                            context.color.btnPrimaryEndColor,
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4.px),
                            bottomRight: Radius.circular(4.px),
                            topLeft: Radius.circular(32.px),
                            bottomLeft: Radius.circular(32.px),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20.px,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
