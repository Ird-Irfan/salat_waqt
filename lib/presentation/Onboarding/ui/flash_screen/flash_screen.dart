import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/presentation/Onboarding/presenter/flash_screen_presenter.dart';
import 'package:salat_waqt/presentation/Onboarding/ui/location_permission/location_permission.dart';
import 'package:salat_waqt/presentation/Onboarding/widgets/reusable_flash_screen.dart';
import 'package:salat_waqt/presentation/home/ui/home_page.dart';

class FlashScreen extends StatelessWidget {
  const FlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize presenter using Get
    final presenter = loadPresenter(FlashScreenPresenter());

    // Listen to changes in UI state and navigate when needed
    ever(presenter.uiState, (state) {
      if (state.shouldNavigate) {
        if (state.skipToHome) {
          Timer(const Duration(milliseconds: 500), () {
            // Navigate directly to home screen if not first run
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          });
        } else {
          // Normal flow - go to location permission
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LocationPermission()),
          );
        }
      }
    });

    return ReusableFlashScreen(
      backgroundImagePath: 'assets/images/bg_flash_screen.png',
      logoImagePath: AppConstant.flashScreenlogo,
      title: 'Muslim Prayer Time',
      subtitle: 'IRD Foundation',
      // Add a loading indicator at the bottom
      additionalWidgets: const [
        SizedBox(height: 50),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }
}
