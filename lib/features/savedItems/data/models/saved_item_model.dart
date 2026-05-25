import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
 import '../../../recommendedItem/data/models/outfit_item_model.dart';
import '../../../recommendedItem/domain/entities/saved_item_entity.dart';

class SavedItemModel extends Equatable {
  final String userId;
  final String itemId;
  final String category;
  final DateTime timestamp;
  final OutfitItemModel outfitModel;

  const SavedItemModel({
    required this.userId,
    required this.itemId,
    required this.category,
    required this.outfitModel,
    required this.timestamp,
  });

  factory SavedItemModel.fromJson(Map<String, dynamic> json) {
    return SavedItemModel(
      userId: json['userId'] as String,
      itemId: json['itemId'] as String,
      category: json['category'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),

      // ✅ FIX هنا
      outfitModel:  OutfitItemModel.fromJson(json['outfitModel'])
     );
  }
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'itemId': itemId,
    'category': category,
    'outfitModel': outfitModel.toJson(), // ✅ الصح
    'timestamp': Timestamp.fromDate(timestamp),
  };

  SavedItemModel toEntity() => SavedItemModel(
    userId: userId,
    itemId: itemId,
    category: category,
    outfitModel: outfitModel,
    timestamp: timestamp,
  );

  @override
  List<Object?> get props => [userId, itemId, category, timestamp];
}
