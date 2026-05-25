import 'package:equatable/equatable.dart';

import '../../data/models/outfit_item_model.dart';

// ── Master list status ────────────────────────────────────────────────────────
enum OutfitStatus {
  initial,
  loading,           // first-page full-screen loader
  success,           // data loaded, list visible
  paginationLoading, // loading next page (bottom indicator)
  error,             // hard failure
}

// ── Per-item save / unsave status ─────────────────────────────────────────────
enum SaveStatus { idle, loading, success, error }

// ─────────────────────────────────────────────────────────────────────────────
//  Single immutable state object
// ─────────────────────────────────────────────────────────────────────────────
class OutfitState extends Equatable {
  final OutfitStatus status;
  final List<OutfitItemModel> items;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;
  final Set<String> savedIds;
  /// itemId → current per-item save status
  final Map<String, SaveStatus> saveStatuses;

  /// itemId → error message for individual save failures
  final Map<String, String?> saveErrors;

  const OutfitState({
    this.status = OutfitStatus.initial,
    this.items = const [],
    this.hasMore = true,
    this.currentPage = 0,this.savedIds = const {},
    this.errorMessage,
    this.saveStatuses = const {},
    this.saveErrors = const {},
  });

  // ── Convenience getters ───────────────────────────────────────────────────
  bool get isInitialLoading =>
      status == OutfitStatus.loading && items.isEmpty;

  bool get isPaginationLoading =>
      status == OutfitStatus.paginationLoading;

  SaveStatus saveStatusFor(String itemId) =>
      saveStatuses[itemId] ?? SaveStatus.idle;

  // ── Immutable copy ────────────────────────────────────────────────────────
  OutfitState copyWith({
    OutfitStatus? status,
    List<OutfitItemModel>? items,
    bool? hasMore,
    int? currentPage,Set<String>? savedIds,
    String? errorMessage,
    Map<String, SaveStatus>? saveStatuses,
    Map<String, String?>? saveErrors,
    bool clearError = false,
  }) {
    return OutfitState(
      status: status ?? this.status,
      items: items ?? this.items,
      savedIds: savedIds??this.savedIds,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      saveStatuses: saveStatuses ?? this.saveStatuses,
      saveErrors: saveErrors ?? this.saveErrors,
    );
  }

  /// Returns a new state with the `isSaved` flag toggled for one item.
  /// Uses [OutfitItemModel.copyWith] — no mutable mutation needed.
  OutfitState withToggledItem(String itemId, {required bool isSaved}) {
    final updatedItems = items.map((item) {
      return item.id == itemId ? item.copyWith(isSaved: isSaved) : item;
    }).toList();
    return copyWith(items: updatedItems);
  }

  /// Sets the per-item save status (and optional error message).
  OutfitState withSaveStatus(
      String itemId,
      SaveStatus saveStatus, [
        String? error,
      ]) {
    return copyWith(
      saveStatuses: Map.from(saveStatuses)..[itemId] = saveStatus,
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
    savedIds, // 🔥 أهم سطر
    saveStatuses,
    saveErrors,
  ];}