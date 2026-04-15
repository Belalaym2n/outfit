import 'dart:convert';
import 'package:dio/dio.dart';
import '../handleErrors/exaption_handler.dart';
import '../handleErrors/result_pattern.dart';
import 'dio_client.dart';

class ApiService {
  static Future<dynamic> request({
    required String endpoint,
    String method = "GET",
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await DioClient.dio!.request(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );

      final res = response.data;

      // لو الرجوع success = false
      if (res is Map && res["success"] == false) {
        final error = (res["errors"] != null
            ? res["errors"].values.first.first ?? res["message"]
            : "Unknown error");

        return Result.failure(error);
      }

      return res;
    } on DioException catch (e) {

      if (e.response != null && e.response?.data != null) {

        final data = e.response!.data;

        if (data is Map && data['errorMessage'] != null) {
          return Result.failure(data['errorMessage'].toString());
        }
      }

      final exception = ExceptionHandler.handleDioException(e);
      final failure = ExceptionHandler.exceptionToFailure(exception);

      return Result.failure(failure.message);
    }
  }

  static Future<dynamic> requestWithFormData({
    required String endpoint,
    String method = "POST",
    Map<String, dynamic>? queryParameters,
    required FormData data,
    Map<String, dynamic>? headers,
    Function(int, int)? onSendProgress, // للتحميل progress
  }) async {
    try {
      final response = await DioClient.dio!.request(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: {
            'Content-Type': 'multipart/form-data',
            ...?headers, // أضف أي headers إضافية
          },
        ),
        onSendProgress: onSendProgress,
      );

      final res = response.data;

      // لو الرجوع success = false
      if (res is Map && res["success"] == false) {
        String error = (res["errors"] is Map && res["errors"].isNotEmpty)
            ? res["errors"].values.first
            : res["message"] ?? "Unknown error";

        return Result.failure(error);
      }

      return res;
    } on DioException catch (e) {
      final exception = ExceptionHandler.handleDioException(e);
      final failure = ExceptionHandler.exceptionToFailure(exception);

      return Result.failure(failure.message);
    }
  }

  // ✅ NEW: helper method لرفع ملف
  static Future<MultipartFile> createMultipartFile({
    required String filePath,
    String? filename,
  }) async {
    return await MultipartFile.fromFile(filePath, filename: filename);
  }
}
