import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/presentation/home/ui/appber/appber_section.dart';
import 'package:salat_waqt/presentation/home/ui/current_prayer_time/current_prayer_time.dart';
import 'package:salat_waqt/presentation/home/ui/date_display/date_display.dart';
import 'package:salat_waqt/presentation/home/ui/forbidden_time/forbidden_time.dart';
import 'package:salat_waqt/presentation/home/ui/iftaar_timer/iftaar_time_counter.dart';
import 'package:salat_waqt/presentation/home/ui/sahri_Iftaar_time_section/sahri_iftar_times_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBarSection(location: 'Dhaka, Bangladesh'),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppConstant.appBg),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Display
                    DateDisplay(theme: theme),
                    SizedBox(height: 12.px),
                    // Iftar Time Counter
                    const IftarTimeCounter(),
                    // Sahri & Iftar Times
                    SahriIftarTimesSection(theme: theme),
                    // Current Prayer Time
                    CurrentPrayerTime(theme: theme),
                    // Sadaqa App Banner
                    const SadaqaAppBanner(),
                    // Forbidden Times Section
                    const ForbiddenTime(),
                    // About Us Footer
                    const AboutUsFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SadaqaAppBanner extends StatelessWidget {
  const SadaqaAppBanner({super.key});

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

class AboutUsFooter extends StatelessWidget {
  const AboutUsFooter({super.key});

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
