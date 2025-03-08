import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
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
                  spacing: 32.px,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Display
                    DateDisplay(theme: theme),
                    // Iftar Time Counter
                    const IftarTimeCounter(),
                    // Sahri & Iftar Times
                    SahriIftarTimesSection(theme: theme),
                    // Current Prayer Time
                    CurrentPrayerTime(theme: theme),
                    // Sadaqa App Banner
                    SadaqaAppBanner(theme: theme),
                    // Forbidden Times Section
                    ForbiddenTime(theme: theme),
                    // About Us Footer
                    AboutUsFooter(theme: theme),

                    SizedBox(height: 40.px),
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
