import 'package:image_picker/image_picker.dart';

import '../../../../core/handleErrors/result_pattern.dart';
import '../repositories/outfit_domain_repo.dart';

class AnalyzeOutfitUseCase {
  final OutfitDomainRepo repo;

  AnalyzeOutfitUseCase(this.repo);

  Future<Result> call(List<XFile?> images) async {
    // Domain-level validation before hitting network
    final filledSlots = images.where((img) => img != null).length;
    if (filledSlots < 3) {
      return Result.failure('Please add at least your Top, Bottom, and Shoes.');
    }

    final result = await repo.analyzeOutfit(images);
    if (result.isSuccess) return Result.success(result.data);
    return Result.failure(result.error);
  }
}