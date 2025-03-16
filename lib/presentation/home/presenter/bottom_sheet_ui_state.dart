import 'package:salat_waqt/core/base/base_ui_state.dart';

class BottomSheetUiState extends BaseUiState {
  final bool isExpanded;
  final String? selectedOption;
  final bool isCalculationMethodExpanded;
  final String? selectedCalculationMethod;
  final bool isLocationExpanded;
  final String? selectedLocation;
  final bool isTimeFormatExpanded;
  final String? selectedTimeFormat;
  final bool isAutomaticSelection;

  const BottomSheetUiState({
    required super.userMessage,
    required super.isLoading,
    this.isExpanded = false,
    this.selectedOption,
    this.isCalculationMethodExpanded = false,
    this.selectedCalculationMethod,
    this.isLocationExpanded = false,
    this.selectedLocation,
    this.isTimeFormatExpanded = false,
    this.selectedTimeFormat,
    this.isAutomaticSelection = true,
  });

  factory BottomSheetUiState.empty() {
    return const BottomSheetUiState(
      isLoading: false,
      userMessage: '',
      isExpanded: false,
      selectedOption: null,
      isCalculationMethodExpanded: false,
      selectedCalculationMethod: null,
      isLocationExpanded: false,
      selectedLocation: null,
      isTimeFormatExpanded: false,
      selectedTimeFormat: null,
      isAutomaticSelection: true,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    isExpanded,
    selectedOption,
    isCalculationMethodExpanded,
    selectedCalculationMethod,
    isLocationExpanded,
    selectedLocation,
    isTimeFormatExpanded,
    selectedTimeFormat,
    isAutomaticSelection,
  ];

  BottomSheetUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isExpanded,
    String? selectedOption,
    bool? isCalculationMethodExpanded,
    String? selectedCalculationMethod,
    bool? isLocationExpanded,
    String? selectedLocation,
    bool? isTimeFormatExpanded,
    String? selectedTimeFormat,
    bool? isAutomaticSelection,
  }) {
    return BottomSheetUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isExpanded: isExpanded ?? this.isExpanded,
      selectedOption: selectedOption ?? this.selectedOption,
      isCalculationMethodExpanded:
          isCalculationMethodExpanded ?? this.isCalculationMethodExpanded,
      selectedCalculationMethod:
          selectedCalculationMethod ?? this.selectedCalculationMethod,
      isLocationExpanded: isLocationExpanded ?? this.isLocationExpanded,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isTimeFormatExpanded: isTimeFormatExpanded ?? this.isTimeFormatExpanded,
      selectedTimeFormat: selectedTimeFormat ?? this.selectedTimeFormat,
      isAutomaticSelection: isAutomaticSelection ?? this.isAutomaticSelection,
    );
  }
}
