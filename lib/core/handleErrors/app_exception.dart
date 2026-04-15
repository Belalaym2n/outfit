import 'package:dio/dio.dart';

import 'error_model.dart';
import 'failures.dart';

/// Base exception class for all server-related exceptions
///
/// هذا الكلاس الأساسي لجميع الاستثناءات في التطبيق
/// يحتوي على:
/// - message: رسالة الخطأ
/// - code: كود الخطأ (اختياري)
/// - originalError: الخطأ الأصلي (للتتبع)
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => 'AppException: $message';
}

/// Server exception for API-related errors
class ServerException extends AppException {
  final ErrorModel errorModel;

  ServerException({required this.errorModel, super.code, super.originalError})
      : super(message: errorModel.message);

  @override
  String toString() => 'ServerException: ${errorModel.message}';
}

/// Network exception for connection-related errors
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Cache exception for local storage errors
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Validation exception for input validation errors
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception handler for Dio exceptions
///
/// هذا الكلاس المسؤول عن تحويل DioException إلى AppException مناسبة
/// يدعم جميع أنواع أخطاء Dio ويحولها إلى استثناءات مفهومة
