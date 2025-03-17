import 'package:salat_waqt/data/data_sources/prayer_time_data_source.dart';
import 'package:salat_waqt/domain/repositories/prayer_time_repository.dart';

class PrayerTimeRepositoryImpl implements PrayerTimeRepository {
  final PrayerTimeDataSource prayerTimeDataSource;

  PrayerTimeRepositoryImpl({required this.prayerTimeDataSource});

  @override
  Future<Map<String, dynamic>> getPrayerTimes(
    double latitude,
    double longitude,
    String date,
  ) async {
    return await prayerTimeDataSource.getPrayerTimes(latitude, longitude, date);
  }

  @override
  Future<Map<String, dynamic>> getPrayerTimesWithMadhab(
    double latitude,
    double longitude,
    String date,
    String madhab,
  ) async {
    return await prayerTimeDataSource.getPrayerTimesWithMadhab(
      latitude,
      longitude,
      date,
      madhab,
    );
  }
}
