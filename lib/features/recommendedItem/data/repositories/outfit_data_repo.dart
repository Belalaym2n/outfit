import 'package:graduation_proj/features/recommendedItem/data/data_sources/locale/outfit_local_ds.dart';
import 'package:graduation_proj/features/recommendedItem/data/data_sources/remote/remote_ds.dart';
import 'package:graduation_proj/features/recommendedItem/data/data_sources/remote/remote_ds_imp.dart';

import '../../../../core/handleErrors/result_pattern.dart';
import '../../../savedItems/data/models/saved_item_model.dart';
import '../../domain/repositories/outfit_domain_repo.dart';
import '../../domain/use_cases/outfit_use_cases.dart';
class OutfitRepositoryImpl implements OutfitRepository {
  OutfitRepositoryImpl({
    required this.local,
    required this.remote,
  });

  final OutfitLocalDataSource local;
  final OutfitRecommendRemoteDataSource remote;

  // ── Outfits ───────────────────────────────────────────
  @override
  Future<Result> getOutfits({
    required int page,
    required int pageSize,
  }) =>
      local.getOutfits(page: page, pageSize: pageSize);

  // ── Save / Unsave ─────────────────────────────────────
  @override
  Future<Result> saveItem({required SavedItemModel outfit}) =>
      remote.saveItem(outfit: outfit);

  @override
  Future<Result> unsaveItem({required SavedItemModel outfit}) =>
      remote.unsaveItem(userId: outfit.userId, itemId: outfit.itemId);

  // ── Saved items ───────────────────────────────────────
  @override
  Future<Result> getSavedItems(String userId) =>
      remote.getSavedItems(userId);
}