import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/features/profile/presentation/manager/profile_states.dart';

 import '../../domain/use_cases/get_user_data_use_case.dart';
import 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfile;

  ProfileBloc({required GetProfileUseCase getProfileUseCase})
      : _getProfile = getProfileUseCase,
        super(const ProfileState()) {
    on<ProfileFetchRequested>(_onFetchRequested);
    on<ProfileRetryRequested>(_onRetryRequested);
  }

  // ── Handlers ─────────────────────────────────────────────────

  Future<void> _onFetchRequested(
      ProfileFetchRequested event,
      Emitter<ProfileState> emit,
      ) async {
    await _fetch(emit);
  }

  Future<void> _onRetryRequested(
      ProfileRetryRequested event,
      Emitter<ProfileState> emit,
      ) async {
    await _fetch(emit);
  }

  // ── Core fetch logic ──────────────────────────────────────────

  Future<void> _fetch(Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));

    final result = await _getProfile();

    if (result.isSuccess) {
      if (result.data == null) {
        emit(state.copyWith(status: ProfileStatus.empty, clearUser: true));
      } else {
        emit(state.copyWith(
          status: ProfileStatus.success,
          user:   result.data,
        ));
      }
    } else {
      emit(state.copyWith(
        status:   ProfileStatus.error,
        errorMsg: result.error?.toString() ?? 'Unexpected error occurred.',
      ));
    }
  }
}