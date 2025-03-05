import 'package:flutter/material.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class ForbiddenTime extends StatefulWidget {
  const ForbiddenTime({super.key});

  @override
  State<ForbiddenTime> createState() => _ForbiddenTimeState();
}

class _ForbiddenTimeState extends State<ForbiddenTime>
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
    _heightAnimation = Tween<double>(begin: 236, end: 400).animate(
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
      animation: _heightAnimation,
      builder: (context, child) {
        return Container(
          height: _heightAnimation.value,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2234),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
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
                      children: const [
                        Text(
                          'CURRENT WAQT • DUHUR',
                          style: TextStyle(fontSize: 12, color: Colors.white),
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
                        color: Colors.amber,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),

              if (isExpanded) ColumnItems(),
            ],
          ),
        );
      },
    );
  }
}

class ColumnItems extends StatelessWidget {
  const ColumnItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Divider(color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 16),
          Row(
            children: [
              SvgIcon(
                svgPath: AppConstant.icForbidden,
                color: Colors.red,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'After Fajr',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Until sunrise',
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SvgIcon(
                svgPath: AppConstant.icForbidden,
                color: Colors.red,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'At Noon',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'When sun at zenith',
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SvgIcon(
                svgPath: AppConstant.icForbidden,
                color: Colors.red,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'After Asr',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Until sunset',
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
            child: Divider(color: Colors.grey.withOpacity(0.2)),
          ),
          _buildPrayerRow(
            Icons.wb_sunny,
            'Dhuhr',
            '12:15 PM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacity(0.2)),
          ),
          _buildPrayerRow(
            Icons.wb_sunny,
            'Asr',
            '3:45 PM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacity(0.2)),
          ),
          _buildPrayerRow(
            Icons.wb_twilight,
            'Maghrib',
            '6:15 PM',
            Icons.notifications_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Divider(color: Colors.grey.withOpacity(0.2)),
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
