//
// // ─────────────────────────────────────────────────────────────
// //  outfit_state.dart  —  Single source of truth for outfit data
// //  Uses ValueNotifier for O(1) rebuild targeting.
// //  NO UI code here. Pure logic/state only.
// // ─────────────────────────────────────────────────────────────
//
// import 'package:flutter/foundation.dart';
// import '../../recommendedItem/domain/entities/outfit_entity.dart';
// import '../../recommendedItem/domain/use_cases/outfit_use_cases.dart';
//
// // ── Pagination constants ──────────────────────────────────────
// const int kPageSize = 12;
//
// // ── Save operation status (per item) ─────────────────────────
// enum SaveOpStatus { idle, loading, error }
//
// // ── Pagination status ─────────────────────────────────────────
// enum PaginationStatus { idle, loading, loadingMore, done, error }
//
// // ─────────────────────────────────────────────────────────────
// //  OutfitNotifier  —  manages outfit list + saved set
// // ─────────────────────────────────────────────────────────────
// class OutfitNotifier extends ChangeNotifier {
//   OutfitNotifier({
//     required GetOutfitsUseCase getOutfits,
//     required LoadMoreOutfitsUseCase loadMore,
//     required SaveItemUseCase saveItem,
//     required UnsaveItemUseCase unsaveItem,
//     required GetSavedItemsUseCase getSavedItems,
//   })  : _getOutfits = getOutfits,
//         _loadMore = loadMore,
//         _saveItem = saveItem,
//         _unsaveItem = unsaveItem,
//         _getSavedItems = getSavedItems;
//
//   final GetOutfitsUseCase _getOutfits;
//   final LoadMoreOutfitsUseCase _loadMore;
//   final SaveItemUseCase _saveItem;
//   final UnsaveItemUseCase _unsaveItem;
//   final GetSavedItemsUseCase _getSavedItems;
//
//   // ── Public state ──────────────────────────────────────────
//   final List<OutfitItemModel> items = [];
//
//   /// O(1) lookup: saved item IDs
//   final Set<String> savedIds = {};
//
//   PaginationStatus paginationStatus = PaginationStatus.idle;
//   String? errorMessage;
//
//   int _currentPage = 0;
//   bool _hasMore = true;
//   bool _isFetchingMore = false;
//
//   bool get hasMore => _hasMore;
//   bool get isLoadingMore => paginationStatus == PaginationStatus.loadingMore;
//   bool get isInitialLoading => paginationStatus == PaginationStatus.loading && items.isEmpty;
//
//   /// Per-item save operation status: itemId → status
//   /// Only active entries are stored (idle items are absent = O(1) lookup with absent=idle)
//   final Map<String, SaveOpStatus> _saveOps = {};
//
//   SaveOpStatus saveOpFor(String id) => _saveOps[id] ?? SaveOpStatus.idle;
//
//   // ── Per-item ValueNotifiers for surgical rebuilds ─────────
//   /// Each item gets its own notifier so only that card rebuilds.
//   final Map<String, ValueNotifier<bool>> _savedNotifiers = {};
//
//   /// Returns (creates if absent) a notifier for [itemId].
//   /// Widget subscribes with ValueListenableBuilder — zero full-list rebuilds.
//   ValueNotifier<bool> savedNotifierFor(String itemId) {
//     return _savedNotifiers.putIfAbsent(
//       itemId,
//           () => ValueNotifier<bool>(savedIds.contains(itemId)),
//     );
//   }
//
//   // ── Init / Load ───────────────────────────────────────────
//   Future<void> load({String? userId}) async {
//     if (paginationStatus == PaginationStatus.loading) return;
//     paginationStatus = PaginationStatus.loading;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       // Parallel: outfits + saved IDs
//       final results = await Future.wait([
//         _getOutfits(page: 0, pageSize: kPageSize),
//         if (userId != null)
//           _getSavedItems(userId).then((_) => _getSavedItemIds(userId))
//         else
//           Future.value(<String>{}),
//       ]);
//
//       final outfits = results[0] as List<OutfitItemModel>;
//       final fetchedSavedIds = results[1] as Set<String>;
//
//       items
//         ..clear()
//         ..addAll(outfits);
//
//       savedIds
//         ..clear()
//         ..addAll(fetchedSavedIds);
//
//       // Sync all notifiers
//       _syncAllNotifiers();
//
//       _currentPage = 0;
//       _hasMore = outfits.length == kPageSize;
//       paginationStatus = _hasMore ? PaginationStatus.idle : PaginationStatus.done;
//     } catch (e) {
//       paginationStatus = PaginationStatus.error;
//       errorMessage = e.toString();
//     }
//
//     notifyListeners();
//   }
//
//   Future<Set<String>> _getSavedItemIds(String userId) async {
//     final saved = await _getSavedItems(userId);
//     return saved.map((e) => e.itemId).toSet();
//   }
//
//   // ── Pagination: load next page ────────────────────────────
//   Future<void> loadMore({String? userId}) async {
//     if (_isFetchingMore || !_hasMore) return;
//     _isFetchingMore = true;
//     paginationStatus = PaginationStatus.loadingMore;
//     notifyListeners();
//
//     try {
//       final nextPage = _currentPage + 1;
//       final newItems = await _loadMore(
//         page: nextPage,
//         pageSize: kPageSize,
//         userId: userId,
//       );
//
//       for (final item in newItems) {
//         items.add(item);
//         // Sync notifier if already created for this id
//         _savedNotifiers[item.id]?.value = savedIds.contains(item.id);
//       }
//
//       _currentPage = nextPage;
//       _hasMore = newItems.length == kPageSize;
//       paginationStatus = _hasMore ? PaginationStatus.idle : PaginationStatus.done;
//     } catch (_) {
//       // Keep existing items; just stop showing loader
//       paginationStatus = PaginationStatus.idle;
//     }
//
//     _isFetchingMore = false;
//     notifyListeners();
//   }
//
//   // ── Refresh ───────────────────────────────────────────────
//   Future<void> refresh({String? userId}) async {
//     _currentPage = 0;
//     _hasMore = true;
//     _isFetchingMore = false;
//     await load(userId: userId);
//   }
//
//   // ── Toggle Save ───────────────────────────────────────────
//   /// Optimistic update → sync backend → rollback on error
//   Future<void> toggleSave({
//     required String itemId,
//     required String category,
//     required String userId,
//   }) async {
//     final wasSaved = savedIds.contains(itemId);
//
//     // 1. Optimistic UI
//     _applyToggle(itemId, isSaved: !wasSaved);
//     _saveOps[itemId] = SaveOpStatus.loading;
//     notifyListeners();
//
//     try {
//       if (wasSaved) {
//         await _unsaveItem(userId: userId, itemId: itemId);
//       } else {
//         await _saveItem(userId: userId, itemId: itemId, category: category);
//       }
//       _saveOps.remove(itemId); // back to idle
//     } catch (_) {
//       // Rollback
//       _applyToggle(itemId, isSaved: wasSaved);
//       _saveOps[itemId] = SaveOpStatus.error;
//     }
//
//     notifyListeners();
//   }
//
//   // ── Internal helpers ──────────────────────────────────────
//   void _applyToggle(String itemId, {required bool isSaved}) {
//     if (isSaved) {
//       savedIds.add(itemId);
//     } else {
//       savedIds.remove(itemId);
//     }
//     // Surgical: only this notifier fires → only this card rebuilds
//     _savedNotifiers[itemId]?.value = isSaved;
//   }
//
//   void _syncAllNotifiers() {
//     for (final notifier in _savedNotifiers.entries) {
//       notifier.value.value = savedIds.contains(notifier.key);
//     }
//   }
//
//   @override
//   void dispose() {
//     for (final n in _savedNotifiers.values) {
//       n.dispose();
//     }
//     super.dispose();
//   }
// }