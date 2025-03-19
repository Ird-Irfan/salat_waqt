import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/services/logger_service.dart';
import 'package:salat_waqt/core/services/prayer_time_service.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_presenter.dart';

class ForbiddenTimePresenter extends BasePresenter
    with GetSingleTickerProviderStateMixin {
  final _isExpanded = false.obs;
  final HomePresenter _homePresenter = loadPresenter(
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
  final PrayerTimeService _prayerTimeService = locator();
  final LoggerService _logger = locator();
  final SettingsPresenter _settingsPresenter = locator();

  // State variables
  final _forbiddenTimes = Rxn<List<Map<String, String>>>();
  final _isInForbiddenTime = false.obs;
  final _currentForbiddenPeriod = Rxn<String>();
  final _currentForbiddenTimeRange = Rxn<String>();
  //final prayerTimes = PrayerTimes.today(myCoordinates, params);

  // Timer for updating forbidden times status
  Timer? _forbiddenTimesTimer;

  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  bool get isExpanded => _isExpanded.value;
  List<Map<String, String>>? get forbiddenTimes => _forbiddenTimes.value;
  bool get isInForbiddenTime => _isInForbiddenTime.value;
  String? get currentForbiddenPeriod => _currentForbiddenPeriod.value;
  String? get currentForbiddenTimeRange => _currentForbiddenTimeRange.value;
  // Get the 24-hour format setting from SettingsPresenter
  bool get is24HourFormat => _settingsPresenter.currentUiState.use24HourFormatEnabled;

  @override
  void onInit() {
    super.onInit();
    // Initialize animation controller
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    // Initialize the forbidden times
    _initializeForbiddenTimes();

    // Start the timer
    _startForbiddenTimesTimer();
    
    // Listen for changes in 24-hour format setting
    ever(_settingsPresenter.uiState, (_) {
      if (forbiddenTimes != null && forbiddenTimes!.isNotEmpty) {
        // Recalculate forbidden times to update the format
        _updateForbiddenTimesStatus();
      }
    });
  }

  @override
  void onClose() {
    _forbiddenTimesTimer?.cancel();
    animationController.dispose();
    super.onClose();
  }

  void toggleExpanded() {
    _isExpanded.value = !_isExpanded.value;
    if (_isExpanded.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  // Initialize forbidden times from home presenter
  void _initializeForbiddenTimes() {
    final homeUiState = _homePresenter.currentUiState;

    if (homeUiState.prayerTimes != null) {
      // Calculate forbidden times if prayer times are available
      final times = calculateForbiddenTimes(
        Map<String, String>.from(homeUiState.prayerTimes!),
      );
      _forbiddenTimes.value = times;

      // Update forbidden time status
      _updateForbiddenTimesStatus();
    } else {
      // If prayer times are not available yet, listen to changes in the home presenter
      ever(_homePresenter.uiState, (state) {
        if (state.prayerTimes != null && _forbiddenTimes.value == null) {
          final times = calculateForbiddenTimes(
            Map<String, String>.from(state.prayerTimes!),
          );
          _forbiddenTimes.value = times;

          // Update forbidden time status
          _updateForbiddenTimesStatus();
        }
      });
    }
  }

  // Start timer to update forbidden times status
  void _startForbiddenTimesTimer() {
    _forbiddenTimesTimer?.cancel();
    // Check every minute to ensure accurate updates
    _forbiddenTimesTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateForbiddenTimesStatus();
    });
  }

  // Update forbidden times status
  void _updateForbiddenTimesStatus() {
    if (_forbiddenTimes.value == null ||
        _forbiddenTimes.value!.isEmpty ||
        _homePresenter.currentUiState.prayerTimes == null) {
      return;
    }

    try {
      // Recalculate forbidden times to ensure they're up to date
      final updatedForbiddenTimes = calculateForbiddenTimes(
        Map<String, String>.from(_homePresenter.currentUiState.prayerTimes!),
      );

      var (isInForbidden, currentForbiddenName) = checkIfInForbiddenTime(
        updatedForbiddenTimes,
      );

      var forbiddenTimeRange = getCurrentForbiddenTimeRange(
        updatedForbiddenTimes,
      );

      _forbiddenTimes.value = updatedForbiddenTimes;
      _isInForbiddenTime.value = isInForbidden;
      _currentForbiddenPeriod.value = currentForbiddenName;
      _currentForbiddenTimeRange.value = forbiddenTimeRange;
    } catch (e) {
      _logger.e('Error updating forbidden times status', e);
    }
  }

  // Calculate forbidden prayer times
  List<Map<String, String>> calculateForbiddenTimes(
    Map<String, String> prayerTimes,
  ) {
    try {
      List<Map<String, String>> forbiddenTimes = [];
      
      // Use the appropriate time format based on settings
      String timeFormat = is24HourFormat ? 'HH:mm' : 'h:mm a';

      // 1. From sunrise until 10 minutes after sunrise
      if (prayerTimes.containsKey('Sunrise')) {
        DateTime? sunriseTime = _prayerTimeService.parseTime(
          prayerTimes['Sunrise'],
        );

        if (sunriseTime != null) {
          // End time is 10 minutes after sunrise
          DateTime endTime = sunriseTime.add(Duration(minutes: 10));
          String endTimeStr = DateFormat(timeFormat).format(endTime);

          forbiddenTimes.add({
            'name': 'Morning',
            'startTime': is24HourFormat 
                ? _formatTo24Hour(prayerTimes['Sunrise']!) 
                : prayerTimes['Sunrise']!,
            'endTime': endTimeStr,
            'icon': 'Fajr',
          });
        }
      }

      // 2. When sun is at zenith (10 min before Dhuhr until Dhuhr)
      if (prayerTimes.containsKey('Dhuhr')) {
        DateTime? dhuhrTime = _prayerTimeService.parseTime(
          prayerTimes['Dhuhr'],
        );

        if (dhuhrTime != null) {
          // Zenith is approximately 5 minutes before Dhuhr
          // Forbidden time starts 10 minutes before zenith
          DateTime zenithTime = dhuhrTime.subtract(Duration(minutes: 5));
          DateTime startTime = zenithTime.subtract(Duration(minutes: 10));

          String formattedStartTime = DateFormat(timeFormat).format(startTime);
          String formattedZenithTime = DateFormat(timeFormat).format(zenithTime);

          forbiddenTimes.add({
            'name': 'Noon',
            'startTime': formattedStartTime,
            'endTime': formattedZenithTime,
            'icon': 'Dhuhr',
          });
        }
      }

      // 3. 10 minutes before sunset until sunset
      if (prayerTimes.containsKey('Maghrib')) {
        DateTime? maghribTime = _prayerTimeService.parseTime(
          prayerTimes['Maghrib'],
        );

        if (maghribTime != null) {
          // Start time is 10 minutes before Maghrib (sunset)
          DateTime startTime = maghribTime.subtract(Duration(minutes: 10));
          String startTimeStr = DateFormat(timeFormat).format(startTime);

          forbiddenTimes.add({
            'name': 'Evening',
            'startTime': startTimeStr,
            'endTime': is24HourFormat 
                ? _formatTo24Hour(prayerTimes['Maghrib']!) 
                : prayerTimes['Maghrib']!,
            'icon': 'Asr',
          });
        }
      }

      return forbiddenTimes;
    } catch (e) {
      _logger.e('Error calculating forbidden times', e);
      return [];
    }
  }
  
  // Helper method to convert a time string to 24-hour format
  String _formatTo24Hour(String timeString) {
    try {
      if (timeString.toLowerCase().contains('am') || timeString.toLowerCase().contains('pm')) {
        // Convert from 12-hour to 24-hour format
        DateTime parsedTime = DateFormat('h:mm a').parse(timeString);
        return DateFormat('HH:mm').format(parsedTime);
      }
      // Already in 24-hour format
      return timeString;
    } catch (e) {
      _logger.e('Error formatting time to 24-hour: $timeString', e);
      return timeString;
    }
  }

  // Check if current time is within any forbidden period
  (bool, String?) checkIfInForbiddenTime(List<Map<String, String>> times) {
    return _prayerTimeService.isInForbiddenTime(times);
  }

  // Get current active forbidden time period with formatted time range
  String? getCurrentForbiddenTimeRange(List<Map<String, String>> times) {
    return _prayerTimeService.getCurrentForbiddenTimeRange(times);
  }

  // Helper method to parse time string to DateTime
  DateTime? parseTime(String? timeString) {
    return _prayerTimeService.parseTime(timeString);
  }

  String getTimeRangeDisplay() {
    String timeRangeDisplay = "";

    if (forbiddenTimes != null && forbiddenTimes!.isNotEmpty) {
      if (isInForbiddenTime && currentForbiddenPeriod != null) {
        // Find the current forbidden period
        for (var period in forbiddenTimes!) {
          if (period['name'] == currentForbiddenPeriod) {
            timeRangeDisplay = "${period['startTime']} - ${period['endTime']}";
            break;
          }
        }
      } else {
        // Show the next upcoming forbidden period if not in one
        final now = DateTime.now();
        DateTime? nextForbiddenTime;
        Map<String, String>? nextPeriod;

        for (var period in forbiddenTimes!) {
          final startTime = parseTime(period['startTime']);
          if (startTime != null && startTime.isAfter(now)) {
            if (nextForbiddenTime == null ||
                startTime.isBefore(nextForbiddenTime)) {
              nextForbiddenTime = startTime;
              nextPeriod = period;
            }
          }
        }

        if (nextPeriod != null) {
          timeRangeDisplay =
              "${nextPeriod['startTime']} - ${nextPeriod['endTime']}";
        } else if (forbiddenTimes!.isNotEmpty) {
          // If no upcoming forbidden time today, show the first one (for tomorrow)
          timeRangeDisplay =
              "${forbiddenTimes![0]['startTime']} - ${forbiddenTimes![0]['endTime']}";
        }
      }
    }

    return timeRangeDisplay;
  }

  Map<String, String>? getCurrentForbiddenPeriod() {
    if (forbiddenTimes != null &&
        forbiddenTimes!.isNotEmpty &&
        isInForbiddenTime &&
        currentForbiddenPeriod != null) {
      // Find the current forbidden period
      for (var period in forbiddenTimes!) {
        if (period['name'] == currentForbiddenPeriod) {
          return period;
        }
      }
    }

    return null;
  }

  @override
  Future<void> addUserMessage(String message) {
    _logger.i(message);
    return Future.value();
  }

  @override
  Future<void> toggleLoading({required bool loading}) {
    return Future.value();
  }
}
