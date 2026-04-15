
import 'package:get_it/get_it.dart';

import '../data/data_sources/profile_remote_ds.dart';
import '../data/data_sources/profile_remote_ds_imp.dart';
import '../data/repositories/profile_data_repo.dart';
import '../domain/repositories/profile_domain_repo.dart';
import '../domain/use_cases/get_user_data_use_case.dart';

profileDi(GetIt getIt){
  // 🔥 Data Source
  getIt.registerLazySingleton<ProfileRDS>(
        () => ProfileRDSImpl(),
  );

// 🔥 Repository
  getIt.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(getIt()),
  );

// 🔥 UseCase
  getIt.registerLazySingleton<GetProfileUseCase>(
        () => GetProfileUseCase(getIt()),
  );
}