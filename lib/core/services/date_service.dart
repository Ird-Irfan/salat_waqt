import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class DateService {
  // Current date offset in days (0 = today, -1 = yesterday, 1 = tomorrow)
  int _currentDateOffset = 0;

  // Get formatted English date
  String getEnglishDate() {
    DateTime now = DateTime.now().add(Duration(days: _currentDateOffset));
    return DateFormat('d MMMM yyyy').format(now);
  }

  // Get formatted Arabic/Hijri date
  String getArabicDate() {
    DateTime adjustedDate = DateTime.now().add(
      Duration(days: _currentDateOffset),
    );
    HijriCalendar hijri = HijriCalendar.fromDate(
      adjustedDate.subtract(Duration(days: 1)),
    );
    return hijri.toFormat("dd MMMM yyyy");
  }

  // Get current date in format yyyy-MM-dd
  String getCurrentDateFormatted() {
    DateTime now = DateTime.now().add(Duration(days: _currentDateOffset));
    return DateFormat('yyyy-MM-dd').format(now);
  }

  // Get previous date
  String getPreviousDate(String currentDate) {
    _currentDateOffset -= 1;
    return getEnglishDate();
  }

  // Get next date
  String getNextDate(String currentDate) {
    _currentDateOffset += 1;
    return getEnglishDate();
  }

  // Set English date (accepts a string but modifies the internal offset)
  void setEnglishDate(String date) {
    // This implementation assumes the offset is already updated by getPreviousDate/getNextDate
    // We're just keeping this method for compatibility with the existing code
  }
}
