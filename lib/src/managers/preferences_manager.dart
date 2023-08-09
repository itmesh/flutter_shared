import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  PreferencesManager({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  // ignore: unused_element
  Future<Map<dynamic, dynamic>> getMap(String key) async {
    final String? encodedMap = _sharedPreferences.getString(key);

    if (encodedMap == null) {
      return <dynamic, dynamic>{};
    }

    return json.decode(encodedMap);
  }

  // ignore: unused_element
  Future<bool> setMap(String key, Map<dynamic, dynamic> map) async {
    final String encodedMap = json.encode(map);

    return await _sharedPreferences.setString(key, encodedMap);
  }

  Future<String?> getString(String key) async {
    return _sharedPreferences.getString(key);
  }

  Future<List<String>?> getStringList(String key) async {
    return _sharedPreferences.getStringList(key);
  }

  Future<bool> setString(String key, String value) async {
    return await _sharedPreferences.setString(key, value);
  }

  Future<int?> getInt(String key) async {
    return _sharedPreferences.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _sharedPreferences.setInt(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _sharedPreferences.setStringList(key, value);
  }
}
