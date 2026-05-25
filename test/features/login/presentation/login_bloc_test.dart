import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:graduation_proj/core/handleErrors/result_pattern.dart';

import 'package:graduation_proj/features/login/data/models/loginModel.dart';

import 'package:graduation_proj/features/login/presentation/bloc/bloc.dart';

import 'package:graduation_proj/features/login/presentation/bloc/loginEvents.dart';

import 'package:graduation_proj/features/login/presentation/bloc/login_states.dart';

import '../../../helpers/test_helpers.dart';
import '../../../mocks/login_mock.dart';


void main() {
  setUpAll(() {
    registerTestFallbacks();
  });

  late LoginBloc loginBloc;

  late MockLoginUseCase mockLoginUseCase;

  late MockForgetPasswordUseCase mockForgetPasswordUseCase;

  late LoginModel loginModel;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();

    mockForgetPasswordUseCase = MockForgetPasswordUseCase();

    loginBloc = LoginBloc(
      loginUseCase: mockLoginUseCase,
      forgetPasswordUseCase: mockForgetPasswordUseCase,
    );

    loginModel = LoginModel(email: 'test@test.com', password: '123456');
  });

  tearDown(() async {
    await loginBloc.close();
  });

  group('LoginBloc Tests', () {
    test('should emit [loading, success] when login succeeds', () async {
      when(
        () => mockLoginUseCase(any()),
      ).thenAnswer((_) async => Result.success({}));

      loginBloc.add(LoginButtonPressed(model: loginModel));

      await expectLater(
        loginBloc.stream,
        emitsInOrder([
          const LoginState(status: LoginStatus.loading),
          const LoginState(status: LoginStatus.success),
        ]),
      );

      verify(() => mockLoginUseCase(any())).called(1);
    });

    test('should emit [loading, failure] when login fails', () async {
      when(
        () => mockLoginUseCase(any()),
      ).thenAnswer((_) async => Result.failure('Invalid credentials'));

      loginBloc.add(LoginButtonPressed(model: loginModel));

      await expectLater(
        loginBloc.stream,
        emitsInOrder([
          const LoginState(status: LoginStatus.loading),
          const LoginState(
            status: LoginStatus.failure,
            error: 'Invalid credentials',
          ),
        ]),
      );

      verify(() => mockLoginUseCase(any())).called(1);
    });

    test(
      'should emit [loading, sendEmailSuccess] when forget password succeeds',
      () async {
        when(() => mockForgetPasswordUseCase(any())).thenAnswer(
          (_) async => Result.success({
            "message": "Password reset email sent successfully",
          }),
        );

        loginBloc.add(ForgetPasswordPressed('test@test.com'));

        await expectLater(
          loginBloc.stream,
          emitsInOrder([
            const LoginState(status: LoginStatus.loading),
            const LoginState(status: LoginStatus.sendEmailSuccess),
          ]),
        );

        verify(() => mockForgetPasswordUseCase(any())).called(1);
      },
    );

    test(
      'should emit [loading, sendEmailFailure] when forget password fails',
      () async {
        when(
          () => mockForgetPasswordUseCase(any()),
        ).thenAnswer((_) async => Result.failure('Email not found'));

        loginBloc.add(ForgetPasswordPressed('wrong@test.com'));

        await expectLater(
          loginBloc.stream,
          emitsInOrder([
            const LoginState(status: LoginStatus.loading),
            const LoginState(
              status: LoginStatus.sendEmailFailure,
              error: 'Email not found',
            ),
          ]),
        );

        verify(() => mockForgetPasswordUseCase(any())).called(1);
      },
    );
  });
}
