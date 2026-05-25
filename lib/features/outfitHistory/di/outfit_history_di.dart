// features/history/outfit_history_di.dart

import 'package:get_it/get_it.dart';

import '../data/data_sources/outfit_history_remote_ds.dart';
import '../data/data_sources/outfit_history_remote_ds_imp.dart';
import '../data/repositories/outfit_history_repo.dart';
import '../domain/repositories/outfit_domain_repo.dart';
import '../domain/use_cases/get_outfit_use_case.dart';
import '../presentation/manager/outfit_history_bloc.dart';


void initialOutfitHistoryDI(GetIt getIt) {
  // Data source
  getIt.registerLazySingleton<OutfitHistoryRDS>(
        () => const OutfitHistoryRDSImpl(),
  );

  // Repository
  getIt.registerLazySingleton<OutfitHistoryDomainRepo>(
        () => OutfitHistoryDataRepoImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(
        () => GetOutfitHistoryUseCase(getIt()),
  );
  getIt.registerLazySingleton(
        () => DeleteOutfitHistoryUseCase(getIt()),
  );
  // Bloc — registerFactory so each screen instance gets a fresh Bloc
  getIt.registerFactory(
        () => OutfitHistoryBloc(
      getOutfitHistoryUseCase: getIt(),
      deleteOutfitHistoryUseCase: getIt(),
     ),
  );
}