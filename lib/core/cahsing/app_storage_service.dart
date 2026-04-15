
import 'package:flutter/foundation.dart';
import 'package:graduation_proj/core/cahsing/secure_storage.dart';
import 'get_storage_helper.dart';
 import 'app_keys.dart';

/// {@template app_storage_service}
/// Centralized in-memory cache for all user data.
///
/// Loads data ONCE at app startup via [init], then provides fast
/// synchronous access through typed getters. Both secure and non-secure
/// storage are handled internally — callers never need to choose.
///
/// ### Lifecycle
/// ```
/// main() → await AppStorageService.instance.init() → runApp()
/// ```
///
/// ### Usage
/// ```dart
/// final service = AppStorageService.instance;
/// print(service.getName());          // sync – no await
/// await service.updateName('Sara');  // persists + refreshes cache
/// service.isUserLoggedIn();          // bool check
/// await service.clearUserData();     // logout
/// ```
/// {@endtemplate}
class AppStorageService {
  // ─────────────────────────────────────────────
  // Singleton
  // ─────────────────────────────────────────────
  AppStorageService._internal();
  static final AppStorageService instance = AppStorageService._internal();
  factory AppStorageService() => instance;

  // ─────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────
  bool _isInitialized = false;

  // 🔒 Secure fields
  String? _token;
  String? _refreshToken;

  // 📦 Normal fields
  String? _name;
  String? _email;
  String? _phone;
  String? _address;
  String? _adminId;
  String? _companyName;
  String? _section;
  String? _cachedProfileImage;

  // ─────────────────────────────────────────────
  // Init
  // ─────────────────────────────────────────────

  /// Loads all user data from disk into memory.
  ///
  /// Call this **once** in [main] before [runApp].
  /// Safe to call multiple times – subsequent calls act as [reload].
  Future<void> init() async {
    try {
      await _loadSecureData();
      _loadNormalData();
      _isInitialized = true;
      _log('✅ AppStorageService initialised');
      _log(_debugSummary());
    } catch (e, st) {
      // Never crash the app on storage failure.
      _isInitialized = true; // allow app to proceed with defaults
      _log('⚠️  AppStorageService init error: $e\n$st');
    }
  }

  /// Re-reads everything from disk (e.g. after a background update).
  Future<void> reload() async {
    _log('🔄 Reloading AppStorageService cache…');
    _isInitialized = false;
    await init();
  }

  // ─────────────────────────────────────────────
  // Private loaders
  // ─────────────────────────────────────────────

  Future<void> _loadSecureData() async {
    try {
      _token = await SecureStorageHelper.read(AppKeys.taken);
      // _refreshToken = await SecureStorageHelper.read(AppKeys.refreshToken);
    } catch (e) {
      _log('⚠️  SecureStorage read failed (will use nulls): $e');
      // Fields stay null – callers receive default values via getters.
    }
  }

  void _loadNormalData() {
    _name = GetStorageHelper.read<String>(AppKeys.name);
    _email = GetStorageHelper.read<String>(AppKeys.email);
     _address = GetStorageHelper.read<String>(AppKeys.address);

  }

  // ─────────────────────────────────────────────
  // Synchronous Getters
  // ─────────────────────────────────────────────

  /// Returns the cached auth token or an empty string.
  String getToken() => _token ?? '';

  /// Returns the cached refresh token or an empty string.
  String getRefreshToken() => _refreshToken ?? '';

  /// Returns the cached user name or an empty string.
  String getName() => _name ?? '';

  /// Returns the cached email or an empty string.
  String getEmail() => _email ?? '';

  /// Returns the cached phone number or an empty string.
  String getPhone() => _phone ?? '';

  /// Returns the cached address or an empty string.
  String getAddress() => _address ?? '';

  /// Returns the cached admin ID or an empty string.
  String getAdminId() => _adminId ?? '';

  /// Returns the cached company name or an empty string.
  String getCompanyName() => _companyName ?? '';

