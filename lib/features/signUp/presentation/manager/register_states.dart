enum RegisterStatus {
  initial,
  loading,
  success,
  failure,
  validationError
}

class RegisterState {
  final RegisterStatus status;
  final String? error;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.error,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? error,
  }) {
    return RegisterState(
      status: status ?? this.status,
      error:  error,           // null clears previous error
    );
  }
}