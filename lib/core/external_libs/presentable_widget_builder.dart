import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// wrapper around GetX, to decouple this unmaintained library from our codebase
class PresentableWidgetBuilder<T extends DisposableInterface>
    extends StatefulWidget {
  const PresentableWidgetBuilder({
    super.key,
    this.presenter,
    this.onInit,
    this.dispose,
    this.shouldRebuild,
    required this.builder,
  });

  final T? presenter;
  final VoidCallback? onInit;
  final VoidCallback? dispose;
  final bool Function(T?, T?)? shouldRebuild;
  final Widget Function() builder;

  @override
  State<PresentableWidgetBuilder<T>> createState() =>
      _PresentableWidgetBuilderState<T>();
}

class _PresentableWidgetBuilderState<T extends DisposableInterface>
    extends State<PresentableWidgetBuilder<T>> {
  T? _previousState;
  late Widget _cachedWidget;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit!();
    }
    if (widget.presenter != null) {
      // Delay registering the presenter to avoid build phase issues
      Future.microtask(() {
        if (!Get.isRegistered<T>()) {
          Get.put(widget.presenter!);
        }
      });
    }

    // Pre-build the widget to prevent build-time state changes
    _cachedWidget = widget.builder();
    _initialized = true;
  }

  @override
  void dispose() {
    if (widget.dispose != null) {
      widget.dispose!();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a safer approach with Obx but with protection against build-time changes
    return Obx(() {
      final currentState = widget.presenter;

      // First render, return the cached widget
      if (!_initialized) {
        return _cachedWidget;
      }

      if (widget.shouldRebuild != null) {
        if (!widget.shouldRebuild!(_previousState, currentState)) {
          return _cachedWidget;
        }
      }

      _previousState = currentState;

      try {
        // Update the cached widget outside of the build phase
        final newWidget = widget.builder();
        _cachedWidget = newWidget;
        return _cachedWidget;
      } catch (e) {
        // If we encounter an error during build, return the last known good widget
        return _cachedWidget;
      }
    });
  }
}
