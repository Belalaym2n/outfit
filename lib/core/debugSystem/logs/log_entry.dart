
// ===== file: core/observability/logger/log_entry.dart =====

// WHY: A typed log entry (not a raw string) is the foundation of a professional
//      observability system.
// PROBLEM: print("API failed") is useless in production. You can't filter it,
//          you can't ship it to a server, you can't search it by user or trace,
//          and you lose it the moment the dev console closes.
// BENEFIT: LogEntry is a structured object. It can be serialised to JSON and
//          shipped to any log aggregator (Datadog, Loki, your own backend).
//          You can query: all ERROR entries for traceId X in the last 10 minutes.
//          That's the difference between guessing and knowing.

import 'log_level.dart';
import 'log_context.dart';


class LogEntry {
 final DateTime timestamp;

   final LogLevel level;
 final String tag;

  final String message;

  final LogContext context;

   final Object? error;

  final StackTrace? stackTrace;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
    required this.context,
    this.error,
    this.stackTrace,
  });


  Map<String, dynamic> toJson() {
    return {
      'ts': timestamp.toIso8601String(),
      'level': level.name.toUpperCase(),
      'tag': tag,
      'msg': message,
      'ctx': context.toMap(),
      if (error != null) 'error': error.toString(),
      // Limit stack to 8 frames — enough to find the bug, small enough to ship.
      if (stackTrace != null)
        'stack': stackTrace.toString().split('\n').take(8).toList(),
    };
  }

  @override
  String toString() {
    final ctx = context.toMap();
    final ctxStr = ctx.isEmpty
        ? ''
        : ' | ${ctx.entries.map((e) => '${e.key}=${e.value}').join(', ')}';
    final errStr = error != null ? '\n  ↳ ERROR: $error' : '';
    return '${level.emoji} [${level.name.toUpperCase()}] $tag: $message$ctxStr$errStr';
  }
}