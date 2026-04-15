import 'package:image_picker/image_picker.dart';

import '../../../../core/handleErrors/result_pattern.dart';

abstract class OutfitDomainRepo {
  Future<Result> analyzeOutfit(List<XFile?> images);
}