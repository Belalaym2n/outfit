// ═══════════════════════════════════════════════════════════════
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_proj/core/sharedWidgets/main_wrapper.dart';
import 'package:graduation_proj/features/signUp/presentation/widgets/create_acc_item.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/Buttons/primary_buttons.dart';
import '../../../../core/sharedWidgets/app_snack_bar.dart';
import '../../../../core/sharedWidgets/custom_loading.dart';
import '../../../../core/sharedWidgets/fields/text_form_field.dart';
import '../../../../core/sharedWidgets/text_styles.dart';
import '../../../../core/utils/app_constants.dart';

import '../../../../core/sharedWidgets/Buttons/bacl_button.dart';
import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/widgets/app_name.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/validations/auth_validation.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../compatapilityModel/presentation/pages/request_to_recommend.dart'
    show C;
import '../../data/models/regester_model.dart';
import '../../domain/use_cases/register_use_case.dart';
import '../manager/register_bloc.dart';
import '../manager/register_events.dart';
import '../manager/register_states.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  // Button spring
  late final Animation<double> _btnScale;

  bool _agreedToTerms = false;
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    // NEW: dispose text controllers
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPassCtrl.dispose();
    // existing disposals unchanged

    super.dispose();
  }

  late final _fields = [
    (
    label: 'Full Name',
    hint: 'Belal Ayman',
    password: false,
    kbType: TextInputType.name,
    ctrl: _fullNameCtrl,
    validator: AuthValidator.validateField,
    ),
    (
    label: 'Email address',
    hint: 'belalscge@gmail.com',
    password: false,
    kbType: TextInputType.emailAddress,
    ctrl: _emailCtrl,
    validator: AuthValidator.validateEmail,
    ),
    (
    label: 'Password',
    hint: '••••••••',
    password: true,
    kbType: TextInputType.text,
    ctrl: _passwordCtrl,
    validator: AuthValidator.validatePassword,
    ),
    (
    label: 'Confirm Password',
    hint: '••••••••',
    password: true,
    kbType: TextInputType.text,
    ctrl: _confirmPassCtrl,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return LocaleKeys.Validations_Auth_field_required.tr();
      }

      if (value.trim() != _passwordCtrl.text.trim()) {
        return "Passwords do not match";
      }

      return null;
    })
  ];

  Future<void> _onCreateAccount(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();

      context.read<RegisterBloc>().add(
        RegisterButtonPressed(
          RegisterModel(
            fullName: _fullNameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
            confirmPassword: _confirmPassCtrl.text,
            isAgree: _agreedToTerms,
          ),
        ),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => RegisterBloc(registerUseCase: getIt<RegisterUseCase>()),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          // Loading dialog — exact same pattern as LoginScreen
          if (state.status == RegisterStatus.loading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) =>
              const Dialog(
                backgroundColor: Colors.transparent,
                child: CustomLoadingWidget(),
              ),
            );
          }
          // Success
          else if (state.status == RegisterStatus.success) {
            print('navigation');
            Navigator.pop(context); // close loading dialog

            context.go(AppRoutes.home);           }
          // Failure
          else if (state.status == RegisterStatus.failure) {
            // Close loading dialog only if it was open
            if (Navigator.canPop(context)) Navigator.pop(context);
            AppSnackBar.showError(
              context,
              state.error ?? 'Registration failed.',
            );
          } else if (state.status == RegisterStatus.validationError) {
            AppSnackBar.showError(
              context,
              state.error ?? 'Registration failed.',
            );
          }
        },

        builder: (context, state) {
          return MainWrapper(
            childWidget: Form(
              key: _formKey,
              child: SignUpScreenItem(
                changeTerms: () =>
                    setState(() => _agreedToTerms = !_agreedToTerms),
                agreedToTerms: _agreedToTerms,

                onTap: () => _onCreateAccount(context),
                fields: _fields,
              ),
            ),
          );
        },
      ),
    );
  }
}
