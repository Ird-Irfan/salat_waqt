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
  final String? nextPrayerName;
  final String? remainingTime;
  final double? progressValue;
  final String? nextPrayerTime;
  // Fields for CurrentPrayerTime widget
  final bool isCurrentPrayerTimeExpanded;
  final double currentPrayerTimeHeight;
  final String? currentWaqt;
  final String? currentTime;
  final String? nextPrayerWaqt;
  // Forbidden prayer times
  final List<Map<String, String>>? forbiddenTimes;
  final bool isInForbiddenTime;
  final String? currentForbiddenPeriod;
  final String? currentForbiddenTimeRange;

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
    this.nextPrayerName,
    this.remainingTime,
    this.progressValue,
    this.nextPrayerTime,
    this.isCurrentPrayerTimeExpanded = false,
    this.currentPrayerTimeHeight = 236,
    this.currentWaqt,
    this.currentTime,
    this.nextPrayerWaqt,
    this.forbiddenTimes,
    this.isInForbiddenTime = false,
    this.currentForbiddenPeriod,
    this.currentForbiddenTimeRange,
  });

  factory HomeUiState.empty() {
    return HomeUiState(
      isLoading: false,
      currentAddress: 'Dhaka',
      prayerTimes: null,
      locationPermissionGranted: false,
      englishDate: '',
      arabicDate: '',
      defaultLatitude: 23.8103,
      defaultLongitude: 90.4125,
      userMessage: '',
      loadingPrayerTimes: false,
      prayerTimesError: null,
      nextPrayerName: null,
      remainingTime: null,
      progressValue: 0.0,
      nextPrayerTime: null,
      isCurrentPrayerTimeExpanded: false,
      currentPrayerTimeHeight: 236,
      currentWaqt: 'DUHUR',
      currentTime: null,
      nextPrayerWaqt: null,
      forbiddenTimes: null,
      isInForbiddenTime: false,
      currentForbiddenPeriod: null,
      currentForbiddenTimeRange: null,
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
    nextPrayerName,
    remainingTime,
    progressValue,
    nextPrayerTime,
    isCurrentPrayerTimeExpanded,
    currentPrayerTimeHeight,
    currentWaqt,
    currentTime,
    nextPrayerWaqt,
    forbiddenTimes,
    isInForbiddenTime,
    currentForbiddenPeriod,
    currentForbiddenTimeRange,
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
    String? nextPrayerName,
    String? remainingTime,
    double? progressValue,
    String? nextPrayerTime,
    bool? isCurrentPrayerTimeExpanded,
    double? currentPrayerTimeHeight,
    String? currentWaqt,
    String? nextPrayerWaqt,
    String? currentTime,
    List<Map<String, String>>? forbiddenTimes,
    bool? isInForbiddenTime,
    String? currentForbiddenPeriod,
    String? currentForbiddenTimeRange,
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
      nextPrayerName: nextPrayerName ?? this.nextPrayerName,
      remainingTime: remainingTime ?? this.remainingTime,
      progressValue: progressValue ?? this.progressValue,
      nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
      isCurrentPrayerTimeExpanded:
          isCurrentPrayerTimeExpanded ?? this.isCurrentPrayerTimeExpanded,
      currentPrayerTimeHeight:
          currentPrayerTimeHeight ?? this.currentPrayerTimeHeight,
      currentWaqt: currentWaqt ?? this.currentWaqt,
      currentTime: currentTime ?? this.currentTime,
      nextPrayerWaqt: nextPrayerWaqt ?? this.nextPrayerWaqt,
      forbiddenTimes: forbiddenTimes ?? this.forbiddenTimes,
      isInForbiddenTime: isInForbiddenTime ?? this.isInForbiddenTime,
      currentForbiddenPeriod:
          currentForbiddenPeriod ?? this.currentForbiddenPeriod,
      currentForbiddenTimeRange:
          currentForbiddenTimeRange ?? this.currentForbiddenTimeRange,
    );
  }
}
