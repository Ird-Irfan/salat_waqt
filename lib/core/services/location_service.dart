import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:salat_waqt/core/services/logger_service.dart';
import 'package:salat_waqt/core/services/preferences_service.dart';
import 'package:salat_waqt/domain/usecases/get_address_from_coordinates_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_current_location_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_coordinates_from_address_usecase.dart';

class LocationService {
  final PreferencesService _preferencesService;
  final LoggerService _logger;
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final GetAddressFromCoordinatesUseCase _getAddressFromCoordinatesUseCase;
  final GetCoordinatesFromAddressUseCase _getCoordinatesFromAddressUseCase;

  // Default coordinates for Dhaka
  final double defaultLatitude = 23.8103;
  final double defaultLongitude = 90.4125;

  LocationService({
    required PreferencesService preferencesService,
    required LoggerService logger,
    required GetCurrentLocationUseCase getCurrentLocationUseCase,
    required GetAddressFromCoordinatesUseCase getAddressFromCoordinatesUseCase,
    required GetCoordinatesFromAddressUseCase getCoordinatesFromAddressUseCase,
  }) : _preferencesService = preferencesService,
       _logger = logger,
       _getCurrentLocationUseCase = getCurrentLocationUseCase,
       _getAddressFromCoordinatesUseCase = getAddressFromCoordinatesUseCase,
       _getCoordinatesFromAddressUseCase = getCoordinatesFromAddressUseCase;

  // Check if location services are enabled and request if not
  Future<bool> isLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationServiceDialog();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }
    return serviceEnabled;
  }

  // Check and request location permission
  Future<LocationPermission> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await _showPermissionExplanationDialog();
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await _showOpenSettingsDialog();
    }

    return permission;
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      return await _getCurrentLocationUseCase.execute();
    } catch (e) {
      _logger.e('Error getting current location', e);
      return null;
    }
  }

  // Get address from coordinates
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      return await _getAddressFromCoordinatesUseCase.execute(
        latitude,
        longitude,
      );
    } catch (e) {
      _logger.e('Error getting address from coordinates', e);
      return 'Dhaka'; // Default fallback
    }
  }

  // Get coordinates from address
  Future<(double, double)?> getCoordinatesFromAddress(String address) async {
    try {
      var locations = await _getCoordinatesFromAddressUseCase.execute(address);
      if (locations.isNotEmpty) {
        return (locations[0].latitude, locations[0].longitude);
      }
      return null;
    } catch (e) {
      _logger.e('Error getting coordinates from address', e);
      return null;
    }
  }

  // Save location to preferences
  Future<void> saveLocation(double latitude, double longitude) async {
    await _preferencesService.setLocationEnabled(true);
    await _preferencesService.setLatitude(latitude);
    await _preferencesService.setLongitude(longitude);
  }

  // Load saved location from preferences
  Future<(double?, double?, String?, bool)> loadSavedLocation() async {
    final locationEnabled = await _preferencesService.isLocationEnabled();

    if (locationEnabled) {
      final latitude = await _preferencesService.getLatitude();
      final longitude = await _preferencesService.getLongitude();

      if (latitude != null && longitude != null) {
        String address = await getAddressFromCoordinates(latitude, longitude);
        return (latitude, longitude, address, true);
      }
    } else {
      final String? defaultLocation =
          await _preferencesService.getDefaultLocation();

      if (defaultLocation != null && defaultLocation.isNotEmpty) {
        return (defaultLatitude, defaultLongitude, defaultLocation, false);
      }
    }

    // Default fallback
    return (defaultLatitude, defaultLongitude, 'Dhaka', false);
  }

  // Save default location
  Future<void> saveDefaultLocation(String location) async {
    await _preferencesService.setLocationEnabled(false);
    await _preferencesService.setDefaultLocation(location);
  }

  // Check if error is related to location permission
  bool isLocationPermissionError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('permission') ||
        errorString.contains('denied') ||
        errorString.contains('disabled');
  }

  // Dialog methods
  Future<void> _showLocationServiceDialog() async {
    return Get.dialog(
      AlertDialog(
        title: Text('Location Service is Off'),
        content: Text(
          'Please enable location services to get accurate prayer times for your current location.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Later')),
          TextButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openLocationSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showPermissionExplanationDialog() async {
    return Get.dialog(
      AlertDialog(
        title: Text('Location Permission Required'),
        content: Text(
          'This app needs to use your location to provide accurate prayer times for your current location.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Understood')),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showOpenSettingsDialog() async {
    return Get.dialog(
      AlertDialog(
        title: Text('Location Access is Disabled'),
        content: Text(
          'You need to give location permission from app settings. Otherwise, default location (Dhaka) will be used.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Later')),
          TextButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
