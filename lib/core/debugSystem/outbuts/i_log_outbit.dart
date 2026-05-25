
// ===== file: core/observability/logger/log_output/i_log_output.dart =====

// WHY: Defining an interface for log outputs is what makes the logger pluggable.
// PROBLEM: If AppLogger directly calls print() or FirebaseCrashlytics, you can
//          never swap implementations, mock them in tests, or add a new backend
//          without touching AppLogger itself.
// BENEFIT: You code against ILogOutput. Today it's console. Tomorrow it's
//          Datadog. The day after it's both. AppLogger never changes.


import '../logs/log_entry.dart';

abstract class ILogOutput {

  Future<void> write(LogEntry entry);

  Future<void> flush();
}