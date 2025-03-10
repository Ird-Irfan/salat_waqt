import 'dart:async';

import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/services/location_service.dart';
import 'package:salat_waqt/core/services/logger_service.dart';
import 'package:salat_waqt/core/services/prayer_time_service.dart';
import 'package:salat_waqt/core/services/timer_service.dart';
import 'package:salat_waqt/domain/service/notification_service.dart';
import 'package:salat_waqt/presentation/home/presenter/current_prayer_time_ui_state.dart';

class CurrentPrayerTimePresenter
    extends BasePresenter<CurrentPrayerTimeUiState> {
  // State management
  final Obs<CurrentPrayerTimeUiState> uiState = Obs(
    CurrentPrayerTimeUiState.empty(),
  );
  CurrentPrayerTimeUiState get currentUiState => uiState.value;

  // Timer for updating current time
  Timer? _timer;

  // Services
  final LocationService _locationService;
  final PrayerTimeService _prayerTimeService;
  final TimerService _timerService;
  final LoggerService _logger;
  final NotificationService _notificationService;

  // Constructor
  CurrentPrayerTimePresenter({
    required LocationService locationService,
    required PrayerTimeService prayerTimeService,
    required TimerService timerService,
    required LoggerService logger,
    required NotificationService notificationService,
  }) : _locationService = locationService,
       _prayerTimeService = prayerTimeService,
       _timerService = timerService,
       _logger = logger,
       _notificationService = notificationService;

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
    await _loadPrayerTimes();
    _startTimer();
    updateCurrentWaqt();
    await _loadNotificationStatuses();
  }

  // Load prayer times
  Future<void> _loadPrayerTimes() async {
    toggleLoading(loading: true);
    try {
      // Get saved location
      final (latitude, longitude, _, _) =
          await _locationService.loadSavedLocation();

      if (latitude != null && longitude != null) {
        var times = await _prayerTimeService.loadPrayerTimes(
          latitude,
          longitude,
        );

        if (times != null) {
          uiState.value = uiState.value.copyWith(prayerTimes: times);
        } else {
          throw Exception('Failed to load prayer times');
        }
      } else {
        // Use default location if no saved location
        final defaultLat = 23.8103; // Dhaka
        final defaultLng = 90.4125;

        var times = await _prayerTimeService.loadPrayerTimes(
          defaultLat,
          defaultLng,
        );

        if (times != null) {
          uiState.value = uiState.value.copyWith(prayerTimes: times);
        } else {
          throw Exception('Failed to load prayer times');
        }
      }
    } catch (e) {
      _logger.e('Error loading prayer times', e);
    } finally {
      toggleLoading(loading: false);
    }
  }

  // Start timer to update time
  void _startTimer() {
    _timerService.startPeriodicTimer(() {
      updateCurrentWaqt();
    });
  }

  // Toggle expansion of prayer time widget
  void toggleCurrentPrayerTimeExpansion() {
    final bool newExpandedState = !currentUiState.isCurrentPrayerTimeExpanded;
    final double newHeight = newExpandedState ? 450.0 : 236.0;

    uiState.value = uiState.value.copyWith(
      isCurrentPrayerTimeExpanded: newExpandedState,
      currentPrayerTimeHeight: newHeight,
    );
  }

  // Update current waqt (prayer time)
  void updateCurrentWaqt() {
    if (currentUiState.prayerTimes == null) return;

    try {
      final now = DateTime.now();
      // Format time in 12-hour format with AM/PM
      final hour =
          now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
      final amPm = now.hour >= 12 ? 'PM' : 'AM';
      final currentTime =
          "${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $amPm";
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
            MapEntry(entry.key, entry.value!.add(const Duration(days: 1))),
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
    } catch (e) {
      _logger.e('Error updating current waqt', e);
    }
  }

  // Load notification statuses for all prayers
  Future<void> _loadNotificationStatuses() async {
    try {
      Map<String, bool> notificationStatus = {};

      for (var prayerName in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
        final isScheduled = await _notificationService
            .isPrayerTimeNotificationScheduled(prayerName);
        notificationStatus[prayerName] = isScheduled;
      }

      uiState.value = uiState.value.copyWith(
        notificationStatus: notificationStatus,
      );
    } catch (e) {
      _logger.e('Error loading notification statuses', e);
    }
  }

  // Toggle notification for a specific prayer
  Future<void> togglePrayerNotification(String prayerName) async {
    try {
      if (currentUiState.prayerTimes == null) return;

      // Get the prayer time
      final prayerTimeString = currentUiState.prayerTimes![prayerName];
      if (prayerTimeString == null) return;

      DateTime? prayerTime = _prayerTimeService.parseTime(prayerTimeString);
      _logger.i('prayerTime: $prayerTime');
      if (prayerTime == null) return;

      // If the prayer time has already passed today, schedule for tomorrow
      final now = DateTime.now();
      if (prayerTime.isBefore(now)) {
        prayerTime = prayerTime.add(const Duration(days: 1));
      }

      // Create notification title and body
      final title = 'Prayer Time Reminder';
      final body = 'It\'s time for $prayerName prayer.';

      // Toggle notification
      final isEnabled = await _notificationService.togglePrayerTimeNotification(
        prayerName: prayerName,
        prayerTime: prayerTime,
        title: title,
        body: body,
      );
      _logger.i('togglePrayerTimeNotification isEnabled: $isEnabled');

      // Update UI state
      final updatedNotificationStatus = Map<String, bool>.from(
        currentUiState.notificationStatus,
      );
      updatedNotificationStatus[prayerName] = isEnabled;

      uiState.value = uiState.value.copyWith(
        notificationStatus: updatedNotificationStatus,
      );

      _logger.i('Prayer notification for $prayerName toggled: $isEnabled');
    } catch (e) {
      _logger.e('Error toggling prayer notification for $prayerName', e);
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
}
