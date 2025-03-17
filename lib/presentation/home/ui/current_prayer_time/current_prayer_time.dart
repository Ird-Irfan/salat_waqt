import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/presenter/current_prayer_time_presenter.dart';
import 'package:salat_waqt/presentation/home/ui/current_prayer_time/column_item.dart';
import 'package:salat_waqt/presentation/home/ui/current_prayer_time/row_item.dart';

class CurrentPrayerTime extends StatelessWidget {
  final ThemeData theme;
  const CurrentPrayerTime({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    // Use the globally registered singleton instance
    final CurrentPrayerTimePresenter presenter =
        locator<CurrentPrayerTimePresenter>();

    // Force reload prayer times when this widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      presenter.reloadPrayerTimes();
    });

    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Container(
          height: presenter.currentUiState.currentPrayerTimeHeight.px,
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
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
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
