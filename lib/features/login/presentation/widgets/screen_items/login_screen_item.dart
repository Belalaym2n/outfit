// ═══════════════════════════════════════════════════════════════
//  AI OUTFIT RECOMMENDATION — AUTHENTICATION SCREENS
//  Login · Sign Up · Forgot Password
//  Theme: Warm Off-White · Luxury Minimal · Apple × Linear SaaS
// ═══════════════════════════════════════════════════════════════
//
//  ANIMATION SYSTEM OVERVIEW
//  ──────────────────────────────────────────────────────────────
//  Every screen shares the same 3-controller pattern:
//
//  1. _entranceCtrl (1400ms)
//     Orchestrates the entire page entrance via Interval() windows.
//     Title → subtitle → fields (staggered) → CTA → footer.
//     A single controller = a single dispose call. Clean.
//
//  2. _bgCtrl (7000ms, repeat-reverse)
//     Drives slow ambient background shape float.
//     Runs independently — never competes with entrance.
//     Max opacity 0.04 so shapes are felt, not seen.
//
//  3. _btnCtrl (220ms)
//     TweenSequence: compress (1.0→0.95) → spring (0.95→1.02)
//     → settle (1.02→1.0). Mimics physical button feedback.
//
//  Navigation between screens uses a custom SlidePageRoute
//  that translates the incoming screen from bottom-right,
//  creating a smooth lateral flow between auth states.
//
//  The  CustomTextField widget owns its own FocusNode and
//  AnimatedContainer that scales the border/shadow on focus.
//  This keeps field animations localised and efficient.
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/validations/auth_validation.dart';
import 'package:graduation_proj/features/bottom_nav/bottom_nav.dart';
import 'package:graduation_proj/features/forgetPass/presentation/pages/forget_password_screen.dart';
import 'package:graduation_proj/features/login/presentation/bloc/bloc.dart';
import 'package:graduation_proj/features/login/presentation/bloc/loginEvents.dart';

import '../../../../../core/sharedWidgets/Buttons/primary_buttons.dart';
import '../../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/sharedWidgets/animations/slide_naviagation.dart';
import '../../../../../core/sharedWidgets/fields/text_form_field.dart';
import '../../../../../core/sharedWidgets/text_styles.dart';
import '../../../../../core/sharedWidgets/widgets/app_name.dart';
import '../../../../../core/sharedWidgets/widgets/divider.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../forgetPass/presentation/pages/forget_pass.dart';
import '../../../../signUp/presentation/pages/create_acc.dart';
import '../../../data/models/loginModel.dart';

class LoginScreenItem extends StatefulWidget {
  const LoginScreenItem({super.key});

  @override
  State<LoginScreenItem> createState() => _LoginScreenItemState();
}

