import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';
import 'package:graduation_proj/features/profile/presentation/pages/profile_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/app_snack_bar.dart';
import '../../domain/use_cases/get_user_data_use_case.dart';
import '../manager/profile_bloc.dart';
import '../manager/profile_event.dart';
import '../manager/profile_states.dart';
import '../widgets/commonWidget/profile_skelton.dart';

class ProfileScreenPage extends StatefulWidget {
  const ProfileScreenPage({super.key});

  @override
  State<ProfileScreenPage> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreenPage> {
  @override
  void initState() {
    super.initState();

    // 🔥 fetch data أول ما الشاشة تفتح
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.white),
      backgroundColor: AppColors.surface,
      body: BlocProvider(
        create: (_) =>
            ProfileBloc(getProfileUseCase: getIt<GetProfileUseCase>())
              ..add(ProfileFetchRequested()),

        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            // ❌ Error
            if (state.status == ProfileStatus.error) {
              AppSnackBar.showError(
                context,
                state.errorMsg ?? "Something went wrong",
              );
            }
          },

          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return ProfileSkeleton(hPad: 1);
            }
            if (state.status == ProfileStatus.success) {
              return ProfileScreen(userModel: state.user!);
            }

            return SizedBox();
            // 🔥 Loading Overlay (Skeleton أو Loader)
          },
        ),
      ),
    );
  }
}
