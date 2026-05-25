// ─────────────────────────────────────────────────────────────
//  outfit_use_cases.dart  —  Domain use cases
//  Each use case has a single, focused responsibility.
//  getSavedItemIds is no longer called inside getOutfits;
//  that concern belongs in the notifier (parallel fetch).
// ─────────────────────────────────────────────────────────────

import 'package:graduation_proj/core/handleErrors/result_pattern.dart';
import 'package:graduation_proj/features/savedItems/data/models/saved_item_model.dart';

import '../../data/models/outfit_item_model.dart';
import '../entities/outfit_entity.dart';
import '../entities/saved_item_entity.dart';
import '../repositories/outfit_domain_repo.dart';

// ── GetOutfitsUseCase ────────────────────────────────────────
/// Fetches a paginated page of outfits.
/// isSaved merging is handled at the notifier level (not here)
/// to avoid redundant network calls.
class GetOutfitsUseCase {
  const GetOutfitsUseCase(this._repository);
  final OutfitRepository _repository;

  Future<Result> call({
    required int page,
    required int pageSize,
  }) =>
      _repository.getOutfits(page: page, pageSize: pageSize);
}

// ── LoadMoreOutfitsUseCase ───────────────────────────────────
/// Semantic alias; delegates to GetOutfitsUseCase.
class LoadMoreOutfitsUseCase {
  const LoadMoreOutfitsUseCase(this._getOutfits);
  final GetOutfitsUseCase _getOutfits;

  Future<Result> call({
    required int page,
    required int pageSize,
    String? userId, // kept for API parity, unused in static source
  }) =>
      _getOutfits(page: page, pageSize: pageSize);
}

// ── SaveItemUseCase ──────────────────────────────────────────
class SaveItemUseCase {
  const SaveItemUseCase(this._repository);
  final OutfitRepository _repository;

  Future<Result> call({
    required SavedItemModel outfit
  }) =>
      _repository.saveItem(outfit:outfit);
}

// ── UnsaveItemUseCase ────────────────────────────────────────
class UnsaveItemUseCase {
  const UnsaveItemUseCase(this._repository);
  final OutfitRepository _repository;

  Future<Result> call({    required SavedItemModel outfit
  }) =>
      _repository.unsaveItem(outfit:outfit);
}

// ── GetSavedItemsUseCase ─────────────────────────────────────
class GetSavedItemsUseCase {
  const GetSavedItemsUseCase(this._repository);
  final OutfitRepository _repository;

  Future<Result> call(String userId) =>
      _repository.getSavedItems(userId);

  Future<Result> getIds(String userId) =>
      _repository.getSavedItems(userId);

  // /// Returns top N categories by save frequency.
  // Future<List<String>> getTopCategories(String userId, {int topN = 5}) async {
  //   final saved = await _repository.getSavedItems(userId);
  //   final freq = <String, int>{};
  //   for (final item in saved) {
  //     freq.update(item.category, (v) => v + 1, ifAbsent: () => 1);
  //   }
  //   return (freq.entries.toList()
  //     ..sort((a, b) => b.value.compareTo(a.value)))
  //       .take(topN)
  //       .map((e) => e.key)
  //       .toList(growable: false);
  // }
}