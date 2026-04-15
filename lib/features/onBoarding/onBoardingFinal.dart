// ═══════════════════════════════════════════════════════════════════════════
//  onboarding_screen.dart  — Premium Cinematic Onboarding (Drop-in Upgrade)
// ═══════════════════════════════════════════════════════════════════════════
//
//  REPLACES / ENHANCES all existing onboarding files:
//    • OnboardingScreen       (was: on_board_screen.dart)
//    • OnboardingPageWidget   (was: on_board_page.dart)
//    • CurvedBottomClipper    (was: on_gurved.dart)
//    • AnimatedNextButton     (was: buttons.dart)
//    • AnimatedPageIndicator  (was: page_indicator.dart)
//
//  NEW ADDITIONS:
//    • _CinematicBackground   — layered gradient + animated blobs + grain
//    • _GlassCard             — glassmorphism content panel (blur 22px)
//    • _SpotlightGlow         — radial light bloom behind hero
//    • _AmbientBlob           — slow-floating blurred shape
//    • _GrainPainter          — subtle film-grain texture
//    • _PremiumPagePhysics    — buttery spring page feel
//
//  ─── PUBSPEC ADDITIONS ────────────────────────────────────────────────────
//  dependencies:
//    flutter:
//      sdk: flutter
//
//  flutter:
//    uses-material-design: true
//    fonts:
//      - family: Cormorant Garamond
//        fonts:
//          - asset: assets/fonts/CormorantGaramond-Light.ttf   # weight: 300
//          - asset: assets/fonts/CormorantGaramond-Regular.ttf # weight: 400
//      - family: DM Sans
//        fonts:
//          - asset: assets/fonts/DMSans-Light.ttf   # weight: 300
//          - asset: assets/fonts/DMSans-Regular.ttf # weight: 400
//          - asset: assets/fonts/DMSans-Medium.ttf  # weight: 500
//    assets:
//      - assets/images/screen1.jpg   # modest women's fashion: hijab + abaya
//      - assets/images/screen2.jpg   # curated collection grid
//      - assets/images/screen3.jpg   # smart outfit preview
//
//  Download fonts free from fonts.google.com → place in assets/fonts/
//  Or use the google_fonts package and replace fontFamily: strings.
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ───────────────────────────────────────────────────────────────────────────
// APP COLORS — matches your existing AppColors class exactly
// ───────────────────────────────────────────────────────────────────────────
abstract final class AppColors {
  // Core brand
  static const Color primaryColor   = Color(0xFF0D0D0D);

  // Surface layers
  static const Color surface0       = Color(0xFF0D0D0D);
  static const Color surface1       = Color(0xFF141414);
  static const Color surface2       = Color(0xFF1C1C1C);
  static const Color surface3       = Color(0xFF242424);
  static const Color divider        = Color(0xFFE8E6E1);

  // Text hierarchy
  static const Color textPrimary    = Color(0xFFF5F5F5);
  static const Color textSecondary  = Color(0xFF8A8A8A);
  static const Color textTertiary   = Color(0xFF4A4A4A);

  // White spectrum
  static const Color white          = Color(0xFFFFFFFF);
  static const Color whiteSoft      = Color(0xCCFFFFFF);
  static const Color whiteFaint     = Color(0x14FFFFFF); // 0.08 opacity
  static const Color whiteBorder    = Color(0x1AFFFFFF); // 0.10 opacity

  // Legacy compat shims (used by old code)
  static const Color cardBackground    = Color(0xFF141414);
  static const Color shadowColor       = Color(0x33000000);
  static const Color indicatorActive   = Color(0xFFC9A96E);
  static const Color indicatorInactive = Color(0xFF3A3A3A);

  // Cinematic FX extras
  static const Color accentGold     = Color(0xFFC9A96E);
  static const Color accentGoldSoft = Color(0x28C9A96E);
  static const Color navyGlow       = Color(0x1A1B3A5C);
  static const Color emeraldGlow    = Color(0x1A2D6A4F);
}

