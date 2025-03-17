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

  // Load prayer times with a specific juristic method
  Future<Map<String, String>?> loadPrayerTimesWithJuristicMethod(
    double latitude,
    double longitude,
    String juristicMethod,
  ) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      // Convert juristic method string to Madhab enum
      String madhab =
          juristicMethod.toLowerCase() == 'hanafi' ? 'hanafi' : 'shafi';

      var times = await _getPrayerTimesUseCase.executeWithMadhab(
        latitude,
        longitude,
        date,
        madhab,
      );

      if (times.isEmpty) {
        throw Exception('Failed to load prayer times');
      }

      Map<String, String> formattedTimes = _formatPrayerTimes(times);
      _addSpecialTimes(formattedTimes);

      return formattedTimes;
    } catch (e) {
      _logger.e('Error loading prayer times with juristic method', e);
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

  // Reformat prayer times based on 24-hour format preference
  Map<String, String> reformatPrayerTimes(Map<String, String> times, bool use24HourFormat) {
    Map<String, String> reformattedTimes = {};
    times.forEach((prayer, time) {
      try {
        // Check if the time string is already in the desired format
        bool isAlready24Hour = !time.toLowerCase().contains('am') && !time.toLowerCase().contains('pm');
        
        // If current format matches desired format, no conversion needed
        if (isAlready24Hour == use24HourFormat) {
          reformattedTimes[prayer] = time;
        } else {
          // Parse the time string based on its current format
          DateTime prayerTime;
          if (isAlready24Hour) {
            // Convert from 24-hour to 12-hour format
            prayerTime = DateFormat('HH:mm').parse(time);
            reformattedTimes[prayer] = DateFormat('h:mm a').format(prayerTime);
          } else {
            // Convert from 12-hour to 24-hour format
            prayerTime = DateFormat('h:mm a').parse(time);
            reformattedTimes[prayer] = DateFormat('HH:mm').format(prayerTime);
          }
        }
      } catch (e) {
        _logger.e('Error reformatting time for $prayer', e);
        reformattedTimes[prayer] = time; // Keep original if there's an error
      }
    });
    return reformattedTimes;
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
        // Parse time string to DateTime, handling both formats
        DateTime fajrTime;
        String fajrTimeStr = formattedTimes['Fajr']!;
        
        if (fajrTimeStr.toLowerCase().contains('am') || fajrTimeStr.toLowerCase().contains('pm')) {
          fajrTime = DateFormat('h:mm a').parse(fajrTimeStr);
        } else {
          fajrTime = DateFormat('HH:mm').parse(fajrTimeStr);
        }
        
        DateTime sehriTime = fajrTime.subtract(Duration(minutes: 20));
        
        // Format in the same format as the input
        if (fajrTimeStr.toLowerCase().contains('am') || fajrTimeStr.toLowerCase().contains('pm')) {
          formattedTimes['Sehri'] = DateFormat('h:mm a').format(sehriTime);
        } else {
          formattedTimes['Sehri'] = DateFormat('HH:mm').format(sehriTime);
        }
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
      // Parse the time string - try both formats
      DateTime now = DateTime.now();
      DateTime parsedTime;
      
      // Check if the time string includes AM/PM (12-hour format)
      if (timeString.toLowerCase().contains('am') || timeString.toLowerCase().contains('pm')) {
        parsedTime = DateFormat('h:mm a').parse(timeString);
      } else {
        // Assume 24-hour format
        parsedTime = DateFormat('HH:mm').parse(timeString);
      }

      // Combine with today's date
      return DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      _logger.e('Error parsing time: $timeString', e);
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
