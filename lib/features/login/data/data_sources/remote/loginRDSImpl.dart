import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:graduation_proj/features/login/data/models/user_model.dart';

import '../../../../../core/apiManager/api_manager.dart';
import '../../../../../core/apiManager/dio_client.dart';
import '../../../../../core/apiManager/end_points.dart';
import '../../../../../core/cahsing/app_keys.dart';
import '../../../../../core/cahsing/app_storage_service.dart';
import '../../../../../core/cahsing/get_storage_helper.dart';
import '../../../../../core/cahsing/load_data.dart';
 import '../../../../../core/handleErrors/result_pattern.dart';
import '../../models/loginModel.dart';
 import 'loginRDS.dart';

class LoginRDSImpl implements LoginRDS {
  @override
  Future<Result> login(LoginModel model) async {
    final response = await ApiService.request(
      endpoint: AppEndPoints.login,
      method: "POST",
      data: model.toJson(),
    );

    if (response is Result) {
      return response; // Result.failure
    }
    final user = UserModel.fromJson(response);

    await DioClient.saveToken(user.token);

    await AppStorageService.instance.saveUserSession(
      token: response['token'],
      name: user.fullName,
      email: model.email,
    );
    return Result.success(response);
  }

  @override
  Future<Result> saveUserData(UserModel user) async {
    try {
      print("user ${user.fullName}");
      GetStorageHelper.write(AppKeys.name, user.fullName ?? "");
      GetStorageHelper.write(AppKeys.email, user.email);
      return Result.success("data saved");
    } catch (e) {
      return Result.failure("Failed to save data");
    }
  }

  @override
  Future<Result> sendPasswordResetEmail(String email) async {
    print("locale ${UserLocalService.cachedUser?.lang ?? "en"}");
    // TODO: implement sendPasswordResetEmail
    final response = await ApiService.request(
      endpoint: AppEndPoints.forgetPass,
      method: "POST",
      queryParameters: {"locale": UserLocalService.cachedUser?.lang ?? "en"},
      data: {"email": email},
    );
    // if (response is Result) {
    //   return response; // Result.failure
    // }
    return Result.success({
      "message": "Password reset email sent successfully"
    });
    // return Result.success(response);
  }
}
