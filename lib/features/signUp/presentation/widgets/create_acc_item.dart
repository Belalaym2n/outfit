// ═══════════════════════════════════════════════════════════════
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/features/signUp/presentation/widgets/policy_viewer.dart';
 import '../../../../config/routes/app_router.dart';
import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/Buttons/primary_buttons.dart';
import '../../../../core/sharedWidgets/app_snack_bar.dart';
import '../../../../core/sharedWidgets/custom_loading.dart';
import '../../../../core/sharedWidgets/fields/text_form_field.dart';
import '../../../../core/sharedWidgets/text_styles.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

import '../../../../core/sharedWidgets/Buttons/bacl_button.dart';
import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/widgets/app_name.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/validations/auth_validation.dart';
import '../../../compatapilityModel/presentation/pages/request_to_recommend.dart'
    show C;
class SignUpScreenItem extends StatefulWidget {
  SignUpScreenItem({super.key,
    required this.agreedToTerms,
    required this.changeTerms,
    required this.onTap, required this.fields});

  final List<dynamic> fields;  bool  agreedToTerms ;
  Function() onTap;
  Function() changeTerms;

  @override
  State<SignUpScreenItem> createState() => _SignUpScreenItemState();
}

class _SignUpScreenItemState extends State<SignUpScreenItem>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _bgCtrl;
  late final AnimationController _btnCtrl;

  // Entrance anims
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final List<Animation<double>> _fieldFades;
  late final List<Animation<Offset>> _fieldSlides;
  late final Animation<double> _checkFade;
  late final Animation<double> _btnFade;
  late final Animation<Offset> _btnSlide;
  late final Animation<double> _footerFade;

  // Bg floats
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  // Button spring
  late final Animation<double> _btnScale;

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;


  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
    _entranceCtrl.forward();

    _termsTap = TapGestureRecognizer()
      ..onTap = () => PolicyViewerScreen.show(context, type: PolicyType.terms);
    _privacyTap = TapGestureRecognizer()
      ..onTap = () => PolicyViewerScreen.show(context, type: PolicyType.privacy);
  }

  void _initControllers() {
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
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

    _logoFade = fade(0.00, 0.28);
    _logoSlide = slide(0.00, 0.28, from: const Offset(0, 0.10));
    _titleFade = fade(0.08, 0.36);
    _titleSlide = slide(0.08, 0.36, from: const Offset(0, 0.14));
    _subtitleFade = fade(0.16, 0.44);
    _subtitleSlide = slide(0.16, 0.44, from: const Offset(0, 0.12));

    // 4 fields staggered 0.06 apart
    _fieldFades = List.generate(
      4,
      (i) => fade(0.26 + i * 0.06, 0.52 + i * 0.06),
    );
    _fieldSlides = List.generate(
      4,
      (i) => slide(0.26 + i * 0.06, 0.52 + i * 0.06),
    );

    _checkFade = fade(0.52, 0.74);
    _btnFade = fade(0.60, 0.82);
    _btnSlide = slide(0.60, 0.82, from: const Offset(0, 0.10));
    _footerFade = fade(0.74, 0.96);

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
  }

  @override
  void dispose() {
    // NEW: dispose text controllers

    // existing disposals unchanged
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
      body: Stack(
        children: [
          AmbientBg(float1: _bg1, float2: _bg2),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      child: Text('CREATE ACCOUNT', style: T.caption),
                    ),
                  ),

                  const SizedBox(height: 14),

                  FadeSlide(
                    fade: _titleFade,
                    slide: _titleSlide,
                    child: Text('Create\nAccount', style: T.display),
                  ),

                  const SizedBox(height: 10),

                  FadeSlide(
                    fade: _subtitleFade,
                    slide: _subtitleSlide,
                    child: Text(
                      'Start building smarter outfits with AI.',
                      style: T.subtitle,
                    ),
                  ),

                  const SizedBox(height: Sp.lg),

                  // ── Form fields — now pass controller ──────────────
                  ...List.generate(widget.fields.length, (i) {
                    final f = widget.fields[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Sp.sm),
                      child: FadeSlide(
                        fade: _fieldFades[i],
                        slide: _fieldSlides[i],
                        child: CustomTextField(
                          controller: f.ctrl,
                          validator: f.validator,
                          label: f.label,
                          hint: f.hint,
                          isPassword: f.password,
                          keyboardType: f.kbType,
                          textInputAction: i < widget.fields.length - 1
                              ? TextInputAction.next
                              : TextInputAction.done,
                        )
                      ),
                    );
                  }),

                  const SizedBox(height: 6),

                  // ── Terms checkbox (UNCHANGED) ─────────────────────

                  _termBox(),
                  const SizedBox(height: Sp.md),

                  FadeSlide(
                    fade: _btnFade,
                    slide: _btnSlide,
                    child: PrimaryBtn(
                      label: 'Create Account',
                      scale: _btnScale,
                      // Pass context so the bloc can be read
                      onTap: widget.onTap,
                    ),
                  ),

                  const SizedBox(height: Sp.md),

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
                                text: 'Already have an account?  ',
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  _termBox(){
    return       FadeTransition(
      opacity: _checkFade,
      child: GestureDetector(
        onTap: widget.changeTerms,        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: widget.agreedToTerms
                    ? AppColors.ink
                    : Colors.transparent,
                border: Border.all(
                  color: widget.agreedToTerms ? AppColors.ink : AppColors.divider,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: widget.agreedToTerms
                  ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 13,
              )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: T.bodySmall,
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(                    recognizer: _termsTap,

                      text: 'Terms of Service',
                      style: T.link.copyWith(fontSize: 13),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      recognizer: _privacyTap,

                      text: 'Privacy Policy',
                      style: T.link.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
