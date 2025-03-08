import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class CurrentPrayerTime extends StatefulWidget {
  final ThemeData theme;
  const CurrentPrayerTime({super.key, required this.theme});

  @override
  State<CurrentPrayerTime> createState() => _CurrentPrayerTimeState();
}

class _CurrentPrayerTimeState extends State<CurrentPrayerTime>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightAnimation = Tween<double>(begin: 236, end: 450).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return Container(
          height: _heightAnimation.value,
          // padding: const EdgeInsets.all(16),
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
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                      if (isExpanded) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    });
                  },
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
                                'DUHUR',
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
                            '12:15 PM - 02:10 PM',
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
                        turns: isExpanded ? 0.5 : 0,
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
                      isExpanded
                          ? ColumnItem(theme: theme)
                          : RowItem(theme: theme),
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
  const ColumnItem({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPrayerRow(
            AppConstant.icFajr,
            'Fajr',
            '5:45 AM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            AppConstant.icDuhur,
            'Dhuhr',
            '12:15 PM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            AppConstant.icAsr,
            'Asr',
            '3:45 PM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            AppConstant.icMaghrib,
            'Maghrib',
            '6:15 PM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            AppConstant.icIsha,
            'Isha',
            '7:45 PM',
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
  const RowItem({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPrayerTimeItem(
          name: 'FAJR',
          time: '5:45 AM',
          svgPath: AppConstant.icFajr,
          theme: theme,
        ),
        _buildPrayerTimeItem(
          name: 'DUHUR',
          time: '12:15 PM',
          svgPath: AppConstant.icDuhur,
          theme: theme,
        ),
        _buildPrayerTimeItem(
          name: 'ASR',
          time: '3:45 PM',
          svgPath: AppConstant.icAsr,
          theme: theme,
        ),
        _buildPrayerTimeItem(
          name: 'MAGHRIB',
          time: '6:15 PM',
          svgPath: AppConstant.icMaghrib,
          theme: theme,
        ),
        _buildPrayerTimeItem(
          name: 'ISHA',
          time: '7:45 PM',
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
