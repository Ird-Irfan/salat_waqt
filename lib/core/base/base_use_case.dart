import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:salat_waqt/core/services/logger_service.dart';
import 'package:salat_waqt/domain/service/error_message_handler.dart';

abstract class BaseUseCase<T> {
  final ErrorMessageHandler _errorMessageHandler;
  final LoggerService _logger = LoggerService();

  BaseUseCase(this._errorMessageHandler);

  @protected
  Future<Either<String, T>> mapResultToEither(
    FutureOr<T> Function() function,
  ) async {
    try {
      final T result = await function();
      return right(result);
    } catch (error, stack) {
      _logger.e("Error in use case", error, stack);
      final String errorMessage = _errorMessageHandler.generateErrorMessage(
        error,
      );
      return left(errorMessage);
    }
  }

  @protected
  Future<T> getRight(FutureOr<T> Function() function) async {
    final Either<String, T> result = await mapResultToEither(() => function());
    return result.getRight().getOrElse(
      () => throw Exception('No successful result available'),
    );
  }

  @protected
  Future<void> doVoid(FutureOr<T> Function() function) async {
    await mapResultToEither(() => function());
  }
}
