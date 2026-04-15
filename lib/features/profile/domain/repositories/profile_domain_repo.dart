import 'package:graduation_proj/core/handleErrors/result_pattern.dart';

abstract class ProfileRepository{

  Future<Result>getProfile();
}