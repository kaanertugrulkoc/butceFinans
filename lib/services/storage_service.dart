import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxController {
  late final SharedPreferences _preferences;

  Future<SharedPreferences> init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  Future<bool> setValue<T>(String key, T value) async {
    try {
      if (value is String) {
        return await _preferences.setString(key, value);
      } else if (value is int) {
        return await _preferences.setInt(key, value);
      } else if (value is double) {
        return await _preferences.setDouble(key, value);
      } else if (value is bool) {
        return await _preferences.setBool(key, value);
      } else if (value is List<String>) {
        return await _preferences.setStringList(key, value);
      } else {
        throw ArgumentError('Desteklenmeyen Veri Türü');
      }
    } catch (e) {
      print('Veri Eklenirken Hata oluştu');
      return false;
    }
  }

//getValue<String>("token");
  T? getValue<T>(String key) {
    if (T == String) {
      return _preferences.getString(key) as T;
    } else if (T == int) {
      return _preferences.getInt(key) as T;
    } else if (T == double) {
      return _preferences.getDouble(key) as T;
    } else if (T == bool) {
      return _preferences.getBool(key) as T;
    } else if (T == List<String>) {
      return _preferences.getStringList(key) as T;
    }
  }
}
