import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:graduation_proj/core/handleErrors/result_pattern.dart';

import 'package:graduation_proj/features/login/data/models/loginModel.dart';

import 'package:graduation_proj/features/login/domain/repositories/loginDomainRepo.dart';

import 'package:graduation_proj/features/login/domain/use_cases/login_use_case.dart';

import '../../../helpers/test_helpers.dart';

class MockLoginRepo extends Mock
    implements LoginDomainRepo {}


void main() {

  setUpAll(() {
    registerTestFallbacks();
  });


  late LoginUseCase loginUseCase;

  late MockLoginRepo mockLoginRepo;

  late LoginModel loginModel;

  setUp(() {
    mockLoginRepo = MockLoginRepo();

    loginUseCase = LoginUseCase(
      mockLoginRepo,
    );

    loginModel = LoginModel(
      email: 'test@test.com',
      password: '123456',
    );
  });

  test(
    'should return success when repo login succeeds',
        () async {

      when(
            () => mockLoginRepo.login(any()),
      ).thenAnswer(
            (_) async => Result.success({}),
      );

      final result = await loginUseCase(
        loginModel,
      );

      expect(result.isSuccess, true);

      verify(
            () => mockLoginRepo.login(any()),
      ).called(1);
    },
  );

  test(
    'should return failure when repo login fails',
        () async {

      when(
            () => mockLoginRepo.login(any()),
      ).thenAnswer(
            (_) async => Result.failure(
          'Login failed',
        ),
      );

      final result = await loginUseCase(
        loginModel,
      );

      expect(result.isFailure, true);

      expect(
        result.error,
        'Login failed',
      );

      verify(
            () => mockLoginRepo.login(any()),
      ).called(1);
    },
  );
}