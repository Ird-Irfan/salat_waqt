import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class DateService {
  // Current date offset in days (0 = today, -1 = yesterday, 1 = tomorrow)
  int _currentDateOffset = 0;
  
  // Calendar type: 'Bangladesh' or 'Umm Al-Qura'
  String _calendarType = 'Bangladesh';
  
  // Set calendar type
  void setCalendarType(String type) {
    _calendarType = type;
  }
  
  // Get calendar type
  String getCalendarType() {
    return _calendarType;
  }

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
    
    // For Bangladesh, show normal Hijri date
    // For Umm Al-Qura, subtract 1 day from the Hijri date
    if (_calendarType == 'Bangladesh') {
      // Bangladesh shows the standard date
     HijriCalendar hijri = HijriCalendar.fromDate(
        adjustedDate.subtract(Duration(days: 1)),
      );
      return hijri.toFormat("dd MMMM yyyy");
    } else {
      // Umm Al-Qura subtracts one day
      HijriCalendar hijri = HijriCalendar.fromDate(adjustedDate);
      return hijri.toFormat("dd MMMM yyyy");
    }
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
