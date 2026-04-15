import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';
import 'app_exception.dart';
import 'error_model.dart';
import 'failures.dart';

class ExceptionHandler {
  /// Handle DioException and convert to appropriate exception
  ///
  /// معالجة DioException وتحويلها إلى AppException مناسبة
  /// يدعم أنواع الأخطاء التالية:
  /// - connectionTimeout: انتهاء مهلة الاتصال
  /// - sendTimeout: انتهاء مهلة الإرسال
  /// - receiveTimeout: انتهاء مهلة الاستقبال
  /// - connectionError: خطأ في الاتصال
  /// - cancel: إلغاء الطلب
  /// - badCertificate: خطأ في الشهادة
  /// - badResponse: خطأ في الاستجابة (4xx, 5xx)
  /// - unknown: خطأ غير معروف

  static AppException handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: LocaleKeys.dio_Errors_connection_timeout.tr(),
          code: 'TIMEOUT',
          originalError: e,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: LocaleKeys.dio_Errors_no_internet_connection.tr(),
          code: 'NO_CONNECTION',
          originalError: e,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          message: LocaleKeys.dio_Errors_request_cancelled.tr(),
          code: 'CANCELLED',
          originalError: e,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: LocaleKeys.dio_Errors_bad_certificate.tr(),
          code: 'BAD_CERTIFICATE',
          originalError: e,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(e);

      case DioExceptionType.unknown:
        return NetworkException(
          message: LocaleKeys.dio_Errors_unexpected_error.tr(),
          code: 'UNKNOWN',
          originalError: e,
        );
    }
  }

  static AppException _handleBadResponse(DioException e) {
    final response = e.response;
    final statusCode = response?.statusCode;

    ErrorModel errorModel;
    try {
      errorModel = ErrorModel.fromJson(response?.data ?? {});
    } catch (_) {
      errorModel = ErrorModel(
        message: _getDefaultErrorMessage(statusCode),
        status: statusCode?.toString(),
      );
    }

    return ServerException(
      errorModel: errorModel,
      code: statusCode?.toString(),
      originalError: e,
    );
  }

  static String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return LocaleKeys.dio_Errors_error_400.tr();
      case 401:
        return LocaleKeys.dio_Errors_error_401.tr();
      case 403:
        return LocaleKeys.dio_Errors_error_403.tr();
      case 404:
        return LocaleKeys.dio_Errors_error_404.tr();
      case 422:
        return LocaleKeys.dio_Errors_error_422.tr();
      case 500:
        return LocaleKeys.dio_Errors_error_500.tr();
      case 502:
        return LocaleKeys.dio_Errors_error_502.tr();
      case 503:
        return LocaleKeys.dio_Errors_error_503.tr();
      default:
        return LocaleKeys.dio_Errors_error_default.tr(
          args: ['${statusCode ?? ''}'],
        );
    }
  }

  /// Convert exception to failure
  static Failure exceptionToFailure(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.errorModel?.userMessage ?? exception.message,
        errorModel: exception.errorModel,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(message: exception.message);
    } else {
      return UnknownFailure(message: exception.message);
    }
  }
}

/// Legacy function for backward compatibility
@Deprecated('Use ExceptionHandler.handleDioException instead')
void handelDioException(DioException e) {
  throw ExceptionHandler.handleDioException(e);
}
