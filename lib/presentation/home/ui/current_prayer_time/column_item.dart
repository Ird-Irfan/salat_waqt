import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/presenter/current_prayer_time_presenter.dart';

class ColumnItem extends StatefulWidget {
  final ThemeData theme;
  final CurrentPrayerTimePresenter presenter;
  const ColumnItem({super.key, required this.theme, required this.presenter});

  @override
  State<ColumnItem> createState() => _ColumnItemState();
}

class _ColumnItemState extends State<ColumnItem> {
  @override
  void initState() {
    super.initState();
    // Delay reload to avoid build phase issues
    Future.microtask(() {
      widget.presenter.reloadPrayerTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPrayerRow(
            AppConstant.icFajr,
            'Fajr',
            widget.presenter.currentUiState.prayerTimes?['Fajr'] ?? '',
            widget.presenter.currentUiState.notificationStatus?['Fajr'] ??
                false,
            () => widget.presenter.togglePrayerNotification('Fajr'),
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
            widget.presenter.currentUiState.prayerTimes?['Dhuhr'] ?? '',
            widget.presenter.currentUiState.notificationStatus?['Dhuhr'] ??
                false,
            () => widget.presenter.togglePrayerNotification('Dhuhr'),
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
            widget.presenter.currentUiState.prayerTimes?['Asr'] ?? '',
            widget.presenter.currentUiState.notificationStatus?['Asr'] ?? false,
            () async {
              await widget.presenter.togglePrayerNotification('Asr');
              log(
                'Asr: ${widget.presenter.currentUiState.notificationStatus?['Asr']}',
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
            widget.presenter.currentUiState.prayerTimes?['Maghrib'] ?? '',
            widget.presenter.currentUiState.notificationStatus?['Maghrib'] ??
                false,
            () => widget.presenter.togglePrayerNotification('Maghrib'),
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
            widget.presenter.currentUiState.prayerTimes?['Isha'] ?? '',
            widget.presenter.currentUiState.notificationStatus?['Isha'] ??
                false,
            () => widget.presenter.togglePrayerNotification('Isha'),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgIcon(svgPath: svgPath, height: 28.px, width: 28.px),
              SizedBox(width: 10.px),
              Text(
                prayerName,
                style: widget.theme.textTheme.labelMedium?.copyWith(
                  fontSize: 16.px,
                  color: context.color.cardTitleColor,
                  fontFamily: AppTextStyles.inter,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: widget.theme.textTheme.labelMedium?.copyWith(
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
