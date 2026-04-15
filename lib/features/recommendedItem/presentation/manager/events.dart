
import 'package:equatable/equatable.dart';

abstract class OutfitEvent extends Equatable {
  const OutfitEvent();

  @override
  List<Object?> get props => [];
}

// ── Initial load ──────────────────────────────────────────────
class LoadOutfitsEvent extends OutfitEvent {
  const LoadOutfitsEvent();
}

// ── Pagination ────────────────────────────────────────────────
class LoadMoreOutfitsEvent extends OutfitEvent {
  const LoadMoreOutfitsEvent();
}

// ── Pull-to-refresh ───────────────────────────────────────────
class RefreshOutfitsEvent extends OutfitEvent {
  const RefreshOutfitsEvent();
}

// ── Save ──────────────────────────────────────────────────────
class SaveItemEvent extends OutfitEvent {
  final String itemId;
  final String category;

  const SaveItemEvent({required this.itemId, required this.category});

  @override
  List<Object?> get props => [itemId, category];
}

// ── Unsave ────────────────────────────────────────────────────
class UnsaveItemEvent extends OutfitEvent {
  final String itemId;

  const UnsaveItemEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}