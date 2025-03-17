import 'package:salat_waqt/core/base/base_ui_state.dart';

class CurrentPrayerTimeUiState extends BaseUiState {
  final Map<String, dynamic>? prayerTimes;
  final bool isCurrentPrayerTimeExpanded;
  final double currentPrayerTimeHeight;
  final String? currentWaqt;
  final String? currentTime;
  final String? nextPrayerTime;
  final String? nextPrayerWaqt;
  final Map<String, bool>? notificationStatus;
  final bool is24HourFormat;

  const CurrentPrayerTimeUiState({
    required super.userMessage,
    required super.isLoading,
    this.prayerTimes,
    this.isCurrentPrayerTimeExpanded = false,
    this.currentPrayerTimeHeight = 210,
    this.currentWaqt,
    this.currentTime,
    this.nextPrayerTime,
    this.nextPrayerWaqt,
    this.notificationStatus,
    this.is24HourFormat = true,
  });

  factory CurrentPrayerTimeUiState.empty() {
    return const CurrentPrayerTimeUiState(
      isLoading: false,
      userMessage: '',
      prayerTimes: null,
      isCurrentPrayerTimeExpanded: false,
      currentPrayerTimeHeight: 210,
      currentWaqt: 'DUHUR',
      currentTime: null,
      nextPrayerTime: null,
      nextPrayerWaqt: null,
      notificationStatus: null,
      is24HourFormat: false,
    );
  }

  @override
  List<Object?> get props => [
    prayerTimes,
    isLoading,
    userMessage,
    isCurrentPrayerTimeExpanded,
    currentPrayerTimeHeight,
    currentWaqt,
    currentTime,
    nextPrayerTime,
    nextPrayerWaqt,
    notificationStatus,
    is24HourFormat,
  ];

  CurrentPrayerTimeUiState copyWith({
    Map<String, dynamic>? prayerTimes,
    bool? isLoading,
    String? userMessage,
    bool? isCurrentPrayerTimeExpanded,
    double? currentPrayerTimeHeight,
    String? currentWaqt,
    String? currentTime,
    String? nextPrayerTime,
    String? nextPrayerWaqt,
    Map<String, bool>? notificationStatus,
    bool? is24HourFormat,
  }) {
    return CurrentPrayerTimeUiState(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isCurrentPrayerTimeExpanded:
          isCurrentPrayerTimeExpanded ?? this.isCurrentPrayerTimeExpanded,
      currentPrayerTimeHeight:
          currentPrayerTimeHeight ?? this.currentPrayerTimeHeight,
      currentWaqt: currentWaqt ?? this.currentWaqt,
      currentTime: currentTime ?? this.currentTime,
      nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
      nextPrayerWaqt: nextPrayerWaqt ?? this.nextPrayerWaqt,
      notificationStatus: notificationStatus ?? this.notificationStatus,
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
    );
  }
}
