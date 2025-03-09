import 'dart:async';

class TimerService {
  Timer? _timer;

  // Start a periodic timer with the given callback
  void startPeriodicTimer(
    Function callback, {
    Duration period = const Duration(seconds: 60),
  }) {
    // Cancel existing timer if any
    stopTimer();

    // Call the callback immediately
    callback();

    // Set timer to update periodically
    _timer = Timer.periodic(period, (_) => callback());
  }

  // Stop the timer
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Check if the timer is active
  bool get isActive => _timer?.isActive ?? false;
}
