import 'package:intl/intl.dart';
import 'package:salat_waqt/core/services/logger_service.dart';
import 'package:salat_waqt/domain/usecases/get_prayer_times_usecase.dart';

class PrayerTimeService {
  final GetPrayerTimesUseCase _getPrayerTimesUseCase;
  final LoggerService _logger;

  PrayerTimeService({
    required GetPrayerTimesUseCase getPrayerTimesUseCase,
    required LoggerService logger,
  }) : _getPrayerTimesUseCase = getPrayerTimesUseCase,
       _logger = logger;

  // Load prayer times for the given coordinates
  Future<Map<String, String>?> loadPrayerTimes(
    double latitude,
    double longitude,
  ) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      var times = await _getPrayerTimesUseCase.execute(
        latitude,
        longitude,
        date,
      );

      if (times.isEmpty) {
        throw Exception('Failed to load prayer times');
      }

      Map<String, String> formattedTimes = _formatPrayerTimes(times);
      _addSpecialTimes(formattedTimes);

      return formattedTimes;
    } catch (e) {
      _logger.e('Error loading prayer times', e);
      return null;
    }
  }

  // Format prayer times
  Map<String, String> _formatPrayerTimes(Map<String, dynamic> times) {
    Map<String, String> formattedTimes = {};
    times.forEach((prayer, time) {
      try {
        DateTime prayerTime = DateFormat('HH:mm').parse(time);
        String formatted = DateFormat('h:mm a').format(prayerTime);
        formattedTimes[prayer] = formatted;
      } catch (e) {
        _logger.e('Error formatting time for $prayer', e);
        throw Exception('Problem formatting time: $prayer');
      }
    });
    return formattedTimes;
  }

  // Add special times like Iftar and Sehri
  void _addSpecialTimes(Map<String, String> formattedTimes) {
    // Add Iftar time (same as Maghrib)
    if (formattedTimes.containsKey('Maghrib')) {
      formattedTimes['Iftar'] = formattedTimes['Maghrib']!;
    }

    // Calculate Sehri time (20 minutes before Fajr)
    if (formattedTimes.containsKey('Fajr')) {
      try {
        DateTime fajrTime = DateFormat('h:mm a').parse(formattedTimes['Fajr']!);
        DateTime sehriTime = fajrTime.subtract(Duration(minutes: 20));
        formattedTimes['Sehri'] = DateFormat('h:mm a').format(sehriTime);
      } catch (e) {
        _logger.e('Error calculating Sehri time', e);
        // Don't throw here, just skip Sehri time if there's an error
      }
    }
  }

  // Parse time string to DateTime
  DateTime? parseTime(String? timeString) {
    if (timeString == null) return null;

    try {
      // Parse the time string (e.g., "5:30 AM")
      DateTime now = DateTime.now();
      DateTime parsedTime = DateFormat('h:mm a').parse(timeString);

      // Combine with today's date
      return DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      _logger.e('Error parsing time', e);
      return null;
    }
  }

  // Format duration to string
  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  // Calculate next prayer time and remaining time
  (String?, String?, double) calculateNextPrayer(
    Map<String, String> prayerTimes,
  ) {
    DateTime now = DateTime.now();
    DateTime? nextPrayerTime;
    String? nextPrayerName;
    double progressValue = 0.0;

    // Check if we're in Ramadan mode (has Sehri and Iftar times)
    bool isRamadanMode =
        prayerTimes.containsKey('Sehri') && prayerTimes.containsKey('Iftar');

    if (isRamadanMode) {
      // Get Iftar and Sehri times
      DateTime? iftarTime = parseTime(prayerTimes['Iftar']);
      DateTime? sehriTime = parseTime(prayerTimes['Sehri']);

      if (iftarTime != null && sehriTime != null) {
        // Create today's and tomorrow's times for comparison
        DateTime todayIftar = iftarTime;
        DateTime todaySehri = sehriTime;

        // If Sehri is after Iftar in the same day, it means Sehri is for the next day
        if (todaySehri.isBefore(todayIftar)) {
          // Sehri is for today, Iftar is for today
          // This is the normal case during Ramadan
        } else {
          // Sehri is for tomorrow, Iftar is for today
          todaySehri = todaySehri.add(Duration(days: 1));
        }

        // If both times are in the past, move to tomorrow
        if (now.isAfter(todayIftar) && now.isAfter(todaySehri)) {
          todayIftar = todayIftar.add(Duration(days: 1));
          todaySehri = todaySehri.add(Duration(days: 1));
        }

        // Determine which is next: Iftar or Sehri
        if (now.isBefore(todayIftar) && now.isBefore(todaySehri)) {
          // Both are in the future, pick the closest one
          if (todayIftar.isBefore(todaySehri)) {
            nextPrayerTime = todayIftar;
            nextPrayerName = 'Iftar';
          } else {
            nextPrayerTime = todaySehri;
            nextPrayerName = 'Sehri';
          }
        } else if (now.isBefore(todayIftar)) {
          // Only Iftar is in the future
          nextPrayerTime = todayIftar;
          nextPrayerName = 'Iftar';
        } else if (now.isBefore(todaySehri)) {
          // Only Sehri is in the future
          nextPrayerTime = todaySehri;
          nextPrayerName = 'Sehri';
        }

        // Calculate progress
        if (nextPrayerName == 'Iftar') {
          // We're waiting for Iftar, so we're between Sehri and Iftar
          // Calculate how much time has passed since Sehri
          DateTime previousSehri = todaySehri.subtract(Duration(days: 1));
          if (now.isBefore(previousSehri)) {
            previousSehri = previousSehri.subtract(Duration(days: 1));
          }

          Duration totalDuration = todayIftar.difference(previousSehri);
          Duration elapsedDuration = now.difference(previousSehri);

          progressValue = elapsedDuration.inMinutes / totalDuration.inMinutes;
        } else if (nextPrayerName == 'Sehri') {
          // We're waiting for Sehri, so we're between Iftar and Sehri
          // Calculate how much time has passed since Iftar
          DateTime previousIftar = todayIftar.subtract(Duration(days: 1));
          if (now.isBefore(previousIftar)) {
            previousIftar = previousIftar.subtract(Duration(days: 1));
          }

          Duration totalDuration = todaySehri.difference(previousIftar);
          Duration elapsedDuration = now.difference(previousIftar);

          progressValue = elapsedDuration.inMinutes / totalDuration.inMinutes;
        }
      }
    } else {
      // Regular prayer time mode
      // Find the next prayer time
      List<MapEntry<String, String>> prayerEntries = [
        MapEntry('Fajr', prayerTimes['Fajr']!),
        MapEntry('Sunrise', prayerTimes['Sunrise']!),
        MapEntry('Dhuhr', prayerTimes['Dhuhr']!),
        MapEntry('Asr', prayerTimes['Asr']!),
        MapEntry('Maghrib', prayerTimes['Maghrib']!),
        MapEntry('Isha', prayerTimes['Isha']!),
      ];

      // Parse all prayer times
      List<MapEntry<String, DateTime>> parsedTimes = [];
      for (var entry in prayerEntries) {
        DateTime? time = parseTime(entry.value);
        if (time != null) {
          // If time is before now, add a day
          if (time.isBefore(now)) {
            time = time.add(Duration(days: 1));
          }
          parsedTimes.add(MapEntry(entry.key, time));
        }
      }

      // Sort by time
      parsedTimes.sort((a, b) => a.value.compareTo(b.value));

      // Find the next prayer
      if (parsedTimes.isNotEmpty) {
        nextPrayerName = parsedTimes.first.key;
        nextPrayerTime = parsedTimes.first.value;

        // Find the previous prayer time
        DateTime previousPrayerTime;
        if (parsedTimes.last.value.subtract(Duration(days: 1)).isAfter(now)) {
          previousPrayerTime = parsedTimes.last.value.subtract(
            Duration(days: 1),
          );
        } else {
          // Find the last prayer time before now
          var previousPrayers =
              parsedTimes
                  .where(
                    (entry) =>
                        entry.value.subtract(Duration(days: 1)).isBefore(now),
                  )
                  .toList();
          previousPrayers.sort((a, b) => b.value.compareTo(a.value));
          previousPrayerTime =
              previousPrayers.isNotEmpty
                  ? previousPrayers.first.value.subtract(Duration(days: 1))
                  : now.subtract(Duration(hours: 1));
        }

        // Calculate progress
        Duration totalDuration = nextPrayerTime.difference(previousPrayerTime);
        Duration elapsedDuration = now.difference(previousPrayerTime);

        progressValue = elapsedDuration.inMinutes / totalDuration.inMinutes;
      }
    }

    progressValue = progressValue.clamp(0.0, 1.0);

    // If we have a next prayer time, calculate remaining time
    String? remainingTime;
    if (nextPrayerTime != null) {
      Duration remainingDuration = nextPrayerTime.difference(now);
      remainingTime = formatDuration(remainingDuration);
    }

    return (nextPrayerName, remainingTime, progressValue);
  }

  // Calculate forbidden prayer times
  List<Map<String, String>> calculateForbiddenTimes(
    Map<String, String> prayerTimes,
  ) {
    try {
      // The three forbidden times:
      // 1. After Fajr until sunrise
      // 2. When sun is at zenith (before Dhuhr)
      // 3. After Asr until sunset

      List<Map<String, String>> forbiddenTimes = [];

      // 1. After Fajr until sunrise
      if (prayerTimes.containsKey('Fajr')) {
        DateTime? fajrTime = parseTime(prayerTimes['Fajr']);
        DateTime? sunriseTime;

        // Check if Sunrise is provided by the API
        if (prayerTimes.containsKey('Sunrise')) {
          sunriseTime = parseTime(prayerTimes['Sunrise']);
        } else {
          // If not, estimate sunrise as approximately 60-90 minutes after Fajr
          // This is a rough estimate and may need adjustment based on location
          if (fajrTime != null) {
            sunriseTime = fajrTime.add(Duration(minutes: 75));
          }
        }

        if (fajrTime != null && sunriseTime != null) {
          String sunriseTimeStr = DateFormat('h:mm a').format(sunriseTime);

          forbiddenTimes.add({
            'name': 'Morning',
            'startTime': prayerTimes['Fajr']!,
            'endTime':
                prayerTimes.containsKey('Sunrise')
                    ? prayerTimes['Sunrise']!
                    : sunriseTimeStr,
            'icon': 'Fajr',
          });
        }
      }

      // 2. When sun is at zenith (before Dhuhr)
      if (prayerTimes.containsKey('Dhuhr')) {
        DateTime? dhuhrTime = parseTime(prayerTimes['Dhuhr']);

        if (dhuhrTime != null) {
          // Calculate zawal time (approximately 15 minutes before Dhuhr)
          DateTime zawalTime = dhuhrTime.subtract(Duration(minutes: 15));
          String formattedZawalTime = DateFormat('h:mm a').format(zawalTime);

          forbiddenTimes.add({
            'name': 'Noon',
            'startTime': formattedZawalTime,
            'endTime': prayerTimes['Dhuhr']!,
            'icon': 'Dhuhr',
          });
        }
      }

      // 3. After Asr until sunset
      if (prayerTimes.containsKey('Asr') &&
          prayerTimes.containsKey('Maghrib')) {
        DateTime? asrTime = parseTime(prayerTimes['Asr']);
        DateTime? maghribTime = parseTime(prayerTimes['Maghrib']);

        if (asrTime != null && maghribTime != null) {
          forbiddenTimes.add({
            'name': 'Evening',
            'startTime': prayerTimes['Asr']!,
            'endTime': prayerTimes['Maghrib']!,
            'icon': 'Asr',
          });
        }
      }

      return forbiddenTimes;
    } catch (e) {
      _logger.e('Error calculating forbidden times', e);
      return [];
    }
  }

  // Check if current time is within any forbidden period
  (bool, String?) isInForbiddenTime(List<Map<String, String>> forbiddenTimes) {
    try {
      DateTime now = DateTime.now();

      for (var period in forbiddenTimes) {
        DateTime? startTime = parseTime(period['startTime']);
        DateTime? endTime = parseTime(period['endTime']);

        if (startTime != null && endTime != null) {
          // Check if current time is between start and end time
          if ((now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) &&
              (now.isBefore(endTime) || now.isAtSameMomentAs(endTime))) {
            return (true, period['name']);
          }
        }
      }

      return (false, null);
    } catch (e) {
      _logger.e('Error checking forbidden time', e);
      return (false, null);
    }
  }

  // Get current active forbidden time period with formatted time range
  String? getCurrentForbiddenTimeRange(
    List<Map<String, String>> forbiddenTimes,
  ) {
    try {
      DateTime now = DateTime.now();

      for (var period in forbiddenTimes) {
        DateTime? startTime = parseTime(period['startTime']);
        DateTime? endTime = parseTime(period['endTime']);

        if (startTime != null && endTime != null) {
          // Check if current time is between start and end time
          if ((now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) &&
              (now.isBefore(endTime) || now.isAtSameMomentAs(endTime))) {
            return '${period['startTime']} - ${period['endTime']}';
          }
        }
      }

      return null;
    } catch (e) {
      _logger.e('Error getting current forbidden time range', e);
      return null;
    }
  }
}
