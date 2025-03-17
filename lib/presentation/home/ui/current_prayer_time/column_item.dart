import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/presenter/current_prayer_time_presenter.dart';

class ColumnItem extends StatelessWidget {
  final ThemeData theme;
  final CurrentPrayerTimePresenter presenter;
  const ColumnItem({super.key, required this.theme, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPrayerRow(
            AppConstant.icFajr,
            'Fajr',
            presenter.currentUiState.prayerTimes?['Fajr'] ?? '',
            presenter.currentUiState.notificationStatus?['Fajr'] ?? false,
            () => presenter.togglePrayerNotification('Fajr'),
          ),
          Divider(
            color: context.color.cardSiblingBottomBorderColor.withOpacityInt(
              0.05,
            ),
          ),
          _buildPrayerRow(
            AppConstant.icDuhur,
            'Dhuhr',
            presenter.currentUiState.prayerTimes?['Dhuhr'] ?? '',
            presenter.currentUiState.notificationStatus?['Dhuhr'] ?? false,
            () => presenter.togglePrayerNotification('Dhuhr'),
          ),
          Divider(
            color: context.color.cardSiblingBottomBorderColor.withOpacityInt(
              0.05,
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
          Divider(
            color: context.color.cardSiblingBottomBorderColor.withOpacityInt(
              0.05,
            ),
          ),
          _buildPrayerRow(
            AppConstant.icMaghrib,
            'Maghrib',
            presenter.currentUiState.prayerTimes?['Maghrib'] ?? '',
            presenter.currentUiState.notificationStatus?['Maghrib'] ?? false,
            () => presenter.togglePrayerNotification('Maghrib'),
          ),
          Divider(
            color: context.color.cardSiblingBottomBorderColor.withOpacityInt(
              0.05,
            ),
          ),
          _buildPrayerRow(
            AppConstant.icIsha,
            'Isha',
            presenter.currentUiState.prayerTimes?['Isha'] ?? '',
            presenter.currentUiState.notificationStatus?['Isha'] ?? false,
            () => presenter.togglePrayerNotification('Isha'),
          ),
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
          padding: EdgeInsets.all(16),
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
