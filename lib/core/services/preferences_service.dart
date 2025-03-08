import 'package:shared_preferences/shared_preferences.dart';

/// A service class to handle all SharedPreferences operations in the app.
///
/// This class centralizes all SharedPreferences access to make it easier
/// to maintain and modify preferences handling.
class PreferencesService {
  // Singleton pattern
  static final PreferencesService _instance = PreferencesService._internal();
  static PreferencesService get instance => _instance;
  PreferencesService._internal();

  // SharedPreferences instance
  SharedPreferences? _preferences;

  // Initialize the preferences service
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Keys for preferences
  static const String _keyIsFirstRun = 'is_first_run';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserId = 'userId';
  static const String _keyUsername = 'username';
  static const String _keyLocationEnabled = 'location_enabled';
  static const String _keyLatitude = 'latitude';
  static const String _keyLongitude = 'longitude';
  static const String _keyDefaultLocation = 'default_location';

  // Methods for first run state
  Future<bool> isFirstRun() async {
    _assertInit();
    return _preferences!.getBool(_keyIsFirstRun) ?? true;
  }

  Future<void> setFirstRunCompleted() async {
    _assertInit();
    await _preferences!.setBool(_keyIsFirstRun, false);
  }

  // Methods for login state
  Future<bool> isLoggedIn() async {
    _assertInit();
    return _preferences!.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    _assertInit();
    await _preferences!.setBool(_keyIsLoggedIn, value);
  }

  // Methods for user data
  Future<String?> getUserId() async {
    _assertInit();
    return _preferences!.getString(_keyUserId);
  }

  Future<String?> getUsername() async {
    _assertInit();
    return _preferences!.getString(_keyUsername);
  }

  Future<void> saveUserCredentials(String userId, String username) async {
    _assertInit();
    await _preferences!.setString(_keyUserId, userId);
    await _preferences!.setString(_keyUsername, username);
  }

  Future<void> clearUserCredentials() async {
    _assertInit();
    await _preferences!.remove(_keyUserId);
    await _preferences!.remove(_keyUsername);
    await _preferences!.remove(_keyIsLoggedIn);
  }

  // Methods for location data
  Future<bool> isLocationEnabled() async {
    _assertInit();
    return _preferences!.getBool(_keyLocationEnabled) ?? false;
  }

  Future<void> setLocationEnabled(bool value) async {
    _assertInit();
    await _preferences!.setBool(_keyLocationEnabled, value);
  }

  Future<double?> getLatitude() async {
    _assertInit();
    return _preferences!.getDouble(_keyLatitude);
  }

  Future<void> setLatitude(double latitude) async {
    _assertInit();
    await _preferences!.setDouble(_keyLatitude, latitude);
  }

  Future<double?> getLongitude() async {
    _assertInit();
    return _preferences!.getDouble(_keyLongitude);
  }

  Future<void> setLongitude(double longitude) async {
    _assertInit();
    await _preferences!.setDouble(_keyLongitude, longitude);
  }

  Future<void> saveLocationCoordinates(
    double latitude,
    double longitude,
  ) async {
    _assertInit();
    await _preferences!.setDouble(_keyLatitude, latitude);
    await _preferences!.setDouble(_keyLongitude, longitude);
    await _preferences!.setBool(_keyLocationEnabled, true);
  }

  Future<String?> getDefaultLocation() async {
    _assertInit();
    return _preferences!.getString(_keyDefaultLocation);
  }

  Future<void> setDefaultLocation(String location) async {
    _assertInit();
    await _preferences!.setString(_keyDefaultLocation, location);
    await _preferences!.setBool(_keyLocationEnabled, false);
  }

  Future<bool> hasLocationConfigured() async {
    _assertInit();
    return _preferences!.containsKey(_keyLocationEnabled);
  }

  // Clear all preferences (for logout or reset)
  Future<void> clearAll() async {
    _assertInit();
    await _preferences!.clear();
  }

  // Helper method to ensure initialization
  void _assertInit() {
    if (_preferences == null) {
      throw StateError(
        'PreferencesService must be initialized before use. Call init() first.',
      );
    }
  }
}
