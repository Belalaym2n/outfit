import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../data/data_sources/remote/loginRDS.dart';
import '../data/data_sources/remote/loginRDSImpl.dart';
import '../data/repositories/loginDataImp.dart';
import '../domain/repositories/loginDomainRepo.dart';
import '../domain/use_cases/forget_password_use_case.dart';
import '../domain/use_cases/login_use_case.dart';
import '../presentation/bloc/bloc.dart';

void initialLoginDI(GetIt getIt) {
  // Data source
  getIt.registerLazySingleton<LoginRDS>(() => LoginRDSImpl());

  // Repository
  getIt.registerLazySingleton<LoginDomainRepo>(
        () => LoginDataRepoImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => ForgetPasswordUseCase(getIt()));

  // Bloc
  getIt.registerFactory(
        () => LoginBloc(loginUseCase: getIt(), forgetPasswordUseCase: getIt()),
  );
}
