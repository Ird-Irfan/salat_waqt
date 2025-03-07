import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
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
    checkAndRequestLocationPermission();
  }

  // Public methods
  Future<void> checkAndRequestLocationPermission() async {
    toggleLoading(loading: true);
    try {
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
      englishDate: DateFormat('EEEE, d MMMM yyyy').format(now),
    );

    // Arabic/Hijri date
    HijriCalendar hijri = HijriCalendar.now();
    uiState.value = uiState.value.copyWith(
      arabicDate: hijri.toFormat("dd MMMM yyyy"),
    );
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

  void _fallbackToDefaultLocation() {
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
}
