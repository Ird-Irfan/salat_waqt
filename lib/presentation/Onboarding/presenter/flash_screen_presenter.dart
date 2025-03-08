import 'dart:async';

import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/presentation/Onboarding/presenter/flash_screen_ui_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashScreenPresenter extends BasePresenter<FlashScreenUiState> {
  final Obs<FlashScreenUiState> uiState = Obs(FlashScreenUiState.empty());
  Timer? _navigationTimer;
  static const String _firstRunKey = 'is_first_run';

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
      final prefs = await SharedPreferences.getInstance();
      final isFirstRun = prefs.getBool(_firstRunKey) ?? true;

      if (isFirstRun) {
        // First time - show splash screen and set flag for next time
        await prefs.setBool(_firstRunKey, false);
        startNavigationTimer();
      } else {
        // Not first time - skip splash and go directly to home
        uiState.value = uiState.value.copyWith(
          shouldNavigate: true,
          skipToHome:
              true, // New flag to indicate we should go to home directly
        );
      }
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
    bool isLoggedIn = await isUserLoggedIn();

    // Update UI state to trigger navigation
    uiState.value = uiState.value.copyWith(
      shouldNavigate: true,
      isLoggedIn: isLoggedIn,
    );
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
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      return false;
    }
  }

  // Save login state
  Future<void> saveLoginState(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', isLoggedIn);
    } catch (e) {
      addUserMessage(e.toString());
    }
  }

  // Save user credentials
  Future<void> saveUserCredentials(String userId, String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('username', username);
    } catch (e) {
      addUserMessage(e.toString());
    }
  }

  // Clear user data on logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userId');
      await prefs.remove('username');
    } catch (e) {
      addUserMessage(e.toString());
    }
  }

  // For testing - reset the first run flag
  Future<void> resetFirstRunFlag() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstRunKey, true);
    } catch (e) {
      addUserMessage(e.toString());
    }
  }
}
