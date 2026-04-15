
import 'package:equatable/equatable.dart';

class SavedItemEntity extends Equatable {
  final String userId;
  final String itemId;
  final String category;
  final DateTime timestamp;

  const SavedItemEntity({
    required this.userId,
    required this.itemId,
    required this.category,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [userId, itemId, category, timestamp];
}