import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get_it/get_it.dart';
import 'package:salat_waqt/core/config/salat_color.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/services/preferences_service.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/Onboarding/widgets/reusable_flash_screen.dart';
import 'package:salat_waqt/presentation/home/ui/home_page.dart';
import 'package:salat_waqt/core/services/logger_service.dart';

class LocationPermission extends StatefulWidget {
  const LocationPermission({super.key});

  @override
  State<LocationPermission> createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {
  bool _isLoading = false;
  String _statusMessage = '';

  // Get the preferences service from the service locator
  PreferencesService get _preferencesService =>
      GetIt.instance<PreferencesService>();

  // Static logger to maintain const constructor
  static final LoggerService _logger = LoggerService();

  // Function to handle the location permission
  Future<void> _handleLocationPermission() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking location services...';
    });

    bool serviceEnabled;
    geo.LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Location services are disabled';
        });
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
      await _preferencesService.setDefaultLocation('Dhaka');
      // Wait for a moment to show the user what happened
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _navigateToNextScreen();
      }
      return;
    }

    if (mounted) {
      setState(() {
        _statusMessage = 'Checking location permission...';
      });
    }

    // Check permission status
    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Requesting location permission...';
        });
      }

      permission = await geo.Geolocator.requestPermission();

      // Add a small delay after permission request to let the system process it
      await Future.delayed(const Duration(milliseconds: 500));

      if (permission == geo.LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _statusMessage = 'Location permission denied';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
        }
        // Save that user denied location permission
        await _preferencesService.setLocationEnabled(false);
        // Set default location
        await _preferencesService.setDefaultLocation('Dhaka');
        // Wait for a moment to show the user what happened
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _navigateToNextScreen();
        }
        return;
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Location permission permanently denied';
        });
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
      // Wait for a moment to show the user what happened
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _navigateToNextScreen();
      }
      return;
    }

    // Permission granted, try to get current position
    if (mounted) {
      setState(() {
        _statusMessage =
            'Location permission granted, fetching your location...';
      });
    }

    // Add a delay to ensure the permission has been properly processed
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Show this is going to take some time
      if (mounted) {
        setState(() {
          _statusMessage = 'Retrieving your location...';
        });
      }

      // Try to get location with a reasonable timeout
      final position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () async {
          _logger.w('Location retrieval timed out, trying with lower accuracy');
          // If high accuracy times out, try with lower accuracy
          return await geo.Geolocator.getCurrentPosition(
            desiredAccuracy: geo.LocationAccuracy.low,
            timeLimit: const Duration(seconds: 5),
          );
        },
      );

      if (mounted) {
        setState(() {
          _statusMessage = 'Location found, saving your coordinates...';
        });
      }

      // Save location data
      await _preferencesService.saveLocationCoordinates(
        position.latitude,
        position.longitude,
      );

      _logger.i('Location: ${position.latitude}, ${position.longitude}');

      if (mounted) {
        setState(() {
          _statusMessage = 'All set! Taking you to the home screen...';
        });
      }

      // Give some time for the system to process the location data
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      _logger.e('Error getting location', e);

      if (mounted) {
        setState(() {
          _statusMessage = 'Could not get your location, using default...';
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }

      // Save that there was an error getting location
      await _preferencesService.setLocationEnabled(false);
      // Set default location
      await _preferencesService.setDefaultLocation('Dhaka');

      // Wait to show the message
      await Future.delayed(const Duration(seconds: 2));
    }

    // Navigate to next screen
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _navigateToNextScreen();
    }
  }

  // Navigate to the next screen
  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReusableFlashScreen(
      // Primary section
      title: 'Location',
      titleStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: context.color.cardTitleColor,
        fontFamily: AppTextStyles.inter,
      ),
      spaceBetween: 12,
      subtitle: 'Enable location permission',
      subtitleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: context.color.cardSubtitleColor,
        fontFamily: AppTextStyles.inter,
      ),

      // Background
      backgroundImagePath:
          Theme.of(context).brightness == Brightness.dark
              ? AppConstant.appBgPngDark
              : AppConstant.appBgPngLight,

      // Secondary section
      secondLogoImagePath: AppConstant.locationicon,
      secondLogoWidth: 120,
      secondLogoHeight: 120,
      secondSubtitle:
          _isLoading
              ? _statusMessage
              : 'Enable location permissions to find your local prayer times & calculate qibla directions.',
      secondSubtitleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: context.color.cardSubtitleColor,
        fontFamily: AppTextStyles.inter,
        height: 1.5,
      ),

      // Button configuration
      buttonText: _isLoading ? 'Please Wait...' : 'Enable Location Permission',
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

      // Loading indicator
      additionalWidgets:
          _isLoading
              ? [
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    SalatColor.primaryColorDark500,
                  ),
                ),
              ]
              : null,

      // Action
      onButtonPressed:
          _isLoading
              ? null
              : () async {
                await _handleLocationPermission();
              },
    );
  }
}
