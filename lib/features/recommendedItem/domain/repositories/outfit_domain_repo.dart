
import '../entities/outfit_entity.dart';
 import '../entities/saved_item_entity.dart';

abstract class OutfitRepository {
  /// Returns a paginated list of outfit items.
  /// [page] starts at 0. [pageSize] items are returned per page.
  Future<List<OutfitItemEntity>> getOutfits({
    required int page,
    required int pageSize,
  });

  /// Saves an item for the current user in Firestore.
  Future<void> saveItem({
    required String userId,
    required String itemId,
    required String category,
  });

  /// Removes a saved item for the current user from Firestore.
  Future<void> unsaveItem({
    required String userId,
    required String itemId,
  });

  /// Returns all saved item records for [userId].
  Future<List<SavedItemEntity>> getSavedItems(String userId);

  /// Returns saved item IDs for [userId] (quick lookup set).
  Future<Set<String>> getSavedItemIds(String userId);
}