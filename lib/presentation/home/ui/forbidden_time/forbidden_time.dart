import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
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
            decoration: BoxDecoration(
              color:
                  isInForbiddenTime
                      ? const Color(0xFF4D1717)
                      : const Color(0xFF1A2234),
              borderRadius: BorderRadius.circular(16.px),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => presenter.toggleExpanded(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgIcon(
                        svgPath: AppConstant.icForbidden,
                        color:
                            isInForbiddenTime
                                ? Colors.red.shade300
                                : Colors.red,
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
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            timeRangeDisplay,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  isInForbiddenTime
                                      ? Colors.red.shade200
                                      : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        turns: presenter.isExpanded ? 0.5 : 0,
                        child: SvgIcon(
                          svgPath: AppConstant.icArrowDown,
                          color: Colors.white,
                          height: 24,
                          width: 24,
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
        spacing: 16.px,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: Colors.grey.withOpacityInt(0.2)),
          ...List.generate(
            forbiddenTimes.length,
            (index) => _buildForbiddenTimeItem(
              context,
              getIconPath(forbiddenTimes[index]['icon'] ?? 'Fajr'),
              forbiddenTimes[index]['name'] ?? '',
              index,
              theme,
              '${forbiddenTimes[index]['startTime']} - ${forbiddenTimes[index]['endTime']}',
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
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.0),
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
                          fontSize: 16.px,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        timeRange,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 12.px,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppTextStyles.inter,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
