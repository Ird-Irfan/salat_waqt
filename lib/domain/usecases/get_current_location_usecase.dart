import 'package:geolocator/geolocator.dart';
import 'package:salat_waqt/domain/repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase({required this.repository});

  Future<Position> execute() async {
    return await repository.getCurrentLocation();
  }
}
