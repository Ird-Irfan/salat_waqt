import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class DateService {
  // Get formatted English date
  String getEnglishDate() {
    DateTime now = DateTime.now();
    return DateFormat('d MMMM yyyy').format(now);
  }

  // Get formatted Arabic/Hijri date
  String getArabicDate() {
    HijriCalendar hijri = HijriCalendar.now();
    return hijri.toFormat("dd MMMM yyyy");
  }

  // Get current date in format yyyy-MM-dd
  String getCurrentDateFormatted() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
