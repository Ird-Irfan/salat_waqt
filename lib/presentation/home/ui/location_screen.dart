import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salat_waqt/core/base/base_presenter.dart';
import 'package:salat_waqt/core/di/service_locator.dart';
import 'package:salat_waqt/core/external_libs/presentable_widget_builder.dart';
import 'package:salat_waqt/presentation/home/presenter/home_presenter.dart';

// Custom painter for circular progress
class CircularProgressPainter extends CustomPainter {
  final double progressValue;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progressValue,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint =
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // Start from top (pi/2)
      progressValue * 6.2832, // Full circle is 2*pi
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progressValue != progressValue ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class LocationScreen extends StatelessWidget {
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

  LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('নামাজের সময়')),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          return presenter.currentUiState.isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Date Display Section
                        Card(
                          elevation: 4,
                          margin: EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  presenter.currentUiState.arabicDate ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  presenter.currentUiState.englishDate ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Circular Progress Timer
                        if (presenter.currentUiState.remainingTime != null)
                          _buildCircularProgressTimer(context),

                        SizedBox(height: 20),

                        Text(
                          'আপনার বর্তমান অবস্থান:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          presenter.currentUiState.currentAddress ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Show an indicator if using location permission vs default
                        presenter.currentUiState.locationPermissionGranted ==
                                true
                            ? Chip(
                              label: Text('ডিফল্ট লোকেশন'),
                              backgroundColor: Colors.amber.shade100,
                            )
                            : SizedBox.shrink(),
                        SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _showLocationDialog(
                                  context,
                                ); // লোকেশন পরিবর্তনের ডায়ালগ বক্স
                              },
                              child: Text('লোকেশন পরিবর্তন করুন'),
                            ),
                            SizedBox(width: 10),
                            // Add a refresh location button
                            ElevatedButton(
                              onPressed:
                                  () =>
                                      presenter
                                          .checkAndRequestLocationPermission(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.refresh, size: 16),
                                  SizedBox(width: 5),
                                  Text('লোকেশন আপডেট'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),

                        // Prayer Times Section
                        if (presenter.currentUiState.loadingPrayerTimes)
                          Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  'নামাজের সময় লোড হচ্ছে...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (presenter.currentUiState.prayerTimesError !=
                            null)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  presenter.currentUiState.prayerTimesError!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed:
                                      () =>
                                          presenter
                                              .checkAndRequestLocationPermission(),
                                  child: Text('আবার চেষ্টা করুন'),
                                ),
                              ],
                            ),
                          )
                        else if (presenter.currentUiState.prayerTimes != null)
                          Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    'নামাজের সময়সূচী:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),

                                  // Ramadan Special Times
                                  if (presenter.currentUiState.prayerTimes!
                                          .containsKey('Sehri') &&
                                      presenter.currentUiState.prayerTimes!
                                          .containsKey('Iftar'))
                                    // Wrap with RepaintBoundary to isolate painting operations
                                    RepaintBoundary(
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        margin: EdgeInsets.only(bottom: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.green.shade200,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              'রমজানের সময়সূচী',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade700,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            _buildPrayerTimeRow(
                                              'সেহরি',
                                              presenter
                                                  .currentUiState
                                                  .prayerTimes!['Sehri'],
                                              Colors.blue.shade700,
                                            ),
                                            Divider(),
                                            _buildPrayerTimeRow(
                                              'ইফতার',
                                              presenter
                                                  .currentUiState
                                                  .prayerTimes!['Iftar'],
                                              Colors.orange.shade700,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  // Regular Prayer Times
                                  // Wrap prayer times in a RepaintBoundary to optimize rendering
                                  RepaintBoundary(
                                    child: Column(
                                      children: [
                                        _buildPrayerTimeRow(
                                          'ফজর',
                                          presenter
                                              .currentUiState
                                              .prayerTimes!['Fajr'],
                                          Colors.indigo,
                                        ),
                                        Divider(),
                                        _buildPrayerTimeRow(
                                          'যোহর',
                                          presenter
                                              .currentUiState
                                              .prayerTimes!['Dhuhr'],
                                          Colors.indigo,
                                        ),
                                        Divider(),
                                        _buildPrayerTimeRow(
                                          'আসর',
                                          presenter
                                              .currentUiState
                                              .prayerTimes!['Asr'],
                                          Colors.indigo,
                                        ),
                                        Divider(),
                                        _buildPrayerTimeRow(
                                          'মাগরিব',
                                          presenter
                                              .currentUiState
                                              .prayerTimes!['Maghrib'],
                                          Colors.indigo,
                                        ),
                                        Divider(),
                                        _buildPrayerTimeRow(
                                          'ঈশা',
                                          presenter
                                              .currentUiState
                                              .prayerTimes!['Isha'],
                                          Colors.indigo,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Container(),
                      ],
                    ),
                  ),
                ),
              );
        },
      ),
    );
  }

  // Build circular progress timer widget
  Widget _buildCircularProgressTimer(BuildContext context) {
    final nextPrayerName = presenter.currentUiState.nextPrayerName;
    final remainingTime = presenter.currentUiState.remainingTime;
    final progressValue = presenter.currentUiState.progressValue ?? 0.0;

    // Determine color based on next prayer
    Color progressColor = Colors.blue;
    if (nextPrayerName == 'ইফতার') {
      progressColor = Colors.orange;
    } else if (nextPrayerName == 'সেহরি') {
      progressColor = Colors.blue.shade700;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'পরবর্তী $nextPrayerName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Use repaint boundary to isolate the animation and reduce redraw of parent widgets
            RepaintBoundary(
              child: SizedBox(
                height: 180,
                width: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Use a simpler custom paint instead of CircularProgressIndicator for better performance
                    CustomPaint(
                      size: const Size(180, 180),
                      painter: CircularProgressPainter(
                        progressValue: progressValue,
                        progressColor: progressColor,
                        backgroundColor: Colors.grey.shade200,
                        strokeWidth: 12,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          remainingTime!,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: progressColor,
                          ),
                        ),
                        Text(
                          'ঘন্টা বাকি',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build prayer time rows
  Widget _buildPrayerTimeRow(String prayerName, String time, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayerName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  //  লোকেশন পরিবর্তনের জন্য ডায়ালগ বক্স
  Future<void> _showLocationDialog(BuildContext context) async {
    String newLocation = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('নতুন লোকেশন দিন'),
          content: TextField(
            onChanged: (value) {
              newLocation = value;
            },
            decoration: InputDecoration(hintText: "শহরের নাম লিখুন"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('বাতিল'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('ঠিক আছে'),
              onPressed: () async {
                if (newLocation.isNotEmpty) {
                  await presenter.changeLocation(newLocation);
                }
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
