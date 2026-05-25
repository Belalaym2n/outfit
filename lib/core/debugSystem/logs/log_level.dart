
// ===== file: core/observability/logger/log_level.dart =====

// WHY: Log levels exist to control the signal-to-noise ratio in your logs.
// PROBLEM: Without levels, you either log everything (noisy, expensive) or
//          nothing (blind in production). Levels let you run debug-verbosity
//          in dev and only ship warning+ to your remote server in prod.
// BENEFIT: You can filter your log store by level and instantly surface the
//          issues that matter without drowning in routine info messages.

/// Severity levels for structured log entries.
///
/// Ordered from least to most severe — used to gate which entries
/// are written to each output (console vs remote server).
enum LogLevel {
 debug,

   info,

   warning,

   error,

  fatal,
}

extension LogLevelX on LogLevel {
  String get emoji {
    switch (this) {
      case LogLevel.debug:
        return '🔵';
      case LogLevel.info:
        return '🟢';
      case LogLevel.warning:
        return '🟡';
      case LogLevel.error:
        return '🔴';
      case LogLevel.fatal:
        return '💀';
    }
  }


  bool isAtLeast(LogLevel other) => index >= other.index;
}