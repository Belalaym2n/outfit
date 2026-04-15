
// ═══════════════════════════════════════════════════════════════════
//  outfit_details_screen.dart
//  AI Outfit Recommendation — Cinematic Detail View
//
//  WIDGETS EXPORTED:
//    • OutfitDetailsScreen        — full detail screen
//    • HeroImageSection           — 3D tilt + parallax image area
//    • OutfitInfoSection          — staggered text / tags section
//
//  NAVIGATION:
//    Call openOutfitDetails(context, item) from your
//    RecommendedItemCard.onTap.  Hero tag = 'outfit_img_${item.id}'.
//
//  NO external packages required.
// ═══════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';   // SpringSimulation

// ─────────────────────────────────────────────────────────────
//  AppConstants shim — replace with your real import
// ─────────────────────────────────────────────────────────────
class AppConstants {
  static late double w;
  static late double h;
  static void init(BuildContext ctx) {
    w = MediaQuery.of(ctx).size.width;
    h = MediaQuery.of(ctx).size.height;
  }
}

// ─────────────────────────────────────────────────────────────
//  MODEL  — copy from / import your recommended_section.dart
// ─────────────────────────────────────────────────────────────
class RecommendedItemModelDetails {
  final String id;
  final String name;
  final String aiSuggestion;
  final Color  placeholder;
  bool saved;

  RecommendedItemModelDetails({
    required this.id, required this.name,
    required this.aiSuggestion, required this.placeholder,
    this.saved = false,
  });

  // Extended fields used on the detail screen
  String get longDescription =>
      'Our AI analysed colour saturation, seasonal harmony and silhouette '
          'ratio across your wardrobe history. This piece scores exceptionally '
          'well for your neutral palette preference and current capsule gaps.';

  int get compatibilityScore => (75 + id.hashCode.abs() % 23);

  List<String> get tags => ['Minimalist', 'Autumn', 'Casual–Formal', 'Tonal'];
}

// ─────────────────────────────────────────────────────────────
//  DESIGN TOKENS  (mirror recommended_section.dart)
// ─────────────────────────────────────────────────────────────
class _C {
  static const bg          = Color(0xFFF7F6F3);
  static const surface     = Color(0xFFFFFFFF);
  static const ink         = Color(0xFF141413);
  static const inkMuted    = Color(0xFF6B6A67);
  static const inkSubtle   = Color(0xFFA8A7A4);
  static const accent      = Color(0xFF1A1A2E);
  static const accentSoft  = Color(0xFFE8E8F0);
  static const border      = Color(0xFFE5E4E0);
  static const scoreHigh   = Color(0xFF34C759);
  static const scoreMid    = Color(0xFFFF9F0A);
}

// ─────────────────────────────────────────────────────────────
//  CUSTOM PAGE ROUTE — cinematic Hero + fade + scale
// ─────────────────────────────────────────────────────────────

/// Call this instead of Navigator.push to get the cinematic transition.
void openOutfitDetails(BuildContext context, RecommendedItemModelDetails item) {
  Navigator.push(context, _CinematicRoute(item: item));
}

class _CinematicRoute extends PageRouteBuilder {
  final RecommendedItemModelDetails item;

