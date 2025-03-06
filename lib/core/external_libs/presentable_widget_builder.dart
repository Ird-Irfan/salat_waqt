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

  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit!();
    }
    if (widget.presenter != null) {
      Get.put(widget.presenter!);
    }
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
    return Obx(() {
      final currentState = widget.presenter;
      if (widget.shouldRebuild != null) {
        if (!widget.shouldRebuild!(_previousState, currentState)) {
          return widget.builder();
        }
      }
      _previousState = currentState;
      return widget.builder();
    });
  }
}
