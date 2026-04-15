import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/app_snack_bar.dart';
import '../../../../core/sharedWidgets/custom_loading.dart';
import '../../../../core/sharedWidgets/main_wrapper.dart';
import '../../../login/domain/use_cases/forget_password_use_case.dart';
import '../../../login/domain/use_cases/login_use_case.dart';
import '../../../login/presentation/bloc/bloc.dart';
import '../../../login/presentation/bloc/login_states.dart';
import 'forget_pass.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        loginUseCase: getIt<LoginUseCase>(),
        forgetPasswordUseCase: getIt<ForgetPasswordUseCase>(),
      ),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state.status == LoginStatus.loading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Dialog(
                backgroundColor: Colors.transparent,
                child: CustomLoadingWidget(),
              ),
            );
          } else if (state.status == LoginStatus.sendEmailSuccess) {
            Navigator.pop(context);


          } else if (state.status == LoginStatus.sendEmailFailure) {
            Navigator.pop(context);

            AppSnackBar.showError(
              context,
              state.error ?? "Something went wrong!",
            );
          }
        },

        builder: (context, state) {
          return MainWrapper(
            childWidget: AbsorbPointer(
              absorbing: state.status == LoginStatus.loading,
              child: ForgotPasswordScreenItem(state: state),
            ),
          );
        },
      ),
    );
  }
}
