 import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import 'app_keys.dart';

class GetStorageHelper {
  static final GetStorage _box = GetStorage();

  /// Save any value (String, int, bool, List, Map)
  static Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Read value by key
  static T? read<T>(String key) {
    return _box.read<T>(key);
  }
  static void loadUserDataForOrders({
    required TextEditingController phoneController,
    required  TextEditingController addressController,

  }) async {
    final address  =   GetStorageHelper
        .read(AppKeys.address);
    final phone  =   GetStorageHelper
        .read(AppKeys.phone);

    if (phone != null) phoneController.text = phone;
    if (address != null) addressController.text = address;

    print("Cached Data Loaded: Phone: $phone, Address: $address");
  }
  /// Delete value by key
  static Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Check if key exists
  static bool has(String key) {
    return _box.hasData(key);
  }


  /// Clear all data
  static Future<void> clear() async {
    await _box.erase();
  }
}
