
import 'package:bloc/bloc.dart';
import '../logs/app_logger.dart';
import '../logs/log_context.dart';
import '../report/crach_report.dart';
import '../trace/trace_manager.dart';

class AppBlocObserver extends BlocObserver {

  // 🟢 كل Event
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    log.debug(
      bloc.runtimeType.toString(),
      'Event: ${event.runtimeType}',
      ctx: LogContext(
        traceId: TraceManager.instance.currentId,
      ),
    );
  }

  // 🔵 كل State change
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    log.debug(
      bloc.runtimeType.toString(),
      'State: ${transition.currentState.runtimeType} → ${transition.nextState.runtimeType}',
      ctx: LogContext(
        traceId: TraceManager.instance.currentId,
        action: transition.event.runtimeType.toString(),
      ),
    );
  }

  // 🔴 أي Error في Bloc
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    log.error(
      bloc.runtimeType.toString(),
      'Unhandled bloc error',
      ctx: LogContext(
        traceId: TraceManager.instance.currentId,
      ),
      error: error,
      st: stackTrace,
    );

    // ربطه بالـ Crashlytics
    CrashReporter.instance.recordError(
      error,
      stackTrace,
      fatal: false,
      extras: {
        'bloc': bloc.runtimeType.toString(),
      },
    );
  }

  // 🟡 lifecycle
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    log.debug(
      'BlocLifecycle',
      'Created: ${bloc.runtimeType}',
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    log.debug(
      'BlocLifecycle',
      'Closed: ${bloc.runtimeType}',
    );
  }
}