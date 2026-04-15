

 import '../entities/outfit_entity.dart';
import '../entities/saved_item_entity.dart';
import '../repositories/outfit_domain_repo.dart';

// ── GetOutfitsUseCase ─────────────────────────────────────────
class GetOutfitsUseCase {
  final OutfitRepository _repository;
  GetOutfitsUseCase(this._repository);

  Future<List<OutfitItemEntity>> call({
    required int page,
    required int pageSize,
    String? userId,
  }) async {
    final items = await _repository.getOutfits(page: page, pageSize: pageSize);

    if (userId == null) return items;

    final savedIds = await _repository.getSavedItemIds(userId);
    return items.map((e) => e.copyWith(isSaved: savedIds.contains(e.id))).toList();
  }
}

// ── LoadMoreOutfitsUseCase ────────────────────────────────────
// Alias with semantic meaning; delegates to GetOutfitsUseCase.
class LoadMoreOutfitsUseCase {
  final GetOutfitsUseCase _getOutfits;
  LoadMoreOutfitsUseCase(this._getOutfits);

  Future<List<OutfitItemEntity>> call({
    required int page,
    required int pageSize,
    String? userId,
  }) =>
      _getOutfits(page: page, pageSize: pageSize, userId: userId);
}

// ── SaveItemUseCase ───────────────────────────────────────────
class SaveItemUseCase {
  final OutfitRepository _repository;
  SaveItemUseCase(this._repository);

  Future<void> call({
    required String userId,
    required String itemId,
    required String category,
  }) =>
      _repository.saveItem(
        userId: userId,
        itemId: itemId,
        category: category,
      );
}

// ── UnsaveItemUseCase ─────────────────────────────────────────
class UnsaveItemUseCase {
  final OutfitRepository _repository;
  UnsaveItemUseCase(this._repository);

  Future<void> call({required String userId, required String itemId}) =>
      _repository.unsaveItem(userId: userId, itemId: itemId);
}

// ── GetSavedItemsUseCase ──────────────────────────────────────
class GetSavedItemsUseCase {
  final OutfitRepository _repository;
  GetSavedItemsUseCase(this._repository);

  Future<List<SavedItemEntity>> call(String userId) =>
      _repository.getSavedItems(userId);

  /// Returns the top N categories the user saves the most.
  /// Used to seed the recommendation engine.
  Future<List<String>> getTopCategories(String userId, {int topN = 5}) async {
    final saved = await _repository.getSavedItems(userId);

    final freq = <String, int>{};
    for (final item in saved) {
      freq[item.category] = (freq[item.category] ?? 0) + 1;
    }

    final sorted = freq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(topN).map((e) => e.key).toList();
  }
}