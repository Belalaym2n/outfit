import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/sharedWidgets/animations/bg_animation.dart';
import 'package:graduation_proj/features/profile/data/models/user_data.dart';

import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/text_styles.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart' show Sp;
import '../widgets/commonWidget/profeil_header.dart';
import '../widgets/commonWidget/profile_nav_bar.dart';
import '../widgets/commonWidget/state_section.dart';
import '../widgets/journey/journey_card.dart';
import '../widgets/settings/setting_widget.dart';

class ProfileScreen extends StatefulWidget {
    ProfileScreen({super.key,    required this.userModel,
  });

  UserModel userModel;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────
  late final AnimationController _masterCtrl;
  late final AnimationController _bgCtrl;
  late final AnimationController _avatarCtrl;
  late final AnimationController _progressCtrl;
  late final AnimationController _btnCtrl;

  // ── Master entrance: Interval-staggered per section ──────────
  late final Animation<double> _navFade;
  late final Animation<Offset> _navSlide;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;

  late final Animation<double> _statsFade;
  late final Animation<Offset> _statsSlide;

  late final Animation<double> _sectionLabelFade;
  late final Animation<double> _settingsFade;
  late final Animation<Offset> _settingsSlide;

  late final Animation<double> _journeyFade;
  late final Animation<Offset> _journeySlide;

  // ── Avatar ────────────────────────────────────────────────────
  late final Animation<double> _avatarScale;
  late final Animation<double> _avatarFade;

  // ── Background floats ─────────────────────────────────────────
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  // ── Progress bar ──────────────────────────────────────────────
  late final Animation<double> _progressValue;

  // ── Button spring ─────────────────────────────────────────────
  late final Animation<double> _btnScale;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();

    // Start entrance and background immediately
    _masterCtrl.forward();

    // Avatar pops in after a short breath
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _avatarCtrl.forward();
    });

    // Progress bar fills after journey card finishes entering
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) _progressCtrl.forward();
    });
  }

  void _initControllers() {
    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat(reverse: true);
    _avatarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  void _initAnimations() {
    // ── Helper factories ─────────────────────────────────────────
    Animation<double> fade(double s, double e) => CurvedAnimation(
      parent: _masterCtrl,
      curve: Interval(s, e, curve: Curves.easeOut),
    );
    Animation<Offset> slide(
      double s,
      double e, {
      Offset from = const Offset(0, 0.16),
    }) => Tween<Offset>(begin: from, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: Interval(s, e, curve: Curves.easeOutCubic),
      ),
    );

    // ── Staggered entrance timeline ──────────────────────────────
    // Nav bar first
    _navFade = fade(0.00, 0.25);
    _navSlide = slide(0.00, 0.25, from: const Offset(0, 0.08));

    // Profile header (name, email, badge)
    _headerFade = fade(0.08, 0.38);
    _headerSlide = slide(0.08, 0.38, from: const Offset(0, 0.12));

    // Stats row
    _statsFade = fade(0.28, 0.56);
    _statsSlide = slide(0.28, 0.56);

    // Settings section label
    _sectionLabelFade = fade(0.44, 0.66);

    // Settings list
    _settingsFade = fade(0.48, 0.74);
    _settingsSlide = slide(0.48, 0.74, from: const Offset(0, 0.12));

    // Journey card — last to appear
    _journeyFade = fade(0.66, 0.90);
    _journeySlide = slide(0.66, 0.90, from: const Offset(0, 0.14));

    // ── Avatar: easeOutBack gives a confident pop ────────────────
    _avatarScale = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _avatarCtrl, curve: Curves.easeOutBack));
    _avatarFade = CurvedAnimation(
      parent: _avatarCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    // ── Background ambient floats ────────────────────────────────
    _bg1 = Tween<double>(
      begin: -16,
      end: 16,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
    _bg2 = Tween<double>(
      begin: 12,
      end: -12,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    _progressValue = Tween<double>(
      begin: 0.0,
      end: (widget.userModel.avgScore / 100).clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(
        parent: _progressCtrl,
        curve: Curves.easeInOutCubic,
      ),

     );

    // ── Button spring: compress → overshoot → settle ─────────────
    _btnScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.02), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));
  }

  Future<void> _onBtnTap(VoidCallback? action) async {
    HapticFeedback.lightImpact();
    await _btnCtrl.forward();
    _btnCtrl.reset();
    action?.call();
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    _bgCtrl.dispose();
    _avatarCtrl.dispose();
    _progressCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.width >= 600;
    final hPad = isTablet ? 40.0 : 20.0;

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.bg, toolbarHeight: 0),
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // ── Ambient background blobs
          AmbientBg(float1: _bg1, float2: _bg2),

          // ── Main scrollable content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Top navigation bar
              SliverToBoxAdapter(
                child: FadeSlide(
                  fade: _navFade,
                  slide: _navSlide,
                  child: ProfileNavBar(hPad: hPad),
                ),
              ),

              // ── Hero profile header
              SliverToBoxAdapter(
                child: ProfileHeader(
                  userModel: widget.userModel,
                  hPad: hPad,
                  headerFade: _headerFade,
                  headerSlide: _headerSlide,
                  avatarScale: _avatarScale,
                  avatarFade: _avatarFade,
                ),
              ),

              // ── Stats section
              SliverToBoxAdapter(
                child: FadeSlide(
                  fade: _statsFade,
                  slide: _statsSlide,
                  child: StatsSection(hPad: hPad,userModel: widget.userModel,),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: Sp.md)),

              // ── "Your AI Journey" card
              SliverToBoxAdapter(
                child: FadeSlide(
                  fade: _journeyFade,
                  slide: _journeySlide,
                  child: JourneyCard(
                      user: widget.userModel,
                      hPad: hPad, progressValue: _progressValue),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: Sp.md)),

              // ── Settings section label
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _sectionLabelFade,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, Sp.xs),
                    child: Text('ACCOUNT', style: T.caption),
                  ),
                ),
              ),

              // ── Settings list
              SliverToBoxAdapter(
                child: FadeSlide(
                  fade: _settingsFade,
                  slide: _settingsSlide,
                  child: SettingsSection(
                    hPad: hPad,
                    onTap: (action) => _onBtnTap(action),
                    btnScale: _btnScale,
                  ),
                ),
              ),

              // ── Bottom safe-area padding
              SliverToBoxAdapter(
                child: SizedBox(height: mq.padding.bottom + Sp.lg),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
