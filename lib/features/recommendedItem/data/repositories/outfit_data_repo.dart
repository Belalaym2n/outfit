
import '../../domain/entities/outfit_entity.dart';
 import '../../domain/entities/saved_item_entity.dart';
import '../../domain/repositories/outfit_domain_repo.dart';
import '../data_sources/locale/outfit_local_ds.dart';
import '../data_sources/remote/remote_ds.dart';

class OutfitRepositoryImpl implements OutfitRepository {
  final OutfitLocalDataSource _local;
  final OutfitRemoteDataSource _remote;

  OutfitRepositoryImpl({
    required OutfitLocalDataSource local,
    required OutfitRemoteDataSource remote,
  })  : _local = local,
        _remote = remote;

  // ── Outfits (from local static source) ───────────────────
  @override
  Future<List<OutfitItemEntity>> getOutfits({
    required int page,
    required int pageSize,
  }) async {
    final models = await _local.getOutfits(page: page, pageSize: pageSize);
    return models.map((m) => m.toEntity()).toList();
  }

  // ── Save / Unsave ─────────────────────────────────────────
  @override
  Future<void> saveItem({
    required String userId,
    required String itemId,
    required String category,
  }) =>
      _remote.saveItem(
        userId: userId,
        itemId: itemId,
        category: category,
      );

  @override
  Future<void> unsaveItem({
    required String userId,
    required String itemId,
  }) =>
      _remote.unsaveItem(userId: userId, itemId: itemId);

  // ── Saved items ───────────────────────────────────────────
  @override
  Future<List<SavedItemEntity>> getSavedItems(String userId) async {
    final models = await _remote.getSavedItems(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Set<String>> getSavedItemIds(String userId) =>
      _remote.getSavedItemIds(userId);
}