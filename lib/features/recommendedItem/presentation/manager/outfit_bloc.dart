import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/outfit_use_cases.dart';
import 'events.dart';
 import 'outfit_states.dart';

class OutfitBloc extends Bloc<OutfitEvent, OutfitState> {
  final GetOutfitsUseCase _getOutfits;
  final LoadMoreOutfitsUseCase _loadMore;
  final SaveItemUseCase _saveItem;
  final UnsaveItemUseCase _unsaveItem;
  final GetSavedItemsUseCase _getSavedItems;

  static const int _pageSize = 12;

  OutfitBloc({
    required GetOutfitsUseCase getOutfits,
    required LoadMoreOutfitsUseCase loadMore,
    required SaveItemUseCase saveItem,
    required UnsaveItemUseCase unsaveItem,
    required GetSavedItemsUseCase getSavedItems,
  })  : _getOutfits = getOutfits,
        _loadMore = loadMore,
        _saveItem = saveItem,
        _unsaveItem = unsaveItem,
        _getSavedItems = getSavedItems,
        super(const OutfitState()) {
    on<LoadOutfitsEvent>(_onLoad);
    on<LoadMoreOutfitsEvent>(_onLoadMore);
    on<RefreshOutfitsEvent>(_onRefresh);
    on<SaveItemEvent>(_onSave);
    on<UnsaveItemEvent>(_onUnsave);
  }

  // ── Helpers ───────────────────────────────────────────────
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // ── LOAD (initial) ────────────────────────────────────────
  Future<void> _onLoad(
      LoadOutfitsEvent event,
      Emitter<OutfitState> emit,
      ) async {
    emit(state.copyWith(status: OutfitStatus.loading));

    try {
      final items = await _getOutfits(
        page: 0,
        pageSize: _pageSize,
        userId: _userId,
      );

      emit(state.copyWith(
        status: OutfitStatus.success,
        items: items,
        currentPage: 0,
        hasMore: items.length == _pageSize,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OutfitStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── LOAD MORE (pagination) ────────────────────────────────
  Future<void> _onLoadMore(
      LoadMoreOutfitsEvent event,
      Emitter<OutfitState> emit,
      ) async {
    // Guard: no duplicate requests
    if (!state.hasMore || state.isPaginationLoading) return;

    emit(state.copyWith(status: OutfitStatus.paginationLoading));

    try {
      final nextPage = state.currentPage + 1;
      final newItems = await _loadMore(
        page: nextPage,
        pageSize: _pageSize,
        userId: _userId,
      );

      emit(state.copyWith(
        status: OutfitStatus.success,
        items: [...state.items, ...newItems],
        currentPage: nextPage,
        hasMore: newItems.length == _pageSize,
      ));
    } catch (e) {
      // On pagination error, keep existing items visible
      emit(state.copyWith(
        status: OutfitStatus.success,
        errorMessage: 'Failed to load more. Try again.',
      ));
    }
  }

  // ── REFRESH ───────────────────────────────────────────────
  Future<void> _onRefresh(
      RefreshOutfitsEvent event,
      Emitter<OutfitState> emit,
      ) async {
    try {
      final items = await _getOutfits(
        page: 0,
        pageSize: _pageSize,
        userId: _userId,
      );

      emit(state.copyWith(
        status: OutfitStatus.success,
        items: items,
        currentPage: 0,
        hasMore: items.length == _pageSize,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OutfitStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // ── SAVE ──────────────────────────────────────────────────
  Future<void> _onSave(
      SaveItemEvent event,
      Emitter<OutfitState> emit,
      ) async {
    if (_userId == null) return;

    // Optimistically flip the UI first
    emit(
      state
          .withSaveStatus(event.itemId, SaveStatus.loading)
          .withToggledItem(event.itemId, isSaved: true),
    );

    try {
      await _saveItem(
        userId: _userId!,
        itemId: event.itemId,
        category: event.category,
      );

      emit(state.withSaveStatus(event.itemId, SaveStatus.success));
    } catch (e) {
      // Roll back optimistic update on failure
      emit(
        state
            .withSaveStatus(event.itemId, SaveStatus.error, e.toString())
            .withToggledItem(event.itemId, isSaved: false),
      );
    }
  }

  // ── UNSAVE ────────────────────────────────────────────────
  Future<void> _onUnsave(
      UnsaveItemEvent event,
      Emitter<OutfitState> emit,
      ) async {
    if (_userId == null) return;

    // Optimistically flip the UI first
    emit(
      state
          .withSaveStatus(event.itemId, SaveStatus.loading)
          .withToggledItem(event.itemId, isSaved: false),
    );

    try {
      await _unsaveItem(userId: _userId!, itemId: event.itemId);
      emit(state.withSaveStatus(event.itemId, SaveStatus.success));
    } catch (e) {
      // Roll back
      emit(
        state
            .withSaveStatus(event.itemId, SaveStatus.error, e.toString())
            .withToggledItem(event.itemId, isSaved: true),
      );
    }
  }
}