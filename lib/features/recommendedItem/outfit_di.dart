import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_proj/features/recommendedItem/data/data_sources/locale/outfit_local_ds.dart' show OutfitLocalDataSourceImpl, OutfitLocalDataSource;
import 'package:graduation_proj/features/recommendedItem/data/data_sources/remote/remote_ds_imp.dart' hide OutfitRemoteDataSource;
  import 'package:graduation_proj/features/recommendedItem/data/repositories/outfit_data_repo.dart';
import 'package:graduation_proj/features/recommendedItem/domain/repositories/outfit_domain_repo.dart' show OutfitRepository;
import 'package:graduation_proj/features/recommendedItem/domain/use_cases/outfit_use_cases.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/manager/outfit_bloc.dart';

import 'data/data_sources/remote/remote_ds.dart';



/// Call from your global DI initializer (e.g. `init_di.dart`).
void initOutfitDI(GetIt getIt) {

  getIt.registerLazySingleton<OutfitRecommendRemoteDataSource>(
        () => OutfitRecommendRemoteDataSourceImpl(
    ),
  );

  // ── Data Sources ──────────────────────────────────────────
  getIt.registerLazySingleton<OutfitLocalDataSource>(
    () => OutfitLocalDataSourceImpl(),
  );


  // ── Repository ────────────────────────────────────────────
  getIt.registerLazySingleton<OutfitRepository>(
    () => OutfitRepositoryImpl(
      local: getIt(),
      remote: getIt(),
    ),
  );

  // ── Use Cases ─────────────────────────────────────────────
  getIt.registerLazySingleton(() => GetOutfitsUseCase(getIt()));
  getIt.registerLazySingleton(
    () => LoadMoreOutfitsUseCase(getIt<GetOutfitsUseCase>()),
  );
  getIt.registerLazySingleton(() => SaveItemUseCase(getIt()));
  getIt.registerLazySingleton(() => UnsaveItemUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSavedItemsUseCase(getIt()));

  // ── Bloc ──────────────────────────────────────────────────
  getIt.registerFactory(
    () => OutfitBloc(
      getOutfits: getIt(),
      loadMore: getIt(),
      saveItem: getIt(),
      unsaveItem: getIt(),
      getSavedItems: getIt(),
    ),
  );
}
