

// features/history/domain/repositories/outfit_history_domain_repo.dart

import '../../../../core/handleErrors/result_pattern.dart';


abstract class OutfitHistoryDomainRepo {
  Future<Result> fetchHistory({required int pageIndex, required int pageSize});

  Future<Result> deleteHistory(int id);
}