// ───────────────────────────────────────────────────────────────────────────
// DATA MODEL  (drop-in compatible with your existing OnboardingPageModel)
// ───────────────────────────────────────────────────────────────────────────
class OnboardingPageModel {
  final String       title;
  final String       subtitle;
  final String       buttonLabel;
  final String       imageAsset;
  final Color        backgroundColor;  // legacy — kept for API compat
  final List<Color>  darkGradient;     // NEW: per-screen cinematic bg
  final Color        glowColor;        // NEW: ambient spotlight hue

  const OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.imageAsset,
    required this.backgroundColor,
    required this.darkGradient,
    required this.glowColor,
  });
}

// ── Sample page data ─────────────────────────────────────────────────────────
//  Images: modest fashion (hijab, abaya, long sleeves) — editorial lighting
final List<OnboardingPageModel> onboardingPages = [
  const OnboardingPageModel(
    title:           'Discover Your\nPerfect Style',
    subtitle:        'Personalized modest fashion recommendations curated for your taste and lifestyle.',
    buttonLabel:     'Continue',
    imageAsset:      'assets/images/screen1.jpg',
    backgroundColor: Color(0xFF0D0D0D),
    darkGradient:    [Color(0xFF0D0D0D), Color(0xFF0F1620), Color(0xFF0D0D0D)],
    glowColor:       Color(0x221B3A5C), // navy
  ),
  const OnboardingPageModel(
    title:           'Save What\nYou Love',
    subtitle:        'Build your own curated fashion collection and revisit favourite looks anytime.',
    buttonLabel:     'Continue',
    imageAsset:      'assets/images/screen2.jpg',
    backgroundColor: Color(0xFF0D0D0D),
    darkGradient:    [Color(0xFF0D0D0D), Color(0xFF0D1810), Color(0xFF0D0D0D)],
    glowColor:       Color(0x222D6A4F), // emerald
  ),
  const OnboardingPageModel(
    title:           'Smart Style,\nEffortlessly Yours',
    subtitle:        'Our intelligent system curates complete modest outfits tailored just for you.',
    buttonLabel:     'Get Started',
    imageAsset:      'assets/images/screen3.jpg',
    backgroundColor: Color(0xFF0D0D0D),
    darkGradient:    [Color(0xFF0D0D0D), Color(0xFF17120A), Color(0xFF0D0D0D)],
    glowColor:       Color(0x22C9A96E), // gold
  ),
];

