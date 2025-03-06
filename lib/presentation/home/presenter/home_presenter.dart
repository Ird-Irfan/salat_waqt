import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  final _prayerTimes = Rx<Map<String, dynamic>?>(null);
  final _isLoading = false.obs;

  String get currentAddress => _currentAddress.value;
  Map<String, dynamic>? get prayerTimes => _prayerTimes.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentLocation();
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
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadPrayerTimes(double latitude, double longitude) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      _prayerTimes.value = await getPrayerTimesUseCase.execute(
        latitude,
        longitude,
        date,
      );
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
    } finally {
      _isLoading.value = false;
    }
  }
}
