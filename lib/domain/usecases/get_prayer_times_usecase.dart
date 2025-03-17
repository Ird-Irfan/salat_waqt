import 'package:salat_waqt/domain/repositories/prayer_time_repository.dart';

class GetPrayerTimesUseCase {
  final PrayerTimeRepository repository;

  GetPrayerTimesUseCase({required this.repository});

  Future<Map<String, dynamic>> execute(
    double latitude,
    double longitude,
    String date,
  ) async {
    return await repository.getPrayerTimes(latitude, longitude, date);
  }

  Future<Map<String, dynamic>> executeWithMadhab(
    double latitude,
    double longitude,
    String date,
    String madhab,
  ) async {
    return await repository.getPrayerTimesWithMadhab(
      latitude,
      longitude,
      date,
      madhab,
    );
  }
}
