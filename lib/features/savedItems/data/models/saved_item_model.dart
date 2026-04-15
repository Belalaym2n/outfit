
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../recommendedItem/domain/entities/saved_item_entity.dart';

class SavedItemModel extends Equatable {
  final String userId;
  final String itemId;
  final String category;
  final DateTime timestamp;

  const SavedItemModel({
    required this.userId,
    required this.itemId,
    required this.category,
    required this.timestamp,
  });

  factory SavedItemModel.fromJson(Map<String, dynamic> json) {
    return SavedItemModel(
      userId: json['userId'] as String,
      itemId: json['itemId'] as String,
      category: json['category'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'itemId': itemId,
    'category': category,
    'timestamp': Timestamp.fromDate(timestamp),
  };

  SavedItemEntity toEntity() => SavedItemEntity(
    userId: userId,
    itemId: itemId,
    category: category,
    timestamp: timestamp,
  );

  @override
  List<Object?> get props => [userId, itemId, category, timestamp];
}