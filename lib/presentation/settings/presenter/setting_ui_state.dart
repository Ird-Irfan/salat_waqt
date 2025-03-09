import 'package:salat_waqt/core/base/base_ui_state.dart';

class SettingsUiState extends BaseUiState {
  final bool notificationEnabled;
  final bool darkModeEnabled;
  final bool autoUpdateEnabled;

  final bool doNotDisturbEnabled;



  const SettingsUiState({
    required super.userMessage,
    required super.isLoading,
    this.notificationEnabled = false,
    this.darkModeEnabled = false,
    this.autoUpdateEnabled = false,
    this.doNotDisturbEnabled = false,
  });

  factory SettingsUiState.empty() {
    return const SettingsUiState(
      isLoading: false,
      userMessage: '',
      notificationEnabled: false,
      darkModeEnabled: false,
      autoUpdateEnabled: false,
      doNotDisturbEnabled: false,
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
  ];

  SettingsUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? notificationEnabled,
    bool? darkModeEnabled,
    bool? autoUpdateEnabled,
    bool? doNotDisturbEnabled,
  }) {
    return SettingsUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      autoUpdateEnabled: autoUpdateEnabled ?? this.autoUpdateEnabled,
      doNotDisturbEnabled: doNotDisturbEnabled ?? this.doNotDisturbEnabled,
    );
  }
}
