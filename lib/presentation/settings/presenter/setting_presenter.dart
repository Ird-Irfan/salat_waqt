import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/presentation/home/presenter/current_prayer_time_presenter.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_ui_state.dart';

class SettingsPresenter extends BasePresenter<SettingsUiState> {
  // State management
  final Obs<SettingsUiState> uiState = Obs(SettingsUiState.empty());
  SettingsUiState get currentUiState => uiState.value;

  final CurrentPrayerTimePresenter _currentPrayerTimePresenter;

  // Construct
  SettingsPresenter({
    required CurrentPrayerTimePresenter currentPrayerTimePresenter,
  }) : _currentPrayerTimePresenter = currentPrayerTimePresenter;

  void toggleDoNotDisturb() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      doNotDisturbEnabled: !currentState.doNotDisturbEnabled,
    );
    _currentPrayerTimePresenter.updateCurrentWaqt(
      currentState.use24HourFormatEnabled,
    );
  }

  void toggleUse24HourFormat(bool value) {
    uiState.value = currentUiState.copyWith(use24HourFormatEnabled: value);
    _currentPrayerTimePresenter.updateCurrentWaqt(value);
  }

  void toggleTimeAdjustment(bool value) {
    _currentPrayerTimePresenter.updateCurrentWaqt(value);
    uiState.value = currentUiState.copyWith(timeAdjustmentEnabled: value);
  }

  void toggleHideIftaarTime() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      hideIftaarTimeEnabled: !currentState.hideIftaarTimeEnabled,
    );
  }

  // void toggleUse24HourFormat() {
  //   final currentState = currentUiState;
  //   uiState.value = currentState.copyWith(
  //     use24HourFormatEnabled: !currentState.use24HourFormatEnabled,
  //   );
  // }

  // void toggleSelectedJuristic() {
  //   final currentState = currentUiState;
  //   uiState.value = currentState.copyWith(
  //     selectedJuristic: !currentState.selectedJuristic,
  //   );
  // }

  @override
  Future<void> addUserMessage(String message) {
    throw UnimplementedError();
  }

  @override
  Future<void> toggleLoading({required bool loading}) {
    throw UnimplementedError();
  }
}
