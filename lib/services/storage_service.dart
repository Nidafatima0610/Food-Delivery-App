import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences prefs;

  StorageService(this.prefs);

  List<String> getFavorites() {
    return prefs.getStringList('favorites') ?? [];
  }

  Future<void> saveFavorites(List<String> favorites) async {
    await prefs.setStringList('favorites', favorites);
  }

  String? getString(String key) => prefs.getString(key);
  Future<void> setString(String key, String value) => prefs.setString(key, value);
  
  List<String> getStringList(String key) => prefs.getStringList(key) ?? [];
  Future<void> setStringList(String key, List<String> value) => prefs.setStringList(key, value);

  bool getBool(String key, {bool defaultValue = false}) => prefs.getBool(key) ?? defaultValue;
  Future<void> setBool(String key, bool value) => prefs.setBool(key, value);
  Future<void> remove(String key) => prefs.remove(key);
}
