import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/cahsing/app_storage_service.dart';

import '../../../savedItems/data/models/saved_item_model.dart';
import '../../data/models/outfit_item_model.dart';
import '../../domain/use_cases/outfit_use_cases.dart';
import 'events.dart'
    show
        UnsaveItemEvent,
        LoadMoreOutfitsEvent,
        OutfitEvent,
        LoadOutfitsEvent,
        RefreshOutfitsEvent,
        SaveItemEvent;
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
  }) : _getOutfits = getOutfits,
       _loadMore = loadMore,
       _saveItem = saveItem,
       _unsaveItem = unsaveItem,
       _getSavedItems = getSavedItems,
       super(const OutfitState()) {
    on<LoadOutfitsEvent>(_onLoad);
    on<RefreshOutfitsEvent>(_onRefresh);
    on<SaveItemEvent>(_onSave);
    on<UnsaveItemEvent>(_onUnsave);
  }

  // ── LOAD (initial — fetches list + saved flags in parallel) ───────────────
  Future<void> _onLoad(
    LoadOutfitsEvent event,
    Emitter<OutfitState> emit,
  ) async {
    emit(state.copyWith(status: OutfitStatus.loading, clearError: true));

    await Future.delayed(Duration(seconds: 4));
    // Run both requests concurrently.
    final results = await Future.wait([
      _getOutfits(page: 0, pageSize: _pageSize),
      _getSavedItems(event.userId),
    ]);

    final rawItems = results[0].data as List<OutfitItemModel>;
    final savedResult = results[1]; // Result<List<SavedItemModel>>

    // Build a Set<String> of saved IDs; fall back to empty set on error.
    final Set<String> savedIds = savedResult.isSuccess
        ? (savedResult.data as List<SavedItemModel>)
              .map((e) => e.itemId)
              .toSet()
        : {};

    // Stamp isSaved on every item — pure, no mutation.
    final items = rawItems
        .map((item) => item.copyWith(isSaved: savedIds.contains(item.id)))
        .toList();

    emit(
      state.copyWith(
        status: OutfitStatus.success,
        items: items,
        savedIds: savedIds,
        currentPage: 0,
        hasMore: rawItems.length == _pageSize,
        clearError: true, // 🔥 مهم
      ),
    );
  }

  // ── REFRESH ───────────────────────────────────────────────────────────────
  Future<void> _onRefresh(
    RefreshOutfitsEvent event,
    Emitter<OutfitState> emit,
  ) async {
    try {
      add(LoadOutfitsEvent(userId: AppStorageService.instance.getEmail()));
    } catch (e) {
      emit(
        state.copyWith(status: OutfitStatus.error, errorMessage: e.toString()),
      );
    }
  }

  // ── SAVE ──────────────────────────────────────────────────────────────────
  Future<void> _onSave(SaveItemEvent event, Emitter<OutfitState> emit) async {
    final itemId = event.outfit.itemId;

    // Optimistic UI: flip to saved immediately + show per-item loader.
    emit(
      state
          .copyWith(
            savedIds: {...state.savedIds, itemId}, // 🔥 أضف هنا
          )
          .withSaveStatus(itemId, SaveStatus.loading)
          .withToggledItem(itemId, isSaved: true),
    );

    final result = await _saveItem(outfit: event.outfit);

    print("got ot ");
    if (result.isSuccess) {
      print("success ");

      emit(state.withSaveStatus(itemId, SaveStatus.success));
    } else {
      // Roll back the optimistic toggle on failure.
      emit(
        state
            .withSaveStatus(itemId, SaveStatus.error, result.error.toString())
            .withToggledItem(itemId, isSaved: false),
      );
    }
  }

  // ── UNSAVE ────────────────────────────────────────────────────────────────
  Future<void> _onUnsave(
    UnsaveItemEvent event,
    Emitter<OutfitState> emit,
  ) async {
    final itemId = event.outfit.itemId;
    final newSavedIds = Set<String>.from(state.savedIds)..remove(itemId);

    // Optimistic UI: flip to unsaved immediately + show per-item loader.
    emit(
      state
          .withSaveStatus(itemId, SaveStatus.loading)
          .withToggledItem(itemId, isSaved: false)
          .copyWith(savedIds: newSavedIds), // 🔥
    );

    final result = await _unsaveItem(outfit: event.outfit);

    if (result.isSuccess) {
      emit(state.withSaveStatus(itemId, SaveStatus.success));
    } else {
      // Roll back on failure.
      emit(
        state
            .withSaveStatus(itemId, SaveStatus.error, result.error.toString())
            .withToggledItem(itemId, isSaved: true),
      );
    }
  }
}
