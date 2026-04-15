
import '../../../../core/handleErrors/result_pattern.dart';
import '../../data/models/regester_model.dart';
import '../repositories/register_repo.dart';

class RegisterUseCase {
  final RegisterDomainRepo repo;

  RegisterUseCase(this.repo);

  Future<Result> call(RegisterModel model) {
    return repo.register(model);
  }
}