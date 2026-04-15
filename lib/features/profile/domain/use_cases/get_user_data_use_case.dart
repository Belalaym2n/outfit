import '../../../../core/handleErrors/result_pattern.dart';
import '../repositories/profile_domain_repo.dart';

/// Single-responsibility use-case: fetch the authenticated user's profile.
/// Thin wrapper — add any domain-level validation / transformation here
/// without touching the BLoC or the repository implementation.
class GetProfileUseCase {
  final ProfileRepository _repository;

  const GetProfileUseCase(this._repository);

  Future<Result> call() => _repository.getProfile();
}