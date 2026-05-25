
// ===== file: core/observability/trace/trace_context.dart =====

// WHY: A TraceContext is the immutable identity card of a single user flow.
// PROBLEM: Distributed systems (UI → Bloc → Repository → Dio → Backend) process
//          the same user action across multiple classes, threads, and services.
//          Without a shared identifier, you cannot link these events together.
//          You see "API failed" and "State changed to error" but you can't
//          prove they belong to the same user action.
// BENEFIT: Every component that touches a user flow stamps the same traceId.
//          In your log store, one filter query reunites the entire timeline:
//          all log entries from UI trigger → API call → backend → response → state update.

/// Immutable value object representing a single traced user flow.
///
/// Lifetime: created by [TraceManager.start()] at the first user action,
///           terminated by [TraceManager.end()] after final state update.
///
/// Examples of flows worth tracing:
///   'analyze_outfit'   → button tap to result rendered
///   'login'            → form submit to home screen
///   'refresh_feed'     → pull-to-refresh to list updated
class TraceContext {
  /// UUID v4. Unique per flow. Stamped on every log and every HTTP header.
  ///
  /// WHY UUID v4 (random) rather than sequential int:
  ///   - No central counter needed (offline-safe)
  ///   - 2^122 space = effectively zero collision probability
  ///   - Unguessable — safe to put in logs without leaking business data
  final String id;

  /// Human-readable name identifying what the user is trying to do.
  /// Snake_case, verb-noun: 'analyze_outfit', 'submit_payment', 'login'.
  ///
  /// WHY: The id alone is opaque. The flowName lets you read logs naturally:
  ///   "Trace started | analyze_outfit | id=a1b2c3..."
  final String flowName;

  /// UTC instant when the flow began. Used to compute [age].
  final DateTime startedAt;

  const TraceContext({
    required this.id,
    required this.flowName,
    required this.startedAt,
  });

  /// How long this trace has been alive. Use to detect hung flows.
  ///
  /// BENEFIT: If [age] exceeds your timeout threshold and the flow hasn't
  /// ended, you can log a warning — the user is probably staring at a spinner.
  Duration get age => DateTime.now().toUtc().difference(startedAt);

  @override
  String toString() =>
      'TraceContext(id=$id, flow=$flowName, age=${age.inMilliseconds}ms)';
}