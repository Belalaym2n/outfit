


import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../logs/app_logger.dart';
import '../trace/trace_manager.dart';

class CrashReporter {
  CrashReporter._();

  static final CrashReporter instance = CrashReporter._();

  FirebaseCrashlytics get _fc => FirebaseCrashlytics.instance;

  // ── Identity ──────────────────────────────────────────────
  Future<void> setUserId(String userId) async {
    await _fc.setUserIdentifier(userId);
    AppLogger.instance.info('CrashReporter', 'User ID set: $userId');
  }

  // ── Custom Keys (visible in crash report dashboard) ───────
  Future<void> setKey(String key, String value) =>
      _fc.setCustomKey(key, value);

  Future<void> setContext({
    String? screen,
    String? traceId,
    String? lastAction,
    String? appState,
  }) async {
    await Future.wait([
      if (screen != null) _fc.setCustomKey('screen', screen),
      if (traceId != null) _fc.setCustomKey('trace_id', traceId),
      if (lastAction != null) _fc.setCustomKey('last_action', lastAction),
      if (appState != null) _fc.setCustomKey('app_state', appState),
    ]);
  }

  // ── Breadcrumbs: ordered trail of what happened ────────────
  void addBreadcrumb(String message, {Map<String, dynamic>? data}) {
    final entry = data != null
        ? '$message | ${data.entries.map((e) => "${e.key}=${e.value}").join(
        ", ")}'
        : message;
    _fc.log(entry.length > 1024 ? entry.substring(0, 1024) : entry);
  }

  // ── Record non-fatal error ────────────────────────────────
  Future<void> recordError(Object error,
      StackTrace? stack, {
        bool fatal = false,
        Map<String, dynamic>? extras,
      }) async {
    // Attach current trace context as keys before recording
    final traceId = TraceManager.instance.currentId;
    if (traceId != null) await _fc.setCustomKey('trace_id', traceId);
    if (extras != null) {
      for (final entry in extras.entries) {
        await _fc.setCustomKey(entry.key, entry.value.toString());
      }
    }
    await _fc.recordError(error, stack, fatal: fatal);
  }
}