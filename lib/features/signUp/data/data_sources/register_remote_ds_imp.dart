import 'package:graduation_proj/features/signUp/data/data_sources/register_remote_ds.dart';

import '../../../../../core/apiManager/api_manager.dart';
import '../../../../../core/apiManager/dio_client.dart';
import '../../../../../core/apiManager/end_points.dart';
import '../../../../../core/handleErrors/result_pattern.dart';
import '../../../../core/cahsing/app_keys.dart';
import '../../../../core/cahsing/app_storage_service.dart';
import '../../../../core/cahsing/get_storage_helper.dart';
import '../../domain/repositories/register_repo.dart';
import '../models/regester_model.dart';

class RegisterRDSImpl implements RegisterRDS {
  @override
  Future<Result> register(RegisterModel model) async {
    final response = await ApiService.request(
      endpoint: AppEndPoints.register, // add to end_points.dart
      method: "POST",
      data: model.toJson(),
    );

    // ApiService already returns Result.failure on DioException
    if (response is Result) return response;
    // On success, optionally persist the token if the API returns one
    await DioClient.saveToken(response['token']);
    await saveUserData(model);
    await AppStorageService.instance.saveUserSession(
      token: response['token'],
      name: model.fullName,
      email: model.email,
    );
    return Result.success(response);
  }

  @override
  Future<Result> saveUserData(RegisterModel user) async {
    try {
      GetStorageHelper.write(AppKeys.name, user.fullName ?? "");
      GetStorageHelper.write(AppKeys.email, user.email);
      return Result.success("data saved");
    } catch (e) {
      return Result.failure("Failed to save data");
    }
  }
}
