abstract class PrayerTimeRepository {
  Future<Map<String, dynamic>> getPrayerTimes(
    double latitude,
    double longitude,
    String date,
  );
}
