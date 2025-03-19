import 'package:salat_waqt/domain/service/error_message_handler.dart';

class ErrorMessageHandlerImpl implements ErrorMessageHandler {
  @override
  String generateErrorMessage(Object error) {
    return error.toString();
  }
} 