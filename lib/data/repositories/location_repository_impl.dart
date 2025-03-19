import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:salat_waqt/data/data_sources/remote/location_data_source.dart';
import 'package:salat_waqt/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource locationDataSource;

  LocationRepositoryImpl({required this.locationDataSource});

  @override
  Future<Position> getCurrentLocation() async {
    return await locationDataSource.getCurrentPosition();
  }

  @override
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    return await locationDataSource.getAddressFromLatLng(latitude, longitude);
  }

  @override
  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    return await locationDataSource.getCoordinatesFromAddress(address);
  }
}
