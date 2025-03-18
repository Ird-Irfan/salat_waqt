import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';

class DateDisplay extends StatelessWidget {
  final ThemeData theme;
  const DateDisplay({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final HomePresenter presenter = loadPresenter(
      HomePresenter(
        locationService: locator(),
        prayerTimeService: locator(),
        dateService: locator(),
        timerService: locator(),
        preferencesService: locator(),
        logger: locator(),
      ),
    );
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Container(
          padding: EdgeInsets.all(20.px),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.px),
            ),
            gradient: RadialGradient(
              center: Alignment(0.97, -1.20),
              radius: 1,
              colors: [
                context.color.cardGradientEnd,
                context.color.cardGradientStart,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.px),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () {
                    presenter.previousDate();
                  },
                  child: SvgIcon(
                    svgPath: AppConstant.icArrowLeft,
                    width: 24.px,
                    height: 24.px,
                    color: context.color.cardTitleColor,
                  ),
                ),
                InkWell(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            datePickerTheme: DatePickerThemeData(
                              backgroundColor: context.color.appBarBgColor,
                              dayForegroundColor: WidgetStateProperty.all(
                                Colors.amberAccent,
                              ),
                              dayOverlayColor: WidgetStateProperty.all(
                                Colors.amberAccent,
                              ),
                              yearForegroundColor: WidgetStateProperty.all(
                                Colors.amberAccent,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        presenter.selectDate(selectedDate);
                      }
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        presenter.currentUiState.arabicDate ?? '',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: context.color.cardTitleColor,
                          fontSize: 18.px,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppTextStyles.inter,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        presenter.currentUiState.englishDate ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: context.color.cardSubtitleColor,
                          fontSize: 14.px,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppTextStyles.inter,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () {
                    presenter.nextDate();
                  },
                  child: SvgIcon(
                    svgPath: AppConstant.icArrowRight,
                    width: 24.px,
                    height: 24.px,
                    color: context.color.cardTitleColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
