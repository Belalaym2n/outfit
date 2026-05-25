import 'dart:math';
import 'package:dio/dio.dart';
import 'package:graduation_proj/core/debugSystem/logs/app_logger.dart';
import '../debugSystem/logs/log_level.dart';
import '../debugSystem/report/crach_report.dart';
import '../debugSystem/network/network_event.dart';
import '../debugSystem/trace/trace_manager.dart';

import '../debugSystem/logs/log_context.dart';

const _kStartMs = '_obs_start_ms';
const _kRequestId = '_obs_req_id';
const _kTraceId = '_obs_trace_id';



class ObservabilityInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final traceId = TraceManager.instance.currentId ?? 'no-active-trace';
    final requestId = _shortId();

    options.headers['X-Trace-Id'] = traceId;
    options.headers['X-Request-Id'] = requestId;

     options.extra[_kStartMs] = DateTime.now().millisecondsSinceEpoch;
    options.extra[_kRequestId] = requestId;
    options.extra[_kTraceId] = traceId;

    AppLogger.instance.debug(
      'Network',
      '→ ${options.method} ${options.uri}',
      ctx: LogContext(
        traceId: traceId,
        extras: {'requestId': requestId, 'body': _sanitize(options.data)},
      ),
    );

    CrashReporter.instance.addBreadcrumb(
      '${options.method} ${options.path}',
      data: {'requestId': requestId, 'traceId': traceId},
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final opts = response.requestOptions;
    final durationMs = _elapsed(opts);
    final traceId = opts.extra[_kTraceId] as String? ?? 'no-active-trace';
    final requestId = opts.extra[_kRequestId] as String? ?? '?';
    final status = response.statusCode ?? 0;

    // WHY: Use error level for 4xx/5xx even though Dio didn't throw.
    // Some backends return non-2xx with a body (soft errors). We still
    // want them flagged at error level in the log store.
    final level = status >= 400 ? LogLevel.error : LogLevel.info;

    AppLogger.instance.warning(
      'Network',
      '← $status ${opts.method} ${opts.path} [${durationMs}ms]',
      ctx: LogContext(
        traceId: traceId,
        extras: {
          'requestId': requestId,
          'durationMs': durationMs,
          'status': status,
        },
      ),
    );

    // ── Latency warning ────────────────────────────────────────────────────
    // WHY: Automatic slow-request detection with zero configuration.
    // 3 seconds is a reasonable P95 budget for a mobile API call.
    // Adjust this threshold to match your SLA.
    if (durationMs > 3000) {
      log.warning(
        'Network',
        'Slow response: ${durationMs}ms for ${opts.method} ${opts.path}',
        ctx: LogContext(
          traceId: traceId,
          extras: {'url': opts.uri.toString(), 'durationMs': durationMs},
        ),
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final opts = err.requestOptions;
    final durationMs = _elapsed(opts);
    final traceId = opts.extra[_kTraceId] as String? ?? 'no-active-trace';
    final requestId = opts.extra[_kRequestId] as String? ?? '?';
    final category = _classify(err);

    log.error(
      'Network',
      '✗ ${opts.method} ${opts.path} [$category]',
      ctx: LogContext(
        traceId: traceId,
        extras: {
          'requestId': requestId,
          'durationMs': durationMs,
          'status': err.response?.statusCode,
          'category': category.name,
          'dioType': err.type.name,
        },
      ),
      error: err.message,
    );

    // ── Stamp Crashlytics keys ─────────────────────────────────────────────
    // WHY: If a crash occurs AFTER this request fails, the crash report will
    // show which URL was last called and what kind of error it produced.
    // This closes the gap between "crash report" and "root cause".
    CrashReporter.instance
      ..setKey('last_failed_url', opts.uri.toString())
      ..setKey('last_error_trace', traceId)
      ..setKey('last_error_category', category.name);

    handler.next(err);
  }

   int _elapsed(RequestOptions opts) {
    final start = opts.extra[_kStartMs] as int? ?? 0;
    return DateTime.now().millisecondsSinceEpoch - start;
  }

   String _shortId() {
    final rng = Random();
    return rng.nextInt(0xFFFFFFFF).toRadixString(16).padLeft(8, '0');
  }

   NetworkErrorCategory _classify(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return NetworkErrorCategory.timeout;
    }
    if (err.type == DioExceptionType.connectionError) {
      return NetworkErrorCategory.network;
    }
    if (err.response == null) return NetworkErrorCategory.unknown;
    final s = err.response!.statusCode ?? 0;
    if (s >= 400 && s < 500) return NetworkErrorCategory.clientError;
    if (s >= 500) return NetworkErrorCategory.serverError;
    return NetworkErrorCategory.unknown;
  }


  dynamic _sanitize(dynamic body) {
    if (body == null) return null;
    if (body is FormData) {
      return {
        'type': 'FormData',
        'fields': body.fields.length,
        'files': body.files.length,
      };
    }
    if (body is String && body.length > 500) {
      return '[truncated: ${body.length} chars]';
    }
    return body;
  }
}
