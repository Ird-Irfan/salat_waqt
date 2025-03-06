import 'package:salat_waqt/domain/repositories/location_repository.dart';

class GetAddressFromCoordinatesUseCase {
  final LocationRepository repository;
  GetAddressFromCoordinatesUseCase({required this.repository});
  Future<String> execute(double latitude, double longitude) async {
    return await repository.getAddressFromCoordinates(latitude, longitude);
  }
}
