
// ===== file: core/observability/navigation/app_navigator_observer.dart =====

// WHY: Navigation tracking bridges the gap between "what the user did" and
//      "what the app did." Without it, your logs show API calls and state
//      changes, but you cannot answer "which screen was the user on when
//      this happened?"
// PROBLEM: Crashes and API failures are reported with a stack trace from deep
//          inside the code. The stack trace doesn't tell you the user journey:
//          did they land on OutfitScreen from the home screen or from a deeplink?
// BENEFIT: Every push/pop is logged. Crashlytics breadcrumbs record the
//          navigation trail. When a crash arrives, you see:
//          "HomeScreen → OutfitScreen → [crash]"
//          instead of just a stack trace.

import 'package:flutter/widgets.dart';
 import '../logs/app_logger.dart';
import '../logs/log_context.dart';
import '../report/crach_report.dart';
import '../trace/trace_manager.dart';


/// A [NavigatorObserver] that logs every route transition and keeps the
/// global log context's `screen` field up to date.
///
/// REGISTRATION:
///   MaterialApp(
///     navigatorObservers: [AppNavigatorObserver()],
///     ...
///   )
///
/// WHY a single global observer (not per-route):
///   Per-route solutions require boilerplate in every screen. One observer
///   on the MaterialApp captures ALL navigation including programmatic pushes,
///   deeplinks, and navigation from third-party packages.
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final to = _routeName(route);
    final from = _routeName(previousRoute);
    _track('PUSH', to: to, from: from);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // After a pop, the user is back on previousRoute.
    final backTo = _routeName(previousRoute);
    final from = _routeName(route);
    _track('POP', to: backTo, from: from);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _track('REPLACE',
        to: _routeName(newRoute), from: _routeName(oldRoute));
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    // WHY: Remove happens during complex navigation operations (e.g. clearing
    // the back stack). Log it so you can detect unexpected route removals.
    log.debug(
      'Navigator',
      'REMOVE ${_routeName(route)}',
      ctx: LogContext(traceId: TraceManager.instance.currentId),
    );
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  void _track(String type, {required String to, String? from}) {
    final label = from != null ? '$type → $to (from $from)' : '$type → $to';

    log.info(
      'Navigator',
      label,
      ctx: LogContext(
        traceId: TraceManager.instance.currentId,
        screen: to,
      ),
    );

    // WHY: Update global context so every subsequent log (in that screen)
    // automatically carries the correct screen name — no manual passing needed.
    AppLogger.instance.setScreen(to);

    // WHY: Crashlytics breadcrumb + key.
    //   breadcrumb = ordered trail of the last 50 navigations
    //   key        = always-current screen name in the crash report header
    CrashReporter.instance
      ..addBreadcrumb('Navigate $label')
      ..setKey('current_screen', to);
  }

  /// Extracts a display name from a route.
  ///
  /// Prefers the named route (e.g. '/OutfitScreen') and falls back to
  /// the runtime type (e.g. 'MaterialPageRoute') when no name was set.
  String _routeName(Route<dynamic>? route) {
    if (route == null) return 'null';
    return route.settings.name?.isNotEmpty == true
        ? route.settings.name!
        : route.runtimeType.toString();
  }
}