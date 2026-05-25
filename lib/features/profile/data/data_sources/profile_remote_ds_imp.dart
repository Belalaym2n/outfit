import 'package:graduation_proj/features/profile/data/data_sources/profile_remote_ds.dart';

import '../../../../../core/handleErrors/result_pattern.dart';
import '../../../../core/apiManager/api_manager.dart';
import '../../../../core/apiManager/end_points.dart';
import '../models/user_data.dart';

class ProfileRDSImpl implements ProfileRDS {
  UserModel userData = UserModel(
     name: "Belal Ayman",
    email: "belalAy@example.com",
    analyses: 1,
    avgScore: 100,

    journeyMessage: "Keep pushing forward 🚀",
  );

  @override
  Future<Result> getProfile() async {
    final response = await ApiService.request(
      endpoint: AppEndPoints.profile,
      method: "GET",
     );

    if (response is Result) {
      return response; // Result.failure
    }
    final user = UserModel.fromJson(response);

    // // ApiService returns a Result directly on failure
    // if (response is Result) return response;
    //
    // // Guard: empty or null body → emit empty state upstream
    // if (response == null) return Result.empty();

    // final user = UserModel.fromJson(response as Map<String, dynamic>);
    return Result.success(user);
  }
}
