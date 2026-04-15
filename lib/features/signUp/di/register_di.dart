import 'package:get_it/get_it.dart';
import '../data/data_sources/register_remote_ds.dart';
import '../data/data_sources/register_remote_ds_imp.dart';
import '../data/repositories/register_data_repo_imp.dart';
import '../domain/repositories/register_repo.dart';
import '../domain/use_cases/register_use_case.dart';
import '../presentation/manager/register_bloc.dart';

void initialRegisterDI(GetIt getIt) {
  // Data source
  getIt.registerLazySingleton<RegisterRDS>(
        () => RegisterRDSImpl(),
  );

  // Repository
  getIt.registerLazySingleton<RegisterDomainRepo>(
        () => RegisterDataRepoImpl(getIt()),
  );

  // Use case
  getIt.registerLazySingleton(
        () => RegisterUseCase(getIt()),
  );

  // Bloc — factory so a fresh instance is created each time
  getIt.registerFactory(
        () => RegisterBloc(registerUseCase: getIt()),
  );
}