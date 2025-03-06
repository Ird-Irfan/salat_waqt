import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

abstract class LocationRepository {
  Future<Position> getCurrentLocation();
  Future<String> getAddressFromCoordinates(double latitude, double longitude);
  Future<List<Location>> getCoordinatesFromAddress(String address);
}
