import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseManager {
  static CollectionReference<T> getCollection<T>({
    required String collectionName,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<T>(
      fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
      toFirestore: (model, _) => toJson(model),
    );
  }

  static Future<void> uploadModel<T>({
    required String collectionName,
    required T model,
    String? docId, // If null, will auto-generate
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final collection = getCollection<T>(
      collectionName: collectionName,
      fromJson: fromJson,
      toJson: toJson,
    );

    final docRef = docId != null ?
    collection.doc(docId) : collection.doc();

    await docRef.set(model);
  }
}
