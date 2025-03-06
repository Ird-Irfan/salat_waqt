import 'package:geocoding/geocoding.dart';
import 'package:salat_waqt/domain/repositories/location_repository.dart';

class GetCoordinatesFromAddressUseCase {
  final LocationRepository repository;

  GetCoordinatesFromAddressUseCase({required this.repository});

  Future<List<Location>> execute(String address) async {
    return await repository.getCoordinatesFromAddress(address);
  }
}
