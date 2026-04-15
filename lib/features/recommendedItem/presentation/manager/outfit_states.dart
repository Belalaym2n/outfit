
import 'package:equatable/equatable.dart';

import '../../domain/entities/outfit_entity.dart';

// ─────────────────────────────────────────────────────────────
//  OutfitStatus — master status of the outfit list
// ─────────────────────────────────────────────────────────────
enum OutfitStatus {
  initial,
  loading,          // first-page full-screen loader
  success,          // data loaded, list visible
  paginationLoading,// loading next page (bottom indicator)
  error,            // hard failure
}

// ─────────────────────────────────────────────────────────────
//  SaveStatus — per-item save/unsave tracking
// ─────────────────────────────────────────────────────────────
enum SaveStatus { idle, loading, success, error }

// ─────────────────────────────────────────────────────────────
//  OutfitState — single immutable state object
// ─────────────────────────────────────────────────────────────
class OutfitState extends Equatable {
  final OutfitStatus status;
  final List<OutfitItemEntity> items;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  /// itemId → current save status (only active entries are kept)
  final Map<String, SaveStatus> saveStatuses;

  /// itemId → error message for individual save failures
  final Map<String, String?> saveErrors;

  const OutfitState({
    this.status = OutfitStatus.initial,
    this.items = const [],
    this.hasMore = true,
    this.currentPage = 0,
    this.errorMessage,
    this.saveStatuses = const {},
    this.saveErrors = const {},
  });

  // ── Convenience getters ───────────────────────────────────
  bool get isInitialLoading => status == OutfitStatus.loading && items.isEmpty;
  bool get isPaginationLoading => status == OutfitStatus.paginationLoading;

  SaveStatus saveStatusFor(String itemId) =>
      saveStatuses[itemId] ?? SaveStatus.idle;

  // ── Immutable copy ────────────────────────────────────────
  OutfitState copyWith({
    OutfitStatus? status,
    List<OutfitItemEntity>? items,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
    Map<String, SaveStatus>? saveStatuses,
    Map<String, String?>? saveErrors,
    bool clearError = false,
  }) {
    return OutfitState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      saveStatuses: saveStatuses ?? this.saveStatuses,
      saveErrors: saveErrors ?? this.saveErrors,
    );
  }

  /// Returns a new state with an updated isSaved flag for [itemId].
  OutfitState withToggledItem(String itemId, {required bool isSaved}) {
    final updated = items.map((item) {
      return item.id == itemId ? item.copyWith(isSaved: isSaved) : item;
    }).toList();
    return copyWith(items: updated);
  }

  /// Sets the save status for a single item.
  OutfitState withSaveStatus(String itemId, SaveStatus status, [String? error]) {
    return copyWith(
      saveStatuses: Map.from(saveStatuses)..[itemId] = status,
      saveErrors: Map.from(saveErrors)..[itemId] = error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    hasMore,
    currentPage,
    errorMessage,
    saveStatuses,
    saveErrors,
  ];
}