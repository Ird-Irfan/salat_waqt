import 'dart:ui';

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
import 'package:salat_waqt/presentation/settings/ui/icon_text_row/icon_text_row.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsPresenter presenter = locator();
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
                      isDarkMode: Get.isDarkMode,
                      onThemeChanged: (isDark) {
                        Get.changeThemeMode(
                          isDark ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                    SizedBox(height: 16.px),
                    IconTextRow(
                      theme: theme,
                      title: 'Do Not Disturb',
                      subtitle: 'Pause All Notifications',
                      svgIconPath: AppConstant.icDnd,
                      switchValue: presenter.currentUiState.doNotDisturbEnabled,
                      onSwitchChanged: (bool) {
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
                      switchValue: presenter.currentUiState.doNotDisturbEnabled,
                      onSwitchChanged: (bool) {},
                    ),
                    SizedBox(height: 16.px),
                    AnimatedCard(
                      theme: theme,
                      title: 'Juristic Method',
                      subtitle: 'Current: Hanafi',
                      svgIconPath: AppConstant.icCalculator,
                    ),
                    SizedBox(height: 16.px),

                    IconTextRow(
                      theme: theme,
                      title: 'Calculation Method',
                      subtitle: 'Current: Moonsighting Comitte...',
                      svgIconPath: AppConstant.icCalculator,
                      hasSwitch: false,
                    ),
                    SizedBox(height: 16.px),
                    IconTextRow(
                      theme: theme,
                      title: 'Time Adjustments',
                      subtitle: 'Adjust Prayer time Notification',
                      svgIconPath: AppConstant.icClock,
                      switchValue: presenter.currentUiState.doNotDisturbEnabled,
                      onSwitchChanged: (bool) {},
                    ),
                    SizedBox(height: 16.px),
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
                      title: 'Ramadan Calender Type',
                      subtitle: 'Current: Bangladesh',
                      svgIconPath: AppConstant.icIslamicCalender,
                    ),
                    SizedBox(height: 16.px),
                    IconTextRow(
                      theme: theme,
                      title: 'Hide Iftar & Sahri Time',
                      subtitle: 'Hides from homepage',
                      svgIconPath: AppConstant.icEye,
                      switchValue: presenter.currentUiState.doNotDisturbEnabled,
                      onSwitchChanged: (bool) {},
                    ),
                    SizedBox(height: 16.px),
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
                    SizedBox(height: 16.px),
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

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Preferences',
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: 16.px,
          fontFamily: AppTextStyles.inter,
          fontWeight: FontWeight.w500,
          color: context.color.cardTitleColor,
        ),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.px),
          bottomRight: Radius.circular(15.px),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.00, -1.00),
              end: const Alignment(0, 1),
              colors: [Colors.black, const Color(0x00666666)],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),
        ),
      ),
    );
  }
}
