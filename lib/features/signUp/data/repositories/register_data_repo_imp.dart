import '../../../../core/handleErrors/result_pattern.dart';
import '../../domain/repositories/register_repo.dart';
import '../data_sources/register_remote_ds.dart';
import '../models/regester_model.dart';

class RegisterDataRepoImpl implements RegisterDomainRepo {
  final RegisterRDS registerRDS;

  RegisterDataRepoImpl(this.registerRDS);

  @override
  Future<Result> register(RegisterModel model) {
    return registerRDS.register(model);
  }
}