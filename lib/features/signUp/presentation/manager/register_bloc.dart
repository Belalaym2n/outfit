import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/register_use_case.dart';
import 'register_events.dart';
import 'register_states.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(const RegisterState()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  Future<void> _onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    // Client-side validation before hitting the network
    final validationError = _validate(event.model);
    if (validationError != null) {
      emit(
        state.copyWith(status: RegisterStatus.validationError, error: validationError),
      );
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    final result = await registerUseCase(event.model);

    if (result.isSuccess) {
      emit(state.copyWith(status: RegisterStatus.success, error: null));
    } else {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          error: result.error.toString(),
        ),
      );
    }
  }

  String? _validate(model) {
    if (!model.isAgree) return 'You must agree to the Terms of Service.';
    return null;
  }
}
