
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_proj/features/recommendedItem/data/data_sources/remote/remote_ds.dart';

import '../../../../savedItems/data/models/saved_item_model.dart';

/// Firestore collection: `saved_items`
///
/// Document ID: `{userId}_{itemId}` — guarantees uniqueness & easy lookup.
///
/// Schema:
/// ```
/// saved_items/{userId}_{itemId}
///   userId   : String
///   itemId   : String
///   category : String
///   timestamp: Timestamp
/// ```
class OutfitRemoteDataSourceImpl implements OutfitRemoteDataSource {
  final FirebaseFirestore _firestore;

  // Injected for testability; defaults to the singleton instance.
  OutfitRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Collection reference ──────────────────────────────────
  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('saved_items');

  String _docId(String userId, String itemId) => '${userId}_$itemId';

  // ── Save ─────────────────────────────────────────────────
  @override
  Future<void> saveItem({
    required String userId,
    required String itemId,
    required String category,
  }) async {
    final model = SavedItemModel(
      userId: userId,
      itemId: itemId,
      category: category,
      timestamp: DateTime.now(),
    );

    await _col.doc(_docId(userId, itemId)).set(model.toJson());
  }

  // ── Unsave ────────────────────────────────────────────────
  @override
  Future<void> unsaveItem({
    required String userId,
    required String itemId,
  }) async {
    await _col.doc(_docId(userId, itemId)).delete();
  }

  // ── Get all saved items ───────────────────────────────────
  @override
  Future<List<SavedItemModel>> getSavedItems(String userId) async {
    final snapshot = await _col
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SavedItemModel.fromJson(doc.data()))
        .toList();
  }

  // ── Get saved IDs (lightweight) ───────────────────────────
  @override
  Future<Set<String>> getSavedItemIds(String userId) async {
    final snapshot = await _col
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => doc.data()['itemId'] as String)
        .toSet();
  }
}