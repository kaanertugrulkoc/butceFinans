import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageKeys {
  static const String UserToken = "user_token";
}

class StorageService extends GetxController {
  late final SharedPreferences _preferences;

  Future<StorageService> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
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
  Future<T?> getValue<T>(String key) async {
    try {
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
      } else {
        throw ArgumentError('Desteklenmeyen Veri Türü');
      }
    } catch (e) {
      print('Veri Eklenirken Hata oluştu');
      return null;
    }
  }

  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (e) {
      print("Keyi Verilen Değer Silinirken Hata oluştu $e");
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      return await _preferences.clear();
    } catch (e) {
      print("Değer temizlenirken Hata oluştu $e");
      return false;
    }
  }

  bool hasKey(String key) {
    return _preferences.containsKey(key);
  }

  Object? getValueOrDefault<T>(String key, T defaultValue) {
    return getValue<T>(key) ?? defaultValue;
  }

  Future<Map<String, dynamic>> getAllValues() async {
    final keys = _preferences.getKeys();
    final map = <String, dynamic>{};
    for (var key in keys) {
      map[key] = _preferences.getKeys();
    }
    return map;
  }
}