  _CinematicRoute({required this.item})
      : super(
    transitionDuration: const Duration(milliseconds: 480),
    reverseTransitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (_, __, ___) => OutfitDetailsScreen(item: item),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Combined: fade + very slight upward slide
      // Hero widget handles the image morph independently.
      final fade = CurvedAnimation(
          parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
          begin: const Offset(0, 0.04), end: Offset.zero)
          .animate(CurvedAnimation(
          parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

// ═══════════════════════════════════════════════════════════════
//  OutfitDetailsScreen
// ═══════════════════════════════════════════════════════════════
class OutfitDetailsScreen extends StatefulWidget {
  final RecommendedItemModelDetails item;
  const OutfitDetailsScreen({super.key, required this.item});

  @override
  State<OutfitDetailsScreen> createState() => _OutfitDetailsScreenState();
}

class _OutfitDetailsScreenState extends State<OutfitDetailsScreen>
    with TickerProviderStateMixin {

  // Master stagger controller — drives info section entrance
  late final AnimationController _staggerCtrl;

  // Individual staggered intervals (driven by _staggerCtrl)
  late final Animation<double> _nameFade;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _scoreFade;
  late final Animation<Offset> _scoreSlide;
  late final Animation<double> _descFade;
  late final Animation<Offset> _descSlide;
  late final Animation<double> _tagsFade;
  late final Animation<Offset> _tagsSlide;
  late final Animation<double> _btnFade;

  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _saved = widget.item.saved;

    // 700 ms covers all stagger stages
    _staggerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    // Helper to create a fade-slide pair for a given interval
    Animation<double> _fade(double from, double to) =>
        Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: _staggerCtrl,
                curve: Interval(from, to, curve: Curves.easeOut)));

    Animation<Offset> _slide(double from, double to) =>
        Tween<Offset>(begin: const Offset(0, 0.28), end: Offset.zero).animate(
            CurvedAnimation(parent: _staggerCtrl,
                curve: Interval(from, to, curve: Curves.easeOutCubic)));

    // Stagger timeline (offset from screen-open):
    // 0.00–0.38  name
    // 0.18–0.52  score row
    // 0.32–0.66  description
    // 0.48–0.78  tags
    // 0.64–1.00  save button
    _nameFade   = _fade(0.00, 0.38);
    _nameSlide  = _slide(0.00, 0.38);
    _scoreFade  = _fade(0.18, 0.52);
    _scoreSlide = _slide(0.18, 0.52);
    _descFade   = _fade(0.32, 0.66);
    _descSlide  = _slide(0.32, 0.66);
    _tagsFade   = _fade(0.48, 0.78);
    _tagsSlide  = _slide(0.48, 0.78);
    _btnFade    = _fade(0.64, 1.00);

    // Wait for Hero to mostly finish, then run stagger
    Future.delayed(const Duration(milliseconds: 280),
            () { if (mounted) _staggerCtrl.forward(); });
  }

  @override
  void dispose() { _staggerCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    AppConstants.init(context);
    final w = AppConstants.w;
    final h = AppConstants.h;

    return   Scaffold(
      body: Stack(
        children: [
          // ── Decorative background blobs ──────────────────
          _BackgroundDecor(),

          // ── Main scrollable content ──────────────────────
          CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [

                // ── 1. Hero Image ────────────────────────────
                SliverToBoxAdapter(
                  child: HeroImageSection(
                    item: widget.item,
                    saved: _saved,
                    onSaveToggle: () =>
                        setState(() { _saved = !_saved; widget.item.saved = _saved; }),
                    onBack: () => Navigator.pop(context),
                  ),
                ),

                // ── 2. Info section ──────────────────────────
                SliverToBoxAdapter(
                  child: OutfitInfoSection(
                    item: widget.item,
                    staggerCtrl: _staggerCtrl,
                    nameFade: _nameFade,     nameSlide: _nameSlide,
                    scoreFade: _scoreFade,   scoreSlide: _scoreSlide,
                    descFade: _descFade,     descSlide: _descSlide,
                    tagsFade: _tagsFade,     tagsSlide: _tagsSlide,
                    btnFade: _btnFade,
                    saved: _saved,
                    onSaveToggle: () =>
                        setState(() { _saved = !_saved; widget.item.saved = _saved; }),
                  ),
                ),

              ],
            ),

        ],
      )
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  HeroImageSection  —  60 % of screen, 3D tilt, parallax
// ═══════════════════════════════════════════════════════════════
class HeroImageSection extends StatefulWidget {
  final RecommendedItemModelDetails item;
  final bool saved;
  final VoidCallback onSaveToggle;
  final VoidCallback onBack;

  const HeroImageSection({
    super.key,
    required this.item, required this.saved,
    required this.onSaveToggle, required this.onBack,
  });

  @override
  State<HeroImageSection> createState() => _HeroImageSectionState();
}

class _HeroImageSectionState extends State<HeroImageSection>
    with TickerProviderStateMixin {

  // 3D tilt state (normalised -1..1 in each axis)
  double _tiltX = 0.0;   // vertical tilt   (drag up/down)
  double _tiltY = 0.0;   // horizontal tilt  (drag left/right)

  // Spring-back controller
  late final AnimationController _springCtrl;
  late Animation<double> _springTiltX;
  late Animation<double> _springTiltY;

  // Badge fade-in
  late final AnimationController _badgeCtrl;
  late final Animation<double>   _badgeFade;
  late final Animation<double>   _badgeScale;

  @override
  void initState() {
    super.initState();

    // Spring-back after drag release
    _springCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _springTiltX = Tween<double>(begin: 0, end: 0).animate(_springCtrl);
    _springTiltY = Tween<double>(begin: 0, end: 0).animate(_springCtrl);

    // Badge entrance — fires after Hero lands
    _badgeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _badgeFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOut));
    _badgeScale = Tween<double>(begin: 0.72, end: 1).animate(
        CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOutBack));

    Future.delayed(const Duration(milliseconds: 320),
            () { if (mounted) _badgeCtrl.forward(); });
  }

