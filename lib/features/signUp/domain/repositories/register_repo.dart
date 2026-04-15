import '../../../../core/handleErrors/result_pattern.dart';
import '../../data/models/regester_model.dart';

abstract class RegisterDomainRepo {
  Future<Result> register(RegisterModel model);
}