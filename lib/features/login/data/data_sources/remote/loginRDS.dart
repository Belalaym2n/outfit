import '../../../../../core/handleErrors/result_pattern.dart';
import '../../models/loginModel.dart';

abstract class LoginRDS {
  Future<Result> login(LoginModel model);

  Future<Result> sendPasswordResetEmail(String email); // ✅
  // Future<Result> saveUserData(UserModel user); // ✅
}
