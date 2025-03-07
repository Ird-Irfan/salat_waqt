import 'package:salat_waqt/core/base/base_ui_state.dart';

class HomeUiState extends BaseUiState {
  final String? currentAddress;
  final Map<String, dynamic>? prayerTimes;
  final bool? locationPermissionGranted;
  final String? englishDate;
  final String? arabicDate;
  final double? defaultLatitude;
  final double? defaultLongitude;
  final bool loadingPrayerTimes;
  final String? prayerTimesError;

  const HomeUiState({
    required super.userMessage,
    required super.isLoading,
    this.currentAddress,
    this.prayerTimes,
    this.locationPermissionGranted,
    this.englishDate,
    this.arabicDate,
    this.defaultLatitude,
    this.defaultLongitude,
    this.loadingPrayerTimes = false,
    this.prayerTimesError,
  });

  factory HomeUiState.empty() {
    return HomeUiState(
      isLoading: false,
      currentAddress: 'ঢাকা',
      prayerTimes: null,
      locationPermissionGranted: false,
      englishDate: '',
      arabicDate: '',
      defaultLatitude: 23.8103,
      defaultLongitude: 90.4125,
      userMessage: '',
      loadingPrayerTimes: false,
      prayerTimesError: null,
    );
  }

  @override
  List<Object?> get props => [
    currentAddress,
    prayerTimes,
    isLoading,
    locationPermissionGranted,
    englishDate,
    arabicDate,
    defaultLatitude,
    defaultLongitude,
    loadingPrayerTimes,
    prayerTimesError,
  ];

  HomeUiState copyWith({
    String? currentAddress,
    Map<String, dynamic>? prayerTimes,
    bool? locationPermissionGranted,
    String? englishDate,
    String? arabicDate,
    bool? isLoading,
    String? userMessage,
    double? defaultLatitude,
    double? defaultLongitude,
    bool? loadingPrayerTimes,
    String? prayerTimesError,
  }) {
    return HomeUiState(
      currentAddress: currentAddress ?? this.currentAddress,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      locationPermissionGranted:
          locationPermissionGranted ?? this.locationPermissionGranted,
      englishDate: englishDate ?? this.englishDate,
      arabicDate: arabicDate ?? this.arabicDate,
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      defaultLatitude: defaultLatitude ?? this.defaultLatitude,
      defaultLongitude: defaultLongitude ?? this.defaultLongitude,
      loadingPrayerTimes: loadingPrayerTimes ?? this.loadingPrayerTimes,
      prayerTimesError: prayerTimesError ?? this.prayerTimesError,
    );
  }
}