  /// Returns the cached section or an empty string.
  String getSection() => _section ?? '';

  /// Returns the cached profile image path/URL or null.
  String? getCachedProfileImage() => _cachedProfileImage;

  // ─────────────────────────────────────────────
  // Update Methods  (persist → refresh cache)
  // ─────────────────────────────────────────────

  // /// Saves [value] as the auth token in secure storage and updates the cache.
  // Future<void> updateToken(String? value) async {
  //   await _writeSecure(AppKeys.token, value);
  //   _token = value;
  // }
  //
  // /// Saves [value] as the refresh token in secure storage and updates the cache.
  // Future<void> updateRefreshToken(String? value) async {
  //   await _writeSecure(AppKeys.refreshToken, value);
  //   _refreshToken = value;
  // }

  /// Saves [value] as the user name in normal storage and updates the cache.
  Future<void> updateName(String? value) async {
    await _writeNormal(AppKeys.name, value);
    _name = value;
  }

  /// Saves [value] as the email in normal storage and updates the cache.
  Future<void> updateEmail(String? value) async {
    await _writeNormal(AppKeys.email, value);
    _email = value;
  }




  /// Convenience: persists all core user fields at once (e.g. after login).
  ///
  /// Any field left `null` is skipped and not overwritten.
  Future<void> saveUserSession({
    required String token,
    String? refreshToken,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? adminId,
    String? companyName,
  }) async {
    // await updateToken(token);
    // if (refreshToken != null) await updateRefreshToken(refreshToken);
    if (name != null) await updateName(name);
    if (email != null) await updateEmail(email);

    _log('💾 User session saved');
  }

  // ─────────────────────────────────────────────
  // Smart Helpers
  // ─────────────────────────────────────────────

  /// Returns `true` when a non-empty token is present in the cache.
  bool isUserLoggedIn() => _token != null && _token!.isNotEmpty;

  /// Returns `true` when [init] has been called at least once successfully.
  bool get isInitialized => _isInitialized;

  /// Clears ALL user data from both storages and resets the in-memory cache.
  ///
  /// Call on logout.
  Future<void> clearUserData() async {
    try {
      await SecureStorageHelper.clear();
      await GetStorageHelper.clear();
      _resetMemoryCache();
      _log('🗑️  User data cleared (logout)');
    } catch (e) {
      _log('⚠️  clearUserData error: $e');
    }
  }

  // ─────────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────────

  /// Writes to secure storage with graceful fallback.
  Future<void> _writeSecure(String key, String? value) async {
    try {
      if (value == null) {
        await SecureStorageHelper.delete(key);
      } else {
        await SecureStorageHelper.write(key, value);
      }
    } catch (e) {
      _log('⚠️  SecureStorage write failed for key=$key: $e');
    }
  }

  /// Writes to GetStorage with graceful fallback.
  Future<void> _writeNormal(String key, dynamic value) async {
    try {
      if (value == null) {
        await GetStorageHelper.remove(key);
      } else {
        await GetStorageHelper.write(key, value);
      }
    } catch (e) {
      _log('⚠️  GetStorage write failed for key=$key: $e');
    }
  }

  void _resetMemoryCache() {
    _token = null;
    _refreshToken = null;
    _name = null;
    _email = null;
    _phone = null;
    _address = null;
    _adminId = null;
    _companyName = null;
    _section = null;
    _cachedProfileImage = null;
  }

  String _debugSummary() => '''
  ┌─ AppStorageService cache ─────────────────
  │ name            : ${_name ?? '(empty)'}
  │ email           : ${_email ?? '(empty)'}
  │ phone           : ${_phone ?? '(empty)'}
  │ address         : ${_address ?? '(empty)'}
  │ token           : ${_token != null ? '***set***' : '(empty)'}
  │ isLoggedIn      : ${isUserLoggedIn()}
  └───────────────────────────────────────────''';

  void _log(String message) {
    if (kDebugMode) debugPrint('[AppStorageService] $message');
  }
}