// ===== file: core/observability/logger/app_logger.dart =====

// WHY: AppLogger is the single, app-wide logging facade. Every class in the
//      project calls this — nothing calls debugPrint/print directly.
// PROBLEM: Without a central facade:
//   - You can't change how logs are formatted or where they go without
//     touching 50+ files.
//   - You can't attach global context (userId, screen) to every log.
//   - You can't enable/disable specific levels per environment.
// BENEFIT: One class to configure, one class to mock in tests, one class to
//          update when you add a new backend. Call sites never change.

import 'package:flutter/foundation.dart';
import '../outbuts/i_log_outbit.dart';
import 'log_level.dart';
import 'log_entry.dart';
import 'log_context.dart';

final logger = AppLogger.instance;
class AppLogger {
  AppLogger._();

   static final AppLogger instance = AppLogger._();
   final List<ILogOutput> _outputs = [];
  LogContext _globalCtx = const LogContext();

  LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  void configure({
    required List<ILogOutput> outputs,
    LogLevel? minLevel,
  }) {
    _outputs
      ..clear()
      ..addAll(outputs);
    if (minLevel != null) _minLevel = minLevel;
  }

 LogContext get globalCtx => _globalCtx;

   void setGlobalContext(LogContext ctx) => _globalCtx = ctx;
  void setUserId(String userId) {
    _globalCtx = _globalCtx.mergeWith(LogContext(userId: userId));
  }
  void setScreen(String screen) {
    _globalCtx = _globalCtx.mergeWith(LogContext(screen: screen));
  }

   void clearGlobalContext() => _globalCtx = const LogContext();
 void debug(
      String tag,
      String message, {
        LogContext? ctx,
        Object? error,
        StackTrace? st,
      }) =>
      _log(LogLevel.debug, tag, message, ctx: ctx, error: error, st: st);

  void info(String tag, String message, {LogContext? ctx}) =>
      _log(LogLevel.info, tag, message, ctx: ctx);

 void warning(
      String tag,
      String message, {
        LogContext? ctx,
        Object? error,
      }) =>
      _log(LogLevel.warning, tag, message, ctx: ctx, error: error);

  void error(
      String tag,
      String message, {
        LogContext? ctx,
        Object? error,
        StackTrace? st,
      }) =>
      _log(LogLevel.error, tag, message, ctx: ctx, error: error, st: st);

  void fatal(
      String tag,
      String message, {
        LogContext? ctx,
        Object? error,
        StackTrace? st,
      }) =>
      _log(LogLevel.fatal, tag, message, ctx: ctx, error: error, st: st);


  void _log(
      LogLevel level,
      String tag,
      String message, {
        LogContext? ctx,
        Object? error,
        StackTrace? st,
      }) {
     if (!level.isAtLeast(_minLevel)) return;

    final merged = ctx != null ? _globalCtx.mergeWith(ctx)
        : _globalCtx;

    final entry = LogEntry(
      timestamp: DateTime.now().toUtc(),
      level: level,
      tag: tag,
      message: message,
      context: merged,
      error: error,
      stackTrace: st,
    );

    for (final output in _outputs) {
      // WHY: catchError on every output individually.
      // If RemoteOutput's HTTP call throws, ConsoleOutput should still work.
      // A broken log output must NEVER propagate an exception to the caller.
      output.write(entry).catchError((_) {});
    }
  }

   Future<void> flush() {
    return Future.wait(_outputs.map((o) async => o?.flush()));
  }
}


final AppLogger log = AppLogger.instance;