import 'package:salat_waqt/core/base/base_ui_state.dart';

class SettingsUiState extends BaseUiState {
  final bool notificationEnabled;
  final bool darkModeEnabled;
  final bool autoUpdateEnabled;
  final bool doNotDisturbEnabled;
  final bool use24HourFormatEnabled;
  final bool timeAdjustmentEnabled;
  final bool hideIftaarTimeEnabled;




  const SettingsUiState({
    required super.userMessage,
    required super.isLoading,
    this.notificationEnabled = false,
    this.darkModeEnabled = false,
    this.autoUpdateEnabled = false,
    this.doNotDisturbEnabled = false,
    this.use24HourFormatEnabled = false,
    this.timeAdjustmentEnabled = false,
    this.hideIftaarTimeEnabled = false,
  });

  factory SettingsUiState.empty() {
    return const SettingsUiState(
      isLoading: false,
      userMessage: '',
      notificationEnabled: false,
      darkModeEnabled: false,
      autoUpdateEnabled: false,
      doNotDisturbEnabled: false,
      use24HourFormatEnabled: false,
      timeAdjustmentEnabled: false,
      hideIftaarTimeEnabled: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    notificationEnabled,
      darkModeEnabled,
        autoUpdateEnabled,
        doNotDisturbEnabled,
        use24HourFormatEnabled,
        timeAdjustmentEnabled,
        hideIftaarTimeEnabled,
        ];

  SettingsUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? notificationEnabled,
    bool? darkModeEnabled,
    bool? autoUpdateEnabled,
    bool? doNotDisturbEnabled,
    bool? use24HourFormatEnabled,
    bool? timeAdjustmentEnabled,
    bool? hideIftaarTimeEnabled,
  }) {
    return SettingsUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      autoUpdateEnabled: autoUpdateEnabled ?? this.autoUpdateEnabled,
      doNotDisturbEnabled: doNotDisturbEnabled ?? this.doNotDisturbEnabled,
      use24HourFormatEnabled: use24HourFormatEnabled ?? this.use24HourFormatEnabled,
      timeAdjustmentEnabled: timeAdjustmentEnabled ?? this.timeAdjustmentEnabled,
      hideIftaarTimeEnabled: hideIftaarTimeEnabled ?? this.hideIftaarTimeEnabled,
    );
  }
}
