import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../apiManager/dio_client.dart';
import '../logs/app_logger.dart';
import '../logs/log_context.dart';
import '../logs/log_level.dart';
import '../outbuts/console_outbut.dart';
import '../outbuts/remote_outbut.dart';
import 'crach_report.dart';

class ObservabilityService {
  ObservabilityService._();
  static final ObservabilityService instance = ObservabilityService._();

  Future<void> initialize() async {
     AppLogger.instance.configure(
      outputs: [
        ConsoleOutput(),                         // Always in dev
        if (!kDebugMode)                         // Only in prod
          RemoteLogOutput(
            endpoint: '/api/logs/ingest',
            dio: DioClient.dio!,
          ),
      ],
      minLevel: kDebugMode ? LogLevel.debug : LogLevel.info,
    );

    // ── 2. Initialize Firebase (if using Crashlytics) ────────
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // ── 3. Set initial device context on Crashlytics ─────────
    await CrashReporter.instance.setContext(
      screen:    'app_start',
      appState:  'initializing',
    );

    log.info('ObservabilityService', 'System initialized', ctx: LogContext(
      extras: {'env': kDebugMode ? 'dev' : 'prod'},
    ));
  }
}
