import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/constant/app_text_styles.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/core/utility/utility.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';
import 'dart:ui' as ui;
import 'dart:async';

class IftarTimeCounter extends StatelessWidget {
  final ThemeData theme;
  const IftarTimeCounter({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final HomePresenter presenter = loadPresenter(
      HomePresenter(
        locationService: locator(),
        prayerTimeService: locator(),
        dateService: locator(),
        timerService: locator(),
        preferencesService: locator(),
        logger: locator(),
      ),
    );
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return _buildCircularProgressTimer(context, presenter);
      },
    );
  }

  // Build circular progress timer widget
  Widget _buildCircularProgressTimer(
    BuildContext context,
    HomePresenter presenter,
  ) {
    final remainingTime = presenter.currentUiState.remainingTime;
    final progressValue = presenter.currentUiState.progressValue ?? 0.0;

    // Determine gradient colors based on theme
    final gradientStartColor = context.color.donutRingGradientStartColor;
    final gradientEndColor = context.color.donutRingGradientEndColor;

    // Choose background image based on theme
    final String backgroundImagePath = _getBackgroundImagePath(context);

    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Use a simpler custom paint instead of CircularProgressIndicator for better performance
          FutureBuilder<ui.Image>(
            future: _loadImage(backgroundImagePath),
            builder: (context, snapshot) {
              return CustomPaint(
                size: Size(294.px, 294.px),
                painter: CircularProgressPainter(
                  progressValue: progressValue,
                  gradientStartColor: gradientStartColor,
                  gradientEndColor: gradientEndColor,
                  backgroundColor: context.color.donutBottomCircleColor,
                  strokeWidth: 20,
                  backgroundImage: snapshot.data,
                ),
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${presenter.currentUiState.nextPrayerName} time',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.color.cardTitleColor,
                  fontFamily: AppTextStyles.inter,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.px,
                ),
              ),
              Text(
                remainingTime ?? '',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: gradientStartColor,
                  fontFamily: AppTextStyles.martianMono,
                  fontSize: 52.px,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Remaining',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.color.cardTitleColor,
                  fontFamily: AppTextStyles.inter,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.px,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final ImageProvider provider = AssetImage(assetPath);
    final ImageStream stream = provider.resolve(const ImageConfiguration());
    Completer<ui.Image> completer = Completer<ui.Image>();

    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        completer.complete(info.image);
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        completer.completeError(exception);
      },
    );

    stream.addListener(listener);
    return completer.future;
  }

  String _getBackgroundImagePath(BuildContext context) {
    // Return different background image based on the theme brightness
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? 'assets/images/circle_bg.png'
        : 'assets/images/circle_bg_light.png';
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progressValue;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final Color backgroundColor;
  final double strokeWidth;
  final ui.Image? backgroundImage;
  final double imagePadding;

  CircularProgressPainter({
    required this.progressValue,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.backgroundColor,
    required this.strokeWidth,
    this.backgroundImage,
    this.imagePadding = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background image if available
    if (backgroundImage != null) {
      final imageSize = Size(
        backgroundImage!.width.toDouble(),
        backgroundImage!.height.toDouble(),
      );

      final srcRect = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);

      // Calculate destination rectangle with padding
      final imageRadius = radius - imagePadding;
      final destRect = Rect.fromCircle(center: center, radius: imageRadius);

      // Draw the image
      canvas.drawImageRect(backgroundImage!, srcRect, destRect, Paint());
    }

    // Draw background circle
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Create gradient for progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = LinearGradient(
      begin: Alignment(-0.76, -0.65),
      end: Alignment(-0.76, 0.65),
      colors: [gradientEndColor, gradientStartColor],
    );

    // Draw progress arc with gradient
    final progressPaint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -1.5708, // Start from top (pi/2)
      progressValue * 6.2832, // Full circle is 2*pi
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progressValue != progressValue ||
        oldDelegate.gradientStartColor != gradientStartColor ||
        oldDelegate.gradientEndColor != gradientEndColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundImage != backgroundImage;
  }
}
