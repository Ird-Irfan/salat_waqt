import 'package:flutter/material.dart';
import 'package:salat_waqt/presentation/home/ui/appber/appber_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 16),
                // Location and notification bar
                const AppBarSection(),
                const SizedBox(height: 16),
                // Date Display
                const DateDisplay(),
                const SizedBox(height: 20),
                // Iftar Time Counter
                const IftarTimeCounter(),
                const SizedBox(height: 20),
                // Sahri & Iftar Times
                const SahriIftarTimesSection(),
                const SizedBox(height: 16),
                // Current Prayer Time
                const CurrentPrayerTime(),
                const SizedBox(height: 16),
                // Prayer Times for Day
                const PrayerTimesRow(),
                const SizedBox(height: 20),
                // Quick Tools Section
                const QuickToolsSection(),
                const SizedBox(height: 20),
                // Sadaqa App Banner
                const SadaqaAppBanner(),
                const SizedBox(height: 20),
                // Forbidden Times Section
                const ForbiddenTimesSection(),
                const SizedBox(height: 20),
                // About Us Footer
                const AboutUsFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateDisplay extends StatelessWidget {
  const DateDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
          Column(
            children: const [
              Text(
                '15 Ramadan, 1445',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                '16 March 2025',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
        ],
      ),
    );
  }
}

class IftarTimeCounter extends StatelessWidget {
  const IftarTimeCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 180,
            width: 180,
            child: CircularProgressIndicator(
              value: 0.65,
              strokeWidth: 8,
              backgroundColor: Colors.grey.shade800,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF2196F3),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Iftaar time',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 8),
              Text(
                '06:28',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2196F3),
                ),
              ),
              Text(
                'Hours',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SahriIftarTimesSection extends StatelessWidget {
  const SahriIftarTimesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: TimeInfoCard(
            title: 'SAHRI LAST TIME',
            time: '04:15 AM',
            icon: Icons.nightlight_outlined,
            showWeatherIcon: true,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: TimeInfoCard(
            title: 'IFTAAR LAST TIME',
            time: '04:15 AM',
            icon: Icons.wb_sunny_outlined,
            showWeatherIcon: false,
          ),
        ),
      ],
    );
  }
}

class TimeInfoCard extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final bool showWeatherIcon;

  const TimeInfoCard({
    Key? key,
    required this.title,
    required this.time,
    required this.icon,
    required this.showWeatherIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: showWeatherIcon ? Colors.amber : Colors.orange,
                size: 18,
              ),
              if (showWeatherIcon)
                const Icon(
                  Icons.cloud_outlined,
                  color: Colors.white54,
                  size: 18,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CurrentPrayerTime extends StatelessWidget {
  const CurrentPrayerTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'CURRENT WAQT • DUHUR',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                '12:15 PM - 02:10 PM',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Icon(Icons.notifications, color: Colors.amber),
        ],
      ),
    );
  }
}

class PrayerTimesRow extends StatelessWidget {
  const PrayerTimesRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        children: const [
          Expanded(
            child: PrayerTimeItem(
              name: 'FAJR',
              time: '05:45',
              icon: Icons.wb_sunny_outlined,
              isActive: false,
            ),
          ),
          Expanded(
            child: PrayerTimeItem(
              name: 'DUHUR',
              time: '12:45',
              icon: Icons.wb_sunny_outlined,
              isActive: true,
            ),
          ),
          Expanded(
            child: PrayerTimeItem(
              name: 'ASR',
              time: '04:45',
              icon: Icons.wb_sunny_outlined,
              isActive: false,
            ),
          ),
          Expanded(
            child: PrayerTimeItem(
              name: 'MAGRIB',
              time: '06:45',
              icon: Icons.nightlight_outlined,
              isActive: false,
            ),
          ),
          Expanded(
            child: PrayerTimeItem(
              name: 'ISHA',
              time: '07:45',
              icon: Icons.nightlight_outlined,
              isActive: false,
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerTimeItem extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isActive;

  const PrayerTimeItem({
    Key? key,
    required this.name,
    required this.time,
    required this.icon,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E3A8A) : const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.amber, size: 20),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.white70 : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickToolsSection extends StatelessWidget {
  const QuickToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Tools',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2234),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.lime],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.compass_calibration_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Qibla Compass', style: TextStyle(fontSize: 13)),
                    const Text(
                      '90° altitude',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2234),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF1E88E5), Color(0xFF1976D2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.track_changes,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Salat Tracker',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '60% Completed',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2234),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.amber, Colors.orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.mosque_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Mosque Finder',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '4 Found Nearby',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SadaqaAppBanner extends StatelessWidget {
  const SadaqaAppBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF006A4E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'সা',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Looking "Need a trusted spot for your sadaqa?"',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Text(
                      'Explore Sadaqa App',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: Colors.teal),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ForbiddenTimesSection extends StatelessWidget {
  const ForbiddenTimesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.do_not_disturb, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Forbidden Times',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                'Today For Salah',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Icon(Icons.expand_more),
            ],
          ),
          const SizedBox(height: 16),
          buildForbiddenTimeRow(
            'MORNING',
            '06:24 - 05:39',
            Icons.wb_sunny_outlined,
          ),
          const SizedBox(height: 12),
          buildForbiddenTimeRow(
            'NOON',
            '12:08 - 12:15',
            Icons.wb_sunny_outlined,
          ),
          const SizedBox(height: 12),
          buildForbiddenTimeRow(
            'EVENING',
            '05:43 - 05:58',
            Icons.wb_sunny_outlined,
          ),
        ],
      ),
    );
  }

  Widget buildForbiddenTimeRow(String title, String time, IconData icon) {
    return Row(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            const Icon(Icons.cloud_outlined, size: 16, color: Colors.grey),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              time,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(width: 8),
        const Icon(Icons.info_outline, size: 16, color: Colors.grey),
      ],
    );
  }
}

class AboutUsFooter extends StatelessWidget {
  const AboutUsFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'About Us',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                'www.irfoundation.com',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
