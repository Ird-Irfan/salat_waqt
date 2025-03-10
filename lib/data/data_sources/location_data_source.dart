import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

abstract class LocationDataSource {
  Future<Position> getCurrentPosition();
  Future<String> getAddressFromLatLng(double latitude, double longitude);
  Future<List<Location>> getCoordinatesFromAddress(String address);
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }

      // Add a small delay after permission is granted to avoid race conditions
      await Future.delayed(Duration(milliseconds: 500));
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    try {
      // Try with higher accuracy first
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 5),
      );
    } catch (e) {
      // If high accuracy fails or times out, try with lower accuracy
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 5),
        );
      } catch (e) {
        throw Exception('Failed to get location: $e');
      }
    }
  }

  @override
  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    // ... (আপনার পূর্বের _getAddressFromLatLng ফাংশনের লজিক এখানে থাকবে)
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      Placemark place = placemarks[0];
      return "${place.locality}, ${place.country}";
    } catch (e) {
      throw Exception("Failed to get address: $e");
    }
  }

  @override
  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    // ... (আপনার পূর্বের _getCoordinatesFromAddress ফাংশনের লজিক এখানে থাকবে)
    try {
      return await locationFromAddress(address);
    } catch (e) {
      throw Exception("Failed to get coordinates: $e");
    }
  }
}
