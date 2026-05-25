// features/history/presentation/manager/events.dart

import 'package:equatable/equatable.dart';

abstract class OutfitHistoryEvent extends Equatable {
  const OutfitHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load page 1 and replace all existing data.
/// Used on first open and pull-to-refresh.
class FetchFirstPageEvent extends OutfitHistoryEvent {
  const FetchFirstPageEvent();
}

/// Append next page to existing list.
/// Fired by the scroll listener when nearing the bottom.
class FetchNextPageEvent extends OutfitHistoryEvent {
  const FetchNextPageEvent();
}

/// Delete a single item by id (optimistic UI update).
class DeleteOutfitHistoryEvent extends OutfitHistoryEvent {
  final int id;

  const DeleteOutfitHistoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}