
// ═══════════════════════════════════════════════════════════════
//  AI OUTFIT RECOMMENDATION — SCREEN 1
//  Outfit Analysis Upload Screen
//  Theme: Warm Off-White · Editorial Minimal · Apple × SaaS
// ═══════════════════════════════════════════════════════════════
//
//  ANIMATION STRUCTURE
//  ──────────────────────────────────────────────────────────────
//  _entranceCtrl (1600ms):
//    Single timeline split with Interval() per element.
//    Header → subtitle → cards (staggered) → CTA button.
//    Eliminates need for multiple controllers or Future.delayed.
//
//  _backgroundCtrl (6000ms, repeat reverse):
//    Drives slow floating of the ambient background shapes.
//    Completely decoupled from entrance — never interrupts it.
//
//  _buttonCtrl (240ms):
//    TweenSequence: compress 1.0→0.95 → overshoot 0.95→1.02 → settle.
//    Mimics physical tactile feedback on CTA press.
//
//  _cardCtrl (per-card, 200ms):
//    Each upload card responds to press with subtle scale down.
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/sharedWidgets/main_wrapper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../drawer/buildMenus.dart';
import '../../data/models/outfite_response_model.dart';
import '../manager/outfit_bloc.dart';
import '../manager/outfit_events.dart';
import '../manager/outfit_states.dart';
import '../widgets/result/result_screen.dart';
import '../widgets/smallWidgets/header.dart';
import '../widgets/uploadCards/upload_card.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/app_snack_bar.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../domain/use_cases/analyze_outfit_use_case.dart';


abstract final class S {
  static const double xs = 8.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 40.0;
  static const double xl = 56.0;
}

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OutfitBloc(analyzeOutfitUseCase: getIt<AnalyzeOutfitUseCase>()),
      child: const _UploadScreenView(),
    );
  }
}

class _UploadScreenView extends StatefulWidget {
  const _UploadScreenView();

  @override
  State<_UploadScreenView> createState() => _UploadScreenViewState();
}

