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
import 'package:url_launcher/url_launcher.dart';

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
    updateCurrentWaqt();
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
    _timerService.startPeriodicTimer(_updateRemainingTimeAndCheckNextPrayer);
  }

  // Update the remaining time until next prayer and check if we need to move to next prayer
  void _updateRemainingTimeAndCheckNextPrayer() {
    _updateRemainingTime();
    _checkForPrayerTransition();
  }

  // Check if we've transitioned to the next prayer time
  void _checkForPrayerTransition() {
    if (currentUiState.prayerTimes == null ||
        currentUiState.nextPrayerTime == null ||
        currentUiState.nextPrayerName == null) {
      return;
    }

    try {
      final now = DateTime.now();
      final nextPrayerDateTime = _prayerTimeService.parseTime(
        currentUiState.nextPrayerTime!,
      );

      // If next prayer time has passed, update the current and next prayer times
      if (nextPrayerDateTime != null && !nextPrayerDateTime.isAfter(now)) {
        updateCurrentWaqt();
      }
    } catch (e) {
      _logger.e('Error checking for prayer transition', e);
    }
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
        nextPrayerName: nextPrayerName ?? currentUiState.nextPrayerName,
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

  // Toggle current prayer time expansion state
  void toggleCurrentPrayerTimeExpansion() {
    final bool newExpandedState = !currentUiState.isCurrentPrayerTimeExpanded;
    final double newHeight = newExpandedState ? 450.0 : 236.0;

    uiState.value = uiState.value.copyWith(
      isCurrentPrayerTimeExpanded: newExpandedState,
      currentPrayerTimeHeight: newHeight,
    );
  }

  // Get current prayer time
  void updateCurrentWaqt() {
    if (currentUiState.prayerTimes == null) return;

    try {
      final now = DateTime.now();
      final currentTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      final prayerTimes = currentUiState.prayerTimes!;

      // Convert prayer times to DateTime objects
      Map<String, DateTime?> parsedTimes = {};
      for (var entry in prayerTimes.entries) {
        if (entry.key == 'Fajr' ||
            entry.key == 'Dhuhr' ||
            entry.key == 'Asr' ||
            entry.key == 'Maghrib' ||
            entry.key == 'Isha') {
          parsedTimes[entry.key] = _prayerTimeService.parseTime(entry.value);
        }
      }

      // Create a list of prayer times with their names
      List<MapEntry<String, DateTime>> todayPrayerTimes = [];
      List<MapEntry<String, DateTime>> tomorrowPrayerTimes = [];

      for (var entry in parsedTimes.entries) {
        if (entry.value != null) {
          todayPrayerTimes.add(MapEntry(entry.key, entry.value!));
          // Also add tomorrow's time for comparison
          tomorrowPrayerTimes.add(
            MapEntry(entry.key, entry.value!.add(Duration(days: 1))),
          );
        }
      }

      // Sort the prayer times
      todayPrayerTimes.sort((a, b) => a.value.compareTo(b.value));
      tomorrowPrayerTimes.sort((a, b) => a.value.compareTo(b.value));

      // Find current prayer (the last prayer before now)
      String currentWaqt = '';
      MapEntry<String, DateTime>? currentPrayer;

      for (var prayer in todayPrayerTimes) {
        if (prayer.value.isBefore(now)) {
          currentPrayer = prayer;
        } else {
          break;
        }
      }

      // If no prayer is found, it means we're after Isha and before Fajr
      currentPrayer ??= todayPrayerTimes.last;

      // Determine the next prayer
      MapEntry<String, DateTime>? nextPrayer;
      String? nextPrayerTime;

      // Find the next prayer after now
      for (var prayer in todayPrayerTimes) {
        if (prayer.value.isAfter(now)) {
          nextPrayer = prayer;
          nextPrayerTime = prayerTimes[prayer.key];
          break;
        }
      }

      // If no next prayer found today, use tomorrow's first prayer
      if (nextPrayer == null) {
        nextPrayer = tomorrowPrayerTimes.first;
        nextPrayerTime = prayerTimes[nextPrayer.key];
      }

      // Set current waqt based on which prayer was found
      currentWaqt = currentPrayer.key.toUpperCase();

      // Get the next prayer name
      String? nextPrayerName = nextPrayer.key;

      uiState.value = uiState.value.copyWith(
        currentWaqt: currentWaqt,
        currentTime: currentTime,
        nextPrayerWaqt: nextPrayerName,
        nextPrayerTime: nextPrayerTime,
      );

      // Re-update remaining time with new info
      _updateRemainingTime();
    } catch (e) {
      _logger.e('Error updating current waqt', e);
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

      // Update current waqt after loading prayer times
      updateCurrentWaqt();
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

  Future<void> launchUrls(String url) async {
    if (await launchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
