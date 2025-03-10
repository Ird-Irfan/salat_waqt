import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_presenter.dart';
import 'package:salat_waqt/presentation/settings/ui/animated_Card/animated_card.dart';
import 'package:salat_waqt/presentation/settings/ui/animated_expansion/animated_expansion.dart';
import 'package:salat_waqt/presentation/settings/ui/icon_text_row/icon_text_row.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsPresenter presenter = locator();
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Preferences'),
      ),

      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          return Padding(
            padding: EdgeInsets.all(16.px),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20.px,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.px),
                    child: Text(
                      'GENERAL',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14.px,
                        fontFamily: AppTextStyles.inter,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AnimatedExpansion(
                    theme: theme,
                    isDarkMode: Get.isDarkMode,
                    onThemeChanged: (isDark) {
                      // Change the app theme based on the selected mode
                      Get.changeThemeMode(
                        isDark ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),

                  IconTextRow(
                    title: 'Do Not Disturb',
                    subtitle: 'Pause All Notifications',
                    svgIconPath: AppConstant.icDnd,
                    switchValue: presenter.currentUiState.doNotDisturbEnabled,
                    onSwitchChanged: (bool) {
                      presenter.toggleDoNotDisturb();
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.px),
                    child: Text(
                      'PRAYER TIMES',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14.px,
                        fontFamily: AppTextStyles.inter,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  IconTextRow(
                    title: 'Use 24 Hour Format',
                    subtitle: 'Shown as: 23:44 PM',
                    svgIconPath: AppConstant.ic24Hour,
                    switchValue: presenter.currentUiState.doNotDisturbEnabled,
                    onSwitchChanged: (bool) {},
                  ),

                  AnimatedCard(
                    title: 'Juristic Method',
                    subtitle: 'Current: Hanafi',
                    svgIconPath: AppConstant.icCalculator,
                  ),
                  IconTextRow(
                    title: 'Calculation Method',
                    subtitle: 'Current: Moonsighting Comitte...',
                    svgIconPath: AppConstant.icCalculator,
                    hasSwitch: false,
                  ),

                  IconTextRow(
                    title: 'Time Adjustments',
                    subtitle: 'Adjust Prayer time Notification',
                    svgIconPath: AppConstant.icClock,
                    switchValue: presenter.currentUiState.doNotDisturbEnabled,
                    onSwitchChanged: (bool) {},
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.px),
                    child: Text(
                      'RAMADAN TIMES',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14.px,
                        fontFamily: AppTextStyles.inter,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  AnimatedCard(
                    title: 'Ramadan Calender Type',
                    subtitle: 'Current: Bangladesh',
                    svgIconPath: AppConstant.icEye,
                  ),
                  IconTextRow(
                    title: 'Hide Iftar & Sahri Time',
                    subtitle: 'Hides from homepage',
                    svgIconPath: AppConstant.icIslamicCalender,
                    switchValue: presenter.currentUiState.doNotDisturbEnabled,
                    onSwitchChanged: (bool) {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
