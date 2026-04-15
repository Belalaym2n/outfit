import 'package:get_it/get_it.dart';

import '../data/data_sources/remote/outfit_rds.dart';
import '../data/data_sources/remote/outfite_remote_ds_imp.dart';
import '../data/repositories/outfite_repo_imp.dart';
import '../domain/repositories/outfit_domain_repo.dart';
import '../domain/use_cases/analyze_outfit_use_case.dart';
import '../presentation/manager/outfit_bloc.dart';

void initialOutfitDI(GetIt getIt) {
  // Data source
  getIt.registerLazySingleton<OutfitRDS>(() => OutfitRDSImpl());

  // Repository
  getIt.registerLazySingleton<OutfitDomainRepo>(
        () => OutfitDataRepoImpl(getIt()),
  );

  // Use case
  getIt.registerLazySingleton(() => AnalyzeOutfitUseCase(getIt()));

  // Bloc
  getIt.registerFactory(
        () => OutfitBloc(analyzeOutfitUseCase: getIt()),
  );
}