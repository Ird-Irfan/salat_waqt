import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class PrayerTimeDataSource {
  Future<Map<String, dynamic>> getPrayerTimes(
    double latitude,
    double longitude,
    String date,
  );
}

class PrayerTimeDataSourceImpl implements PrayerTimeDataSource {
  @override
  Future<Map<String, dynamic>> getPrayerTimes(
    double latitude,
    double longitude,
    String date,
  ) async {
    // ... (আপনার পূর্বের _loadPrayerTimes ফাংশনের লজিক এখানে থাকবে)
    var url = Uri.parse(
      'http://api.aladhan.com/v1/timings/$date?latitude=$latitude&longitude=$longitude&method=2',
    );
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['timings'];
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
