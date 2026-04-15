import '../../../../core/handleErrors/result_pattern.dart';

abstract class ProfileRDS {
  Future<Result> getProfile();
}