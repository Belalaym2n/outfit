
// ===== file: core/observability/network/network_event.dart =====

// WHY: A typed model for network events lets you treat HTTP traffic as
//      structured data rather than formatted strings.
// BENEFIT: You can query your log store for:
//   - All TIMEOUT events in the last 24h
//   - All SERVER_ERROR events for /api/Outfit/analyze
//   - Average durationMs per endpoint (primitive APM)
//   Without this model, those queries are impossible regex nightmares.

/// Categories of error that help identify WHERE a failure lives.
///
/// HOW TO USE FOR DEBUGGING:
///   TIMEOUT      → Backend is overloaded or the request is too large.
///                  Check server-side p99 latency and request payload size.
///   NETWORK      → Client has no connectivity or DNS failed.
///                  Nothing you can fix server-side; show offline UI.
///   CLIENT_ERROR → Your app sent a bad request (wrong auth, bad params).
///                  Fix the client code or the token refresh logic.
///   SERVER_ERROR → Backend crashed. Escalate to the backend team with
///                  the traceId so they can correlate with server logs.
///   UNKNOWN      → Unexpected edge case. Investigate the raw DioException.
enum NetworkErrorCategory {
  timeout,
  network,
  clientError, // 4xx
  serverError, // 5xx
  unknown,
}

/// A structured record of a single HTTP interaction captured by
/// [ObservabilityInterceptor].
///
/// One request produces up to two events: a [NetworkEventType.request]
/// event immediately, then either [response] or [error] when it completes.
class NetworkEvent {
  final String method;
  final String url;

  /// Matches [TraceManager.currentId] at request time.
  /// Sent as 'X-Trace-Id' header so backend logs can correlate.
  final String traceId;

  /// Short random ID unique to this HTTP request (not the whole flow).
  /// Useful when one trace contains multiple API calls.
  final String requestId;

  final int? statusCode;

  /// Null on request events (timer hasn't started yet for response events).
  /// For response/error events: end_time - start_time in milliseconds.
  ///
  /// WHY: durationMs is the cheapest latency signal you can collect.
  ///      Track it over time per endpoint to detect backend regressions.
  final int? durationMs;

  final NetworkErrorCategory? errorCategory;
  final String? errorMessage;
  final DateTime timestamp;

  const NetworkEvent({
    required this.method,
    required this.url,
    required this.traceId,
    required this.requestId,
    required this.timestamp,
    this.statusCode,
    this.durationMs,
    this.errorCategory,
    this.errorMessage,
  });

  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;

  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  bool get isServerError =>
      statusCode != null && statusCode! >= 500;

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'url': url,
      'traceId': traceId,
      'requestId': requestId,
      'ts': timestamp.toIso8601String(),
      if (statusCode != null) 'status': statusCode,
      if (durationMs != null) 'durationMs': durationMs,
      if (errorCategory != null) 'errorCategory': errorCategory!.name,
      if (errorMessage != null) 'error': errorMessage,
    };
  }
}