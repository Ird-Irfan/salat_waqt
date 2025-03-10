import 'package:get_it/get_it.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/services/preferences_service.dart';
import 'package:salat_waqt/data/data_sources/location_data_source.dart';
import 'package:salat_waqt/data/data_sources/prayer_time_data_source.dart';
import 'package:salat_waqt/data/repositories/location_repository_impl.dart';
import 'package:salat_waqt/data/repositories/prayer_time_repository_impl.dart';
import 'package:salat_waqt/domain/repositories/location_repository.dart';
import 'package:salat_waqt/domain/repositories/prayer_time_repository.dart';
import 'package:salat_waqt/domain/usecases/get_address_from_coordinates_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_coordinates_from_address_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_current_location_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_prayer_times_usecase.dart';
import 'package:salat_waqt/presentation/Onboarding/presenter/flash_screen_presenter.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_presenter.dart';

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
    // Register PreferencesService as a singleton and initialize it
    final preferencesService = PreferencesService.instance;
    await preferencesService.init();
    _serviceLocator.registerSingleton<PreferencesService>(preferencesService);

    // _serviceLocator.registerLazySingleton(() => QuranDatabase());
  }

  Future<void> _setUpDataSources() async {
    // _serviceLocator
    //     .registerLazySingleton(() => SurahLocalDataSource(database: locator()));
    _serviceLocator.registerLazySingleton<LocationDataSource>(
      () => LocationDataSourceImpl(),
    );
    _serviceLocator.registerLazySingleton<PrayerTimeDataSource>(
      () => PrayerTimeDataSourceImpl(),
    );
  }

  Future<void> _setUpRepositories() async {
    _serviceLocator.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(locationDataSource: locator()),
    );
    _serviceLocator.registerLazySingleton<PrayerTimeRepository>(
      () => PrayerTimeRepositoryImpl(prayerTimeDataSource: locator()),
    );
  }

  Future<void> _setUpUseCases() async {
    // _serviceLocator.registerLazySingleton(() => GetAyahsUseCase(locator()));
    _serviceLocator.registerLazySingleton<GetCurrentLocationUseCase>(
      () => GetCurrentLocationUseCase(repository: locator()),
    );
    _serviceLocator.registerLazySingleton<GetAddressFromCoordinatesUseCase>(
      () => GetAddressFromCoordinatesUseCase(repository: locator()),
    );
    _serviceLocator.registerLazySingleton<GetCoordinatesFromAddressUseCase>(
      () => GetCoordinatesFromAddressUseCase(repository: locator()),
    );
    _serviceLocator.registerLazySingleton<GetPrayerTimesUseCase>(
      () => GetPrayerTimesUseCase(repository: locator()),
    );
  }

  Future<void> _setUpPresenters() async {
    _serviceLocator.registerLazySingleton<HomePresenter>(
      () => HomePresenter(
        getCurrentLocationUseCase: locator(),
        getAddressFromCoordinatesUseCase: locator(),
        getCoordinatesFromAddressUseCase: locator(),
        getPrayerTimesUseCase: locator(), 
        locationService: locator(),
        dateService: locator(),
        timerService: locator(),
        preferencesService: locator(),
        logger: locator(),
        themeService: locator(),
        locationRepository: locator(),
        prayerTimeRepository: locator(),
        locationDataSource: locator(),
        prayerTimeDataSource: locator(), 
        prayerTimeService: locator(),
      ),
    );
    _serviceLocator.registerLazySingleton<FlashScreenPresenter>(
      () => FlashScreenPresenter(),
    );
    _serviceLocator.registerLazySingleton<SettingsPresenter>(
        () => SettingsPresenter(),
      );
  }
}
