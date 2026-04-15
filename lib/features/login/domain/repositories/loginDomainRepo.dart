import '../../../../core/handleErrors/result_pattern.dart';
import '../../data/models/loginModel.dart';

abstract class LoginDomainRepo {
  Future<Result> sendPasswordResetEmail(String email); // ✅ جديد
  Future<Result> login(LoginModel model);
}
