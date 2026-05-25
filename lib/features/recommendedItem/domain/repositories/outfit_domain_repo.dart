
import '../../../../core/handleErrors/result_pattern.dart';
import '../../../savedItems/data/models/saved_item_model.dart';
import '../../data/models/outfit_item_model.dart';
import '../entities/outfit_entity.dart';
 import '../entities/saved_item_entity.dart';

abstract class OutfitRepository {
  /// Returns a paginated list of outfit items.
  /// [page] starts at 0. [pageSize] items are returned per page.
  Future<Result> getOutfits({
    required int page,
    required int pageSize,
  });

  /// Saves an item for the current user in Firestore.
  Future<Result> saveItem({
    required SavedItemModel outfit

  });

  /// Removes a saved item for the current user from Firestore.
  Future<Result> unsaveItem({
    required SavedItemModel outfit

  });

  /// Returns all saved item records for [userId].
  Future<Result> getSavedItems(String userId);

  /// Returns saved item IDs for [userId] (quick lookup set).
 }