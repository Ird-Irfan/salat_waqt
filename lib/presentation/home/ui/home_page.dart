import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: PresentableWidgetBuilder(
          presenter: presenter,
          builder: () {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  flexibleSpace: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Colors.black, Color(0x00666666)],
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                          child: AppBarSection(
                            location: presenter.currentUiState.currentAddress ?? '',
                            theme: theme,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Date Display
                            DateDisplay(  
                              theme: theme,
                              englishDate:
                                  presenter.currentUiState.englishDate ?? '',
                                arabicDate: presenter.currentUiState.arabicDate ?? '', presenter: presenter,
                            ),
                            const SizedBox(height: 20),
                            // Iftar Time Counter
                            const IftarTimeCounter(),
                            const SizedBox(height: 20),
                            // Sahri & Iftar Times
                            SahriIftarTimesSection(
                              sahriTime:
                                  presenter.currentUiState.prayerTimes?['Sehri'] ??
                                  '',
                              iftarTime:
                                  presenter.currentUiState.prayerTimes?['Iftar'] ??
                                  '',
                            ),
                            const SizedBox(height: 16),
                            // Current Prayer Time
                            CurrentPrayerTime(theme: theme),
                            const SizedBox(height: 20),
                            // Sadaqa App Banner
                            SadaqaAppBanner(presenter: presenter),
                            const SizedBox(height: 20),
                            // Forbidden Times Section
                            ForbiddenTime(theme: theme),
                            const SizedBox(height: 20),
                            // About Us Footer
                            AboutUsFooter(presenter: presenter),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SadaqaAppBanner extends StatelessWidget {
  final HomePresenter presenter;
  const SadaqaAppBanner({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => presenter.launchUrls(
            'https://play.google.com/store/apps/details?id=com.barakah.app',
          ),
      child: Container(
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
      ),
    );
  }
}

class AboutUsFooter extends StatelessWidget {
  final HomePresenter presenter;
  const AboutUsFooter({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
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
      ),
    );
  }
}
