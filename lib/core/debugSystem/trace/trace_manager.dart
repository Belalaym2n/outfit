
// ===== file: core/observability/trace/trace_manager.dart =====

// WHY: TraceManager is the single authority that creates, holds, and terminates
//      trace identifiers. No other class generates traceIds.
// PROBLEM: If every class generated its own ID, you'd have thousands of orphan
//          IDs with no way to link related events. The "same user action"
//          becomes invisible across the system.
// BENEFIT: TraceManager guarantees one ID per flow. The Bloc starts it, the
//          Dio interceptor reads it, the repository stamps it, and the final
//          state update closes it. Every log in between carries the same ID.
//          You can reproduce any production issue by searching one string.

import 'dart:math';
import 'package:graduation_proj/core/debugSystem/logs/app_logger.dart';

import '../logs/log_context.dart';
import 'trace_context.dart';
/// Singleton that owns the lifecycle of the current trace context.
///
/// Thread-safety note: Dart is single-threaded per isolate, so no locking
/// is needed. If you use multiple isolates, each needs its own TraceManager.
///
/// HOW TO USE:
///   1. In your Bloc event handler (BEFORE async work):
///      final ctx = trace.start('analyze_outfit');
///
///   2. Pass traceId to LogContext at every log site:
///      log.info('Repo', 'msg', ctx: LogContext(traceId: trace.currentId));
///
///   3. The Dio interceptor reads trace.currentId and stamps X-Trace-Id header.
///
///   4. After final state update:
///      trace.end(success: true);
class TraceManager {
  TraceManager._();

  /// Singleton. Matches AppLogger's singleton pattern — one per app.
  static final TraceManager instance = TraceManager._();

  TraceContext? _current;

  /// The currently active trace, or null if no flow is in progress.
  TraceContext? get current => _current;

  /// Convenience accessor for the ID string. Returns null if no trace is active.
  ///
  /// WHY nullable: Not every log event happens inside a traced flow.
  /// Repository methods called from background jobs, for example, may have
  /// no associated user action. Null is honest; a fake ID would be misleading.
  String? get currentId => _current?.id;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  /// Creates and activates a new [TraceContext] for [flowName].
  ///
  /// Call this at the EARLIEST point of a user-initiated action — typically
  /// the first line of a Bloc event handler, before any async work.
  ///
  /// WHY earliest: If you start the trace after the first await, the log
  /// entries produced during that await already have no traceId — you lose
  /// part of the timeline.
  ///
  /// Returns the new context so callers can capture the id if needed,
  /// though most call sites use [currentId] lazily.
  TraceContext start(String flowName) {
    // WHY: Log the start event. This becomes the anchor in your log query:
    // "Show me everything after this line with this traceId."
    final ctx = TraceContext(
      id: _generateUuid(),
      flowName: flowName,
      startedAt: DateTime.now().toUtc(),
    );
    _current = ctx;

    AppLogger.instance.info(
      'TraceManager',
      'Trace STARTED | flow=$flowName',
      ctx: LogContext(traceId: ctx.id, action: 'trace_start'),
    );

    return ctx;
  }

  /// Terminates the current trace and logs its outcome + duration.
  ///
  /// Call this after the final state update — the very last thing in your
  /// Bloc handler after emit(successState) or emit(errorState).
  ///
  /// [success] — whether the flow completed as intended.
  /// [reason]  — optional detail for failures (error message, status code).
  ///
  /// WHY log duration: It's the cheapest performance metric you can collect.
  /// Over time, rising p95 durations signal backend degradation before users
  /// start complaining.
  void end({bool success = true, String? reason}) {
    if (_current == null) return;

    final outcome = success ? 'SUCCESS' : 'FAILURE';
    final duration = _current!.age.inMilliseconds;
    final detail = reason != null ? ' | reason=$reason' : '';

    log.info(
      'TraceManager',
      'Trace ENDED [$outcome] | flow=${_current!.flowName} | ${duration}ms$detail',
      ctx: LogContext(traceId: _current!.id, action: 'trace_end'),
    );

    _current = null;
  }

  // ── UUID v4 generation ────────────────────────────────────────────────────
  // WHY: No external dependency (uuid package) needed.
  // The standard UUID v4 format is preserved so backend systems that parse
  // UUIDs (e.g. Postgres uuid type) accept these values without conversion.

  static final Random _rng = Random.secure();

  static String _generateUuid() {
    final bytes = List<int>.generate(16, (_) => _rng.nextInt(256));
    // Set version (4) and variant (1) bits per RFC 4122 §4.4
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    String h(int b) => b.toRadixString(16).padLeft(2, '0');
    final b = bytes.map(h).toList();
    return '${b[0]}${b[1]}${b[2]}${b[3]}'
        '-${b[4]}${b[5]}'
        '-${b[6]}${b[7]}'
        '-${b[8]}${b[9]}'
        '-${b[10]}${b[11]}${b[12]}${b[13]}${b[14]}${b[15]}';
  }
}

// ── Top-level alias ───────────────────────────────────────────────────────────
// WHY: Mirrors the `log` alias pattern. Shorter call sites reduce friction
//      and improve readability throughout the codebase.
// ignore: non_constant_identifier_names
final TraceManager trace = TraceManager.instance;