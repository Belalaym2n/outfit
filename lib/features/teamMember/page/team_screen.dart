// features/team/team_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../core/sharedWidgets/animations/slide_naviagation.dart';
import '../../../core/sharedWidgets/text_styles.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../data/team_data.dart';
import '../widgets/team_intro.dart';
import '../widgets/team_member_card.dart';
import '../data/team_member_model.dart';
import '../widgets/top_bar.dart';
import 'team_member_screen.dart';

class OurTeamScreen extends StatefulWidget {
  const OurTeamScreen({super.key});

  @override
  State<OurTeamScreen> createState() => _OurTeamScreenState();
}

class _OurTeamScreenState extends State<OurTeamScreen>
    with TickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────────
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  // ── Entrance animations ────────────────────────────────────────
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _dividerFade;
  late final List<Animation<double>> _cardFades;
  late final List<Animation<Offset>> _cardSlides;

  // ── Ambient background floats ──────────────────────────────────
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
    _entranceController.forward();
  }

  void _initControllers() {
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);
  }

  void _initAnimations() {
    Animation<double> fade(double s, double e) => CurvedAnimation(
          parent: _entranceController,
          curve: Interval(s, e, curve: Curves.easeOut),
        );

    Animation<Offset> slide(
      double s,
      double e, {
      Offset from = const Offset(0, 0.16),
    }) =>
        Tween<Offset>(begin: from, end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Interval(s, e, curve: Curves.easeOutCubic),
          ),
        );

    _headerFade = fade(0.00, 0.38);
    _headerSlide = slide(0.00, 0.38);
    _subtitleFade = fade(0.18, 0.52);
    _subtitleSlide = slide(0.18, 0.52, from: const Offset(0, 0.12));
    _dividerFade = fade(0.32, 0.58);

    final count = TeamData.members.length;
    _cardFades = List.generate(
      count,
      (i) => fade(0.40 + i * 0.06, 0.68 + i * 0.06),
    );
    _cardSlides = List.generate(
      count,
      (i) => slide(0.40 + i * 0.06, 0.68 + i * 0.06,
          from: const Offset(0, 0.10)),
    );

    _bg1 = Tween<double>(begin: -14, end: 14).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _bg2 = Tween<double>(begin: 10, end: -10).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _openProfile(TeamMember member) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      SlideRoute(page: TeamMemberScreen(member: member)),
    );
  }

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.width >= 600;
    final isDesktop = mq.size.width >= 1024;
    final hPad = isDesktop ? 80.0 : isTablet ? 48.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(backgroundColor: AppColors.bg, toolbarHeight: 0),
      body: Stack(
        children: [
          AmbientBg(float1: _bg1, float2: _bg2),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: TopBar(hPad: hPad)),
              SliverToBoxAdapter(
                child: TeamIntroHeroSection(
                  hPad: hPad,
                  headerFade: _headerFade,
                  headerSlide: _headerSlide,
                  subtitleFade: _subtitleFade,
                  subtitleSlide: _subtitleSlide,
                  dividerFade: _dividerFade,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                sliver: isDesktop
                    ? _DesktopGrid(
                        cardFades: _cardFades,
                        cardSlides: _cardSlides,
                        onTap: _openProfile,
                      )
                    : isTablet
                        ? _TabletGrid(
                            cardFades: _cardFades,
                            cardSlides: _cardSlides,
                            onTap: _openProfile,
                          )
                        : _MobileList(
                            cardFades: _cardFades,
                            cardSlides: _cardSlides,
                            onTap: _openProfile,
                          ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ],
      ),
    );
  }
}


class _MobileList extends StatelessWidget {
  const _MobileList({
    required this.cardFades,
    required this.cardSlides,
    required this.onTap,
  });

  final List<Animation<double>> cardFades;
  final List<Animation<Offset>> cardSlides;
  final void Function(TeamMember) onTap;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: Sp.sm),
          child: FadeSlide(
            fade: cardFades[i],
            slide: cardSlides[i],
            child: TeamMemberCard(
              member: TeamData.members[i],
              onTap: () => onTap(TeamData.members[i]),
            ),
          ),
        ),
        childCount: TeamData.members.length,
      ),
    );
  }
}

 class _TabletGrid extends StatelessWidget {
  const _TabletGrid({
    required this.cardFades,
    required this.cardSlides,
    required this.onTap,
  });

  final List<Animation<double>> cardFades;
  final List<Animation<Offset>> cardSlides;
  final void Function(TeamMember) onTap;

  @override
  Widget build(BuildContext context) {
    final members = TeamData.members;
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Sp.sm,
        crossAxisSpacing: Sp.sm,
        childAspectRatio: 1.35,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, i) => FadeSlide(
          fade: cardFades[i],
          slide: cardSlides[i],
          child: TeamMemberCard(
            member: members[i],
            onTap: () => onTap(members[i]),
          ),
        ),
        childCount: members.length,
      ),
    );
  }
}

 class _DesktopGrid extends StatelessWidget {
  const _DesktopGrid({
    required this.cardFades,
    required this.cardSlides,
    required this.onTap,
  });

  final List<Animation<double>> cardFades;
  final List<Animation<Offset>> cardSlides;
  final void Function(TeamMember) onTap;

  @override
  Widget build(BuildContext context) {
    final members = TeamData.members;
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Sp.sm,
        crossAxisSpacing: Sp.sm,
        childAspectRatio: 1.4,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, i) => FadeSlide(
          fade: cardFades[i],
          slide: cardSlides[i],
          child: TeamMemberCard(
            member: members[i],
            onTap: () => onTap(members[i]),
          ),
        ),
        childCount: members.length,
      ),
    );
  }
}
