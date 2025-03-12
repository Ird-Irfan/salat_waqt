import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_ui_state.dart';

class SettingsPresenter extends BasePresenter<SettingsUiState> {
  // State management
  final Obs<SettingsUiState> uiState = Obs(SettingsUiState.empty());
  SettingsUiState get currentUiState => uiState.value;

  // Constructor
  SettingsPresenter();

  void toggleDoNotDisturb() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      doNotDisturbEnabled: !currentState.doNotDisturbEnabled,
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
