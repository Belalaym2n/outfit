import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/app_snack_bar.dart';
import '../../../../core/sharedWidgets/custom_loading.dart';
import '../../../../core/sharedWidgets/main_wrapper.dart';
import '../../domain/use_cases/forget_password_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../bloc/bloc.dart' show LoginBloc;
import '../bloc/login_states.dart';
import '../widgets/screen_items/login_screen_item.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
          }

          else if (state.status == LoginStatus.success) {
            Navigator.pop(context);

            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.bottomNav,
                  (route) => false,
            );

           }

          else if (state.status == LoginStatus.failure) {
            Navigator.pop(context);

            AppSnackBar.showError(context, state.error ?? "Login Failed");
          }
        },

        builder: (context, state) {
          return  MainWrapper(
            childWidget: AbsorbPointer(
              absorbing: state.status == LoginStatus.loading,
              child: LoginScreenItem(),
            ),
          );
        },
      ),
    );
  }
  // BELAL@gmail.com  Aa123456@
}