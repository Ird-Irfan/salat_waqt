import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/home/ui/appber/custom_switch.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_presenter.dart';
import 'package:salat_waqt/presentation/settings/ui/animated_Card/animated_card.dart';
import 'package:salat_waqt/presentation/settings/ui/animated_expansion/animated_expansion.dart';
import 'package:salat_waqt/presentation/settings/ui/animated_lang_card/animated_lang_card.dart';
import 'package:salat_waqt/presentation/settings/ui/custom_appbar/custom_appbar.dart';
import 'package:salat_waqt/presentation/settings/ui/icon_text_row/icon_text_row.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsPresenter presenter = locator<SettingsPresenter>();
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.px),
        child: ClipRRect(child: SettingsAppBar(theme: theme)),
      ),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16.px,
              right: 16.px,
              bottom: 16.px,
              top: 110.px,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.px, bottom: 9.px, left: 8.px),
                  child: Text(
                    'GENERAL',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 14.px,
                      fontFamily: AppTextStyles.inter,
                      fontWeight: FontWeight.w300,
                      color: context.color.cardSubtitleColor,
                    ),
                  ),
                ),
                AnimatedExpansion(
                  theme: theme,
                  onThemeChanged: (isDark) {
                    Get.changeThemeMode(
                      isDark ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
                SizedBox(height: 12.px),
                AnimatedLangCard(
                  theme: theme,
                  title: "Select Language",
                  subtitle: "Current: English",
                  svgIconPath: AppConstant.icLanguage,
                  isExpanded: presenter.currentUiState.isExpandedLang,
                  onCardTap: () => presenter.toggleExpansionLang(),
                  onTextSelect: (text) => presenter.selectText(text),
                  selectedText: presenter.currentUiState.selectedText,
                  selectedTextOne: "English",
                  selectedTextTwo: "Bangla",
                ),
                SizedBox(height: 12.px),
                IconTextRow(
                  theme: theme,
                  title: 'Do Not Disturb',
                  subtitle: 'Pause All Notifications',
                  svgIconPath: AppConstant.icDnd,
                  switchValue: presenter.currentUiState.doNotDisturbEnabled,
                  onSwitchChanged: (bool value) {
                    presenter.toggleDoNotDisturb();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 22.px,
                    bottom: 8.px,
                    left: 8.px,
                  ),
                  child: Text(
                    'PRAYER TIMES',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 14.px,
                      fontFamily: AppTextStyles.inter,
                      fontWeight: FontWeight.w400,
                      color: context.color.cardSubtitleColor,
                    ),
                  ),
                ),
                IconTextRow(
                  theme: theme,
                  title: 'Use 24 Hour Format',
                  subtitle: 'Shown as: 23:44 PM',
                  svgIconPath: AppConstant.ic24Hour,
                  switchValue: presenter.currentUiState.use24HourFormatEnabled,
                  onSwitchChanged: (bool value) {
                    presenter.toggleUse24HourFormat(value);
                  },
                ),
                SizedBox(height: 12.px),
                AnimatedCard(
                  theme: theme,
                  title: 'Juristic Method',
                  subtitle:
                      'Current: ${presenter.currentUiState.selectedJuristic ?? "Hanafi"}',
                  svgIconPath: AppConstant.icCalculator,
                  isExpanded: presenter.currentUiState.isExpandedJuristic,
                  onCardTap: () => presenter.toggleExpansionJuristic(),
                  onTextSelect: (text) => presenter.selectJuristic(text),
                  selectedText: presenter.currentUiState.selectedJuristic,
                  selectedTextOne: "Hanafi",
                  selectedTextTwo: "Shafi",
                ),
                SizedBox(height: 12.px),

                IconTextRow(
                  theme: theme,
                  title: 'Calculation Method',
                  subtitle: 'Current: Moonsighting Comitte...',
                  svgIconPath: AppConstant.icCalculator,
                  hasSwitch: false,
                ),
                SizedBox(height: 12.px),
                TimeAdjustments(
                  theme: theme,
                  title: 'Time Adjustments',
                  subtitle: 'Adjust Prayer time Notification',
                  svgIconPath: AppConstant.icClock,
                  switchValue: presenter.currentUiState.timeAdjustmentEnabled,
                  onSwitchChanged: (bool value) {
                    presenter.toggleTimeAdjustment(value);
                  },
                ),
                SizedBox(height: 12.px),
                Padding(
                  padding: EdgeInsets.only(
                    top: 22.px,
                    bottom: 8.px,
                    left: 8.px,
                  ),
                  child: Text(
                    'RAMADAN TIMES',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 14.px,
                      fontFamily: AppTextStyles.inter,
                      fontWeight: FontWeight.w400,
                      color: context.color.cardSubtitleColor,
                    ),
                  ),
                ),
                AnimatedCard(
                  theme: theme,
                  title: 'Calender Type',
                  subtitle: 'Current: Bangladesh',
                  svgIconPath: AppConstant.icIslamicCalender,
                  isExpanded: presenter.currentUiState.isExpandedRamadan,
                  onCardTap: () => presenter.toggleExpansionRamadan(),
                  onTextSelect: (text) => presenter.selectRamadan(text),
                  selectedText: presenter.currentUiState.selectedRamadan,
                  selectedTextOne: "Bangladesh",
                  selectedTextTwo: "Umm Al-Qura",
                ),
                SizedBox(height: 12.px),
                IconTextRow(
                  theme: theme,
                  title: 'Hide Iftar & Sahri Time',
                  subtitle: 'Hides from homepage',
                  svgIconPath: AppConstant.icEye,
                  switchValue: presenter.currentUiState.hideIftaarTimeEnabled,
                  onSwitchChanged: (bool value) {
                    presenter.toggleHideIftaarTime();
                  },
                ),
                SizedBox(height: 12.px),
                Padding(
                  padding: EdgeInsets.only(
                    top: 22.px,
                    bottom: 8.px,
                    left: 8.px,
                  ),
                  child: Text(
                    'RAMADAN TIMES',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 14.px,
                      fontFamily: AppTextStyles.inter,
                      fontWeight: FontWeight.w400,
                      color: context.color.cardSubtitleColor,
                    ),
                  ),
                ),

                IconTextRow(
                  theme: theme,
                  title: 'About Us',
                  subtitle: 'www.irdfoundation.com',
                  svgIconPath: AppConstant.icLayer,
                  hasSwitch: false,
                  titleFontSize: 14,
                ),
                SizedBox(height: 12.px),
                IconTextRow(
                  theme: theme,
                  title: 'Calculation Method',
                  subtitle: 'Current: Moonsighting Comitte...',
                  svgIconPath: AppConstant.icReview,
                  hasSwitch: false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [
            context.color.appBarBgColor.withOpacityInt(0.2),
            context.color.appBarBgColor.withOpacityInt(0.0),
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: CustomAppBar(theme: theme),
      ),
    );
  }
}

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
              padding: EdgeInsets.all(18.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.px),
                    ),
                    child: IconButton(
                      onPressed: () {
                        presenter.decrementTimeAdjustment();
                      },
                      icon: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 20.px,
                      ),
                    ),
                  ),
                  Text(
                    '${presenter.currentUiState.timeAdjustmentValue} মিনিট',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: AppTextStyles.inter,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.px,
                      color: context.color.cardTitleColor,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.px),
                    ),
                    child: IconButton(
                      onPressed: () {
                        presenter.incrementTimeAdjustment();
                      },
                      icon: Icon(Icons.add, color: Colors.white, size: 20.px),
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
