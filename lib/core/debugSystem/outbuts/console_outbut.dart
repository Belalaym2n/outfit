

// ===== file: core/observability/logger/log_output/console_output.dart =====

// WHY: Development needs a zero-friction, human-readable output.
// PROBLEM: Raw print() bypasses Flutter's log pipeline and can be truncated
//          on Android. It also has no timestamps or level filtering.
// BENEFIT: debugPrint respects Flutter's line-length limits, appears in the
//          IDE Run console, and is automatically no-op'd in release builds
//          when dart:developer is stripped. We add level filtering so you
//          can crank verbosity up/down without touching call sites.

import 'package:flutter/foundation.dart';

import '../logs/log_entry.dart';
import '../logs/log_level.dart';
import 'i_log_outbit.dart';

class ConsoleOutput implements ILogOutput {
 final LogLevel minLevel;

  const ConsoleOutput({this.minLevel = LogLevel.debug});

  @override
  Future<void> write(LogEntry entry) async {
     if (!entry.level.isAtLeast(minLevel)) return;

     debugPrint(entry.toString());
 if (entry.stackTrace != null) {
      final frames = entry.stackTrace
          .toString()
          .split('\n')
          .take(12)
          .map((l) => '  $l')
          .join('\n');
      debugPrint('  StackTrace:\n$frames');
    }
  }

  @override
  Future<void> flush() async {
    // WHY: Console output is synchronous — nothing to flush.
    // This method exists only to satisfy the ILogOutput contract.
  }
}