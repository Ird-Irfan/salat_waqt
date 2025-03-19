import 'package:fpdart/fpdart.dart';
import 'package:salat_waqt/core/base/base_use_case.dart';
import 'package:salat_waqt/domain/entities/country_entity.dart';
import 'package:salat_waqt/domain/repositories/country_repository.dart';
import 'package:salat_waqt/domain/service/error_message_handler.dart';


class GetCountriesUseCase extends BaseUseCase<List<CountryNameEntity>> {
  final CountryRepository repository;

  GetCountriesUseCase(
    this.repository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, List<CountryNameEntity>>> execute() async {
    return mapResultToEither(() async {
      final List<CountryNameEntity> result = await repository.getAllCountries();
      return result;
    });
  }
}