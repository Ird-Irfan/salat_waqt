import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/services/preferences_service.dart';
import 'package:salat_waqt/presentation/Onboarding/presenter/flash_screen_ui_state.dart';

class FlashScreenPresenter extends BasePresenter<FlashScreenUiState> {
  final Obs<FlashScreenUiState> uiState = Obs(FlashScreenUiState.empty());
  Timer? _navigationTimer;

  // Get the preferences service from the service locator
  final PreferencesService _preferencesService =
      GetIt.instance<PreferencesService>();

  FlashScreenUiState get currentUiState => uiState.value;

  @override
  void onInit() {
    super.onInit();
    // Check if this is the first run
    checkIfFirstRun();
  }

  @override
  void onClose() {
    // Clean up timer when presenter is closed
    _navigationTimer?.cancel();
    super.onClose();
  }

  // Check if this is the first time running the app
  Future<void> checkIfFirstRun() async {
    try {
      final isFirstRun = await _preferencesService.isFirstRun();

      if (isFirstRun) {
        // First time - set flag for next time
        await _preferencesService.setFirstRunCompleted();
      }

      // Always show splash screen for 5 seconds, regardless of first run status
      startNavigationTimer();
    } catch (e) {
      // Fall back to showing splash screen if there's an error
      startNavigationTimer();
    }
  }

  // Start the 10-second timer for navigation
  void startNavigationTimer() {
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      checkLoginStatusAndNavigate();
    });
  }

  // Check login status and prepare for navigation
  Future<void> checkLoginStatusAndNavigate() async {
    try {
      bool isLoggedIn = await _preferencesService.isLoggedIn();
      bool isFirstTimeDone = !(await _preferencesService.isFirstRun());

      // Check if location has already been configured
      bool locationConfigured =
          await _preferencesService.hasLocationConfigured();

      // Update UI state to trigger navigation
      uiState.value = uiState.value.copyWith(
        shouldNavigate: true,
        isLoggedIn: isLoggedIn,
        // Skip to home if location has already been configured (not first run)
        skipToHome: isFirstTimeDone && locationConfigured,
      );
    } catch (e) {
      // In case of error, still navigate but don't skip
      uiState.value = uiState.value.copyWith(
        shouldNavigate: true,
        isLoggedIn: false,
        skipToHome: false,
      );
    }
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = uiState.value.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = uiState.value.copyWith(isLoading: loading);
  }

  // Check if user is already logged in
  Future<bool> isUserLoggedIn() async {
    return await _preferencesService.isLoggedIn();
  }

  // Save login state
  Future<void> saveLoginState(bool isLoggedIn) async {
    try {
      await _preferencesService.setLoggedIn(isLoggedIn);
    } catch (e) {
      addUserMessage(e.toString());
    }
  }

  // Save user credentials
  Future<void> saveUserCredentials(String userId, String username) async {
    try {
      await _preferencesService.saveUserCredentials(userId, username);
    } catch (e) {
      addUserMessage(e.toString());
    }
  }

  // Clear user data on logout
  Future<void> logout() async {
    try {
      await _preferencesService.clearUserCredentials();
    } catch (e) {
      addUserMessage(e.toString());
    }
  }

  // For testing - reset the first run flag
  Future<void> resetFirstRunFlag() async {
    try {
      await _preferencesService.setFirstRunCompleted(); // Set to false
      await _preferencesService.init(); // Reinitialize with new values
    } catch (e) {
      addUserMessage(e.toString());
    }
  }
}
