import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/common/widgets/custom_bottom_sheet.dart';
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
    final bool isSelected = true;
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
                  scrolledUnderElevation: 0,
                  flexibleSpace: ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [
                            context.color.appBarBgColor.withOpacityInt(0.01),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.black.withOpacityInt(0.1),
                          child: AppBarSection(
                            onLocationTap: () {
                              CustomBottomSheet.show(
                                context: context,
                                child: Container(
                                  child: _homeBottomContent(
                                    theme,
                                    context,
                                    isSelected,
                                  ),
                                ),
                              );
                            },
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

  Widget _homeBottomContent(
    ThemeData theme,
    BuildContext context,
    bool isSelected,
  ) {
    return Column(
      mainAxisSize:
          MainAxisSize
              .min, //  Important! Make the column only take the necessary space
      crossAxisAlignment: CrossAxisAlignment.start, // Left-align the text
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.px),
          child: Text(
            'Set Your Location',
            style: theme.textTheme.titleMedium?.copyWith(
              color: context.color.cardTitleColor,
              fontSize: 18.px,
              fontWeight: FontWeight.w500,
              fontFamily: AppTextStyles.inter,
            ),
          ),
        ), // Spacing between elements
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 10),
        //   child: CustomDivider(),
        // ),
        // Auto-detect Location
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: context.color.cardSiblingBottomBorderColor
                    .withOpacityInt(0.05),
                width: 0.5,
              ),
              bottom: BorderSide(
                color: context.color.cardSiblingBottomBorderColor
                    .withOpacityInt(0.05),
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(
                      0.2,
                    ), // Light blue background for the circle
                  ),
                  padding: const EdgeInsets.all(2),
                  child:
                      isSelected
                          ? Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: const Icon(
                              Icons.fork_right,
                              color: Colors.black,
                              size: 24,
                            ),
                          )
                          : Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                          ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  // Use Expanded to let the text take the available space
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Automatic Selection',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: context.color.cardTitleColor,
                          fontSize: 18.px,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppTextStyles.inter,
                          letterSpacing: 0.1,
                        ),
                      ),
                      SizedBox(height: 12.px),
                      Text(
                        'Dhaka, Bangladesh',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: context.color.cardSubtitleColor,
                          fontSize: 14.px,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppTextStyles.inter,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(AppConstant.icGps, width: 24, height: 24),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Manual Location Option
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ), // Circle with grey border
                ),
                padding: const EdgeInsets.all(4), //  Add a small padding
                width: 28, // Explicit width
                height: 28, // Explicit height
                //  No icon is needed here, just the circle
              ),

              const SizedBox(width: 12),
              Text(
                'Enter Manually',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.color.cardTitleColor,
                  fontSize: 16.px,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppTextStyles.inter,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Country Selection Dropdown
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(
              0xFF2D4A60,
            ), // Darker background for dropdowns
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none, // Remove the border
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ), // Adjust padding
          ),
          dropdownColor: const Color(
            0xFF2D4A60,
          ), // Set the dropdown menu's background color
          style: const TextStyle(
            color: Colors.white,
          ), // Text color inside the dropdown
          items: const [
            //  Placeholder, add actual countries later
            DropdownMenuItem(
              value: 'placeholder',
              child: Text(
                'দেশ নির্বাচন করুন',
                style: TextStyle(color: Colors.grey),
              ), //  Make this grey
            ),
          ],
          onChanged: (value) {},
          hint: const Text(
            'দেশ নির্বাচন করুন',
            style: TextStyle(color: Colors.grey),
          ), //  Make the hint text grey
        ),

        const SizedBox(height: 16),

        // City Selection Dropdown
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2D4A60),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ), // Adjust padding
          ),
          dropdownColor: const Color(0xFF2D4A60),
          style: const TextStyle(color: Colors.white),
          items: const [
            //  Placeholder, add actual cities later
            DropdownMenuItem(
              value: 'placeholder',
              child: Text(
                'শহর নির্বাচন করুন',
                style: TextStyle(color: Colors.grey),
              ), //  Make this grey
            ),
          ],
          onChanged: (value) {},
          hint: const Text(
            'শহর নির্বাচন করুন',
            style: TextStyle(color: Colors.grey),
          ), //  Make the hint grey
        ),

        const SizedBox(height: 24),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              // Wrap each button with Expanded
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAEAEA), // Light grey button
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'বাতিল',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 16), // Add spacing between buttons
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue button
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('নিশ্চিত'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
