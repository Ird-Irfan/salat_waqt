import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(context),
              _buildDateHeader(),
              _buildIftaarTimer(),
              _buildSahriIftarTimes(),
              _buildPrayerTimes(),
              _buildQuickTools(),
              _buildSadaqaBanner(),
              _buildForbiddenTimes(),
              _buildAboutUs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "Dhaka, Bangladesh",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ), // Use TextStyle
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.white, size: 24),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "15 Ramadan, 1145",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIftaarTimer() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937), // Darker shade for the card
        borderRadius: BorderRadius.circular(20),
        gradient: const RadialGradient(
          center: Alignment.center,
          radius: 0.7,
          colors: [Color(0xFF42A5F5), Color(0xFF1F2937)],
        ),
      ),
      child: const Column(
        children: [
          Text(
            "Iftaar time",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            "06:28",
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Hours", style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSahriIftarTimes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeCard("Sahri Last Time", "04:15 AM", Icons.nights_stay),
          _buildTimeCard("Iftaar Last Time", "04:15 AM", Icons.wb_sunny),
        ],
      ),
    );
  }

  Widget _buildTimeCard(String title, String time, IconData icon) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937), // Darker shade for the card
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimes() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current Waqt • DuHUR",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              Icon(Icons.notifications, size: 20, color: Colors.yellow),
            ],
          ),
          const Text(
            "12:15 PM - 02:10 PM",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrayerTimeItem("Fajar", "05:45", Icons.wb_twilight),
              _buildPrayerTimeItem("Duhur", "12:45", Icons.wb_sunny),
              _buildPrayerTimeItem("Asr", "04:45", Icons.cloud),
              _buildPrayerTimeItem("Magrib", "06:45", Icons.nights_stay),
              _buildPrayerTimeItem("Isha", "07:45", Icons.nightlight_round),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeItem(String name, String time, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                name == "Duhur"
                    ? const Color(0xFF1F2937)
                    : Colors.transparent, // Highlight Duhur
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: name == "Duhur" ? Colors.yellow : Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            color: name == "Duhur" ? Colors.yellow : Colors.white,
            fontSize: 12,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: name == "Duhur" ? Colors.yellow : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTools() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Tools",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToolItem(
                "Qibla Compass",
                "90° altitude",
                Icons.explore_outlined,
                true,
              ),
              _buildToolItem(
                "Salat Tracker",
                "60% Completed",
                Icons.check_circle,
                false,
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToolItem(
                "Mosque Finder",
                "4 Found Nearby",
                Icons.location_on,
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(
    String title,
    String subtitle,
    IconData icon,
    bool showArrow,
  ) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            // Use Stack to overlay the arrow
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.green, size: 24),
              ),
              if (showArrow) // Conditionally show the arrow
                Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.rotate(
                    angle:
                        45 *
                        (3.141592653589793 / 180), // Convert degrees to radians
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSadaqaBanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937), // Darker shade for the card
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text(
                  "সাদাকাহ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ), // Use TextStyle
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Looking “Need a trusted spot for",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "your sadaqa?”",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                textStyle: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Explore Sadaqa App", style: TextStyle(fontSize: 12)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForbiddenTimes() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red, // Red circle
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                "Forbidden Times",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_upward, size: 18, color: Colors.white),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Today For Salah",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildForbiddenTimeItem("Morning", "06:24 - 05:39", Icons.wb_sunny),
          const SizedBox(height: 8),
          _buildForbiddenTimeItem("Noon", "12:08 - 12:15", Icons.wb_sunny),
          const SizedBox(height: 8),
          _buildForbiddenTimeItem("Evening", "05:43 - 05:58", Icons.cloud),
        ],
      ),
    );
  }

  Widget _buildForbiddenTimeItem(
    String period,
    String timeRange,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(
          period,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          timeRange,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.info_outline, size: 14, color: Colors.white),
      ],
    );
  }

  Widget _buildAboutUs() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.info, size: 24, color: Colors.orange),
          SizedBox(width: 8),
          Text(
            "About Us",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          Text(
            "www.irdfoundation.com",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
