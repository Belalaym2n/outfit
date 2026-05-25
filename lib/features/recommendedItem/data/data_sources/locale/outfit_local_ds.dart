// ─────────────────────────────────────────────────────────────
//  outfit_local_ds.dart  —  Local static data source
//  Handles pagination purely by offset. No stale hasMore field.
// ─────────────────────────────────────────────────────────────

import 'package:graduation_proj/features/recommendedItem/data/models/outfit_item_model.dart';

import '../../../../../core/handleErrors/result_pattern.dart';

abstract class OutfitLocalDataSource {
  Future<Result> getOutfits({required int page, required int pageSize});

  int get totalCount;

  bool hasMoreAfter(int page, int pageSize);
}

class OutfitLocalDataSourceImpl implements OutfitLocalDataSource {
  // Lazy-initialized once; immutable after that.
  static final List<OutfitItemModel> _allItems =fakeOutfits;

  @override
  int get totalCount => _allItems.length;

  @override
  bool hasMoreAfter(int page, int pageSize) =>
      (page + 1) * pageSize < _allItems.length;

  @override
  Future<Result> getOutfits({required int page, required int pageSize}) async {
    try {
      // Simulated latency (first page slightly longer)
      await Future.delayed(Duration(milliseconds: page == 0 ? 600 : 350));

      final start = page * pageSize;

      final end = (start + pageSize).clamp(0, _allItems.length);
      return Result.success(_allItems.sublist(start, end));
    } catch (e) {
      return Result.failure("error");
    }
  }
}