  @override
  void dispose() {
    _springCtrl.dispose();
    _badgeCtrl.dispose();
    super.dispose();
  }

  // Drag updates tilt within ±1.0
  void _onPanUpdate(DragUpdateDetails d) {
    final w = AppConstants.w;
    final h = AppConstants.h;
    setState(() {
      _tiltY += d.delta.dx / (w * 0.5);
      _tiltX -= d.delta.dy / (h * 0.4);
      _tiltY = _tiltY.clamp(-1.0, 1.0);
      _tiltX = _tiltX.clamp(-1.0, 1.0);
    });
  }

  // Spring back to flat on release
  void _onPanEnd(DragEndDetails _) {
    _springTiltX = Tween<double>(begin: _tiltX, end: 0).animate(
        CurvedAnimation(parent: _springCtrl, curve: Curves.elasticOut));
    _springTiltY = Tween<double>(begin: _tiltY, end: 0).animate(
        CurvedAnimation(parent: _springCtrl, curve: Curves.elasticOut));

    _springCtrl
      ..reset()
      ..forward().whenComplete(() {
        if (mounted) setState(() { _tiltX = 0; _tiltY = 0; });
      });

    // Update tilt during spring
    _springCtrl.addListener(() {
      if (mounted) setState(() {
        _tiltX = _springTiltX.value;
        _tiltY = _springTiltY.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;
    final imageH = h * 0.5;

    // Max tilt angle in radians (5°)
    const maxAngle = 5 * math.pi / 180;

    return SizedBox(
      width: w,
      height: imageH,
      child: Stack(
        children: [

          // ── Draggable 3D image ──────────────────────────
          GestureDetector(
            onPanUpdate: _onPanUpdate,
            onPanEnd:    _onPanEnd,
            child: Transform(
              // Perspective matrix for 3D illusion
              // matrix4[3][2] = 0.001 sets the depth of field
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0008)          // perspective depth
                ..rotateX(_tiltX * maxAngle)       // vertical tilt
                ..rotateY(-_tiltY * maxAngle),     // horizontal tilt
              alignment: Alignment.center,
              child: Hero(
                // Hero tag must match the tag used in RecommendedItemCard
                tag: 'outfit_img_${widget.item.id}',
                flightShuttleBuilder: _cinematicShuttle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: w,
                  height: imageH,
                  decoration: BoxDecoration(
                    color: widget.item.placeholder,
                    boxShadow: [
                      BoxShadow(
                        // Shadow reacts to tilt direction
                        color: _C.ink.withOpacity(0.14 + _tiltY.abs() * 0.06),
                        blurRadius: 32 + _tiltY.abs() * 12,
                        offset: Offset(
                          _tiltY * 14,     // horizontal shadow shift
                          8 + _tiltX * 6,  // vertical shadow shift
                        ),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.checkroom_outlined,
                      size: w * 0.26,
                      color: _C.ink.withOpacity(0.12),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Soft bottom gradient (eases into info section) ─
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: h * 0.14,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    _C.bg,
                    _C.bg.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // ── Back button ───────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: w * 0.04,
            child: _CircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: widget.onBack,
            ),
          ),

          // ── Save button (top right) ───────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: w * 0.04,
            child: _SaveCircleButton(
              saved: widget.saved,
              onTap: widget.onSaveToggle,
            ),
          ),

          // ── AI Score badge (top right, below save) ────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 68,
            right: w * 0.04,
            child: AnimatedBuilder(
              animation: _badgeCtrl,
              builder: (_, child) => Opacity(
                opacity: _badgeFade.value,
                child: Transform.scale(scale: _badgeScale.value, child: child),
              ),
              child: _AiScoreBadge(score: widget.item.compatibilityScore),
            ),
          ),

          // ── Tilt hint label (bottom center, fades out) ───
          Positioned(
            bottom: h * 0.055,
            left: 0, right: 0,
            child: Center(
              child: Text(
                'Drag to tilt',
                style: TextStyle(
                  color: _C.inkSubtle.withOpacity(0.55),
                  fontSize: w * 0.028,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Hero flight widget — adds scale + fade during morph
  Widget _cinematicShuttle(
      BuildContext context,
      Animation<double> animation,
      HeroFlightDirection direction,
      BuildContext fromHero,
      BuildContext toHero,
      ) {
    final scale = Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
    return ScaleTransition(
      scale: scale,
      child: direction == HeroFlightDirection.push ? toHero.widget : fromHero.widget,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  OutfitInfoSection  —  staggered text / tags / button
// ═══════════════════════════════════════════════════════════════
class OutfitInfoSection extends StatelessWidget {
  final RecommendedItemModelDetails item;
  final AnimationController staggerCtrl;
  final Animation<double> nameFade,   scoreFade,  descFade,  tagsFade,  btnFade;
  final Animation<Offset>  nameSlide, scoreSlide, descSlide, tagsSlide;
  final bool saved;
  final VoidCallback onSaveToggle;

  const OutfitInfoSection({
    super.key,
    required this.item,
    required this.staggerCtrl,
    required this.nameFade,    required this.nameSlide,
    required this.scoreFade,   required this.scoreSlide,
    required this.descFade,    required this.descSlide,
    required this.tagsFade,    required this.tagsSlide,
    required this.btnFade,
    required this.saved,
    required this.onSaveToggle,
  });

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return AnimatedBuilder(
      animation: staggerCtrl,
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: w * 0.055, vertical: h * 0.008),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Item Name ──────────────────────────────────
              FadeSlideWidget(
                opacity: nameFade, slide: nameSlide,
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: w * 0.072,
                    fontWeight: FontWeight.w700,
                    color: _C.ink,
                    letterSpacing: -1.2,
                    height: 1.05,
                  ),
                ),
              ),

              SizedBox(height: h * 0.022),

              // ── Score row ──────────────────────────────────
              FadeSlideWidget(
                opacity: scoreFade, slide: scoreSlide,
                child: _ScoreRow(score: item.compatibilityScore),
              ),

              SizedBox(height: h * 0.024),

              // ── Description ────────────────────────────────
              FadeSlideWidget(
                opacity: descFade, slide: descSlide,
                child: Text(
                  item.longDescription,
                  style: TextStyle(
                    fontSize: w * 0.036,
                    height: 1.65,
                    color: _C.inkMuted,
                    letterSpacing: 0.1,
                  ),
                ),
              ),

              SizedBox(height: h * 0.028),

              // ── Tags ───────────────────────────────────────
              FadeSlideWidget(
                opacity: tagsFade, slide: tagsSlide,
                child: Wrap(
                  spacing: w * 0.022,
                  runSpacing: h * 0.01,
                  children: item.tags
                      .map((t) => _TagCapsule(label: t))
                      .toList(),
                ),
              ),

              SizedBox(height: h * 0.036),

              // ── Save button ────────────────────────────────
              Opacity(
                opacity: btnFade.value,
                child: _SaveCollectionButton(
                  saved: saved,
                  onTap: onSaveToggle,
                ),
              ),

              SizedBox(height: h * 0.055),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FadeSlideWidget  — reusable compound animation wrapper
// ─────────────────────────────────────────────────────────────
class FadeSlideWidget extends StatelessWidget {
  final Animation<double> opacity;
  final Animation<Offset>  slide;
  final Widget child;

  const FadeSlideWidget({
    super.key,
    required this.opacity,
    required this.slide,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: slide.value,
      child: Opacity(opacity: opacity.value, child: child),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _ScoreRow  — compatibility score bar
// ─────────────────────────────────────────────────────────────
class _ScoreRow extends StatelessWidget {
  final int score;
  const _ScoreRow({required this.score});

  Color get _barColor {
    if (score >= 88) return _C.scoreHigh;
    if (score >= 72) return _C.scoreMid;
    return const Color(0xFFFF453A);
  }

  @override
  Widget build(BuildContext context) {
  final w = AppConstants.w;
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  children: [
  Text(
  'AI Compatibility',
  style: TextStyle(
  fontSize: w * 0.032,
  fontWeight: FontWeight.w500,
  color: _C.inkSubtle,
  letterSpacing: 0.4,
  ),
  ),
  const Spacer(),
  Text(
  '$score%',
  style: TextStyle(
  fontSize: w * 0.042,
  fontWeight: FontWeight.w700,
  color: _C.ink,
  letterSpacing: -0.5,
  ),
  ),
  ],
  ),
  SizedBox(height: w * 0.024),
  ClipRRect(
  borderRadius: BorderRadius.circular(100),
  child: TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: score / 100),
  duration: const Duration(milliseconds: 900),
  curve: Curves.easeOutCubic,
  builder: (_, value, __) => Stack(
  children: [
  Container(
  height: w * 0.018,
  width: double.infinity,
  color: _C.border,
  ),
  Container(
  height: w * 0.018,
  width: AppConstants.w * 0.89 * value,
  decoration: BoxDecoration(
  color: _barColor,
  borderRadius: BorderRadius.circular(100),
  ),
  ),
  ],
  ),
  ),
  ),
  ],
  );
  }
}

// ─────────────────────────────────────────────────────────────
//  _TagCapsule
// ─────────────────────────────────────────────────────────────
class _TagCapsule extends StatelessWidget {
  final String label;
  const _TagCapsule({required this.label});

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: w * 0.04, vertical: w * 0.018),
      decoration: BoxDecoration(
        color: _C.accentSoft,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: _C.border, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: w * 0.03,
          fontWeight: FontWeight.w500,
          color: _C.accent,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _SaveCollectionButton  — full-width animated CTA
// ─────────────────────────────────────────────────────────────
class _SaveCollectionButton extends StatefulWidget {
  final bool saved;
  final VoidCallback onTap;
  const _SaveCollectionButton({required this.saved, required this.onTap});

  @override
  State<_SaveCollectionButton> createState() => _SaveCollectionButtonState();
}

class _SaveCollectionButtonState extends State<_SaveCollectionButton>
    with SingleTickerProviderStateMixin {

  late final AnimationController _bounceCtrl;
  late final Animation<double>   _bounce;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 340));
    _bounce = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.06)
              .chain(CurveTween(curve: Curves.easeOut)), weight: 35),
      TweenSequenceItem(
          tween: Tween(begin: 1.06, end: 0.96)
              .chain(CurveTween(curve: Curves.easeInOut)), weight: 30),
      TweenSequenceItem(
          tween: Tween(begin: 0.96, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)), weight: 35),
    ]).animate(_bounceCtrl);
  }

  @override
  void dispose() { _bounceCtrl.dispose(); super.dispose(); }

  void _handle() {
    widget.onTap();
    _bounceCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return GestureDetector(
      onTapDown:   (_) => setState(() => _scale = 0.965),
      onTapCancel: ()  => setState(() => _scale = 1.0),
      onTapUp:     (_) { setState(() => _scale = 1.0); _handle(); },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeInOut,
        child: AnimatedBuilder(
          animation: _bounce,
          builder: (_, child) =>
              Transform.scale(scale: _bounce.value, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: h * 0.068,
            decoration: BoxDecoration(
              color: widget.saved ? _C.accentSoft : _C.accent,
              borderRadius: BorderRadius.circular(w * 0.04),
              boxShadow: widget.saved
                  ? []
                  : [
                BoxShadow(
                  color: _C.accent.withOpacity(0.22),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    widget.saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_add_outlined,
                    key: ValueKey(widget.saved),
                    color: widget.saved ? _C.accent : _C.surface,
                    size: w * 0.05,
                  ),
                ),
                SizedBox(width: w * 0.028),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                    color: widget.saved ? _C.accent : _C.surface,
                  ),
                  child: Text(widget.saved
                      ? 'Saved to Collection'
                      : 'Save to Collection'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _AiScoreBadge  — floating top-right badge
// ─────────────────────────────────────────────────────────────
class _AiScoreBadge extends StatelessWidget {
  final int score;
  const _AiScoreBadge({required this.score});

  Color get _dot => score >= 88
      ? const Color(0xFF34C759)
      : score >= 72
      ? const Color(0xFFFF9F0A)
      : const Color(0xFFFF453A);

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: w * 0.034, vertical: w * 0.018),
      decoration: BoxDecoration(
        color: _C.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(w * 0.03),
        border: Border.all(color: _dot.withOpacity(0.28), width: 1),
        boxShadow: [
          BoxShadow(
              color: _C.ink.withOpacity(0.10),
              blurRadius: 12, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w * 0.018, height: w * 0.018,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _dot),
          ),
          SizedBox(width: w * 0.018),
          Text('$score% Match',
              style: TextStyle(
                fontSize: w * 0.03,
                fontWeight: FontWeight.w700,
                color: _C.ink,
                letterSpacing: 0.2,
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _CircleButton  — back button
// ─────────────────────────────────────────────────────────────
class _CircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  State<_CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<_CircleButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final size = w * 0.102;
    return GestureDetector(
      onTapDown:   (_) => setState(() => _scale = 0.90),
      onTapCancel: ()  => setState(() => _scale = 1.0),
      onTapUp:     (_) { setState(() => _scale = 1.0); widget.onTap(); },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _C.surface.withOpacity(0.88),
            boxShadow: [
              BoxShadow(
                  color: _C.ink.withOpacity(0.10),
                  blurRadius: 12, offset: const Offset(0, 3)),
            ],
          ),
          child: Icon(widget.icon, size: size * 0.4, color: _C.ink),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _SaveCircleButton  — bookmark button (top right over image)
// ─────────────────────────────────────────────────────────────
class _SaveCircleButton extends StatefulWidget {
  final bool saved;
  final VoidCallback onTap;
  const _SaveCircleButton({required this.saved, required this.onTap});

  @override
  State<_SaveCircleButton> createState() => _SaveCircleButtonState();
}

class _SaveCircleButtonState extends State<_SaveCircleButton>
    with SingleTickerProviderStateMixin {

  late final AnimationController _bounceCtrl;
  late final Animation<double>   _bounce;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 320));
    _bounce = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.38)
              .chain(CurveTween(curve: Curves.easeOut)), weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.38, end: 0.88)
              .chain(CurveTween(curve: Curves.easeInOut)), weight: 30),
      TweenSequenceItem(
          tween: Tween(begin: 0.88, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)), weight: 30),
    ]).animate(_bounceCtrl);
  }

  @override
  void dispose() { _bounceCtrl.dispose(); super.dispose(); }

  void _handle() {
    widget.onTap();
    _bounceCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final size = w * 0.102;
    return GestureDetector(
      onTap: _handle,
      child: AnimatedBuilder(
        animation: _bounce,
        builder: (_, child) =>
            Transform.scale(scale: _bounce.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.saved ? _C.accent : _C.surface.withOpacity(0.88),
            boxShadow: [
              BoxShadow(
                  color: (widget.saved ? _C.accent : _C.ink)
                      .withOpacity(widget.saved ? 0.26 : 0.10),
                  blurRadius: widget.saved ? 16 : 10,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Icon(
            widget.saved
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            size: size * 0.44,
            color: widget.saved ? _C.surface : _C.inkMuted,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _BackgroundDecor  — ambient floating blobs
// ─────────────────────────────────────────────────────────────
class _BackgroundDecor extends StatefulWidget {
  @override
  State<_BackgroundDecor> createState() => _BackgroundDecorState();
}

class _BackgroundDecorState extends State<_BackgroundDecor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _float;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000))
      ..repeat(reverse: true);
    _float = Tween<double>(begin: -10, end: 10).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;
    return AnimatedBuilder(
      animation: _float,
      builder: (_, __) => IgnorePointer(
        child: Stack(children: [
          Positioned(
            top: h * 0.55 + _float.value,
            right: -w * 0.2,
            child: _Blob(size: w * 0.72, opacity: 0.05),
          ),
          Positioned(
            bottom: h * 0.08 - _float.value * 0.5,
            left: -w * 0.25,
            child: _Blob(size: w * 0.60, opacity: 0.04),
          ),
        ]),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size; final double opacity;
  const _Blob({required this.size, required this.opacity});
  @override
  Widget build(BuildContext context) => Opacity(
    opacity: opacity,
    child: Container(
      width: size, height: size,
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: _C.accent),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  MISSING CONSTANT  (duplicate-safe; already in recommended_section)
// ─────────────────────────────────────────────────────────────
extension on _C {
  static const surface = Color(0xFFFFFFFF);
  static const accentSoft = Color(0xFFE8E8F0);
  static const accent  = Color(0xFF1A1A2E);
  static const inkMuted = Color(0xFF6B6A67);
  static const inkSubtle = Color(0xFFA8A7A4);
  static const ink    = Color(0xFF141413);
  static const border = Color(0xFFE5E4E0);
  static const bg     = Color(0xFFF7F6F3);
}

// ═══════════════════════════════════════════════════════════════
//  HOW TO WIRE THIS INTO RecommendedItemCard
//  (add this to your existing recommended_section.dart)
// ═══════════════════════════════════════════════════════════════
//
//  1. Wrap your card's image container with:
//
//     Hero(
//       tag: 'outfit_img_${item.id}',
//       child: /* your existing image/placeholder container */,
//     )
//
//  2. In the card's onTap callback:
//
//     onTap: () => openOutfitDetails(context, item),
//
//  That's it. Hero handles the morph; _CinematicRoute handles
//  the overlay fade+slide.
//
// ═══════════════════════════════════════════════════════════════

// DEMO ENTRY — remove when integrating into your app
