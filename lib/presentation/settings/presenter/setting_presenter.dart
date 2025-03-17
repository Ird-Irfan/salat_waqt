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

  @override
  void onInit() {
    super.onInit();
    // Initialize with default Hanafi juristic method
    _currentPrayerTimePresenter.updateJuristicMethod('Hanafi');
  }

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

  // Theme expansion toggle function
  void toggleExpansion() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(isExpanded: !currentState.isExpanded);
  }

  // Theme change function
  void changeTheme(bool isDarkMode) {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(isDarkMode: isDarkMode);
  }

  void toggleExpansionLang() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      isExpandedLang: !currentState.isExpandedLang,
    );
  }

  void selectText(String text) {
    final currentState = currentUiState;
    if (currentState.selectedText == text) {
      uiState.value = currentState.copyWith(selectedText: null);
    } else {
      uiState.value = currentState.copyWith(selectedText: text);
    }
  }

  void toggleExpansionJuristic() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      isExpandedJuristic: !currentState.isExpandedJuristic,
    );
  }

  void selectJuristic(String text) {
    final currentState = currentUiState;
    if (currentState.selectedJuristic == text) {
      uiState.value = currentState.copyWith(selectedJuristic: null);
    } else {
      uiState.value = currentState.copyWith(
        selectedJuristic: text,
        isExpandedJuristic: false,
      );

      _currentPrayerTimePresenter.updateJuristicMethod(text);
    }
  }

  void toggleExpansionRamadan() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      isExpandedRamadan: !currentState.isExpandedRamadan,
    );
  }

  void selectRamadan(String text) {
    final currentState = currentUiState;
    if (currentState.selectedRamadan == text) {
      uiState.value = currentState.copyWith(selectedRamadan: null);
    } else {
      uiState.value = currentState.copyWith(selectedRamadan: text);
    }
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
