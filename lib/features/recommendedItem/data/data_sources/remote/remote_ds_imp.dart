import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_proj/features/recommendedItem/data/data_sources/remote/remote_ds.dart';

import '../../../../../core/handleErrors/result_pattern.dart';
import '../../../../savedItems/data/models/saved_item_model.dart';


class OutfitRecommendRemoteDataSourceImpl implements OutfitRecommendRemoteDataSource {

  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('saved_items');

   String _docId(String userId, String itemId) => '${userId}_$itemId';

  // ── Save ──────────────────────────────────────────────────────────────────
  @override
  Future<Result> saveItem({required SavedItemModel outfit}) async {
    try {
      await _col
          .doc(_docId(outfit.userId, outfit.itemId))
          .set(outfit.toJson());
      return Result.success(null);
    } catch (e) {
       return Result.failure(e.toString());
    }
  }

   @override
  Future<Result> unsaveItem({
    required String userId,
    required String itemId,
  }) async {
    try {
      await _col.doc(_docId(userId, itemId)).delete();
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  /// Create it in the Firebase console or deploy via firestore.indexes.json.
  @override
  Future<Result> getSavedItems(String userId) async {
    try {

       final snapshot = await _col
          .where('userId', isEqualTo: userId) // ← use the passed userId, not email
          .orderBy('timestamp', descending: true)
          .get();



      final data = snapshot.docs
          .map((doc) => SavedItemModel.fromJson(doc.data()))

          .toList();

      print("dataa ${data[0].userId}");
      return Result.success(data);
    } catch (e) {
      print("errpr ${e.toString()}");
      return Result.failure(e.toString());
    }
  }
}