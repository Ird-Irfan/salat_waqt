import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/presenter/current_prayer_time_presenter.dart';

class CurrentPrayerTime extends StatelessWidget {
  final ThemeData theme;
  const CurrentPrayerTime({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final CurrentPrayerTimePresenter presenter = loadPresenter(
      CurrentPrayerTimePresenter(
        locationService: locator(),
        prayerTimeService: locator(),
        timerService: locator(),
        logger: locator(),
        notificationService: locator(),
      ),
    );

    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Container(
          height: presenter.currentUiState.currentPrayerTimeHeight,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.93, 1.20),
              radius: 0.72,
              colors: [
                context.color.cardGradientStart,
                context.color.cardGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(16.px),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20.px,
                  right: 28.px,
                  top: 20.px,
                  bottom: 12.px,
                ),
                child: InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () => presenter.toggleCurrentPrayerTimeExpansion(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'CURRENT WAQT • ',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 13.px,
                                  color: context.color.cardTitleColor,
                                  fontFamily: AppTextStyles.inter,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                presenter.currentUiState.currentWaqt ?? '--:--',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 14.px,
                                  color: context.color.cardTitleColor,
                                  fontFamily: AppTextStyles.inter,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.px),
                          Text(
                            '${presenter.currentUiState.currentTime} - ${presenter.currentUiState.nextPrayerTime}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 18.px,
                              fontWeight: FontWeight.w500,
                              color: context.color.cardTitleColor,
                              fontFamily: AppTextStyles.inter,
                            ),
                          ),
                        ],
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        turns:
                            presenter.currentUiState.isCurrentPrayerTimeExpanded
                                ? 0.5
                                : 0,
                        child: SvgIcon(
                          svgPath: AppConstant.icArrowDown,
                          height: 24.px,
                          width: 24.px,
                          color: context.color.cardTitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0.1.px,
                color: context.color.cardSiblingBottomBorderColor
                    .withOpacityInt(0.05),
              ),
              SizedBox(height: 16.px),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child:
                    presenter.currentUiState.isCurrentPrayerTimeExpanded
                        ? ColumnItem(theme: theme, presenter: presenter)
                        : RowItem(theme: theme, presenter: presenter),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ColumnItem extends StatelessWidget {
  final ThemeData theme;
  final CurrentPrayerTimePresenter presenter;
  const ColumnItem({super.key, required this.theme, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPrayerRow(
            AppConstant.icFajr,
            'Fajr',
            presenter.currentUiState.prayerTimes?['Fajr'] ?? '',
            presenter.currentUiState.notificationStatus?['Fajr'] ?? false,
            () => presenter.togglePrayerNotification('Fajr'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: context.color.cardSiblingBottomBorderColor.withOpacityInt(
                0.05,
              ),
            ),
          ),
          _buildPrayerRow(
            AppConstant.icDuhur,
            'Dhuhr',
            presenter.currentUiState.prayerTimes?['Dhuhr'] ?? '',
            presenter.currentUiState.notificationStatus?['Dhuhr'] ?? false,
            () => presenter.togglePrayerNotification('Dhuhr'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: context.color.cardSiblingBottomBorderColor.withOpacityInt(
                0.05,
              ),
            ),
          ),
          _buildPrayerRow(
            AppConstant.icAsr,
            'Asr',
            presenter.currentUiState.prayerTimes?['Asr'] ?? '',
            presenter.currentUiState.notificationStatus?['Asr'] ?? false,
            () async {
              await presenter.togglePrayerNotification('Asr');
              log(
                'Asr: ${presenter.currentUiState.notificationStatus?['Asr']}',
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: context.color.cardSiblingBottomBorderColor.withOpacityInt(
                0.05,
              ),
            ),
          ),
          _buildPrayerRow(
            AppConstant.icMaghrib,
            'Maghrib',
            presenter.currentUiState.prayerTimes?['Maghrib'] ?? '',
            presenter.currentUiState.notificationStatus?['Maghrib'] ?? false,
            () => presenter.togglePrayerNotification('Maghrib'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: context.color.cardSiblingBottomBorderColor.withOpacityInt(
                0.05,
              ),
            ),
          ),
          _buildPrayerRow(
            AppConstant.icIsha,
            'Isha',
            presenter.currentUiState.prayerTimes?['Isha'] ?? '',
            presenter.currentUiState.notificationStatus?['Isha'] ?? false,
            () => presenter.togglePrayerNotification('Isha'),
          ),
          // SizedBox(height: 26.px),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(
    String svgPath,
    String prayerName,
    String time,
    bool isNotificationEnabled,
    VoidCallback onNotificationTap,
  ) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgIcon(svgPath: svgPath, height: 28.px, width: 28.px),
              SizedBox(width: 10.px),
              Text(
                prayerName,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 16.px,
                  color: context.color.cardTitleColor,
                  fontFamily: AppTextStyles.inter,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 16.px,
                  color: context.color.cardTitleColor,
                  fontFamily: AppTextStyles.inter,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 12.px),
              InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                splashColor: Colors.transparent,
                onTap: onNotificationTap,
                child: SvgPicture.asset(
                  isNotificationEnabled
                      ? AppConstant.icNotificationOn
                      : AppConstant.icNotificationOff,
                  height: 24.px,
                  width: 21.px,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RowItem extends StatelessWidget {
  final ThemeData theme;
  final CurrentPrayerTimePresenter presenter;
  const RowItem({super.key, required this.theme, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPrayerTimeItem(
            name: 'FAJR',
            time: presenter.currentUiState.prayerTimes?['Fajr'] ?? '',
            svgPath: AppConstant.icFajr,
            theme: theme,
            context: context,
          ),
          _buildPrayerTimeItem(
            name: 'DUHUR',
            time: presenter.currentUiState.prayerTimes?['Dhuhr'] ?? '',
            svgPath: AppConstant.icDuhur,
            theme: theme,
            context: context,
          ),
          _buildPrayerTimeItem(
            name: 'ASR',
            time: presenter.currentUiState.prayerTimes?['Asr'] ?? '',
            svgPath: AppConstant.icAsr,
            theme: theme,
            context: context,
          ),
          _buildPrayerTimeItem(
            name: 'MAGHRIB',
            time: presenter.currentUiState.prayerTimes?['Maghrib'] ?? '',
            svgPath: AppConstant.icMaghrib,
            theme: theme,
            context: context,
          ),
          _buildPrayerTimeItem(
            name: 'ISHA',
            time: presenter.currentUiState.prayerTimes?['Isha'] ?? '',
            svgPath: AppConstant.icIsha,
            theme: theme,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeItem({
    required String name,
    required String time,
    required String svgPath,
    required ThemeData theme,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.all(8.px),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 12.px,
              color: context.color.cardSubtitleColor,
              fontFamily: AppTextStyles.inter,
              fontWeight: FontWeight.w400,
              // letterSpacing: 1.5.px,
            ),
          ),
          SizedBox(height: 10.px),
          SvgIcon(svgPath: svgPath, height: 22.px, width: 22.px),
          SizedBox(height: 12.px),
          Text(
            time,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 13.px,
              color: context.color.cardTitleColor,
              fontFamily: AppTextStyles.inter,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
