import 'package:salat_waqt/core/base/base_ui_state.dart';

class CurrentPrayerTimeUiState extends BaseUiState {
  final Map<String, dynamic>? prayerTimes;
  final bool isCurrentPrayerTimeExpanded;
  final double currentPrayerTimeHeight;
  final String? currentWaqt;
  final String? currentTime;
  final String? nextPrayerTime;
  final String? nextPrayerWaqt;
  final Map<String, bool> notificationStatus;

  const CurrentPrayerTimeUiState({
    required super.userMessage,
    required super.isLoading,
    this.prayerTimes,
    this.isCurrentPrayerTimeExpanded = false,
    this.currentPrayerTimeHeight = 236,
    this.currentWaqt,
    this.currentTime,
    this.nextPrayerTime,
    this.nextPrayerWaqt,
    this.notificationStatus = const {
      'Fajr': false,
      'Dhuhr': false,
      'Asr': false,
      'Maghrib': false,
      'Isha': false,
    },
  });

  factory CurrentPrayerTimeUiState.empty() {
    return const CurrentPrayerTimeUiState(
      isLoading: false,
      userMessage: '',
      prayerTimes: null,
      isCurrentPrayerTimeExpanded: false,
      currentPrayerTimeHeight: 236,
      currentWaqt: 'DUHUR',
      currentTime: null,
      nextPrayerTime: null,
      nextPrayerWaqt: null,
      notificationStatus: {
        'Fajr': false,
        'Dhuhr': false,
        'Asr': false,
        'Maghrib': false,
        'Isha': false,
      },
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
    );
  }
}
