import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Save secure data
  static Future<void> write(String key, String? value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Read secure data
  static Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Delete secure data
  static Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    return await _secureStorage.containsKey(key: key);
  }

  /// Delete all data
  static Future<void> clear() async {
    await _secureStorage.deleteAll();
  }
}
