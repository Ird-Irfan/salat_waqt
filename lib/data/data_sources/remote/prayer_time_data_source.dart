import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:salat_waqt/core/services/logger_service.dart';

abstract class PrayerTimeDataSource {
  Future<Map<String, dynamic>> getPrayerTimes(
    double latitude,
    double longitude,
    String date,
  );

  Future<Map<String, dynamic>> getPrayerTimesWithMadhab(
    double latitude,
    double longitude,
    String date,
    String madhab,
  );
}

class PrayerTimeDataSourceImpl implements PrayerTimeDataSource {
  final LoggerService _logger = LoggerService();

  @override
  Future<Map<String, dynamic>> getPrayerTimes(
    double latitude,
    double longitude,
    String date,
  ) async {
    try {
      final coordinates = Coordinates(latitude, longitude);

      // Set calculation parameters for Bangladesh
      final params = CalculationMethod.karachi.getParameters();
      params.madhab =
          Madhab.hanafi; // Default: Using Hanafi method for Asr calculation

      // Create DateComponents from the provided date
      DateTime dateTime = DateTime.parse(date);
      final prayerTimes = PrayerTimes(
        coordinates,
        DateComponents(dateTime.year, dateTime.month, dateTime.day),
        params,
      );

      // Format times in 24-hour format
      final timeFormat = DateFormat('HH:mm');

      final Map<String, String> formattedTimes = {
        'Fajr': timeFormat.format(prayerTimes.fajr),
        'Sunrise': timeFormat.format(prayerTimes.sunrise),
        'Dhuhr': timeFormat.format(prayerTimes.dhuhr),
        'Asr': timeFormat.format(prayerTimes.asr),
        'Maghrib': timeFormat.format(prayerTimes.maghrib),
        'Isha': timeFormat.format(prayerTimes.isha),
      };

      // Validate times
      for (var entry in formattedTimes.entries) {
        if (entry.value.isEmpty) {
          throw Exception('Invalid prayer time for ${entry.key}');
        }
      }

      return formattedTimes;
    } catch (e) {
      _logger.e('Error calculating prayer times', e);
      throw Exception('নামাজের সময় গণনা করতে সমস্যা হয়েছে: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getPrayerTimesWithMadhab(
    double latitude,
    double longitude,
    String date,
    String madhab,
  ) async {
    try {
      final coordinates = Coordinates(latitude, longitude);

      // Set calculation parameters for Bangladesh
      final params = CalculationMethod.karachi.getParameters();

      // Set the juristic method based on the parameter
      if (madhab.toLowerCase() == 'hanafi') {
        params.madhab = Madhab.hanafi;
      } else {
        params.madhab = Madhab.shafi;
      }

      // Create DateComponents from the provided date
      DateTime dateTime = DateTime.parse(date);
      final prayerTimes = PrayerTimes(
        coordinates,
        DateComponents(dateTime.year, dateTime.month, dateTime.day),
        params,
      );

      // Format times in 24-hour format
      final timeFormat = DateFormat('HH:mm');

      final Map<String, String> formattedTimes = {
        'Fajr': timeFormat.format(prayerTimes.fajr),
        'Sunrise': timeFormat.format(prayerTimes.sunrise),
        'Dhuhr': timeFormat.format(prayerTimes.dhuhr),
        'Asr': timeFormat.format(prayerTimes.asr),
        'Maghrib': timeFormat.format(prayerTimes.maghrib),
        'Isha': timeFormat.format(prayerTimes.isha),
      };

      // Validate times
      for (var entry in formattedTimes.entries) {
        if (entry.value.isEmpty) {
          throw Exception('Invalid prayer time for ${entry.key}');
        }
      }

      return formattedTimes;
    } catch (e) {
      _logger.e('Error calculating prayer times with madhab', e);
      throw Exception('নামাজের সময় গণনা করতে সমস্যা হয়েছে: $e');
    }
  }
}
