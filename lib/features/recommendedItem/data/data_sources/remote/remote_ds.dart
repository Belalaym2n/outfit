
import '../../../../../core/handleErrors/result_pattern.dart';
import '../../../../savedItems/data/models/saved_item_model.dart';

abstract class OutfitRecommendRemoteDataSource {
   Future<Result> saveItem({required SavedItemModel outfit});
  Future<Result> unsaveItem({required String userId, required String itemId});
  Future<Result> getSavedItems(String userId);

 }