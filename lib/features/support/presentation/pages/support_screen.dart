import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────
//  ENTRY POINT

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/sharedWidgets/Buttons/primary_buttons.dart';
import 'package:graduation_proj/features/support/presentation/widgets/nav_bar.dart'
    show NavBar;
import 'package:image_picker/image_picker.dart';

import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../drawer/buildMenus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/app_snack_bar.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../widgets/app_guide.dart';
import '../widgets/videp_app.dart';

class SupportCenterScreen extends StatefulWidget {
  const SupportCenterScreen({super.key});

  @override
  State<SupportCenterScreen> createState() => _SupportCenterScreenState();
}

class _SupportCenterScreenState extends State<SupportCenterScreen>
    with TickerProviderStateMixin {
  late final AnimationController _supportCtrl;
  late final AnimationController _bgCtrl;
  late final AnimationController _reportBtnCtrl;
  late final AnimationController _ideaBtnCtrl;

  // Section animations
  late final Animation<double> _navFade;
  late final Animation<Offset> _navSlide;
  late final Animation<double> _videoFade;
  late final Animation<Offset> _videoSlide;



  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
    _supportCtrl.forward();
  }

  void _initControllers() {
    _supportCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    )..repeat(reverse: true);
    _reportBtnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _ideaBtnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  void _initAnimations() {
    Animation<double> fade(double s, double e) => CurvedAnimation(
      parent: _supportCtrl,
      curve: Interval(s, e, curve: Curves.easeOut),
    );
    Animation<Offset> slide(
      double s,
      double e, {
      Offset from = const Offset(0, 0.15),
    }) => Tween<Offset>(begin: from, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _supportCtrl,
        curve: Interval(s, e, curve: Curves.easeOutCubic),
      ),
    );

    _navFade = fade(0.00, 0.22);
    _navSlide = slide(0.00, 0.22, from: const Offset(0, 0.08));
    _videoFade = fade(0.10, 0.36);
    _videoSlide = slide(0.10, 0.36);


  }

  @override
  void dispose() {
    _supportCtrl.dispose();
    _bgCtrl.dispose();
    _reportBtnCtrl.dispose();
    _ideaBtnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final hPad = mq.size.width >= 600 ? 40.0 : 20.0;

    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(
        children: [
          // AmbientBg(float1: nuntBg float2: null, ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Nav
                SliverToBoxAdapter(
                  child: FadeSlide(
                    fade: _navFade,
                    slide: _navSlide,
                    child: NavBar(
                      title: 'Support',
                      hPad: hPad,
                      onBack: () => Navigator.pop(context),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Header
                      _build_header(),

                      // ── Section 1: Help Video
                      FadeSlide(
                        fade: _videoFade,
                        slide: _videoSlide,
                        child: const HelpVideoCard(),
                      ),

                      SizedBox(height: mq.padding.bottom + Sp.lg),
                    ]),
                  ),
                ),
                AppGuideScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _build_header(){
   return FadeTransition(
      opacity: _videoFade,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Support Center', style: T.display),
          SizedBox(height: 6),
          Text(
            'Guides, help & feedback — all in one place.',
            style: T.body,
          ),
          SizedBox(height: Sp.md),
        ],
      ),
    );
  }
}

