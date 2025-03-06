import 'package:flutter/material.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class CurrentPrayerTime extends StatefulWidget {
  const CurrentPrayerTime({super.key});

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
              Divider(color: Colors.grey.withOpacity(0.2)),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isExpanded ? const ColumnItem() : const RowItem(),
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

class RowItem extends StatelessWidget {
  const RowItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPrayerTimeItem(
          name: 'FAJR',
          time: '5:45 AM',
          icon: Icons.wb_sunny_outlined,
        ),
        _buildPrayerTimeItem(
          name: 'FAJR',
          time: '5:45 AM',
          icon: Icons.wb_sunny_outlined,
        ),
        _buildPrayerTimeItem(
          name: 'FAJR',
          time: '5:45 AM',
          icon: Icons.wb_sunny_outlined,
        ),
        _buildPrayerTimeItem(
          name: 'FAJR',
          time: '5:45 AM',
          icon: Icons.wb_sunny_outlined,
        ),
        _buildPrayerTimeItem(
          name: 'FAJR',
          time: '5:45 AM',
          icon: Icons.wb_sunny_outlined,
        ),
      ],
    );
  }

  Widget _buildPrayerTimeItem({
    required String name,
    required String time,
    required IconData icon,
  }) {
    return SizedBox(
      width: 50,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: const TextStyle(fontSize: 12, color: Colors.white)),
          Icon(icon, color: Colors.white, size: 24),
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}
