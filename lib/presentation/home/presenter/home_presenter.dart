import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:salat_waqt/domain/usecases/get_address_from_coordinates_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_current_location_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_prayer_times_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_coordinates_from_address_usecase.dart';

class LocationController extends GetxController {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetAddressFromCoordinatesUseCase getAddressFromCoordinatesUseCase;
  final GetPrayerTimesUseCase getPrayerTimesUseCase;
  final GetCoordinatesFromAddressUseCase getCoordinatesFromAddressUseCase;

  LocationController({
    required this.getCurrentLocationUseCase,
    required this.getAddressFromCoordinatesUseCase,
    required this.getPrayerTimesUseCase,
    required this.getCoordinatesFromAddressUseCase,
  });

  final _currentAddress = 'ঢাকা'.obs; // ডিফল্ট লোকেশন

  // Default coordinates for Dhaka, Bangladesh
  final double _defaultLatitude = 23.8103;
  final double _defaultLongitude = 90.4125;

  final _prayerTimes = Rx<Map<String, dynamic>?>(null);
  final _isLoading = false.obs;
  final _locationPermissionGranted = false.obs;

  // New date variables
  final _englishDate = ''.obs;
  final _arabicDate = ''.obs;

  String get currentAddress => _currentAddress.value;
  Map<String, dynamic>? get prayerTimes => _prayerTimes.value;
  bool get isLoading => _isLoading.value;
  bool get locationPermissionGranted => _locationPermissionGranted.value;
  String get englishDate => _englishDate.value;
  String get arabicDate => _arabicDate.value;

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
    _englishDate.value = DateFormat('EEEE, d MMMM yyyy').format(now);

    // Arabic/Hijri date
    HijriCalendar hijri = HijriCalendar.now();
    _arabicDate.value = hijri.toFormat("dd MMMM yyyy");
  }

  // Check location service status and request permission
  Future<void> checkAndRequestLocationPermission() async {
    _isLoading.value = true;
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
      _locationPermissionGranted.value = true;
      await _loadCurrentLocation();
    } catch (e) {
      // Use default location for any errors
      _useDefaultLocation('একটি সমস্যা হয়েছে: ${e.toString()}');
    } finally {
      _isLoading.value = false;
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
    _currentAddress.value = 'ঢাকা';
    await _loadPrayerTimes(_defaultLatitude, _defaultLongitude);
    Get.snackbar(
      'সতর্কতা',
      message,
      backgroundColor: Colors.amber,
      duration: Duration(seconds: 5),
    );
  }

  Future<void> _loadCurrentLocation() async {
    _isLoading.value = true;
    try {
      Position position = await getCurrentLocationUseCase.execute();
      _currentAddress.value = await getAddressFromCoordinatesUseCase.execute(
        position.latitude,
        position.longitude,
      );
      await _loadPrayerTimes(position.latitude, position.longitude);
    } catch (e) {
      // Check if the error is related to location permission
      if (e.toString().contains('permission') ||
          e.toString().contains('denied') ||
          e.toString().contains('disabled')) {
        // Use default Dhaka location when permission is denied
        _currentAddress.value = 'ঢাকা';
        await _loadPrayerTimes(_defaultLatitude, _defaultLongitude);
        Get.snackbar(
          'Notice',
          'Using default location (Dhaka) for prayer times.',
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 3),
        );
      } else {
        Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);

        // Fall back to default location if any error occurs
        _currentAddress.value = 'ঢাকা';
        await _loadPrayerTimes(_defaultLatitude, _defaultLongitude);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadPrayerTimes(double latitude, double longitude) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      var times = await getPrayerTimesUseCase.execute(
        latitude,
        longitude,
        date,
      );

      // Convert each time to 12-hour format with AM/PM
      Map<String, String> formattedTimes = {};
      times.forEach((prayer, time) {
        DateTime prayerTime = DateFormat('HH:mm').parse(time);
        String formatted = DateFormat('h:mm a').format(prayerTime);
        formattedTimes[prayer] = formatted;
      });

      // Add Iftar time (same as Maghrib)
      if (formattedTimes.containsKey('Maghrib')) {
        formattedTimes['Iftar'] = formattedTimes['Maghrib']!;
      }

      // Calculate Sehri time (20 minutes before Fajr)
      if (formattedTimes.containsKey('Fajr')) {
        DateTime fajrTime = DateFormat('h:mm a').parse(formattedTimes['Fajr']!);
        DateTime sehriTime = fajrTime.subtract(Duration(minutes: 20));
        formattedTimes['Sehri'] = DateFormat('h:mm a').format(sehriTime);
      }

      _prayerTimes.value = formattedTimes;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load prayer times.',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> changeLocation(String address) async {
    _isLoading.value = true;
    try {
      List<Location> locations = await getCoordinatesFromAddressUseCase.execute(
        address,
      );
      Location location = locations[0];
      _currentAddress.value = address;
      await _loadPrayerTimes(location.latitude, location.longitude);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change location.',
        backgroundColor: Colors.red,
      );

      // Fall back to default location if changing location fails
      _currentAddress.value = 'ঢাকা';
      await _loadPrayerTimes(_defaultLatitude, _defaultLongitude);
    } finally {
      _isLoading.value = false;
    }
  }
}
