// features/history/repo/outfit_history_repo.dart

import '../../../../core/handleErrors/result_pattern.dart';
import '../../domain/repositories/outfit_domain_repo.dart';
import '../data_sources/outfit_history_remote_ds.dart';



class OutfitHistoryDataRepoImpl implements OutfitHistoryDomainRepo {
  final OutfitHistoryRDS outfitHistoryRDS;

  const OutfitHistoryDataRepoImpl(this.outfitHistoryRDS);

  @override
  Future<Result> fetchHistory({
    required int pageIndex,
    required int pageSize,
  }) =>
      outfitHistoryRDS.fetchHistory(
        pageIndex: pageIndex,
        pageSize: pageSize,
      );

  @override
  Future<Result> deleteHistory(int id) => outfitHistoryRDS.deleteHistory(id);
}