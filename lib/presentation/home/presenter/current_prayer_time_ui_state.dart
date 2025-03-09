import 'package:salat_waqt/core/base/base_ui_state.dart';

class CurrentPrayerTimeUiState extends BaseUiState {
  final Map<String, dynamic>? prayerTimes;
  final bool isCurrentPrayerTimeExpanded;
  final double currentPrayerTimeHeight;
  final String? currentWaqt;
  final String? currentTime;
  final String? nextPrayerTime;
  final String? nextPrayerWaqt;

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
    );
  }
}
