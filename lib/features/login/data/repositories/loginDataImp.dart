
import '../../../../core/handleErrors/result_pattern.dart';
import '../../domain/repositories/loginDomainRepo.dart';
import '../data_sources/remote/loginRDS.dart';
import '../models/loginModel.dart';

class LoginDataRepoImpl implements LoginDomainRepo {
  LoginRDS loginRDS;


  LoginDataRepoImpl(this.loginRDS);

  @override
  Future<Result> login(LoginModel model) {
    // TODO: implement login
    return loginRDS.login(model);
  }

  @override
  Future<Result> sendPasswordResetEmail(String email) {
    return loginRDS.sendPasswordResetEmail(email);
  }

}
