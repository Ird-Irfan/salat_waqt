import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/presentation/home/presenter/current_prayer_time_presenter.dart';

class RowItem extends StatelessWidget {
  final ThemeData theme;
  final CurrentPrayerTimePresenter presenter;
  const RowItem({super.key, required this.theme, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
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
      },
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
      padding: EdgeInsets.symmetric(horizontal: 11.px, vertical: 8.px),
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
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 10.px),
          SvgPicture.asset(svgPath, height: 28.px, width: 30.px),
          SizedBox(height: 10.px),
          Text(
            time,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 12.px,
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
