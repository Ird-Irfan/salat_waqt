import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/domain/usecases/get_address_from_coordinates_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_current_location_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_prayer_times_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_coordinates_from_address_usecase.dart';
import 'package:salat_waqt/presentation/home/presenter/home_ui_state.dart';

class HomePresenter extends BasePresenter<HomeUiState> {
  // State management
  final Obs<HomeUiState> uiState = Obs(HomeUiState.empty());
  HomeUiState get currentUiState => uiState.value;

  // Timer for updating remaining time
  Timer? _timer;

  // Use cases
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetAddressFromCoordinatesUseCase getAddressFromCoordinatesUseCase;
  final GetPrayerTimesUseCase getPrayerTimesUseCase;
  final GetCoordinatesFromAddressUseCase getCoordinatesFromAddressUseCase;

  // Constructor
  HomePresenter({
    required this.getCurrentLocationUseCase,
    required this.getAddressFromCoordinatesUseCase,
    required this.getPrayerTimesUseCase,
    required this.getCoordinatesFromAddressUseCase,
  });

  // Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    _updateDates();
    _loadSavedLocation();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Public methods
  Future<void> checkAndRequestLocationPermission() async {
    toggleLoading(loading: true);
    try {
      // First check if we already have location data saved
      final prefs = await SharedPreferences.getInstance();
      final bool locationEnabled = prefs.getBool('location_enabled') ?? false;

      if (locationEnabled) {
        // User has previously granted location permission, use saved coordinates
        final double? latitude = prefs.getDouble('latitude');
        final double? longitude = prefs.getDouble('longitude');

        if (latitude != null && longitude != null) {
          // Get address from coordinates
          String address = await getAddressFromCoordinatesUseCase.execute(
            latitude,
            longitude,
          );

          uiState.value = uiState.value.copyWith(
            currentAddress: address,
            locationPermissionGranted: true,
          );

          // Load prayer times with saved coordinates
          await _loadPrayerTimes(latitude, longitude);
          return;
        }
      }

      // If no saved location data, proceed with location checks
      if (!await _isLocationServiceEnabled()) {
        return;
      }

      final permission = await _checkAndRequestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }

      // If we got here, permission is granted
      uiState.value = uiState.value.copyWith(locationPermissionGranted: true);
      await _loadCurrentLocation();
    } catch (e) {
      _useDefaultLocation('একটি সমস্যা হয়েছে: ${e.toString()}');
    } finally {
      toggleLoading(loading: false);
    }
  }

  Future<void> changeLocation(String address) async {
    toggleLoading(loading: true);
    try {
      List<Location> locations = await getCoordinatesFromAddressUseCase.execute(
        address,
      );
      Location location = locations[0];
      uiState.value = uiState.value.copyWith(currentAddress: address);
      await _loadPrayerTimes(location.latitude, location.longitude);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change location.',
        backgroundColor: Colors.red,
      );
      _fallbackToDefaultLocation();
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

  // Private helper methods
  void _updateDates() {
    // English date
    DateTime now = DateTime.now();
    uiState.value = uiState.value.copyWith(
      englishDate: DateFormat('d MMMM yyyy').format(now),
    );

    // Arabic/Hijri date
    HijriCalendar hijri = HijriCalendar.now();
    uiState.value = uiState.value.copyWith(
      arabicDate: hijri.toFormat("dd MMMM yyyy"),
    );
  }

  void _startTimer() {
    // Cancel existing timer if any
    _timer?.cancel();

    // Update immediately
    _updateRemainingTime();

    // Set timer to update less frequently - every 60 seconds instead of every minute
    // this helps reduce UI rebuilds while still keeping the display accurate
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    if (currentUiState.prayerTimes == null) return;

    DateTime now = DateTime.now();
    DateTime? nextPrayerTime;
    String? nextPrayerName;
    double progressValue = 0.0;

    // Check if we're in Ramadan mode (has Sehri and Iftar times)
    bool isRamadanMode =
        currentUiState.prayerTimes!.containsKey('Sehri') &&
        currentUiState.prayerTimes!.containsKey('Iftar');

    if (isRamadanMode) {
      // Get Iftar and Sehri times
      DateTime? iftarTime = _parseTime(currentUiState.prayerTimes!['Iftar']);
      DateTime? sehriTime = _parseTime(currentUiState.prayerTimes!['Sehri']);

      if (iftarTime != null && sehriTime != null) {
        // Create today's and tomorrow's times for comparison
        DateTime todayIftar = iftarTime;
        DateTime todaySehri = sehriTime;

        // If Sehri is after Iftar in the same day, it means Sehri is for the next day
        if (todaySehri.isBefore(todayIftar)) {
          // Sehri is for today, Iftar is for today
          // This is the normal case during Ramadan
        } else {
          // Sehri is for tomorrow, Iftar is for today
          todaySehri = todaySehri.add(Duration(days: 1));
        }

        // If both times are in the past, move to tomorrow
        if (now.isAfter(todayIftar) && now.isAfter(todaySehri)) {
          todayIftar = todayIftar.add(Duration(days: 1));
          todaySehri = todaySehri.add(Duration(days: 1));
        }

        // Determine which is next: Iftar or Sehri
        if (now.isBefore(todayIftar) && now.isBefore(todaySehri)) {
          // Both are in the future, pick the closest one
          if (todayIftar.isBefore(todaySehri)) {
            nextPrayerTime = todayIftar;
            nextPrayerName = 'ইফতার';
          } else {
            nextPrayerTime = todaySehri;
            nextPrayerName = 'সেহরি';
          }
        } else if (now.isBefore(todayIftar)) {
          // Only Iftar is in the future
          nextPrayerTime = todayIftar;
          nextPrayerName = 'ইফতার';
        } else if (now.isBefore(todaySehri)) {
          // Only Sehri is in the future
          nextPrayerTime = todaySehri;
          nextPrayerName = 'সেহরি';
        }

        // Calculate progress
        if (nextPrayerName == 'ইফতার') {
          // We're waiting for Iftar, so we're between Sehri and Iftar
          // Calculate how much time has passed since Sehri
          DateTime previousSehri = todaySehri.subtract(Duration(days: 1));
          if (now.isBefore(previousSehri)) {
            previousSehri = previousSehri.subtract(Duration(days: 1));
          }

          Duration totalDuration = todayIftar.difference(previousSehri);
          Duration elapsedDuration = now.difference(previousSehri);

          progressValue = elapsedDuration.inMinutes / totalDuration.inMinutes;
        } else if (nextPrayerName == 'সেহরি') {
          // We're waiting for Sehri, so we're between Iftar and Sehri
          // Calculate how much time has passed since Iftar
          DateTime previousIftar = todayIftar.subtract(Duration(days: 1));
          if (now.isBefore(previousIftar)) {
            previousIftar = previousIftar.subtract(Duration(days: 1));
          }

          Duration totalDuration = todaySehri.difference(previousIftar);
          Duration elapsedDuration = now.difference(previousIftar);

          progressValue = elapsedDuration.inMinutes / totalDuration.inMinutes;
        }

        progressValue = progressValue.clamp(0.0, 1.0);
      }
    } else {
      // Regular prayer time mode
      // Find the next prayer time
      List<MapEntry<String, String>> prayerEntries = [
        MapEntry('ফজর', currentUiState.prayerTimes!['Fajr']),
        MapEntry('যোহর', currentUiState.prayerTimes!['Dhuhr']),
        MapEntry('আসর', currentUiState.prayerTimes!['Asr']),
        MapEntry('মাগরিব', currentUiState.prayerTimes!['Maghrib']),
        MapEntry('ঈশা', currentUiState.prayerTimes!['Isha']),
      ];

      // Parse all prayer times
      List<MapEntry<String, DateTime>> parsedTimes = [];
      for (var entry in prayerEntries) {
        DateTime? time = _parseTime(entry.value);
        if (time != null) {
          // If time is before now, add a day
          if (time.isBefore(now)) {
            time = time.add(Duration(days: 1));
          }
          parsedTimes.add(MapEntry(entry.key, time));
        }
      }

      // Sort by time
      parsedTimes.sort((a, b) => a.value.compareTo(b.value));

      // Find the next prayer
      if (parsedTimes.isNotEmpty) {
        nextPrayerName = parsedTimes.first.key;
        nextPrayerTime = parsedTimes.first.value;

        // Find the previous prayer time
        DateTime previousPrayerTime;
        if (parsedTimes.last.value.subtract(Duration(days: 1)).isAfter(now)) {
          previousPrayerTime = parsedTimes.last.value.subtract(
            Duration(days: 1),
          );
        } else {
          // Find the last prayer time before now
          var previousPrayers =
              parsedTimes
                  .where(
                    (entry) =>
                        entry.value.subtract(Duration(days: 1)).isBefore(now),
                  )
                  .toList();
          previousPrayers.sort((a, b) => b.value.compareTo(a.value));
          previousPrayerTime =
              previousPrayers.isNotEmpty
                  ? previousPrayers.first.value.subtract(Duration(days: 1))
                  : now.subtract(Duration(hours: 1));
        }

        // Calculate progress
        Duration totalDuration = nextPrayerTime.difference(previousPrayerTime);
        Duration elapsedDuration = now.difference(previousPrayerTime);

        progressValue = elapsedDuration.inMinutes / totalDuration.inMinutes;
        progressValue = progressValue.clamp(0.0, 1.0);
      }
    }

    // Update the UI state with the calculated values
    if (nextPrayerTime != null) {
      Duration remainingDuration = nextPrayerTime.difference(now);
      String remainingTime = _formatDuration(remainingDuration);

      uiState.value = uiState.value.copyWith(
        nextPrayerName: nextPrayerName,
        remainingTime: remainingTime,
        progressValue: progressValue,
      );
    }
  }

  DateTime? _parseTime(String? timeString) {
    if (timeString == null) return null;

    try {
      // Parse the time string (e.g., "5:30 AM")
      DateTime now = DateTime.now();
      DateTime parsedTime = DateFormat('h:mm a').parse(timeString);

      // Combine with today's date
      return DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      print('Error parsing time: $e');
      return null;
    }
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  Future<bool> _isLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationServiceDialog();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _useDefaultLocation(
          'লোকেশন সার্ভিস বন্ধ আছে। ডিফল্ট লোকেশন (ঢাকা) ব্যবহার করা হচ্ছে।',
        );
        return false;
      }
    }
    return true;
  }

  Future<LocationPermission> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await _showPermissionExplanationDialog();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _useDefaultLocation(
          'লোকেশন পারমিশন দেওয়া হয়নি। ডিফল্ট লোকেশন (ঢাকা) ব্যবহার করা হচ্ছে।',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _showOpenSettingsDialog();
      _useDefaultLocation(
        'লোকেশন পারমিশন স্থায়ীভাবে বন্ধ করা আছে। ডিফল্ট লোকেশন (ঢাকা) ব্যবহার করা হচ্ছে।',
      );
    }

    return permission;
  }

  Future<void> _loadCurrentLocation() async {
    toggleLoading(loading: true);
    try {
      Position position = await getCurrentLocationUseCase.execute();
      String address = await getAddressFromCoordinatesUseCase.execute(
        position.latitude,
        position.longitude,
      );

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('location_enabled', true);
      await prefs.setDouble('latitude', position.latitude);
      await prefs.setDouble('longitude', position.longitude);

      uiState.value = uiState.value.copyWith(currentAddress: address);
      await _loadPrayerTimes(position.latitude, position.longitude);
    } catch (e) {
      _handleLocationError(e);
    } finally {
      toggleLoading(loading: false);
    }
  }

  void _handleLocationError(dynamic error) {
    if (_isLocationPermissionError(error)) {
      _fallbackToDefaultLocation();
      Get.snackbar(
        'Notice',
        'Using default location (Dhaka) for prayer times.',
        backgroundColor: Colors.amber,
        duration: Duration(seconds: 3),
      );
    } else {
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
      _fallbackToDefaultLocation();
    }
  }

  bool _isLocationPermissionError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('permission') ||
        errorString.contains('denied') ||
        errorString.contains('disabled');
  }

  void _fallbackToDefaultLocation() async {
    // Save to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('location_enabled', false);
      await prefs.setString('default_location', 'ঢাকা');
    } catch (e) {
      print('Error saving default location: $e');
    }

    uiState.value = uiState.value.copyWith(currentAddress: 'ঢাকা');
    _loadPrayerTimes(
      currentUiState.defaultLatitude!,
      currentUiState.defaultLongitude!,
    );
  }

  Future<void> _loadPrayerTimes(double latitude, double longitude) async {
    uiState.value = uiState.value.copyWith(
      loadingPrayerTimes: true,
      prayerTimesError: null,
    );

    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      var times = await getPrayerTimesUseCase.execute(
        latitude,
        longitude,
        date,
      );
      if (times.isEmpty) {
        throw Exception('নামাজের সময় লোড করা যায়নি');
      }

      Map<String, String> formattedTimes = _formatPrayerTimes(times);
      _addSpecialTimes(formattedTimes);

      uiState.value = uiState.value.copyWith(
        prayerTimes: formattedTimes,
        loadingPrayerTimes: false,
        prayerTimesError: null,
      );

      // Update the remaining time after loading prayer times
      _updateRemainingTime();
    } catch (e) {
      print('Error loading prayer times: $e');
      uiState.value = uiState.value.copyWith(
        loadingPrayerTimes: false,
        prayerTimesError:
            'নামাজের সময় লোড করা যায়নি। দয়া করে আবার চেষ্টা করুন।\nError: ${e.toString()}',
        prayerTimes: null,
      );
    }
  }

  Map<String, String> _formatPrayerTimes(Map<String, dynamic> times) {
    Map<String, String> formattedTimes = {};
    times.forEach((prayer, time) {
      try {
        DateTime prayerTime = DateFormat('HH:mm').parse(time);
        String formatted = DateFormat('h:mm a').format(prayerTime);
        formattedTimes[prayer] = formatted;
      } catch (e) {
        print('Error formatting time for $prayer: $e');
        throw Exception('সময় ফরম্যাট করতে সমস্যা হয়েছে: $prayer');
      }
    });
    return formattedTimes;
  }

  void _addSpecialTimes(Map<String, String> formattedTimes) {
    // Add Iftar time (same as Maghrib)
    if (formattedTimes.containsKey('Maghrib')) {
      formattedTimes['Iftar'] = formattedTimes['Maghrib']!;
    }

    // Calculate Sehri time (20 minutes before Fajr)
    if (formattedTimes.containsKey('Fajr')) {
      try {
        DateTime fajrTime = DateFormat('h:mm a').parse(formattedTimes['Fajr']!);
        DateTime sehriTime = fajrTime.subtract(Duration(minutes: 20));
        formattedTimes['Sehri'] = DateFormat('h:mm a').format(sehriTime);
      } catch (e) {
        print('Error calculating Sehri time: $e');
        // Don't throw here, just skip Sehri time if there's an error
      }
    }
  }

  Future<void> _useDefaultLocation(String message) async {
    uiState.value = uiState.value.copyWith(currentAddress: 'ঢাকা');
    await _loadPrayerTimes(
      currentUiState.defaultLatitude!,
      currentUiState.defaultLongitude!,
    );
    Get.snackbar(
      'সতর্কতা',
      message,
      backgroundColor: Colors.amber,
      duration: Duration(seconds: 5),
    );
  }

  // Dialog methods
  Future<void> _showLocationServiceDialog() async {
    return Get.dialog(
      AlertDialog(
        title: Text('লোকেশন সার্ভিস বন্ধ আছে'),
        content: Text(
          'আপনার বর্তমান অবস্থান অনুযায়ী সঠিক নামাজের সময় পাওয়ার জন্য অনুগ্রহ করে লোকেশন সার্ভিস চালু করুন।',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('পরে')),
          TextButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openLocationSettings();
            },
            child: Text('সেটিংস খুলুন'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showPermissionExplanationDialog() async {
    return Get.dialog(
      AlertDialog(
        title: Text('লোকেশন পারমিশন প্রয়োজন'),
        content: Text(
          'আপনার বর্তমান অবস্থান অনুযায়ী সঠিক নামাজের সময় পাওয়ার জন্য অ্যাপটি আপনার লোকেশন ব্যবহার করতে চায়।',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('বুঝেছি')),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showOpenSettingsDialog() async {
    return Get.dialog(
      AlertDialog(
        title: Text('লোকেশন অ্যাক্সেস বন্ধ আছে'),
        content: Text(
          'অ্যাপ সেটিংস থেকে লোকেশন পারমিশন দিতে হবে। অন্যথায় ডিফল্ট লোকেশন (ঢাকা) ব্যবহার করা হবে।',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('পরে')),
          TextButton(
            onPressed: () async {
              Get.back();
              await Geolocator.openAppSettings();
            },
            child: Text('সেটিংস খুলুন'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Load saved location from SharedPreferences
  Future<void> _loadSavedLocation() async {
    toggleLoading(loading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool locationEnabled = prefs.getBool('location_enabled') ?? false;

      if (locationEnabled) {
        // User has previously granted location permission, use saved coordinates
        final double? latitude = prefs.getDouble('latitude');
        final double? longitude = prefs.getDouble('longitude');

        if (latitude != null && longitude != null) {
          // Get address from coordinates
          String address = await getAddressFromCoordinatesUseCase.execute(
            latitude,
            longitude,
          );

          uiState.value = uiState.value.copyWith(
            currentAddress: address,
            locationPermissionGranted: true,
          );

          // Load prayer times with saved coordinates
          await _loadPrayerTimes(latitude, longitude);
          return;
        }
      } else {
        // User denied location permission, check if we have a default location
        final String? defaultLocation = prefs.getString('default_location');

        if (defaultLocation != null && defaultLocation.isNotEmpty) {
          uiState.value = uiState.value.copyWith(
            currentAddress: defaultLocation,
            locationPermissionGranted: false,
          );

          // Use default location coordinates (Dhaka)
          await _loadPrayerTimes(
            currentUiState.defaultLatitude!,
            currentUiState.defaultLongitude!,
          );
          return;
        }
      }

      // If we get here, either first time use or something went wrong with saved data
      // Just load default location (Dhaka)
      _fallbackToDefaultLocation();
    } catch (e) {
      print('Error loading saved location: $e');
      _fallbackToDefaultLocation();
    } finally {
      toggleLoading(loading: false);
    }
  }
}
