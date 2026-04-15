import '../../../../../core/handleErrors/result_pattern.dart';
import '../../../login/data/models/loginModel.dart';
import '../../data/models/regester_model.dart';

abstract class RegisterRDS {
  Future<Result> register(RegisterModel model);
  Future<Result> saveUserData(RegisterModel user); // ✅

}