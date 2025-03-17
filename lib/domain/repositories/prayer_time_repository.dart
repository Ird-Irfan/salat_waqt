abstract class PrayerTimeRepository {
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
