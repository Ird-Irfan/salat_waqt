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
    // ... (আপনার পূর্বের _getCurrentLocation ফাংশনের লজিক এখানে থাকবে)
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
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
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
      return "${place.locality}, ${place.administrativeArea}, ${place.country}";
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
