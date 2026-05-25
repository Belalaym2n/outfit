
// ===== file: core/observability/logger/log_output/remote_output.dart =====

// WHY: Production bugs happen on real user devices, not your dev machine.
//      You need logs shipped off-device so you can read them after the fact.
// PROBLEM: Console output vanishes the moment the user closes the app.
//          Crashlytics gives you crash reports but NOT the 200 events
//          that led up to the crash.
// BENEFIT: RemoteLogOutput silently buffers warning+ entries and batches
//          them to your backend. You get a queryable, persistent log store
//          that survives crashes, backgrounding, and device restarts.

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:graduation_proj/core/debugSystem/logs/log_level.dart';

import '../logs/log_entry.dart';
import 'i_log_outbit.dart';

/// Buffers log entries and ships them in batches to a remote endpoint.
///
/// IMPORTANT decisions baked into this implementation:
///   - Only [LogLevel.warning] and above are shipped — debug/info stay local.
///     This keeps your backend bill sane and your log signal high.
///   - A fixed-size buffer ([_maxBuffer]) prevents unbounded memory growth
///     during network outages.
///   - Network errors from the shipping call are silently swallowed.
///     WHY: A logging system that crashes your app on network failure is
///          worse than no logging at all.
class RemoteLogOutput implements ILogOutput {
  final List<LogEntry> _buffer = [];
  final int _maxBuffer;
  final String _endpoint;
  final Dio _dio;

  /// [endpoint] — absolute path on your backend, e.g. '/api/logs/ingest'.
  /// [dio]      — pass the same Dio instance used for the rest of the app
  ///              so the auth token interceptor is applied automatically.
  /// [maxBuffer]— flush when this many entries accumulate (default 50).
  RemoteLogOutput({
    required String endpoint,
    required Dio dio,
    int maxBuffer = 50,
  })  : _endpoint = endpoint,
        _dio = dio,
        _maxBuffer = maxBuffer;

  @override
  Future<void> write(LogEntry entry) async {
    // Gate: only ship warning and above to the server.
    // debug and info are too verbose for remote storage and create cost.
    if (!entry.level.isAtLeast(LogLevel.warning)) return;

    _buffer.add(entry);

    // Auto-flush when the buffer fills up. This bounds memory usage and
    // ensures logs arrive even if flush() is never called explicitly.
    if (_buffer.length >= _maxBuffer) {
      await flush();
    }
  }

  @override
  Future<void> flush() async {
    if (_buffer.isEmpty) return;

    // Snapshot and clear the buffer immediately.
    // WHY: We clear before the async call so that entries logged DURING
    //      the HTTP request don't get flushed twice if flush() is re-entered.
    final batch = List<LogEntry>.from(_buffer);
    _buffer.clear();

    try {
      await _dio.post(
        _endpoint,
        data: {
          'logs': batch.map((e) => e.toJson()).toList(),
        },
      );
    } catch (_) {
      // WHY: Silently drop. The alternative — re-adding to the buffer —
      // risks an infinite retry loop during a backend outage.
      // In a more advanced system you'd back-fill from local SQLite storage.
    }
  }
}