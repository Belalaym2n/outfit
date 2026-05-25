import 'package:equatable/equatable.dart';

import '../../../savedItems/data/models/saved_item_model.dart';

abstract class OutfitEvent extends Equatable {
  const OutfitEvent();

  @override
  List<Object?> get props => [];
}

/// Load first page + merge saved-item flags in one shot.
class LoadOutfitsEvent extends OutfitEvent {
  final String userId;
  const LoadOutfitsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Append next page.
class LoadMoreOutfitsEvent extends OutfitEvent {
  const LoadMoreOutfitsEvent();
}

/// Pull-to-refresh — resets to page 0.
class RefreshOutfitsEvent extends OutfitEvent {
  const RefreshOutfitsEvent();
}

/// Persist a save to Firestore + flip UI optimistically.
class SaveItemEvent extends OutfitEvent {
  final SavedItemModel outfit;
  const SaveItemEvent({required this.outfit});

  @override
  List<Object?> get props => [outfit];
}

/// Remove a saved item from Firestore + flip UI optimistically.
class UnsaveItemEvent extends OutfitEvent {
  final SavedItemModel outfit;
  const UnsaveItemEvent({required this.outfit});

  @override
  List<Object?> get props => [outfit];
}