import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/constant/constants.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/custom_bottom_sheet.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';
import 'package:salat_waqt/presentation/home/presenter/forbidden_time_presenter.dart';

class ForbiddenTime extends StatelessWidget {
  final ThemeData theme;

  ForbiddenTime({super.key, required this.theme}) {
    // Initialize the presenter when widget is created
    loadPresenter(ForbiddenTimePresenter());
  }

  @override
  Widget build(BuildContext context) {
    final presenter = loadPresenter(ForbiddenTimePresenter());

    return Obx(() {
      final isInForbiddenTime = presenter.isInForbiddenTime;
      final forbiddenTimes = presenter.forbiddenTimes;
      final timeRangeDisplay = presenter.getTimeRangeDisplay();

      return AnimatedBuilder(
        animation: presenter.animationController,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(20.px),
            decoration: ShapeDecoration(
              gradient: RadialGradient(
                center: Alignment(0.93, 1.20),
                radius: 0.72,
                colors: [
                  context.color.cardGradientStart,
                  context.color.cardGradientEnd,
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.px),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  splashColor: Colors.transparent,
                  onTap: () => presenter.toggleExpanded(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgIcon(
                        svgPath: AppConstant.icForbidden,
                        color: Colors.red,
                        height: 32.px,
                        width: 32.px,
                      ),
                      SizedBox(width: 16.px),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isInForbiddenTime
                                ? 'Currently Forbidden'
                                : 'Forbidden Times',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 18.px,
                              color: context.color.cardTitleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.px),
                          Text(
                            timeRangeDisplay,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 14.px,
                              fontWeight: FontWeight.w400,
                              color: context.color.cardSubtitleColor,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        turns: presenter.isExpanded ? 0.5 : 0,
                        child: SvgPicture.asset(
                          AppConstant.icArrowDown,
                          height: 24.px,
                          width: 24.px,
                          colorFilter: ColorFilter.mode(
                            context.color.collapseBtnColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ClipRect(
                  child: SizeTransition(
                    sizeFactor: presenter.animationController,
                    axis: Axis.vertical,
                    child: FadeTransition(
                      opacity: presenter.fadeAnimation,
                      child:
                          forbiddenTimes != null && forbiddenTimes.isNotEmpty
                              ? ForbiddenTimeItems(
                                theme: theme,
                                forbiddenTimes: forbiddenTimes,
                              )
                              : Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    "Loading forbidden times...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class ForbiddenTimeItems extends StatelessWidget {
  final ThemeData theme;
  final List<Map<String, String>> forbiddenTimes;

  const ForbiddenTimeItems({
    super.key,
    required this.theme,
    required this.forbiddenTimes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            forbiddenTimes.length,
            (index) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Divider(
                    color: context.color.cardSiblingBottomBorderColor
                        .withOpacityInt(0.05),
                    height: 0.5.px,
                  ),
                ),
                InkWell(
                  onTap: () {
                    CustomBottomSheet.show(
                      context: context,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.px),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              forbiddenTimesList[index].title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: context.color.cardTitleColor,
                                fontSize: 24.px,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppTextStyles.inter,
                                letterSpacing: 0.24,
                              ),
                            ),
                            SizedBox(height: 12.px),
                            Text(
                              forbiddenTimesList[index].description,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: context.color.cardTitleColor,
                                fontSize: 16.px,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppTextStyles.inter,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: _buildForbiddenTimeItem(
                    context,
                    getIconPath(forbiddenTimes[index]['icon'] ?? 'Fajr'),
                    forbiddenTimes[index]['name'] ?? '',
                    index,
                    theme,
                    '${forbiddenTimes[index]['startTime']} - ${forbiddenTimes[index]['endTime']}',
                  ),
                ),
                SizedBox(height: 12.px),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getIconPath(String prayerName) {
    switch (prayerName) {
      case 'Morning':
        return AppConstant.icFajr;
      case 'Noon':
        return AppConstant.icDuhur;
      case 'Evening':
        return AppConstant.icAsr;
      case 'Fajr':
        return AppConstant.icFajr;
      case 'Dhuhr':
        return AppConstant.icDuhur;
      case 'Asr':
        return AppConstant.icAsr;
      default:
        return AppConstant.icFajr;
    }
  }

  Widget _buildForbiddenTimeItem(
    BuildContext context,
    String svgPath,
    String title,
    int index,
    ThemeData theme,
    String timeRange,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1.0 - value) * 20, 0),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                SvgIcon(svgPath: svgPath, height: 27.px, width: 29.px),
                SizedBox(width: 16.px),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 12.px,
                        fontWeight: FontWeight.w400,
                        color: context.color.cardTitleColor,
                      ),
                    ),
                    SizedBox(height: 6.px),
                    Text(
                      timeRange,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 16.px,
                        color: context.color.cardTitleColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppTextStyles.inter,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
