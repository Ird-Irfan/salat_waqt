import 'package:get_it/get_it.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/services/date_service.dart';
import 'package:salat_waqt/core/services/location_service.dart';
import 'package:salat_waqt/core/services/logger_service.dart';
import 'package:salat_waqt/core/services/notification_service_impl.dart';
import 'package:salat_waqt/core/services/prayer_time_service.dart';
import 'package:salat_waqt/core/services/preferences_service.dart';
import 'package:salat_waqt/core/services/timer_service.dart';
import 'package:salat_waqt/data/data_sources/remote/location_data_source.dart';
import 'package:salat_waqt/data/data_sources/remote/prayer_time_data_source.dart';
import 'package:salat_waqt/data/repositories/location_repository_impl.dart';
import 'package:salat_waqt/data/repositories/prayer_time_repository_impl.dart';
import 'package:salat_waqt/domain/repositories/location_repository.dart';
import 'package:salat_waqt/domain/repositories/prayer_time_repository.dart';
import 'package:salat_waqt/domain/service/notification_service.dart';
import 'package:salat_waqt/domain/usecases/get_address_from_coordinates_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_coordinates_from_address_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_current_location_usecase.dart';
import 'package:salat_waqt/domain/usecases/get_prayer_times_usecase.dart';
import 'package:salat_waqt/presentation/Onboarding/presenter/flash_screen_presenter.dart';
import 'package:salat_waqt/presentation/home/presenter/current_prayer_time_presenter.dart';
import 'package:salat_waqt/presentation/home/presenter/forbidden_time_presenter.dart';
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
    await locator._setUpServicesDependOnUseCases();
    await locator._setUpPresenters();
  }

  Future<void> _setUpService() async {
    final preferencesService = PreferencesService.instance;
    await preferencesService.init();
    _serviceLocator.registerSingleton<PreferencesService>(preferencesService);
    _serviceLocator.registerSingleton<TimerService>(TimerService());
    _serviceLocator.registerSingleton<LoggerService>(LoggerService());
    _serviceLocator.registerSingleton<DateService>(DateService());

    // Initialize notification service
    final notificationServiceImpl = NotificationServiceImpl(
      logger: LoggerService(),
    );
    await notificationServiceImpl.initialize();
    _serviceLocator.registerSingleton<NotificationService>(
      notificationServiceImpl,
    );
  }

  // Register data sources first (no dependencies)
  Future<void> _setUpDataSources() async {
    _serviceLocator.registerLazySingleton<LocationDataSource>(
      () => LocationDataSourceImpl(),
    );
    _serviceLocator.registerLazySingleton<PrayerTimeDataSource>(
      () => PrayerTimeDataSourceImpl(),
    );
  }

  // Register repositories (depend on data sources)
  Future<void> _setUpRepositories() async {
    _serviceLocator.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(locationDataSource: locator()),
    );
    _serviceLocator.registerLazySingleton<PrayerTimeRepository>(
      () => PrayerTimeRepositoryImpl(prayerTimeDataSource: locator()),
    );
  }

  // Register use cases (depend on repositories)
  Future<void> _setUpUseCases() async {
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

  // Register services that depend on use cases

  Future<void> _setUpServicesDependOnUseCases() async {
    _serviceLocator.registerSingleton<LocationService>(
      LocationService(
        preferencesService: locator(),
        logger: locator(),
        getCurrentLocationUseCase: locator(),
        getAddressFromCoordinatesUseCase: locator(),
        getCoordinatesFromAddressUseCase: locator(),
      ),
    );
    _serviceLocator.registerSingleton<PrayerTimeService>(
      PrayerTimeService(logger: locator(), getPrayerTimesUseCase: locator()),
    );
  }

  Future<void> _setUpPresenters() async {
    _serviceLocator.registerLazySingleton<FlashScreenPresenter>(
      () => FlashScreenPresenter(),
    );
    _serviceLocator.registerLazySingleton<HomePresenter>(
      () => HomePresenter(
        locationService: locator(),
        prayerTimeService: locator(),
        dateService: locator(),
        timerService: locator(),
        preferencesService: locator(),
        logger: locator(),
      ),
    );

    _serviceLocator.registerLazySingleton<CurrentPrayerTimePresenter>(
      () => CurrentPrayerTimePresenter(
        locationService: locator(),
        prayerTimeService: locator(),
        timerService: locator(),
        logger: locator(),
        notificationService: locator(),
      ),
    );
    _serviceLocator.registerLazySingleton<ForbiddenTimePresenter>(
      () => ForbiddenTimePresenter(),
    );
    _serviceLocator.registerLazySingleton<SettingsPresenter>(
      () => SettingsPresenter(
        currentPrayerTimePresenter: locator(),
      ),
    );
  }
}
