// features/history/presentation/manager/states.dart

import 'package:equatable/equatable.dart';
import '../../data/models/outfit_history_model.dart';

/// Describes every possible UI condition for the history screen.
enum OutfitHistoryStatus {
  /// Screen just opened — nothing fetched yet.
  initial,

  /// First page is loading (full-screen spinner).
  firstPageLoading,

  /// First page failed (full-screen error).
  firstPageError,

  /// At least one page loaded successfully; list is visible.
  loaded,

  /// Appending a next page (bottom spinner visible, list still shown).
  paginationLoading,

  /// Next-page request failed; list stays visible with an inline retry.
  paginationError,

  /// Server confirmed there are no more items.
  noMoreData,

  /// List is loaded but contains zero items.
  empty,
}

class OutfitHistoryState extends Equatable {
  final OutfitHistoryStatus status;

  /// Accumulated items across all loaded pages.
  final List<OutfitHistoryModel> items;

  /// Human-readable error text (first-page or pagination error).
  final String? error;

  /// The next page index the Bloc should request.
  /// Starts at 1; incremented only after a successful fetch.
  final int nextPage;

  /// Whether the API has signalled that no further pages exist.
  final bool hasReachedMax;

  const OutfitHistoryState({
    this.status = OutfitHistoryStatus.initial,
    this.items = const [],
    this.error,
    this.nextPage = 1,
    this.hasReachedMax = false,
  });

  OutfitHistoryState copyWith({
    OutfitHistoryStatus? status,
    List<OutfitHistoryModel>? items,
    String? error,
    int? nextPage,
    bool? hasReachedMax,
  }) {
    return OutfitHistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      // Passing null explicitly clears the error (e.g. on retry success).
      error: error,
      nextPage: nextPage ?? this.nextPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  /// Convenience getters used by the UI.
  bool get isFirstLoad =>
      status == OutfitHistoryStatus.firstPageLoading ||
          status == OutfitHistoryStatus.initial;

  bool get canLoadMore =>
      !hasReachedMax &&
          status != OutfitHistoryStatus.paginationLoading &&
          status != OutfitHistoryStatus.firstPageLoading;

  @override
  List<Object?> get props =>
      [status, items, error, nextPage, hasReachedMax];
}