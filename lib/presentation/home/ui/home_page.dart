import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';
import 'package:salat_waqt/presentation/home/ui/about_us_footer/about_us_footer.dart';
import 'package:salat_waqt/presentation/home/ui/appber/appber_section.dart';
import 'package:salat_waqt/presentation/home/ui/current_prayer_time/current_prayer_time.dart';
import 'package:salat_waqt/presentation/home/ui/date_display/date_display.dart';
import 'package:salat_waqt/presentation/home/ui/forbidden_time/forbidden_time.dart';
import 'package:salat_waqt/presentation/home/ui/iftaar_timer/iftaar_time_counter.dart';
import 'package:salat_waqt/presentation/home/ui/sadaka_app_banner/sadaka_app_banner.dart';
import 'package:salat_waqt/presentation/home/ui/sahri_Iftaar_time_section/sahri_iftar_times_section.dart';
import 'package:salat_waqt/presentation/home/ui/set_location_bottom_sheet/set_location_bottom_sheet.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_presenter.dart';

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
        getCountriesUseCase: locator(),
      ),
    );
    final SettingsPresenter settingsPresenter = locator<SettingsPresenter>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.px),
          child: ClipRRect(
            child: HomeAppBar( theme: theme),
          ),
        ),
        body: PresentableWidgetBuilder(
          presenter: presenter,
          builder: () {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        spacing: 32.px,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Date Display
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.px),
                            child: DateDisplay(
                              theme: theme,
                            ),
                          ),
                          // Iftar Time Counter - Only show if hideIftaarTimeEnabled is false
                          if (!settingsPresenter.currentUiState.hideIftaarTimeEnabled)
                            IftarTimeCounter(theme: theme),
                          // Sahri & Iftar Times - Only show if hideIftaarTimeEnabled is false
                          if (!settingsPresenter.currentUiState.hideIftaarTimeEnabled)
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
                          // Current Prayer Time
                          CurrentPrayerTime(theme: theme),
                          // Sadaqa App Banner
                          SadaqaAdsBanner(presenter: presenter, theme: theme),
                          // Forbidden Times Section
                          ForbiddenTime(theme: theme),
                          // About Us Footer
                          AboutUsFooter(theme: theme),
                          SizedBox(height: 20.px),
                        ],
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

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.50, 0.00),
              end: Alignment(0.50, 1.00),
              colors: [
                context.color.appBarBgColor.withOpacityInt(0.2),
                context.color.appBarBgColor.withOpacityInt(0.0),
              ],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBarSection(
              onLocationTap: () {
                Get.bottomSheet(SetLocationBottomSheet() as Widget);
              },
              theme: theme,
            ),
          ),
        );
     
  }
}
