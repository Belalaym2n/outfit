
import '../../../../core/handleErrors/result_pattern.dart';
import '../../data/models/loginModel.dart';
import '../repositories/loginDomainRepo.dart';

class LoginUseCase {
  LoginDomainRepo loginDomainRepo;

  LoginUseCase(this.loginDomainRepo);

  Future<Result> call(LoginModel model) async {
    final result = await loginDomainRepo.login(model);
    if (result.isSuccess) {
      return Result.success(result.data);
    } else {
      return Result.failure(result.error);
    }
  }
}
