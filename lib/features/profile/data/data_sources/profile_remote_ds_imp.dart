import 'package:graduation_proj/features/profile/data/data_sources/profile_remote_ds.dart';

import '../../../../../core/apiManager/api_manager.dart';
import '../../../../../core/apiManager/end_points.dart';
import '../../../../../core/handleErrors/result_pattern.dart';
import '../models/user_data.dart';


class ProfileRDSImpl implements ProfileRDS {

  UserModel user=
  UserModel(
    id: "1",
    name:  "Belal Ayman",
    email: "belal@example.com",
    badge: "AI Explorer",
    avatarUrl: null,
    analyses:  24,
    avgScore:   87,
    saved: 12,
    journeyProgress: 0.65,
    journeyMessage: "Keep pushing forward 🚀",
  );

  @override
  Future<Result> getProfile() async {
    await Future.delayed(const Duration(seconds: 2));

    // // ApiService returns a Result directly on failure
    // if (response is Result) return response;
    //
    // // Guard: empty or null body → emit empty state upstream
    // if (response == null) return Result.empty();

    // final user = UserModel.fromJson(response as Map<String, dynamic>);
    return Result.success(user);
  }
}