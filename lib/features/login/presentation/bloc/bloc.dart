import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/validations/auth_validation.dart';
import '../../domain/use_cases/forget_password_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import 'loginEvents.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;

  LoginBloc({
    required this.loginUseCase,
    required this.forgetPasswordUseCase,
  }) : super(const LoginState()) {

    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<ForgetPasswordPressed>(_onForgetPasswordPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event,
      Emitter<LoginState> emit,
      ) async {

    emit(state.copyWith(status: LoginStatus.loading));

    final result = await loginUseCase(event.model);

    if (result.isSuccess) {
      emit(state.copyWith(
        status: LoginStatus.success,
        error: null,
      ));
    } else {
      emit(state.copyWith(
        status: LoginStatus.failure,
        error: result.error.toString(),
      ));
    }
  }

  Future<void> _onForgetPasswordPressed(
      ForgetPasswordPressed event,
      Emitter<LoginState> emit,
      ) async {

    emit(state.copyWith(status: LoginStatus.loading));

    final result = await forgetPasswordUseCase(event.email);

    if (result.isSuccess) {
      emit(state.copyWith(
        status: LoginStatus.sendEmailSuccess,
        error: null,
      ));
    } else {
      emit(state.copyWith(
        status: LoginStatus.sendEmailFailure,
        error: result.error.toString(),
      ));
    }
  }
}