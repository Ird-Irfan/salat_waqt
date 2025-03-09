import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get_it/get_it.dart';
import 'package:salat_waqt/core/config/salat_color.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/services/preferences_service.dart';
import 'package:salat_waqt/presentation/Onboarding/widgets/reusable_flash_screen.dart';
import 'package:salat_waqt/presentation/home/ui/location_screen.dart';
import 'package:salat_waqt/core/services/logger_service.dart';

class LocationPermission extends StatelessWidget {
  const LocationPermission({super.key});

  // Get the preferences service from the service locator
  PreferencesService get _preferencesService =>
      GetIt.instance<PreferencesService>();

  // Static logger to maintain const constructor
  static final LoggerService _logger = LoggerService();

  // Function to handle the location permission
  Future<void> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location services are disabled. Please enable the services',
            ),
          ),
        );
      }
      // Save that user didn't enable location services
      await _preferencesService.setLocationEnabled(false);
      if (context.mounted) {
        _navigateToNextScreen(context);
      }
      return;
    }

    // Check permission status
    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
        }
        // Save that user denied location permission
        await _preferencesService.setLocationEnabled(false);
        // Set default location
        await _preferencesService.setDefaultLocation('Dhaka');
        if (context.mounted) {
          _navigateToNextScreen(context);
        }
        return;
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are permanently denied, we cannot request permissions.',
            ),
          ),
        );
      }
      // Save that user permanently denied location permission
      await _preferencesService.setLocationEnabled(false);
      // Set default location
      await _preferencesService.setDefaultLocation('Dhaka');
      if (context.mounted) {
        _navigateToNextScreen(context);
      }
      return;
    }

    // Permission granted, try to get current position
    try {
      final position = await geo.Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      // Save location data
      await _preferencesService.saveLocationCoordinates(
        position.latitude,
        position.longitude,
      );

      _logger.i('Location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      _logger.e('Error getting location', e);
      // Save that there was an error getting location
      await _preferencesService.setLocationEnabled(false);
      // Set default location
      await _preferencesService.setDefaultLocation('Dhaka');
    }

    // Navigate to next screen
    if (context.mounted) {
      _navigateToNextScreen(context);
    }
  }

  // Navigate to the next screen
  void _navigateToNextScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LocationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReusableFlashScreen(
      // Primary section
      title: 'Location',
      titleStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: SalatColor.primaryColorDark300,
        fontFamily: AppTextStyles.inter,
      ),
      spaceBetween: 12,
      subtitle: 'Enable location permission',
      subtitleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: SalatColor.cardSubTitleColorDark,
        fontFamily: AppTextStyles.inter,
      ),

      // Background
      backgroundImagePath: AppConstant.bgflashScreen,

      // Secondary section
      secondLogoImagePath: AppConstant.locationicon,
      secondLogoWidth: 120,
      secondLogoHeight: 120,
      secondSubtitle:
          'Enable location permissions to find your local prayer times & calculate qibla directions.',
      secondSubtitleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: SalatColor.cardSubTitleColorDark,
        fontFamily: AppTextStyles.inter,
        height: 1.5,
      ),

      // Button configuration
      buttonText: 'Enable Location Permission',
      buttonGradientColors: const [
        SalatColor.primaryColorDark500,
        SalatColor.primaryColorDark600,
      ],
      buttonHeight: 55,
      buttonBorderRadius: 12,
      buttonTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: SalatColor.primaryColorDark100,
        fontFamily: AppTextStyles.inter,
      ),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 30),

      // Spacing
      primaryToSecondarySpacing: 80,
      subtitleToButtonSpacing: 40,

      // Content layout
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

      // Action
      onButtonPressed: () async {
        await _handleLocationPermission(context);
      },
    );
  }
}
