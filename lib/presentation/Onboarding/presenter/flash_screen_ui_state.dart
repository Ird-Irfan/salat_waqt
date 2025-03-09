import 'package:flutter/material.dart';
import 'package:salat_waqt/core/base/base_ui_state.dart';

class FlashScreenUiState extends BaseUiState {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final List<Color> buttonGradientColors;
  final TextStyle buttonTextStyle;
  final bool shouldNavigate;
  final bool isLoggedIn;
  final bool skipToHome;

  const FlashScreenUiState({
    required super.isLoading,
    required super.userMessage,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    required this.buttonGradientColors,
    required this.buttonTextStyle,
    required this.shouldNavigate,
    required this.isLoggedIn,
    required this.skipToHome,
  });

  factory FlashScreenUiState.empty() {
    return FlashScreenUiState(
      isLoading: false,
      userMessage: null,
      title: '',
      subtitle: '',
      buttonText: '',
      onButtonPressed: () {},
      buttonGradientColors: [],
      buttonTextStyle: const TextStyle(),
      shouldNavigate: false,
      isLoggedIn: false,
      skipToHome: false,
    );
  }

  @override
  List<Object?> get props => [
    title,
    subtitle,
    buttonText,
    onButtonPressed,
    buttonGradientColors,
    buttonTextStyle,
    shouldNavigate,
    isLoggedIn,
    skipToHome,
  ];

  FlashScreenUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? title,
    String? subtitle,
    String? buttonText,
    VoidCallback? onButtonPressed,
    List<Color>? buttonGradientColors,
    TextStyle? buttonTextStyle,
    bool? shouldNavigate,
    bool? isLoggedIn,
    bool? skipToHome,
  }) {
    return FlashScreenUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      buttonText: buttonText ?? this.buttonText,
      onButtonPressed: onButtonPressed ?? this.onButtonPressed,
      buttonGradientColors: buttonGradientColors ?? this.buttonGradientColors,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      skipToHome: skipToHome ?? this.skipToHome,
    );
  }
}
