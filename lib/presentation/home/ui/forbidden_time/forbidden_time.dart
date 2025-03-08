import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class ForbiddenTime extends StatefulWidget {
  final ThemeData theme;
  const ForbiddenTime({super.key, required this.theme});

  @override
  State<ForbiddenTime> createState() => _ForbiddenTimeState();
}

class _ForbiddenTimeState extends State<ForbiddenTime>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(20.px),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2234),
            borderRadius: BorderRadius.circular(16.px),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
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
                          'Forbidden Times',
                          style: widget.theme.textTheme.labelMedium?.copyWith(
                            fontSize: 18.px,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '12:15 PM - 02:10 PM',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: isExpanded ? 0.5 : 0,
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
                  sizeFactor: _animationController,
                  axis: Axis.vertical,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ColumnItems(theme: widget.theme),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ColumnItems extends StatelessWidget {
  final ThemeData theme;
  const ColumnItems({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        spacing: 16.px,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: Colors.grey.withOpacityInt(0.2)),
          _buildForbiddenTimeItem(
            context,
            AppConstant.icFajr,
            'After Fajr',
            'Until sunrise',
            0,
            theme,
          ),
          _buildForbiddenTimeItem(
            context,
            AppConstant.icDuhur,
            'At Noon',
            'When sun at zenith',
            1,
            theme,
          ),
          _buildForbiddenTimeItem(
            context,
            AppConstant.icAsr,
            'After Asr',
            'Until sunset',
            2,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildForbiddenTimeItem(
    BuildContext context,
    String svgPath,
    String title,
    String subtitle,
    int index,
    ThemeData theme,
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 16.px,
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
        );
      },
    );
  }
}

class ColumnItem extends StatelessWidget {
  const ColumnItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPrayerRow(
            Icons.wb_sunny_outlined,
            'Fajr',
            '5:45 AM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            Icons.wb_sunny,
            'Dhuhr',
            '12:15 PM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            Icons.wb_sunny,
            'Asr',
            '3:45 PM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            Icons.wb_twilight,
            'Maghrib',
            '6:15 PM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacityInt(0.2)),
          ),
          _buildPrayerRow(
            Icons.nightlight_round,
            'Isha',
            '7:45 PM',
            Icons.notifications_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(
    IconData icon,
    String prayerName,
    String time,
    IconData notificationIcon,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon, color: Colors.amber, size: 20),
        Text(
          prayerName,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const Spacer(),
        Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Icon(notificationIcon, color: Colors.grey, size: 20),
      ],
    );
  }
}
