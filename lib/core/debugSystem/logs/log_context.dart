
class LogContext {
  final String? traceId; final String? userId;

 final String? screen;

  final String? action;

  final Map<String, dynamic> extras;

  const LogContext({
    this.traceId,
    this.userId,
    this.screen,
    this.action,
    this.extras = const {},
  });

  LogContext mergeWith(LogContext other) {
    return LogContext(
      traceId: other.traceId ?? traceId,
      userId: other.userId ?? userId,
      screen: other.screen ?? screen,
      action: other.action ?? action,
      extras: {...extras, ...other.extras},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (traceId != null) 'traceId': traceId,
      if (userId != null) 'userId': userId,
      if (screen != null) 'screen': screen,
      if (action != null) 'action': action,
      if (extras.isNotEmpty) ...extras,
    };
  }
}