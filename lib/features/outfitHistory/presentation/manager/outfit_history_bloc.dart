// features/history/presentation/manager/outfit_history_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/outfit_history_model.dart';
 import '../../data/models/pagination_repsonse.dart';
import '../../domain/use_cases/get_outfit_use_case.dart';
import 'events.dart';
import 'states.dart';

class OutfitHistoryBloc
    extends Bloc<OutfitHistoryEvent, OutfitHistoryState> {
  final GetOutfitHistoryUseCase getOutfitHistoryUseCase;
  final DeleteOutfitHistoryUseCase deleteOutfitHistoryUseCase;

  OutfitHistoryBloc({
    required this.getOutfitHistoryUseCase,
    required this.deleteOutfitHistoryUseCase,
  }) : super(const OutfitHistoryState()) {
    on<FetchFirstPageEvent>(_onFetchFirstPage);
    on<FetchNextPageEvent>(_onFetchNextPage);
    on<DeleteOutfitHistoryEvent>(_onDelete);
  }

  // ─── First page (replaces all data) ────────────────────────────────────────

  Future<void> _onFetchFirstPage(
      FetchFirstPageEvent event,
      Emitter<OutfitHistoryState> emit,
      ) async {
    // Avoid duplicate first-page requests while one is already in flight.
    if (state.status == OutfitHistoryStatus.firstPageLoading) return;

    emit(state.copyWith(
      status: OutfitHistoryStatus.firstPageLoading,
      // Reset pagination cursor so a refresh always starts from page 1.
      nextPage: 1,
      hasReachedMax: false,
      error: null,
    ));

    final result = await getOutfitHistoryUseCase(pageIndex: 1);

    if (!result.isSuccess) {
      emit(state.copyWith(
        status: OutfitHistoryStatus.firstPageError,
        error: result.error?.toString(),
      ));
      return;
    }

    final page = result.data as PaginatedResponse<OutfitHistoryModel>;

    if (page.data.isEmpty) {
      emit(state.copyWith(
        status: OutfitHistoryStatus.empty,
        items: const [],
        hasReachedMax: true,
        nextPage: 1,
      ));
      return;
    }

    emit(state.copyWith(
      status: page.isLastPage
          ? OutfitHistoryStatus.noMoreData
          : OutfitHistoryStatus.loaded,
      items: page.data, // replace — first page
      nextPage: 2,      // next fetch will request page 2
      hasReachedMax: page.isLastPage,
      error: null,
    ));
  }

  // ─── Next page (appends to existing data) ──────────────────────────────────

  Future<void> _onFetchNextPage(
      FetchNextPageEvent event,
      Emitter<OutfitHistoryState> emit,
      ) async {
    // Guard: do nothing if there's nothing more, or a fetch is already running.
    if (state.hasReachedMax) return;
    if (state.status == OutfitHistoryStatus.paginationLoading) return;
    if (state.status == OutfitHistoryStatus.firstPageLoading) return;

    emit(state.copyWith(
      status: OutfitHistoryStatus.paginationLoading,
      error: null,
    ));

    final result =
    await getOutfitHistoryUseCase(pageIndex: state.nextPage);

    if (!result.isSuccess) {
      // Preserve existing list — only show an inline error indicator.
      emit(state.copyWith(
        status: OutfitHistoryStatus.paginationError,
        error: result.error?.toString(),
      ));
      return;
    }

    final page = result.data as PaginatedResponse<OutfitHistoryModel>;

    if (page.data.isEmpty) {
      // Server returned an empty page — we have everything.
      emit(state.copyWith(
        status: OutfitHistoryStatus.noMoreData,
        hasReachedMax: true,
      ));
      return;
    }

    // Deduplicate: only add items whose id is not already in the list.
    final existingIds = state.items.map((e) => e.id).toSet();
    final newItems =
    page.data.where((e) => !existingIds.contains(e.id)).toList();

    final merged = [...state.items, ...newItems];

    emit(state.copyWith(
      status: page.isLastPage
          ? OutfitHistoryStatus.noMoreData
          : OutfitHistoryStatus.loaded,
      items: merged,
      nextPage: state.nextPage + 1,
      hasReachedMax: page.isLastPage,
      error: null,
    ));
  }

  // ─── Delete (optimistic) ───────────────────────────────────────────────────

  Future<void> _onDelete(
      DeleteOutfitHistoryEvent event,
      Emitter<OutfitHistoryState> emit,
      ) async {
    final snapshot = state.items; // keep a rollback copy
    final updated = state.items.where((e) => e.id != event.id).toList();

    // Optimistically remove item from UI immediately.
    emit(state.copyWith(
      items: updated,
      status: updated.isEmpty
          ? OutfitHistoryStatus.empty
          : state.status,
    ));

    final result = await deleteOutfitHistoryUseCase(event.id);

    if (!result.isSuccess) {
      // Rollback on server error so the user doesn't lose data silently.
      emit(state.copyWith(
        items: snapshot,
        status: OutfitHistoryStatus.paginationError,
        error: result.error?.toString(),
      ));
    }

    // ── Refill heuristic ──────────────────────────────────────────────────
    // If after deletion the local list has fewer items than one full page
    // AND the server still has more data, fetch the next page to keep the
    // list feeling full (avoids a half-empty screen with a "load more" prompt).
    if (result.isSuccess &&
        !state.hasReachedMax &&
        state.items.length < kDefaultPageSize) {
      add(const FetchNextPageEvent());
    }
  }
}