import '../../../../core/handleErrors/result_pattern.dart';
 import '../../domain/repositories/profile_domain_repo.dart';
import '../data_sources/profile_remote_ds.dart';

/// Bridges the domain contract to the actual data source.
/// Swap [ProfileRDS] for a mock/local source without touching the domain.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRDS _rds;

  const ProfileRepositoryImpl(this._rds);

  @override
  Future<Result> getProfile() => _rds.getProfile();
}