import 'package:image_picker/image_picker.dart';

import '../../../../core/handleErrors/result_pattern.dart';
import '../../domain/repositories/outfit_domain_repo.dart';
import '../data_sources/remote/outfit_rds.dart';

class OutfitDataRepoImpl implements OutfitDomainRepo {
  final OutfitRDS outfitRDS;

  OutfitDataRepoImpl(this.outfitRDS);

  @override
  Future<Result> analyzeOutfit(List<XFile?> images) {
    return outfitRDS.analyzeOutfit(images);
  }


}
