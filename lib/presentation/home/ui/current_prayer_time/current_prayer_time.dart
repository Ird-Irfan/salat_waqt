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

class CurrentPrayerTime extends StatefulWidget {
  final ThemeData theme;

  const CurrentPrayerTime({super.key, required this.theme});

  @override
  State<CurrentPrayerTime> createState() => _CurrentPrayerTimeState();
}

class _CurrentPrayerTimeState extends State<CurrentPrayerTime> {
  late final CurrentPrayerTimePresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = locator<CurrentPrayerTimePresenter>();

    // Delay reload to avoid build phase issues
    Future.microtask(() {
      _presenter.reloadPrayerTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: _presenter,
      builder: () {
        return Container(
          height: _presenter.currentUiState.currentPrayerTimeHeight.px,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.93, 1.20),
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
                  onTap: () => _presenter.toggleCurrentPrayerTimeExpansion(),
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
                                style: widget.theme.textTheme.labelMedium
                                    ?.copyWith(
                                      fontSize: 13.px,
                                      color: context.color.cardTitleColor,
                                      fontFamily: AppTextStyles.inter,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              Text(
                                _presenter.currentUiState.currentWaqt ??
                                    '--:--',
                                style: widget.theme.textTheme.labelMedium
                                    ?.copyWith(
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
                            '${_presenter.currentUiState.currentTime} - ${_presenter.currentUiState.nextPrayerTime}',
                            style: widget.theme.textTheme.labelMedium?.copyWith(
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
                            _presenter
                                    .currentUiState
                                    .isCurrentPrayerTimeExpanded
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
                    _presenter.currentUiState.isCurrentPrayerTimeExpanded
                        ? ColumnItem(theme: widget.theme, presenter: _presenter)
                        : RowItem(theme: widget.theme, presenter: _presenter),
              ),
            ],
          ),
        );
      },
    );
  }
}
