// features/history/domain/use_cases/get_outfit_use_case.dart

import '../../../../core/handleErrors/result_pattern.dart';
import '../repositories/outfit_domain_repo.dart';

const int kDefaultPageSize = 10;

class GetOutfitHistoryUseCase {
  final OutfitHistoryDomainRepo repo;

  const GetOutfitHistoryUseCase(this.repo);

  Future<Result> call({
    required int pageIndex,
    int pageSize = kDefaultPageSize,
  }) =>
      repo.fetchHistory(pageIndex: pageIndex, pageSize: pageSize);
}

class DeleteOutfitHistoryUseCase {
  final OutfitHistoryDomainRepo repo;

  const DeleteOutfitHistoryUseCase(this.repo);

  Future<Result> call(int id) => repo.deleteHistory(id);
}