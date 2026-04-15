import 'package:get_storage/get_storage.dart';
import 'package:graduation_proj/core/cahsing/get_storage_helper.dart';

import 'app_keys.dart' show AppKeys;

class AppData {
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? lang;

  AppData({this.lang, this.name, this.email, this.phone, this.address});
}

class UserLocalService {
  static AppData? cachedUser;

  static void loadUserData() {
    cachedUser = AppData(
      lang: GetStorageHelper.read("lang"),
      name: GetStorageHelper.read(AppKeys.name),
      email: GetStorageHelper.read(AppKeys.email),
      phone: GetStorageHelper.read(AppKeys.phone),
      address: GetStorageHelper.read(AppKeys.address),
    );

    print("User Data Loaded: ${cachedUser?.name} - ${cachedUser?.phone}");
  }
}
