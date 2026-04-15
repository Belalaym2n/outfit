import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class DioClient {
  static Dio? dio;

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  // Call once on app start
  static Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();

    dio =
        Dio(
            BaseOptions(
              baseUrl: "http://outfitai.runasp.net/api/",
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
              headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
              },
            ),
          )
          ..interceptors.addAll([
            LogInterceptor(responseBody: true, requestBody: true),
            TokenInterceptor(_storage, _tokenKey), // ← NEW
          ]);

    (dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  static Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  static Future<void> clearToken() => _storage.delete(key: _tokenKey);

  static Future<String?> getToken() => _storage.read(key: _tokenKey);
}

class TokenInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final String _tokenKey;

  const TokenInterceptor(this._storage, this._tokenKey);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _storage.delete(key: _tokenKey); // Stale token → clear silently
    }
    handler.next(err);
  }
}
