import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/presentation/home/presenter/bottom_sheet_ui_state.dart';

class BottomSheetPresenter extends BasePresenter<BottomSheetUiState> {
  // State management
  final Obs<BottomSheetUiState> uiState = Obs(BottomSheetUiState.empty());
  BottomSheetUiState get currentUiState => uiState.value;

  // Set UI state
  set currentUiState(BottomSheetUiState state) {
    uiState.value = state;
  }

  // Constructor
  BottomSheetPresenter();

  // Toggle main expansion
  void toggleExpansion() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(isExpanded: !currentState.isExpanded);
  }

  // Select option
  void selectOption(String option) {
    final currentState = currentUiState;
    if (currentState.selectedOption == option) {
      uiState.value = currentState.copyWith(selectedOption: null);
    } else {
      uiState.value = currentState.copyWith(selectedOption: option);
    }
  }

  // Set automatic selection
  void setAutomaticSelection(bool isAutomatic) {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(isAutomaticSelection: isAutomatic);
  }

  // Toggle calculation method expansion
  void toggleCalculationMethodExpansion() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      isCalculationMethodExpanded: !currentState.isCalculationMethodExpanded,
    );
  }

  // Select calculation method
  void selectCalculationMethod(String method) {
    final currentState = currentUiState;
    if (currentState.selectedCalculationMethod == method) {
      uiState.value = currentState.copyWith(selectedCalculationMethod: null);
    } else {
      uiState.value = currentState.copyWith(selectedCalculationMethod: method);
    }
  }

  // Toggle location expansion
  void toggleLocationExpansion() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      isLocationExpanded: !currentState.isLocationExpanded,
    );
  }

  // Select location
  void selectLocation(String location) {
    final currentState = currentUiState;
    if (currentState.selectedLocation == location) {
      uiState.value = currentState.copyWith(selectedLocation: null);
    } else {
      uiState.value = currentState.copyWith(selectedLocation: location);
    }
  }

  // Toggle time format expansion
  void toggleTimeFormatExpansion() {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(
      isTimeFormatExpanded: !currentState.isTimeFormatExpanded,
    );
  }

  // Select time format
  void selectTimeFormat(String format) {
    final currentState = currentUiState;
    if (currentState.selectedTimeFormat == format) {
      uiState.value = currentState.copyWith(selectedTimeFormat: null);
    } else {
      uiState.value = currentState.copyWith(selectedTimeFormat: format);
    }
  }

  @override
  Future<void> addUserMessage(String message) async {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(userMessage: message);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    final currentState = currentUiState;
    uiState.value = currentState.copyWith(isLoading: loading);
  }
}
