// features/team/team_member_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../core/utils/app_colors.dart';
 import '../service/team_share_member.dart';
import '../widgets/teamMemberWidgets/member_profile.dart';
import '../widgets/teamMemberWidgets/profile_actions.dart';
import '../widgets/teamMemberWidgets/team_member_top_bar.dart';
 import '../data/team_member_model.dart';

class TeamMemberScreen extends StatefulWidget {
  const TeamMemberScreen({super.key, required this.member});

  final TeamMember member;

  @override
  State<TeamMemberScreen> createState() => _TeamMemberScreenState();
}

class _TeamMemberScreenState extends State<TeamMemberScreen>
    with TickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────────
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  // ── Entrance animations ────────────────────────────────────────
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;
  late final Animation<double> _nameFade;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _section1Fade;
  late final Animation<Offset> _section1Slide;
  late final Animation<double> _section2Fade;
  late final Animation<Offset> _section2Slide;
  late final Animation<double> _actionsFade;
  late final Animation<Offset> _actionsSlide;

  // ── Ambient bg ─────────────────────────────────────────────────
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  // ── Share button key for iPad popover anchor ───────────────────
  final _shareKey = GlobalKey();

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
      duration: const Duration(milliseconds: 1400),
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

    Animation<Offset> slide(double s, double e,
            {Offset from = const Offset(0, 0.14)}) =>
        Tween<Offset>(begin: from, end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Interval(s, e, curve: Curves.easeOutCubic),
          ),
        );

    _heroFade = fade(0.00, 0.40);
    _heroSlide = slide(0.00, 0.40, from: const Offset(0, 0.08));
    _nameFade = fade(0.15, 0.50);
    _nameSlide = slide(0.15, 0.50);
    _section1Fade = fade(0.30, 0.62);
    _section1Slide = slide(0.30, 0.62);
    _section2Fade = fade(0.44, 0.74);
    _section2Slide = slide(0.44, 0.74);
    _actionsFade = fade(0.58, 0.86);
    _actionsSlide = slide(0.58, 0.86, from: const Offset(0, 0.10));

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

  // ── Actions ────────────────────────────────────────────────────

  Future<void> _openLinkedIn() async {
    final url = widget.member.linkedInUrl;
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openWhatsApp() async {
    final number = widget.member.whatsAppNumber;
    if (number == null) return;
    final uri = Uri.parse(widget.member.whatsAppUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _share() async {
    print("object");
    HapticFeedback.lightImpact();
    final box = _shareKey.currentContext?.findRenderObject() as RenderBox?;
    await TeamShareService.shareMember(
      widget.member,
      sharePositionOrigin:
          box != null ? box.localToGlobal(Offset.zero) & box.size : null,
    );
  }

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.width >= 600;
    final isDesktop = mq.size.width >= 1024;
    final hPad = isDesktop ? 120.0 : isTablet ? 64.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(backgroundColor: AppColors.bg, toolbarHeight: 0),
      body: Stack(
        children: [
          AmbientBg(float1: _bg1, float2: _bg2),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: TeamMemberTopBar(
                  shareKey: _shareKey,
                  onShare: _share,
                  hPad: hPad,
                ),
              ),
              SliverToBoxAdapter(
                child: MemberProfileHero(
                  member: widget.member,
                  hPad: hPad,
                  heroFade: _heroFade,
                  heroSlide: _heroSlide,
                  nameFade: _nameFade,
                  nameSlide: _nameSlide,
                ),
              ),
              SliverToBoxAdapter(
                child:  MemberProfileContent(
                  member: widget.member,
                  hPad: hPad,
                  section1Fade: _section1Fade,
                  section1Slide: _section1Slide,
                  section2Fade: _section2Fade,
                  section2Slide: _section2Slide,
                ),
              ),
              SliverToBoxAdapter(
                child: MemberProfileActions(
                  member: widget.member,
                  hPad: hPad,
                  fade: _actionsFade,
                  slide: _actionsSlide,
                  onLinkedIn: _openLinkedIn,
                  onWhatsApp: _openWhatsApp,
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

