import 'package:equatable/equatable.dart';
import 'package:graduation_proj/features/profile/data/models/user_data.dart';


enum ProfileStatus { initial, loading, success, empty, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.status   = ProfileStatus.initial,
    this.user     ,
    this.errorMsg ,
  });

  final ProfileStatus status;
  final UserModel?   user;
  final String?       errorMsg;

  // ── Convenience getters ──────────────────────────────────────
  bool get isLoading => status == ProfileStatus.loading;
  bool get isSuccess => status == ProfileStatus.success;
  bool get isEmpty   => status == ProfileStatus.empty;
  bool get isError   => status == ProfileStatus.error;

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel?    user,
    String?        errorMsg,
    bool           clearError  = false,
    bool           clearUser   = false,
  }) {
    return ProfileState(
      status:   status   ?? this.status,
      user:     clearUser  ? null : (user     ?? this.user),
      errorMsg: clearError ? null : (errorMsg ?? this.errorMsg),
    );
  }

  @override
  List<Object?> get props => [status, user, errorMsg];
}