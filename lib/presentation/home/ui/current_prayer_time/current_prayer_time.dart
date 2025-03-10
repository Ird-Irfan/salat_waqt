import 'package:flutter/material.dart';
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
      ),
    );

    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Container(
          height: presenter.currentUiState.currentPrayerTimeHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF1A2234),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 16.px,
                  right: 16.px,
                  top: 16.px,
                  bottom: 10.px,
                ),
                child: InkWell(
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
                                  fontSize: 14.px,
                                  color: Colors.white,
                                  fontFamily: AppTextStyles.inter,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                presenter.currentUiState.currentWaqt ?? '',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 14.px,
                                  color: Colors.white,
                                  fontFamily: AppTextStyles.inter,
                                  fontWeight: FontWeight.w500,
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
                              color: Colors.white,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.grey.withOpacityInt(0.2)),
              SizedBox(height: 16.px),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      presenter.currentUiState.isCurrentPrayerTimeExpanded
                          ? ColumnItem(theme: theme, presenter: presenter)
                          : RowItem(theme: theme, presenter: presenter),
                ),
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
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            AppConstant.icDuhur,
            'Dhuhr',
            presenter.currentUiState.prayerTimes?['Dhuhr'] ?? '',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            AppConstant.icAsr,
            'Asr',
            presenter.currentUiState.prayerTimes?['Asr'] ?? '',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            AppConstant.icMaghrib,
            'Maghrib',
            presenter.currentUiState.prayerTimes?['Maghrib'] ?? '',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            AppConstant.icIsha,
            'Isha',
            presenter.currentUiState.prayerTimes?['Isha'] ?? '',
            Icons.notifications_outlined,
          ),
          SizedBox(height: 26.px),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(
    String svgPath,
    String prayerName,
    String time,
    IconData notificationIcon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgIcon(svgPath: svgPath, height: 26.px, width: 26.px),
          SizedBox(width: 10.px),
          Text(
            prayerName,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 16.px,
              color: Colors.white,
              fontFamily: AppTextStyles.inter,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 16.px,
              color: Colors.white,
              fontFamily: AppTextStyles.inter,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 10.px),
          SvgIcon(
            svgPath: AppConstant.icNotificationOn,
            height: 20.px,
            width: 20.px,
          ),
        ],
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  final ThemeData theme;
  final CurrentPrayerTimePresenter presenter;
  const RowItem({super.key, required this.theme, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPrayerTimeItem(
          name: 'FAJR',
          time: presenter.currentUiState.prayerTimes?['Fajr'] ?? '',
          svgPath: AppConstant.icFajr,
          theme: theme,
        ),
        _buildPrayerTimeItem(
          name: 'DUHUR',
          time: presenter.currentUiState.prayerTimes?['Dhuhr'] ?? '',
          svgPath: AppConstant.icDuhur,
          theme: theme,
        ),
        _buildPrayerTimeItem(
          name: 'ASR',
          time: presenter.currentUiState.prayerTimes?['Asr'] ?? '',
          svgPath: AppConstant.icAsr,
          theme: theme,
        ),
        _buildPrayerTimeItem(
          name: 'MAGHRIB',
          time: presenter.currentUiState.prayerTimes?['Maghrib'] ?? '',
          svgPath: AppConstant.icMaghrib,
          theme: theme,
        ),
        _buildPrayerTimeItem(
          name: 'ISHA',
          time: presenter.currentUiState.prayerTimes?['Isha'] ?? '',
          svgPath: AppConstant.icIsha,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildPrayerTimeItem({
    required String name,
    required String time,
    required String svgPath,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 12.px,
              color: Colors.white,
              fontFamily: AppTextStyles.inter,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5.px,
            ),
          ),
          SizedBox(height: 14.px),
          SvgIcon(svgPath: svgPath, height: 24.px, width: 24.px),
          SizedBox(height: 18.px),
          Text(
            time,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 10.px,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
