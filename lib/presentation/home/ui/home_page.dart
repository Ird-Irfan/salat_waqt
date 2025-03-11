import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';
import 'package:salat_waqt/presentation/home/ui/about_us_footer/about_us_footer.dart';
import 'package:salat_waqt/presentation/home/ui/appber/appber_section.dart';
import 'package:salat_waqt/presentation/home/ui/current_prayer_time/current_prayer_time.dart';
import 'package:salat_waqt/presentation/home/ui/date_display/date_display.dart';
import 'package:salat_waqt/presentation/home/ui/forbidden_time/forbidden_time.dart';
import 'package:salat_waqt/presentation/home/ui/iftaar_timer/iftaar_time_counter.dart';
import 'package:salat_waqt/presentation/home/ui/sadaka_app_banner/sadaka_app_banner.dart';
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
                            location:
                                presenter.currentUiState.currentAddress ?? '',
                            theme: theme,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(),
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
                              arabicDate:
                                  presenter.currentUiState.arabicDate ?? '',
                              presenter: presenter,
                            ),
                            const SizedBox(height: 20),
                            // Iftar Time Counter
                            IftarTimeCounter(theme: theme),
                            const SizedBox(height: 20),
                            // Sahri & Iftar Times
                            SahriIftarTimesSection(
                              theme: theme,
                              sahriTime:
                                  presenter
                                      .currentUiState
                                      .prayerTimes?['Sehri'] ??
                                  '',
                              iftarTime:
                                  presenter
                                      .currentUiState
                                      .prayerTimes?['Iftar'] ??
                                  '',
                            ),
                            const SizedBox(height: 16),
                            // Current Prayer Time
                            CurrentPrayerTime(theme: theme),
                            const SizedBox(height: 20),
                            // Sadaqa App Banner
                            SadaqaAdsBanner(presenter: presenter, theme: theme),
                            const SizedBox(height: 20),
                            // Forbidden Times Section
                            ForbiddenTime(theme: theme),
                            const SizedBox(height: 20),
                            // About Us Footer
                            AboutUsFooter(theme: theme),
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


