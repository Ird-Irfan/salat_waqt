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
  final Obs<HomeUiState> uiState = Obs(HomeUiState.empty());

  HomeUiState get currentUiState => uiState.value;

  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetAddressFromCoordinatesUseCase getAddressFromCoordinatesUseCase;
  final GetPrayerTimesUseCase getPrayerTimesUseCase;
  final GetCoordinatesFromAddressUseCase getCoordinatesFromAddressUseCase;

  HomePresenter({
    required this.getCurrentLocationUseCase,
    required this.getAddressFromCoordinatesUseCase,
    required this.getPrayerTimesUseCase,
    required this.getCoordinatesFromAddressUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    _updateDates();
    checkAndRequestLocationPermission();
  }

  // Update both English and Arabic dates
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

  // Check location service status and request permission
  Future<void> checkAndRequestLocationPermission() async {
    toggleLoading(loading: true);
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Show dialog to enable location service
        await _showLocationServiceDialog();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          // If still not enabled, use default location
          _useDefaultLocation(
            'লোকেশন সার্ভিস বন্ধ আছে। ডিফল্ট লোকেশন (ঢাকা) ব্যবহার করা হচ্ছে।',
          );
          return;
        }
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Show dialog explaining why we need location permission
        await _showPermissionExplanationDialog();
        // Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // If permission still denied, use default location
          _useDefaultLocation(
            'লোকেশন পারমিশন দেওয়া হয়নি। ডিফল্ট লোকেশন (ঢাকা) ব্যবহার করা হচ্ছে।',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // If permission permanently denied, show settings dialog
        await _showOpenSettingsDialog();
        _useDefaultLocation(
          'লোকেশন পারমিশন স্থায়ীভাবে বন্ধ করা আছে। ডিফল্ট লোকেশন (ঢাকা) ব্যবহার করা হচ্ছে।',
        );
        return;
      }

      // If we got here, permission is granted
      uiState.value = uiState.value.copyWith(locationPermissionGranted: true);
      await _loadCurrentLocation();
    } catch (e) {
      // Use default location for any errors
      _useDefaultLocation('একটি সমস্যা হয়েছে: ${e.toString()}');
    } finally {
      toggleLoading(loading: false);
    }
  }

  // Show dialog to enable location service
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

  // Show dialog explaining why we need location permission
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

  // Show dialog to open settings when permission permanently denied
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

  // Use default location with explanation message
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

  Future<void> _loadCurrentLocation() async {
    toggleLoading(loading: true);
    try {
      Position position = await getCurrentLocationUseCase.execute();
      uiState.value = uiState.value.copyWith(
        currentAddress: await getAddressFromCoordinatesUseCase.execute(
          position.latitude,
          position.longitude,
        ),
      );
      await _loadPrayerTimes(position.latitude, position.longitude);
    } catch (e) {
      // Check if the error is related to location permission
      if (e.toString().contains('permission') ||
          e.toString().contains('denied') ||
          e.toString().contains('disabled')) {
        // Use default Dhaka location when permission is denied
        uiState.value = uiState.value.copyWith(currentAddress: 'ঢাকা');
        await _loadPrayerTimes(
          currentUiState.defaultLatitude!,
          currentUiState.defaultLongitude!,
        );
        Get.snackbar(
          'Notice',
          'Using default location (Dhaka) for prayer times.',
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 3),
        );
      } else {
        Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);

        // Fall back to default location if any error occurs
        uiState.value = uiState.value.copyWith(currentAddress: 'ঢাকা');
        await _loadPrayerTimes(
          currentUiState.defaultLatitude!,
          currentUiState.defaultLongitude!,
        );
      }
    } finally {
      toggleLoading(loading: false);
    }
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

      // Convert each time to 12-hour format with AM/PM
      Map<String, String> formattedTimes = {};
      times.forEach((prayer, time) {
        try {
          // Parse the 24-hour time
          DateTime prayerTime = DateFormat('HH:mm').parse(time);
          // Format to 12-hour time with AM/PM
          String formatted = DateFormat('h:mm a').format(prayerTime);
          formattedTimes[prayer] = formatted;
        } catch (e) {
          print('Error formatting time for $prayer: $e');
          throw Exception('সময় ফরম্যাট করতে সমস্যা হয়েছে: $prayer');
        }
      });

      // Add Iftar time (same as Maghrib)
      if (formattedTimes.containsKey('Maghrib')) {
        formattedTimes['Iftar'] = formattedTimes['Maghrib']!;
      }

      // Calculate Sehri time (20 minutes before Fajr)
      if (formattedTimes.containsKey('Fajr')) {
        try {
          DateTime fajrTime = DateFormat(
            'h:mm a',
          ).parse(formattedTimes['Fajr']!);
          DateTime sehriTime = fajrTime.subtract(Duration(minutes: 20));
          formattedTimes['Sehri'] = DateFormat('h:mm a').format(sehriTime);
        } catch (e) {
          print('Error calculating Sehri time: $e');
          // Don't throw here, just skip Sehri time if there's an error
        }
      }

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

      // Fall back to default location if changing location fails
      uiState.value = uiState.value.copyWith(currentAddress: 'ঢাকা');
      await _loadPrayerTimes(
        currentUiState.defaultLatitude!,
        currentUiState.defaultLongitude!,
      );
    } finally {
      toggleLoading(loading: false);
    }
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = uiState.value.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = uiState.value.copyWith(isLoading: loading);
  }
}
