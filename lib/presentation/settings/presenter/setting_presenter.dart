import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/services/date_service.dart';
import 'package:salat_waqt/core/services/preferences_service.dart';
import 'package:salat_waqt/presentation/home/presenter/current_prayer_time_presenter.dart';
import 'package:salat_waqt/presentation/settings/presenter/setting_ui_state.dart';

class SettingsPresenter extends BasePresenter<SettingsUiState> {
  // State management
  final Obs<SettingsUiState> uiState = Obs(SettingsUiState.empty());
  SettingsUiState get currentUiState => uiState.value;

  final CurrentPrayerTimePresenter _currentPrayerTimePresenter;
  final DateService _dateService = locator<DateService>();
  final PreferencesService _preferencesService = PreferencesService.instance;
  
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Construct
  SettingsPresenter({
    required CurrentPrayerTimePresenter currentPrayerTimePresenter,
      }) : _currentPrayerTimePresenter = currentPrayerTimePresenter;

  @override
  void onInit() {
    super.onInit();
    // Load saved settings when presenter is initialized
    // We'll use a separate initAsync method to properly await results
    _loadSettingsSync();
  }
  
  // Synchronous initialization that sets defaults but doesn't await results
  void _loadSettingsSync() {
    // Initialize with default values in case preferences aren't loaded yet
    final defaultState = SettingsUiState.empty().copyWith(
      selectedJuristic: 'Hanafi',
      selectedRamadan: 'Bangladesh',
    );
    uiState.value = defaultState;
  }
  
  // This method should be called during app startup to ensure settings 
  // are loaded before the home page is displayed
  Future<void> initAsync() async {
    if (_isInitialized) return;
    
    await _loadSavedSettings();
    _isInitialized = true;
  }
  
  Future<void> _loadSavedSettings() async {
    final doNotDisturb = await _preferencesService.isDoNotDisturbEnabled();
    final use24HourFormat = await _preferencesService.isUse24HourFormatEnabled();
    final timeAdjustment = await _preferencesService.isTimeAdjustmentEnabled();
    final hideIftarTime = await _preferencesService.isHideIftarTimeEnabled();
    final isDarkMode = await _preferencesService.isDarkModeEnabled();
    final selectedJuristic = await _preferencesService.getSelectedJuristic();
    final selectedRamadan = await _preferencesService.getSelectedRamadan();
    final selectedLanguage = await _preferencesService.getSelectedLanguage();
    
    // Update UI state with loaded settings
    uiState.value = currentUiState.copyWith(
      doNotDisturbEnabled: doNotDisturb,
      use24HourFormatEnabled: use24HourFormat,
      timeAdjustmentEnabled: timeAdjustment,
      hideIftaarTimeEnabled: hideIftarTime,
      isDarkMode: isDarkMode,
      selectedJuristic: selectedJuristic,
      selectedRamadan: selectedRamadan,
      selectedText: selectedLanguage,
    );
    
    // Initialize services with loaded settings
    _currentPrayerTimePresenter.updateJuristicMethod(selectedJuristic ?? 'Hanafi');
    _dateService.setCalendarType(selectedRamadan ?? 'Bangladesh');
    _currentPrayerTimePresenter.updateCurrentWaqt(use24HourFormat);
  }
  
  Future<void> _saveSettings() async {
    final state = currentUiState;
    await _preferencesService.saveAllSettings(
      doNotDisturb: state.doNotDisturbEnabled,
      use24HourFormat: state.use24HourFormatEnabled,
      timeAdjustment: state.timeAdjustmentEnabled, 
      hideIftarTime: state.hideIftaarTimeEnabled,
      selectedJuristic: state.selectedJuristic ?? 'Hanafi',
      selectedRamadan: state.selectedRamadan ?? 'Bangladesh',
      isDarkMode: state.isDarkMode,
      selectedLanguage: state.selectedText,
    );
  }

  void toggleDoNotDisturb() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      doNotDisturbEnabled: !currentState.doNotDisturbEnabled,
    );
    _currentPrayerTimePresenter.updateCurrentWaqt(
      currentState.use24HourFormatEnabled,
    );
    _saveSettings();
  }

  void toggleUse24HourFormat(bool value) {
    uiState.value = currentUiState.copyWith(use24HourFormatEnabled: value);
    _currentPrayerTimePresenter.updateCurrentWaqt(value);
    _saveSettings();
  }

  void toggleTimeAdjustment(bool value) {
    _currentPrayerTimePresenter.updateCurrentWaqt(value);
    uiState.value = currentUiState.copyWith(timeAdjustmentEnabled: value);
    _saveSettings();
  }

  void toggleHideIftaarTime() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      hideIftaarTimeEnabled: !currentState.hideIftaarTimeEnabled,
    );
    _saveSettings();
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
    _preferencesService.setDarkMode(isDarkMode);
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
    _preferencesService.setSelectedLanguage(text);
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
      _preferencesService.setSelectedJuristic(text);
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
      uiState.value = currentState.copyWith(
        selectedRamadan: text,
        isExpandedRamadan: false,
      );
      
      // Update the date service with the selected calendar type
      _dateService.setCalendarType(text);
      _preferencesService.setSelectedRamadan(text);
    }
  }

  @override
  Future<void> addUserMessage(String message) {
    throw UnimplementedError();
  }

  @override
  Future<void> toggleLoading({required bool loading}) {
    throw UnimplementedError();
  }
}
