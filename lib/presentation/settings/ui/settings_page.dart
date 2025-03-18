import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/core/utility/utility.dart';
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
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          return CustomScrollView(
            slivers: [
              CustomAppBar(theme: theme),
              SliverPadding(
                padding: EdgeInsets.all(16.px),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.px,
                        bottom: 9.px,
                        left: 8.px,
                      ),
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
                      switchValue:
                          presenter.currentUiState.use24HourFormatEnabled,
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
                    IconTextRow(
                      theme: theme,
                      title: 'Time Adjustments',
                      subtitle: 'Adjust Prayer time Notification',
                      svgIconPath: AppConstant.icClock,
                      switchValue:
                          presenter.currentUiState.timeAdjustmentEnabled,
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
                      subtitle: presenter.currentUiState.selectedRamadan ?? "Bangladesh",
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
                      switchValue:
                          presenter.currentUiState.hideIftaarTimeEnabled,
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
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
