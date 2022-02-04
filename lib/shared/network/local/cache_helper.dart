import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late final SharedPreferences _sharedPreferences;

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getValue(String key) {
    return _sharedPreferences.get(key);
  }

  static Future<bool> saveValue({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);
    if (value is double) return await _sharedPreferences.setDouble(key, value);
    if (value is List<String>) {
      return await _sharedPreferences.setStringList(key, value);
    }
    return Future.error(
        'Invalid value type. Types allowed [String, int, bool, double, List<String>]');
  }

  static Future<bool> removeValue(String key) async {
    return await _sharedPreferences.remove(key);
  }
}