class _UploadScreenViewState extends State<_UploadScreenView>
    with TickerProviderStateMixin {

  late final AnimationController _entranceCtrl;
  late final AnimationController _bgCtrl;
  late final AnimationController _buttonCtrl;

  late final Animation<double> _headerFade;
  late final Animation<Offset>  _headerSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset>  _subtitleSlide;
  late final List<Animation<double>> _cardFades;
  late final List<Animation<Offset>>  _cardSlides;
  late final Animation<double> _ctaFade;
  late final Animation<Offset>  _ctaSlide;
  late final Animation<double> _bgFloat1;
  late final Animation<double> _bgFloat2;
  late final Animation<double> _btnScale;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _entranceCtrl.forward();
  }

  void _setupControllers() {
    _entranceCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600),
    );
    _bgCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);
    _buttonCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 240),
    );
  }

  void _setupAnimations() {
    Animation<double> fade(double s, double e) => CurvedAnimation(
      parent: _entranceCtrl,
      curve:  Interval(s, e, curve: Curves.easeOut),
    );
    Animation<Offset> slide(double s, double e,
        {Offset from = const Offset(0, 0.20)}) =>
        Tween<Offset>(begin: from, end: Offset.zero).animate(CurvedAnimation(
          parent: _entranceCtrl,
          curve:  Interval(s, e, curve: Curves.easeOutCubic),
        ));

    _headerFade    = fade(0.00, 0.38);
    _headerSlide   = slide(0.00, 0.38, from: const Offset(0, 0.16));
    _subtitleFade  = fade(0.15, 0.48);
    _subtitleSlide = slide(0.15, 0.48, from: const Offset(0, 0.12));
    _cardFades  = List.generate(5, (i) => fade(0.28 + i * 0.07, 0.55 + i * 0.07));
    _cardSlides = List.generate(5, (i) => slide(0.28 + i * 0.07, 0.55 + i * 0.07,
        from: const Offset(0, 0.18)));
    _ctaFade  = fade(0.72, 1.0);
    _ctaSlide = slide(0.72, 1.0, from: const Offset(0, 0.10));
    _bgFloat1 = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut),
    );
    _bgFloat2 = Tween<double>(begin: 8, end: -8).animate(
      CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut),
    );
    _btnScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0,  end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.02), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0 ), weight: 30),
    ]).animate(CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeInOut));
  }

  Future<void> _onCtaTap(BuildContext context, OutfitState state) async {

    HapticFeedback.mediumImpact();
    await _buttonCtrl.forward();
    _buttonCtrl.reset();
    context.read<OutfitBloc>().add(SubmitImagesEvent());
  }

  void _navigateToResult(BuildContext context, OutfitResponseModel result) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => FadeTransition(
          opacity: anim,
          child: BlocProvider.value(
            value: context.read<OutfitBloc>(), // 🔥 نفس الـ bloc
            child: ResultScreen(result: result),
          ),
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _bgCtrl.dispose();
    _buttonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq       = MediaQuery.of(context);
    final isTablet = mq.size.width >= 600;
    final hPad     = isTablet ? 40.0 : 20.0;

    return BlocConsumer<OutfitBloc, OutfitState>(
      listener: (context, state) {
        if (state.status == OutfitStatus.success && state.result != null) {
          _navigateToResult(context, state.result!);
        }
        if (state.status == OutfitStatus.error && state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: C.bg,
          body:MainWrapper(childWidget:  Stack(
            children: [
              AmbientBg(float1: _bgFloat1, float2: _bgFloat2),
              SafeArea(
                child: AbsorbPointer(
                  absorbing: state.isSubmitting,
                  child: Column(
                    children: [
                      _NavBar(hPad: hPad),
                      Expanded(
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: PageHeader(
                                hPad:          hPad,
                                headerFade:    _headerFade,
                                headerSlide:   _headerSlide,
                                subtitleFade:  _subtitleFade,
                                subtitleSlide: _subtitleSlide,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: FadeTransition(
                                opacity: _cardFades[0],
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(hPad, S.md, hPad, S.sm),
                                  child: const Text('OUTFIT ITEMS', style: T.label),
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: hPad),
                              sliver: isTablet
                                  ? TabletCardGrid(
                                cardFades:  _cardFades,
                                cardSlides: _cardSlides,
                                images:     state.images,
                                onTap:      (i) => _handleCardTap(context, i, state),
                              )
                                  : MobileCardList(
                                cardFades:  _cardFades,
                                cardSlides: _cardSlides,
                                images:     state.images,
                                onTap:      (i) => _handleCardTap(context, i, state),
                              ),
                            ),
                            const SliverToBoxAdapter(child: SizedBox(height: 120)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Fixed CTA
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _BottomCTA(
                  ctaFade:    _ctaFade,
                  ctaSlide:   _ctaSlide,
                  btnScale:   _btnScale,
                  onTap:      () => _onCtaTap(context, state),
                  hPad:       hPad,
                  safeBottom: mq.padding.bottom,
                  imagesCount: state.imagesCount,
                  isLoading:   state.isSubmitting,
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  void _handleCardTap(BuildContext context, int index, OutfitState state) {
    final bloc = context.read<OutfitBloc>();
    if (state.images[index] != null) {
      // Already has image → trigger replace
      bloc.add(ReplaceImageEvent(index: index, image: state.images[index]!));
    } else {
      // Empty slot → add image
      bloc.add(AddImageEvent(index: index, image: state.images[index] ?? _emptyXFile()));
    }
  }

  // Placeholder — the bloc internally calls the picker
  XFile _emptyXFile() => XFile('');
}
class _NavBar extends StatelessWidget {
  const _NavBar({required this.hPad});
  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: S.sm),
      child: Row(
        children: [
          // Back button
          _RoundBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {Navigator.pop(context);},
          ),
          const Spacer(),
          const Text(
            'OutFix AI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: C.textHigh,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          // Info
          _RoundBtn(icon: Icons.info_outline_rounded, onTap: () {}),
        ],
      ),
    );
  }
}


class _RoundBtn extends StatelessWidget {
  const _RoundBtn({required this.icon, required this.onTap});
  final IconData     icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: C.textMid, size: 18),
    ),
  );
}

class _BottomCTA extends StatelessWidget {
  const _BottomCTA({
    required this.ctaFade,
    required this.ctaSlide,
    required this.btnScale,
    required this.onTap,
    required this.hPad,
    required this.safeBottom,
    required this.imagesCount,
    required this.isLoading,
  });

  final Animation<double> ctaFade;
  final Animation<Offset>  ctaSlide;
  final Animation<double> btnScale;
  final VoidCallback       onTap;
  final double             hPad;
  final double             safeBottom;
  final int                imagesCount;
  final bool               isLoading;

  @override
  Widget build(BuildContext context) {
    return FadeSlide(
      fade: ctaFade, slide: ctaSlide,
      child: Container(
        padding: EdgeInsets.fromLTRB(hPad, S.sm, hPad, safeBottom + S.sm),
        decoration: BoxDecoration(
          color: C.bg.withOpacity(0.96),
          border: const Border(top: BorderSide(color: C.divider, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress dots — filled ones show images added
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    color: i < imagesCount ? C.ink : C.textLow,
                    shape: BoxShape.circle,
                  ),
                ),
              )),
            ),
            const SizedBox(height: S.sm),
            ScaleTransition(
              scale: btnScale,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: C.ink,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: C.ink.withOpacity(0.22),
                        blurRadius: 24, spreadRadius: -4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Send to AI Model ($imagesCount/5)',
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600,
                            color: Colors.white, letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 26, height: 26,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white, size: 13,
                          ),
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
    );
  }
}
