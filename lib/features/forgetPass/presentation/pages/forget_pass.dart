import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/sharedWidgets/main_wrapper.dart';
import 'package:graduation_proj/core/validations/auth_validation.dart';
import 'package:graduation_proj/features/bottom_nav/bottom_nav.dart';
import 'package:graduation_proj/features/forgetPass/presentation/widgets/email_sent_success.dart';
import 'package:graduation_proj/features/login/presentation/bloc/loginEvents.dart';
import 'package:graduation_proj/features/login/presentation/bloc/login_states.dart';

import '../../../../core/sharedWidgets/Buttons/bacl_button.dart';
import '../../../../core/sharedWidgets/Buttons/primary_buttons.dart';
import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/fields/text_form_field.dart';
import '../../../../core/sharedWidgets/text_styles.dart';
import '../../../../core/sharedWidgets/widgets/app_name.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../login/presentation/bloc/bloc.dart';
import '../../../signUp/presentation/pages/create_acc.dart';

class ForgotPasswordScreenItem extends StatefulWidget {
  ForgotPasswordScreenItem({super.key, required this.state});

  LoginState state;

  @override
  State<ForgotPasswordScreenItem> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreenItem>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _bgCtrl;
  late final AnimationController _btnCtrl;
  late final AnimationController _successCtrl; // drives success state

  // Entrance anims
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _fieldFade;
  late final Animation<Offset> _fieldSlide;
  late final Animation<double> _btnFade;
  late final Animation<Offset> _btnSlide;
  late final Animation<double> _footerFade;

  // Background
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  // Button spring
  late final Animation<double> _btnScale;

  // Success state
  // ── _successCtrl (600ms): scale 0→1 with easeOutBack for the icon,
  //    then a fade for the message text. Plays once on CTA tap.
  late final Animation<double> _successScale;
  late final Animation<double> _successFade;
  late final Animation<double> _contentFade; // fades OUT the form

  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
    _entranceCtrl.forward();
  }

  void _initControllers() {
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    )..repeat(reverse: true);
    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  void _initAnimations() {
    Animation<double> fade(double s, double e) => CurvedAnimation(
      parent: _entranceCtrl,
      curve: Interval(s, e, curve: Curves.easeOut),
    );
    Animation<Offset> slide(
      double s,
      double e, {
      Offset from = const Offset(0, 0.18),
    }) => Tween<Offset>(begin: from, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: Interval(s, e, curve: Curves.easeOutCubic),
      ),
    );

    _logoFade = fade(0.00, 0.30);
    _logoSlide = slide(0.00, 0.30, from: const Offset(0, 0.10));
    _titleFade = fade(0.10, 0.40);
    _titleSlide = slide(0.10, 0.40, from: const Offset(0, 0.14));
    _subtitleFade = fade(0.22, 0.50);
    _subtitleSlide = slide(0.22, 0.50, from: const Offset(0, 0.12));
    _fieldFade = fade(0.34, 0.62);
    _fieldSlide = slide(0.34, 0.62);
    _btnFade = fade(0.50, 0.78);
    _btnSlide = slide(0.50, 0.78, from: const Offset(0, 0.10));
    _footerFade = fade(0.68, 0.95);

    _bg1 = Tween<double>(
      begin: -14,
      end: 14,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
    _bg2 = Tween<double>(
      begin: 10,
      end: -10,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    _btnScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.02), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));

    // ── Success state animations
    // Icon: pop in with easeOutBack bounce
    _successScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    // Message text: fade in after icon lands
    _successFade = CurvedAnimation(
      parent: _successCtrl,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );
    // Form content fades out when success plays
    _contentFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _successCtrl,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );
  }

  final _emailCtrl = TextEditingController();

  Future<void> _onSendLink() async {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        ForgetPasswordPressed(_emailCtrl.text.trim()),
      );
      //  HapticFeedback.mediumImpact();
      // // Button press spring
      // await _btnCtrl.forward();
      // _btnCtrl.reset();
      // // Trigger success transition
      // setState(() => _submitted = true);
      // await Future.delayed(const Duration(milliseconds: 80));
      // _successCtrl.forward();
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _bgCtrl.dispose();
    _btnCtrl.dispose();
    _successCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final hPad = mq.size.width >= 600 ? 48.0 : 24.0;

    print(widget.state );
    return MainWrapper(
      childWidget: Scaffold(
        backgroundColor: AppColors.bg,
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              AmbientBg(float1: _bg1, float2: _bg2),

              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Back + wordmark
                      FadeSlide(
                        fade: _logoFade,
                        slide: _logoSlide,
                        child: Row(
                          children: [
                            BackBtn(onTap: () => Navigator.pop(context)),
                            const SizedBox(width: 12),
                            const Wordmark(),
                          ],
                        ),
                      ),

                      SizedBox(height: Sp.lg),
                      // ── SUCCESS STATE — overlays entire form area
                      if (widget.state.status ==
                          LoginStatus.sendEmailSuccess) ...[
                        navigateToSuccess()
                      ] else ...[
                        FadeSlide(
                          fade: _logoFade,
                          slide: _logoSlide,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Text('RESET PASSWORD', style: T.caption),
                          ),
                        ),

                        const SizedBox(height: 14),

                        FadeSlide(
                          fade: _titleFade,
                          slide: _titleSlide,
                          child: Text('Reset\nPassword', style: T.display),
                        ),

                        const SizedBox(height: 10),

                        FadeSlide(
                          fade: _subtitleFade,
                          slide: _subtitleSlide,
                          child: Text(
                            'Enter your email address and we\'ll send you a link to reset your password.',
                            style: T.subtitle,
                          ),
                        ),

                        const SizedBox(height: Sp.lg),

                        FadeSlide(
                          fade: _fieldFade,
                          slide: _fieldSlide,
                          child: CustomTextField(
                            controller: _emailCtrl,
                            validator: AuthValidator.validateEmail,
                            label: 'Email address',
                            hint: 'you@example.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                          ),
                        ),

                        const SizedBox(height: Sp.md),

                        // ── Send link CTA
                        FadeSlide(
                          fade: _btnFade,
                          slide: _btnSlide,
                          child: PrimaryBtn(
                            label: 'Send Reset Link',
                            scale: _btnScale,
                            onTap: _onSendLink,
                          ),
                        ),

                        const SizedBox(height: Sp.md),

                        // ── Back to login link
                        FadeTransition(
                          opacity: _footerFade,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: RichText(
                                text: TextSpan(
                                  style: T.bodySmall,
                                  children: [
                                    const TextSpan(
                                      text: 'Remember your password?  ',
                                    ),
                                    TextSpan(
                                      text: 'Sign In',
                                      style: T.link.copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 Widget navigateToSuccess()   {
    HapticFeedback.mediumImpact();
    // Button press spring
     _btnCtrl.reset();
    _successCtrl.forward();
    return EmailSentSuccessView(
        scaleAnim: _successScale,
        fadeAnim: _successFade,
        onBack: () => Navigator.pop(context));
  }
}
