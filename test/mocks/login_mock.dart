import 'package:graduation_proj/features/login/data/models/loginModel.dart';
import 'package:graduation_proj/features/login/domain/use_cases/forget_password_use_case.dart';
import 'package:graduation_proj/features/login/domain/use_cases/login_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock
    implements LoginUseCase {}

class MockForgetPasswordUseCase extends Mock
    implements ForgetPasswordUseCase {}

class FakeLoginModel extends Fake
    implements LoginModel {}