class _LoginScreenItemState extends State<LoginScreenItem>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────
  late final AnimationController _entranceCtrl;
  late final AnimationController _bgCtrl;
  late final AnimationController _btnCtrl;

  // ── Entrance animations (Interval-staggered) ─────────────────
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _field1Fade;
  late final Animation<Offset> _field1Slide;
  late final Animation<double> _field2Fade;
  late final Animation<Offset> _field2Slide;
  late final Animation<double> _forgotFade;
  late final Animation<double> _btnFade;
  late final Animation<Offset> _btnSlide;
  late final Animation<double> _footerFade;

  // ── Background float ─────────────────────────────────────────
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  // ── Button spring ─────────────────────────────────────────────
  late final Animation<double> _btnScale;

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
      duration: const Duration(milliseconds: 1400),
    );
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    )..repeat(reverse: true);
    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  void _initAnimations() {
    // Helper factories
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

    // Staggered windows: each element starts ~0.10 after previous
    _logoFade = fade(0.00, 0.30);
    _logoSlide = slide(0.00, 0.30, from: const Offset(0, 0.10));
    _titleFade = fade(0.08, 0.38);
    _titleSlide = slide(0.08, 0.38, from: const Offset(0, 0.14));
    _subtitleFade = fade(0.18, 0.46);
    _subtitleSlide = slide(0.18, 0.46, from: const Offset(0, 0.12));
    _field1Fade = fade(0.28, 0.56);
    _field1Slide = slide(0.28, 0.56);
    _field2Fade = fade(0.36, 0.62);
    _field2Slide = slide(0.36, 0.62);
    _forgotFade = fade(0.44, 0.68);
    _btnFade = fade(0.52, 0.78);
    _btnSlide = slide(0.52, 0.78, from: const Offset(0, 0.10));
    _footerFade = fade(0.68, 0.95);

    // Ambient background
    _bg1 = Tween<double>(
      begin: -14,
      end: 14,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
    _bg2 = Tween<double>(
      begin: 10,
      end: -10,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    // Button spring
    _btnScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.02), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));
  }

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // NEW: dispose text controllers
    _emailCtrl.dispose();
    _passwordCtrl.dispose();

    _entranceCtrl.dispose();
    _bgCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final hPad = mq.size.width >= 600 ? 48.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            // Ambient background
            AmbientBg(float1: _bg1, float2: _bg2),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  mq.padding.top > 20 ? 16 : 32,
                  hPad,
                  32,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        mq.size.height -
                        mq.padding.top -
                        mq.padding.bottom -
                        64,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Wordmark
                      FadeSlide(
                        fade: _logoFade,
                        slide: _logoSlide,
                        child: const Wordmark(),
                      ),

                      SizedBox(height: Sp.lg),

                      // ── Step tag
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
                          child: Text('SIGN IN', style: T.caption),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── Title
                      FadeSlide(
                        fade: _titleFade,
                        slide: _titleSlide,
                        child: Text('Welcome\nBack', style: T.display),
                      ),

                      const SizedBox(height: 10),

                      // ── Subtitle
                      FadeSlide(
                        fade: _subtitleFade,
                        slide: _subtitleSlide,
                        child: Text(
                          'Sign in to continue your AI outfit analysis.',
                          style: T.subtitle,
                        ),
                      ),

                      const SizedBox(height: Sp.lg),

                      // ── Email field
                      FadeSlide(
                        fade: _field1Fade,
                        slide: _field1Slide,
                        child: CustomTextField(
                          controller: _emailCtrl,
                          validator: AuthValidator.validateEmail,

                          label: 'Email address',
                          hint: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),

                      const SizedBox(height: Sp.sm),

                      // ── Password field
                      FadeSlide(
                        fade: _field2Fade,
                        slide: _field2Slide,
                        child: CustomTextField(
                          controller: _passwordCtrl,
                          validator: AuthValidator.validatePassword,

                          label: 'Password',
                          hint: '••••••••',
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                        ),
                      ),

                      const SizedBox(height: 14),

                      forgetPass(),

                      const SizedBox(height: Sp.md),

                      // ── Sign In CTA
                      signInButton(),

                      const SizedBox(height: Sp.md),

                      // ── Divider
                      FadeTransition(
                        opacity: _footerFade,
                        child: const OrDivider(),
                      ),

                      const SizedBox(height: Sp.md),

                      createAcc(),
                      // ── Create account
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget forgetPass() {
    return FadeTransition(
      opacity: _forgotFade,
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            SlideRoute(page: const ForgetPasswordScreen()),
          ),
          child: Text('Forgot Password?', style: T.link),
        ),
      ),
    );
  }

  Widget signInButton() {
    return FadeSlide(
      fade: _btnFade,
      slide: _btnSlide,
      child: PrimaryBtn(
        label: 'Sign In',
        scale: _btnScale,
        onTap: () {
          if (_formKey.currentState!.validate()) {
            context.read<LoginBloc>().add(
              LoginButtonPressed(
                model: LoginModel(
                  email: _emailCtrl.text.trim(),
                  password: _passwordCtrl.text.trim(),
                ),
              ),
            );

          }
        },
      ),
    );
  }

  Widget createAcc() {
    return FadeTransition(
      opacity: _footerFade,
      child: Center(
        child: GestureDetector(
          onTap: () =>
              Navigator.push(context, SlideRoute(page: const SignUpScreen())),
          child: RichText(
            text: TextSpan(
              style: T.bodySmall,
              children: [
                const TextSpan(text: "Don't have an account?  "),
                TextSpan(
                  text: 'Create Account',
                  style: T.link.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



}
