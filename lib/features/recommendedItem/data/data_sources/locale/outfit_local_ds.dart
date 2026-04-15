
import '../../models/outfit_item_model.dart';
import '../../models/outfit_statiic_data.dart';

abstract class OutfitLocalDataSource {
  Future<List<OutfitItemModel>> getOutfits({
    required int page,
    required int pageSize,
  });

  bool get hasMore;
  int get totalCount;
}

class OutfitLocalDataSourceImpl implements OutfitLocalDataSource {
  final List<OutfitItemModel> _allItems = OutfitStaticData.all;

  @override
  int get totalCount => _allItems.length;

  @override
  bool get hasMore => false; // evaluated per-call; see getOutfits

  @override
  Future<List<OutfitItemModel>> getOutfits({
    required int page,
    required int pageSize,
  }) async {
    // Simulate realistic network/DB latency
    await Future.delayed(
      Duration(milliseconds: page == 0 ? 800 : 500),
    );

    final start = page * pageSize;
    if (start >= _allItems.length) return [];

    final end = (start + pageSize).clamp(0, _allItems.length);
    return _allItems.sublist(start, end);
  }

  bool hasMoreItems(int page, int pageSize) {
    return (page + 1) * pageSize < _allItems.length;
  }
}