// ───────────────────────────────────────────────────────────────────────────
// ONBOARDING SCREEN  (root widget — replaces your on_board_screen.dart)
// ───────────────────────────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Global entrance fade
  late final AnimationController _entranceCtrl;
  late final Animation<double>   _entranceFade;

  // Per-page content controllers
  late final List<AnimationController> _pageCtrl;

  // Ambient float loop — 10 s, very slow
  late final AnimationController _floatCtrl;

  // Glow pulse — 2.8 s
  late final AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:          Colors.transparent,
      statusBarBrightness:     Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    _entranceCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 700),
    );
    _entranceFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve:  Curves.easeOut,
    );

    _pageCtrl = List.generate(
      onboardingPages.length,
          (_) => AnimationController(
        vsync:    this,
        duration: const Duration(milliseconds: 760),
      ),
    );

    _floatCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _glowCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    // Rebuild on scroll for parallax (lightweight — only triggers AnimatedBuilders)
    _pageController.addListener(() => setState(() {}));

    _entranceCtrl.forward();
    _pageCtrl[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceCtrl.dispose();
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    for (final c in _pageCtrl) c.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 480),
        curve:    Curves.easeInOutCubic,
      );
    } else {
      // TODO: replace with LoginScreen or HomeScreen
      HapticFeedback.mediumImpact();
    }
  }

  void _onPageChanged(int index) {
    HapticFeedback.lightImpact();
    setState(() => _currentPage = index);
    _pageCtrl[index]
      ..reset()
      ..forward();
  }

  List<Color> _morphedGradient() {
    final page = _pageController.hasClients
        ? (_pageController.page ?? 0.0) : 0.0;
    final lo = page.floor().clamp(0, onboardingPages.length - 1);
    final hi = (lo + 1).clamp(0, onboardingPages.length - 1);
    final t  = page - lo;
    final a  = onboardingPages[lo].darkGradient;
    final b  = onboardingPages[hi].darkGradient;
    return [
      Color.lerp(a[0], b[0], t)!,
      Color.lerp(a[1], b[1], t)!,
      Color.lerp(a[2], b[2], t)!,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size   = MediaQuery.sizeOf(context);
    final colors = _morphedGradient();

    return FadeTransition(
      opacity: _entranceFade,
      child: Scaffold(
        backgroundColor: AppColors.surface0,
        body: Stack(
          children: [
            // ① Cinematic background (lives outside PageView — never rebuilds on swipe)
            _CinematicBackground(
              gradient:   colors,
              floatCtrl:  _floatCtrl,
              glowCtrl:   _glowCtrl,
              size:       size,
            ),

            // ② Page content
            PageView.builder(
              controller:    _pageController,
              onPageChanged: _onPageChanged,
              physics:       const _PremiumPagePhysics(),
              itemCount:     onboardingPages.length,
              itemBuilder:   (_, index) => OnboardingPageWidget(
                data:           onboardingPages[index],
                pageIndex:      index,
                totalPages:     onboardingPages.length,
                pageController: _pageController,
                contentCtrl:    _pageCtrl[index],
                glowCtrl:       _glowCtrl,
                onNext:         _goToNextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// CINEMATIC BACKGROUND
// ───────────────────────────────────────────────────────────────────────────
class _CinematicBackground extends StatelessWidget {
  final List<Color>         gradient;
  final AnimationController floatCtrl;
  final AnimationController glowCtrl;
  final Size                size;

  const _CinematicBackground({
    required this.gradient,
    required this.floatCtrl,
    required this.glowCtrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([floatCtrl, glowCtrl]),
      builder: (_, __) {
        final f = floatCtrl.value; // 0→1 slow sine wave
        final g = glowCtrl.value;  // 0→1 pulse

        return SizedBox.fromSize(
          size: size,
          child: Stack(
            children: [
              // ── Base gradient ──────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin:  Alignment.topCenter,
                    end:    Alignment.bottomCenter,
                    colors: gradient,
                    stops:  const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // ── Floating ambient blob — top-left (navy) ────────────────
              Positioned(
                top:  -90 + f * 55,
                left: -70 + f * 35,
                child: _AmbientBlob(
                  diameter: 320,
                  color:    AppColors.navyGlow,
                  opacity:  0.55 + g * 0.18,
                ),
              ),

              // ── Floating ambient blob — bottom-right (emerald) ─────────
              Positioned(
                bottom: -70 + f * 40,
                right:  -90 + f * 28,
                child: _AmbientBlob(
                  diameter: 290,
                  color:    AppColors.emeraldGlow,
                  opacity:  0.42 + g * 0.14,
                ),
              ),

              // ── Soft light bloom — center-top ──────────────────────────
              Positioned(
                top:   -50,
                left:  size.width * 0.15,
                right: size.width * 0.15,
                child: _AmbientBlob(
                  diameter: size.width * 0.85,
                  color:    AppColors.accentGoldSoft,
                  opacity:  0.18 + g * 0.08,
                ),
              ),

              // ── Film-grain texture ─────────────────────────────────────
              CustomPaint(size: size, painter: _GrainPainter()),
            ],
          ),
        );
      },
    );
  }
}

// ── Blurred floating circle ──────────────────────────────────────────────────
class _AmbientBlob extends StatelessWidget {
  final double diameter;
  final Color  color;
  final double opacity;

  const _AmbientBlob({
    required this.diameter,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 72, sigmaY: 72),
      child: Container(
        width:  diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
        ),
      ),
    );
  }
}

// ── Subtle film grain (painted once — never repaints) ───────────────────────
class _GrainPainter extends CustomPainter {
  static final _rng  = math.Random(77);
  static final _dots = List.generate(
    1100,
        (_) => Offset(_rng.nextDouble() * 430, _rng.nextDouble() * 960),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.whiteFaint.withOpacity(0.055)
      ..style = PaintingStyle.fill;
    for (final d in _dots) {
      if (d.dx < size.width && d.dy < size.height) {
        canvas.drawCircle(d, 0.65, p);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ───────────────────────────────────────────────────────────────────────────
// ONBOARDING PAGE WIDGET  (drop-in for on_board_page.dart)
// ───────────────────────────────────────────────────────────────────────────
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageModel  data;
  final int                  pageIndex;
  final int                  totalPages;
  final PageController       pageController;
  final AnimationController  contentCtrl;
  final AnimationController  glowCtrl;
  final VoidCallback         onNext;

  const OnboardingPageWidget({
    super.key,
    required this.data,
    required this.pageIndex,
    required this.totalPages,
    required this.pageController,
    required this.contentCtrl,
    required this.glowCtrl,
    required this.onNext,
  });

  double _delta() {
    if (!pageController.hasClients || pageController.page == null) return 0.0;
    return (pageController.page! - pageIndex).clamp(-1.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final size        = MediaQuery.sizeOf(context);
    final imageH      = size.height * 0.58;
    const cardOverlap = 32.0;

    // Staggered entrance curves
    final imgAnim = CurvedAnimation(
      parent: contentCtrl,
      curve:  const Interval(0.00, 0.65, curve: Curves.easeOutCubic),
    );
    final headlineAnim = CurvedAnimation(
      parent: contentCtrl,
      curve:  const Interval(0.18, 0.78, curve: Curves.easeOutCubic),
    );
    final bodyAnim = CurvedAnimation(
      parent: contentCtrl,
      curve:  const Interval(0.30, 0.88, curve: Curves.easeOutCubic),
    );
    final btnAnim = CurvedAnimation(
      parent: contentCtrl,
      curve:  const Interval(0.45, 1.00, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: Listenable.merge([pageController, contentCtrl, glowCtrl]),
      builder: (context, _) {
        final delta     = _delta();
        final abs       = delta.abs();
        final parallaxX = delta * size.width * 0.32;
        final scrimAlp  = abs * 0.20;
        final cardY     = abs * 16.0;
        final cardScale = 1.0 - abs * 0.025;
        final contentOp = (1.0 - abs * 1.5).clamp(0.0, 1.0);

        // Entrance: slide-up + scale
        final imgSlideY = (1 - imgAnim.value) * 42.0;
        final imgScale  = 0.95 + imgAnim.value * 0.05;

        return Stack(
          children: [
            // ── Hero image ─────────────────────────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              height: imageH,
              child: Transform.translate(
                offset: Offset(parallaxX, imgSlideY),
                child: Transform.scale(
                  scale: imgScale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Spotlight radial glow
                      _SpotlightGlow(
                        radius:  size.width * 0.55,
                        color:   data.glowColor,
                        pulse:   glowCtrl.value,
                      ),

                      // Image with curved clip
                      ClipPath(
                        clipper: const CurvedBottomClipper(curveDepth: 36),
                        child: _HeroImage(
                          asset:  data.imageAsset,
                          height: imageH,
                        ),
                      ),

                      // Bottom gradient fade into bg
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin:  Alignment.topCenter,
                              end:    Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.surface0.withOpacity(0.80),
                                AppColors.surface0,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Depth scrim (dims non-active pages) ───────────────────
            Positioned(
              top: 0, left: 0, right: 0, height: imageH,
              child: IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withOpacity(scrimAlp),
                ),
              ),
            ),

            // ── Glassmorphism content card ─────────────────────────────
            Positioned(
              top: imageH - cardOverlap,
              left: 0, right: 0, bottom: 0,
              child: Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()
                  ..translate(0.0, cardY)
                  ..scale(cardScale),
                child: Opacity(
                  opacity: contentOp,
                  child: _GlassCard(
                    headlineAnim: headlineAnim,
                    bodyAnim:     bodyAnim,
                    btnAnim:      btnAnim,
                    data:         data,
                    currentPage:  pageIndex,
                    totalPages:   totalPages,
                    onNext:       onNext,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// HERO IMAGE
// ───────────────────────────────────────────────────────────────────────────
class _HeroImage extends StatelessWidget {
  final String asset;
  final double height;

  const _HeroImage({required this.asset, required this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      height: height,
      width:  double.infinity,
      fit:    BoxFit.cover,
      errorBuilder: (_, __, ___) => _PlaceholderHero(height: height),
    );
  }
}

class _PlaceholderHero extends StatelessWidget {
  final double height;
  const _PlaceholderHero({required this.height});

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin:  Alignment.topLeft,
        end:    Alignment.bottomRight,
        colors: [Color(0xFF1C1C1C), Color(0xFF0D0D0D), Color(0xFF1A1A1A)],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.checkroom_outlined, color: AppColors.accentGold, size: 72),
        const SizedBox(height: 14),
        const Text(
          'Modest Fashion',
          style: TextStyle(
            fontFamily:    'Cormorant Garamond',
            fontSize:      22,
            letterSpacing: 2,
            color:         AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Add images to assets/images/',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize:   12,
            color:      AppColors.textTertiary,
          ),
        ),
      ],
    ),
  );
}

// ───────────────────────────────────────────────────────────────────────────
// SPOTLIGHT GLOW
// ───────────────────────────────────────────────────────────────────────────
class _SpotlightGlow extends StatelessWidget {
  final double radius;
  final Color  color;
  final double pulse; // 0→1

  const _SpotlightGlow({
    required this.radius,
    required this.color,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final r = radius + pulse * 22;
    return Container(
      width:  r * 2,
      height: r * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.55 + pulse * 0.20),
            color.withOpacity(0.18),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// GLASSMORPHISM CONTENT CARD
// ───────────────────────────────────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  final Animation<double>   headlineAnim;
  final Animation<double>   bodyAnim;
  final Animation<double>   btnAnim;
  final OnboardingPageModel data;
  final int                 currentPage;
  final int                 totalPages;
  final VoidCallback        onNext;

  const _GlassCard({
    required this.headlineAnim,
    required this.bodyAnim,
    required this.btnAnim,
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: BoxDecoration(
            // 0.09 white overlay — glassmorphism sweet spot
            color:        AppColors.whiteFaint,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            border: const Border(
              top: BorderSide(color: AppColors.whiteBorder, width: 0.8),
            ),
            boxShadow: [
              BoxShadow(
                color:      Colors.black.withOpacity(0.22),
                blurRadius: 32,
                offset:     const Offset(0, -6),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag pill
              Center(
                child: Container(
                  width: 36, height: 4,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    color:        AppColors.whiteBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Headline ──────────────────────────────────────────────
              AnimatedBuilder(
                animation: headlineAnim,
                builder: (_, __) => Opacity(
                  opacity: headlineAnim.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset((1 - headlineAnim.value) * -28, 0),
                    child: Text(
                      data.title,
                      style: const TextStyle(
                        fontFamily:    'Cormorant Garamond',
                        fontSize:      38,
                        fontWeight:    FontWeight.w300,
                        color:         AppColors.textPrimary,
                        height:        1.16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

              // Gold accent line
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: headlineAnim,
                builder: (_, __) => FractionallySizedBox(
                  widthFactor: headlineAnim.value.clamp(0.0, 1.0) * 0.14,
                  child: Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accentGold, Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Body / description (inner glass inset) ────────────────
              AnimatedBuilder(
                animation: bodyAnim,
                builder: (_, __) => Opacity(
                  opacity: bodyAnim.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, (1 - bodyAnim.value) * 14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color:        AppColors.whiteFaint.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.whiteBorder,
                              width: 0.6,
                            ),
                          ),
                          child: Text(
                            data.subtitle,
                            style: const TextStyle(
                              fontFamily:    'DM Sans',
                              fontSize:      15,
                              fontWeight:    FontWeight.w300,
                              color:         AppColors.textSecondary,
                              height:        1.60,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // ── Primary button ─────────────────────────────────────────
              AnimatedBuilder(
                animation: btnAnim,
                builder: (_, __) => Opacity(
                  opacity: btnAnim.value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.92 + btnAnim.value * 0.08,
                    child: AnimatedNextButton(
                      label: data.buttonLabel,
                      onTap: onNext,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Page indicator ─────────────────────────────────────────
              AnimatedBuilder(
                animation: btnAnim,
                builder: (_, __) => Opacity(
                  opacity: btnAnim.value.clamp(0.0, 1.0),
                  child: Center(
                    child: AnimatedPageIndicator(
                      pageCount:     totalPages,
                      currentPage:   currentPage,
                      activeColor:   AppColors.indicatorActive,
                      inactiveColor: AppColors.indicatorInactive,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// ANIMATED NEXT BUTTON  (drop-in for buttons.dart — AnimatedNextButton)
// ───────────────────────────────────────────────────────────────────────────
class AnimatedNextButton extends StatefulWidget {
  final String       label;
  final VoidCallback onTap;
  final Color?       color; // kept for API compat — ignored; uses gradient

  const AnimatedNextButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  State<AnimatedNextButton> createState() => _AnimatedNextButtonState();
}

class _AnimatedNextButtonState extends State<AnimatedNextButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double>   _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 110),
    );
    _scaleAnim = Tween(begin: 1.0, end: 0.965).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => _pressCtrl.forward(),
      onTapUp:     (_) { _pressCtrl.reverse(); widget.onTap(); },
      onTapCancel: ()  => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          width:  double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            gradient: const LinearGradient(
              colors: [Color(0xFFD4AA6E), Color(0xFFA87B34)],
            ),
            boxShadow: [
              BoxShadow(
                color:      const Color(0xFFC9A96E).withOpacity(0.28),
                blurRadius: 22,
                offset:     const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontFamily:    'DM Sans',
              fontSize:      16,
              fontWeight:    FontWeight.w500,
              color:         AppColors.surface0,
              letterSpacing: 0.9,
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// ANIMATED PAGE INDICATOR  (drop-in for page_indicator.dart)
// ───────────────────────────────────────────────────────────────────────────
class AnimatedPageIndicator extends StatelessWidget {
  final int   pageCount;
  final int   currentPage;
  final Color activeColor;
  final Color inactiveColor;

  const AnimatedPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (i) {
        final active = i == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 430),
          curve:    Curves.easeInOut,
          margin:   const EdgeInsets.symmetric(horizontal: 4),
          width:    active ? 30.0 : 8.0,
          height:   8.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: active ? activeColor : inactiveColor,
            boxShadow: active
                ? [BoxShadow(
              color:      activeColor.withOpacity(0.35),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            )]
                : null,
          ),
        );
      }),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// CURVED BOTTOM CLIPPER  (drop-in — unchanged from on_gurved.dart)
// ───────────────────────────────────────────────────────────────────────────
class CurvedBottomClipper extends CustomClipper<Path> {
  final double curveDepth;
  const CurvedBottomClipper({this.curveDepth = 40});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - curveDepth);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + curveDepth,
      size.width,
      size.height - curveDepth,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CurvedBottomClipper old) => old.curveDepth != curveDepth;
}

// ───────────────────────────────────────────────────────────────────────────
// CUSTOM PAGE PHYSICS — buttery smooth, no bounce
// ───────────────────────────────────────────────────────────────────────────
class _PremiumPagePhysics extends PageScrollPhysics {
  const _PremiumPagePhysics()
      : super(parent: const ClampingScrollPhysics());

  @override
  _PremiumPagePhysics applyTo(ScrollPhysics? ancestor) =>
      const _PremiumPagePhysics();

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 1.0, stiffness: 110, damping: 19);
}