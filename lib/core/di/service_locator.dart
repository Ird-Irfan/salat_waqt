import 'package:get_it/get_it.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';

final GetIt _serviceLocator = GetIt.instance;
T locator<T extends Object>() => _serviceLocator.get<T>();
void unloadPresenterManually<T extends BasePresenter>() =>
    unloadPresenterManually<T>();

class ServiceLocator {
  ServiceLocator._();

  static Future<void> setUp({bool startOnlyService = false}) async {
    final ServiceLocator locator = ServiceLocator._();
    await locator._setUpService();
    if (startOnlyService) return;
    await locator._setUpDataSources();
    await locator._setUpRepositories();
    await locator._setUpUseCases();
    await locator._setUpPresenters();
  }

  Future<void> _setUpService() async {
    // _serviceLocator.registerLazySingleton(() => QuranDatabase());
  }

  Future<void> _setUpDataSources() async {
    // _serviceLocator
    //     .registerLazySingleton(() => SurahLocalDataSource(database: locator()));
  }

  Future<void> _setUpRepositories() async {}

  Future<void> _setUpUseCases() async {
    // _serviceLocator.registerLazySingleton(() => GetAyahsUseCase(locator()));
  }

  Future<void> _setUpPresenters() async {}
}
