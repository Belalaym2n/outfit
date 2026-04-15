
import '../../../../savedItems/data/models/saved_item_model.dart';

abstract class OutfitRemoteDataSource {
  Future<void> saveItem({
    required String userId,
    required String itemId,
    required String category,
  });

  Future<void> unsaveItem({
    required String userId,
    required String itemId,
  });

  Future<List<SavedItemModel>> getSavedItems(String userId);

  Future<Set<String>> getSavedItemIds(String userId);
}