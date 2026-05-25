// features/history/data/outfit_history_rds.dart

import '../../../../core/handleErrors/result_pattern.dart';

abstract class OutfitHistoryRDS {
  /// [pageIndex] is 1-based (matches API contract).
  Future<Result> fetchHistory({required int pageIndex, required int pageSize});

  Future<Result> deleteHistory(int id);
}
