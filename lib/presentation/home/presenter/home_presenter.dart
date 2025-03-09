import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/services/date_service.dart';
import 'package:salat_waqt/core/services/location_service.dart';
import 'package:salat_waqt/core/services/logger_service.dart';
import 'package:salat_waqt/core/services/prayer_time_service.dart';
import 'package:salat_waqt/core/services/preferences_service.dart';
import 'package:salat_waqt/core/services/timer_service.dart';
import 'package:salat_waqt/presentation/home/presenter/home_ui_state.dart';

class HomePresenter extends BasePresenter<HomeUiState> {
  // State management
  final Obs<HomeUiState> uiState = Obs(HomeUiState.empty());
  HomeUiState get currentUiState => uiState.value;

  // Timer for updating remaining time
  Timer? _timer;

  // Services
  final LocationService _locationService;
  final PrayerTimeService _prayerTimeService;
  final DateService _dateService;
  final TimerService _timerService;
  final LoggerService _logger;

  // Constructor
  HomePresenter({
    required LocationService locationService,
    required PrayerTimeService prayerTimeService,
    required DateService dateService,
    required TimerService timerService,
    required PreferencesService preferencesService,
    required LoggerService logger,
  }) : _locationService = locationService,
       _prayerTimeService = prayerTimeService,
       _dateService = dateService,
       _timerService = timerService,
       _logger = logger;

  // Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _timerService.stopTimer();
    super.onClose();
  }

  // Initialize data
  Future<void> _initializeData() async {
    _updateDates();
    await _loadSavedLocation();
    _startTimer();
  }

  // Update dates (English and Hijri)
  void _updateDates() {
    uiState.value = uiState.value.copyWith(
      englishDate: _dateService.getEnglishDate(),
      arabicDate: _dateService.getArabicDate(),
    );
  }

  // Start timer to update remaining time
  void _startTimer() {
    _timerService.startPeriodicTimer(_updateRemainingTime);
  }

  // Update the remaining time until next prayer
  void _updateRemainingTime() {
    if (currentUiState.prayerTimes == null) return;

    try {
      var (nextPrayerName, remainingTime, progressValue) = _prayerTimeService
          .calculateNextPrayer(
            Map<String, String>.from(currentUiState.prayerTimes!),
          );

      uiState.value = uiState.value.copyWith(
        nextPrayerName: nextPrayerName,
        remainingTime: remainingTime,
        progressValue: progressValue,
      );
    } catch (e) {
      _logger.e('Error updating remaining time', e);
    }
  }

  // Public methods
  // Check and request location permission if needed
  Future<void> checkAndRequestLocationPermission() async {
    toggleLoading(loading: true);
    try {
      // Check if location service is enabled
      if (!await _locationService.isLocationServiceEnabled()) {
        _loadDefaultLocation('Location service is turned off');
        return;
      }

      // Check location permission
      final permission = await _locationService.checkAndRequestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _loadDefaultLocation('Location permission was not granted');
        return;
      }

      // Permission granted, load current location
      uiState.value = uiState.value.copyWith(locationPermissionGranted: true);
      await _loadCurrentLocation();
    } catch (e) {
      _logger.e('Error during location permission check', e);
      _loadDefaultLocation('A problem occurred: ${e.toString()}');
    } finally {
      toggleLoading(loading: false);
    }
  }

  // Change location based on address
  Future<void> changeLocation(String address) async {
    toggleLoading(loading: true);
    try {
      final coordinates = await _locationService.getCoordinatesFromAddress(
        address,
      );
      if (coordinates != null) {
        final (latitude, longitude) = coordinates;
        uiState.value = uiState.value.copyWith(currentAddress: address);
        await _loadPrayerTimes(latitude, longitude);
      } else {
        throw Exception('Could not find coordinates for address');
      }
    } catch (e) {
      _logger.e('Error changing location', e);
      Get.snackbar(
        'Error',
        'Failed to change location.',
        backgroundColor: Colors.red,
      );
      _loadDefaultLocation('Failed to change location');
    } finally {
      toggleLoading(loading: false);
    }
  }

  // BasePresenter overrides
  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = uiState.value.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = uiState.value.copyWith(isLoading: loading);
  }

  // Private methods
  // Load saved location from preferences
  Future<void> _loadSavedLocation() async {
    toggleLoading(loading: true);
    try {
      final (latitude, longitude, address, locationPermissionGranted) =
          await _locationService.loadSavedLocation();

      if (latitude != null && longitude != null) {
        uiState.value = uiState.value.copyWith(
          currentAddress: address,
          locationPermissionGranted: locationPermissionGranted,
        );

        await _loadPrayerTimes(latitude, longitude);
      } else {
        _loadDefaultLocation('No saved location found');
      }
    } catch (e) {
      _logger.e('Error loading saved location', e);
      _loadDefaultLocation('Error loading saved location');
    } finally {
      toggleLoading(loading: false);
    }
  }

  // Load current location using GPS
  Future<void> _loadCurrentLocation() async {
    toggleLoading(loading: true);
    try {
      final position = await _locationService.getCurrentLocation();
      if (position == null) {
        throw Exception('Could not get current location');
      }

      final address = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Save to preferences
      await _locationService.saveLocation(
        position.latitude,
        position.longitude,
      );

      uiState.value = uiState.value.copyWith(currentAddress: address);
      await _loadPrayerTimes(position.latitude, position.longitude);
    } catch (e) {
      _logger.e('Error loading current location', e);
      if (_locationService.isLocationPermissionError(e)) {
        _loadDefaultLocation('Location permission error');
      } else {
        Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
        _loadDefaultLocation('Error getting location');
      }
    } finally {
      toggleLoading(loading: false);
    }
  }

  // Load prayer times for specific coordinates
  Future<void> _loadPrayerTimes(double latitude, double longitude) async {
    uiState.value = uiState.value.copyWith(
      loadingPrayerTimes: true,
      prayerTimesError: null,
    );

    try {
      var times = await _prayerTimeService.loadPrayerTimes(latitude, longitude);
      if (times == null) {
        throw Exception('Failed to load prayer times');
      }

      uiState.value = uiState.value.copyWith(
        prayerTimes: times,
        loadingPrayerTimes: false,
        prayerTimesError: null,
      );

      // Update the remaining time after loading prayer times
      _updateRemainingTime();
    } catch (e) {
      _logger.e('Error loading prayer times', e);
      uiState.value = uiState.value.copyWith(
        loadingPrayerTimes: false,
        prayerTimesError: 'Could not load prayer times. Error: ${e.toString()}',
        prayerTimes: null,
      );
    }
  }

  // Load default location (Dhaka)
  Future<void> _loadDefaultLocation(String reason) async {
    try {
      // Save default location to preferences
      await _locationService.saveDefaultLocation('Dhaka');

      uiState.value = uiState.value.copyWith(
        currentAddress: 'Dhaka',
        locationPermissionGranted: false,
      );

      // Load prayer times for default location
      await _loadPrayerTimes(
        currentUiState.defaultLatitude!,
        currentUiState.defaultLongitude!,
      );

      Get.snackbar(
        'Notice',
        '$reason. Using default location (Dhaka).',
        backgroundColor: Colors.amber,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      _logger.e('Error loading default location', e);
    }
  }
}
