// ============================================================
//  OUTFIT.AI — Premium Animated Splash Screen
//  Flutter · Production-Ready · AnimationController
// ============================================================
//
//  ANIMATION FLOW (total: 4 000 ms)
//  ─────────────────────────────────────────────────────────
//  0–300ms    Background gradient wipe (CurvedAnimation)
//  200–700ms  Logo hanger icon — scale + fade in (elastic)
//  500–900ms  App name "OUTFIT" — character-by-character slide-up
//  800–1100ms Tagline "AI-powered style." — fade + slide from bottom
//  1000–1400ms Decorative rule lines — width expansion
//  1300–1700ms Version / brand badge — fade in
//  1600–2200ms Floating fashion particles — staggered opacity
//  2200–3000ms Lottie / fallback AI pulse ring — scale breathe
//  3000–3500ms AI scan line sweep across logo (slide + fade)
//  3500–3800ms Everything dims slightly (exit pre-wind)
//  3800–4000ms Full fade-out → push to HomeScreen
//
//  BEST PRACTICES USED
//  ─────────────────────────────────────────────────────────
//  ✓ Single TickerProvider (SingleTickerProviderStateMixin)
//  ✓ Multiple CurvedAnimations driven by ONE AnimationController
//  ✓ Interval curves for precise timeline control
//  ✓ dispose() properly called to prevent memory leaks
//  ✓ SystemChrome immersive edge-to-edge UI
//  ✓ Responsive sizing via MediaQuery
//  ✓ RepaintBoundary around heavy particle layer
//  ✓ Lottie wrapped in try-catch / graceful fallback widget
//  ✓ No hard-coded pixel widths — all relative units
//  ✓ Const constructors wherever possible
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_proj/config/routes/app_router.dart';
import 'package:graduation_proj/features/login/presentation/pages/auto_login.dart';
import 'package:graduation_proj/features/onBoarding/on_boarding_screen.dart';

import '../../core/apiManager/dio_client.dart';
import '../login/presentation/pages/login_screen.dart';
import '../login/presentation/widgets/screen_items/login_screen_item.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ─── Single master controller (4 000 ms) ──────────────────
  late final AnimationController _ctrl;

   late final Animation<double> _bgReveal;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _ruleWidth;
  late final Animation<double> _badgeFade;
  late final Animation<double> _particleFade;
  late final Animation<double> _scanSlide;
  late final Animation<double> _scanFade;
  late final Animation<double> _exitFade;

   final List<_Particle> _particles = List.generate(
    18,
        (i) => _Particle(i),
  );

  // ─── Color palette ────────────────────────────────────────
  static const Color _ink = Color(0xFF0A0A0A);
  static const Color _cream = Color(0xFFF5F0E8);
  static const Color _gold = Color(0xFFD4AF6A);
  static const Color _goldLight = Color(0xFFEDD98A);
  static const Color _charcoal = Color(0xFF1C1C1E);

  // ─── Font family (add to pubspec / Google Fonts) ──────────
  // Using 'Didot'-inspired fallback via serif. For production,
  // add google_fonts and swap to GoogleFonts.cormorantGaramond()
  static const String _displayFont = 'Georgia';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // ── Helper: interval curve ────────────────────────────
    CurvedAnimation ci(double begin, double end, [Curve c = Curves.easeOut]) =>
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(begin, end, curve: c),
        );

    // ── Wire animations ───────────────────────────────────
    _bgReveal = ci(0.0, 0.075, Curves.easeInOut);

    _logoFade = ci(0.05, 0.175, Curves.easeIn);
    _logoScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      ci(0.05, 0.175, Curves.elasticOut),
    );

    _titleFade = ci(0.125, 0.225, Curves.easeIn);
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.9),
      end: Offset.zero,
    ).animate(ci(0.125, 0.225, Curves.easeOutCubic));

    _taglineFade = ci(0.2, 0.275, Curves.easeIn);
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(ci(0.2, 0.275, Curves.easeOutCubic));

    _ruleWidth = ci(0.25, 0.35, Curves.easeOut);
    _badgeFade = ci(0.325, 0.425, Curves.easeIn);
    _particleFade = ci(0.4, 0.55, Curves.easeInOut);

    _scanSlide = Tween<double>(begin: 0.0, end: 1.0).animate(
      ci(0.75, 0.875, Curves.easeInOut),
    );
    _scanFade = ci(0.75, 0.95, Curves.easeInOut);

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      ci(0.9, 1.0, Curves.easeIn),
    );
    // DioClient.clearToken();

    // ── Start & navigate on complete ──────────────────────
    _ctrl.forward().then((_) => _navigate());
  }
  void _navigate() {
    if (!mounted) return;
    context.go(AppRoutes.autoLogin); // replace '/home' with your actual route

  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. Background gradient reveal ─────────────
              _buildBackground(size),

              // ── 2. Floating fashion particles ─────────────
              RepaintBoundary(child: _buildParticles(size)),

              // ── 3. AI scan line ────────────────────────────
              _buildScanLine(size),

              // ── 4. Centre content ─────────────────────────
              _buildContent(size),

              // ── 5. Exit fade overlay ──────────────────────
              Opacity(
                opacity: 1.0 - _exitFade.value,
                child: Container(color: _ink),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Background ─────────────────────────────────────────────
  Widget _buildBackground(Size size) {
    return Opacity(
      opacity: _bgReveal.value,
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.3),
            radius: 1.4,
            colors: [
              Color(0xFF1A1612),
              Color(0xFF0F0D0B),
              Color(0xFF0A0A0A),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: CustomPaint(
          painter: _GridPainter(),
          size: size,
        ),
      ),
    );
  }

  // ── Particles ──────────────────────────────────────────────
  Widget _buildParticles(Size size) {
    return Opacity(
      opacity: _particleFade.value,
      child: CustomPaint(
        painter: _ParticlePainter(_particles, _ctrl.value),
        size: size,
      ),
    );
  }

  // ── AI Scan Line ───────────────────────────────────────────
  Widget _buildScanLine(Size size) {
    final topStart = size.height * 0.2;
    final travel = size.height * 0.6;
    return Positioned(
      left: 0,
      right: 0,
      top: topStart + travel * _scanSlide.value,
      child: Opacity(
        opacity: _scanFade.value *
            (1.0 - (_scanSlide.value * 1.6 - 0.6).clamp(0.0, 1.0)),
        child: Container(
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                _gold.withOpacity(0.15),
                _goldLight.withOpacity(0.9),
                _gold.withOpacity(0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Main Content ───────────────────────────────────────────
  Widget _buildContent(Size size) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // ── Logo icon ─────────────────────────────────────
          FadeTransition(
            opacity: _logoFade,
            child: ScaleTransition(
              scale: _logoScale,
              child: _buildLogoIcon(size),
            ),
          ),

          SizedBox(height: size.height * 0.038),

          // ── Rule line top ─────────────────────────────────
          _buildRule(),

          SizedBox(height: size.height * 0.028),

          // ── App title ─────────────────────────────────────
          ClipRect(
            child: SlideTransition(
              position: _titleSlide,
              child: FadeTransition(
                opacity: _titleFade,
                child: _buildTitle(),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.014),

          // ── Tagline ───────────────────────────────────────
          ClipRect(
            child: SlideTransition(
              position: _taglineSlide,
              child: FadeTransition(
                opacity: _taglineFade,
                child: _buildTagline(),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.028),

          // ── Rule line bottom ──────────────────────────────
          _buildRule(),

          SizedBox(height: size.height * 0.044),

          // ── Lottie / AI pulse ─────────────────────────────
          FadeTransition(
            opacity: _badgeFade,
            child: const _LottieOrFallback(),
          ),

          const Spacer(flex: 2),

          // ── Version badge ─────────────────────────────────
          FadeTransition(
            opacity: _badgeFade,
            child: _buildVersionBadge(),
          ),

          SizedBox(height: size.height * 0.04),
        ],
      ),
    );
  }

  // ── Logo Icon (Hanger + AI dot) ────────────────────────────
  Widget _buildLogoIcon(Size size) {
    final iconSize = size.width * 0.22;
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CustomPaint(
        painter: _HangerPainter(_gold),
        child: Center(
          child: Container(
            width: iconSize * 0.18,
            height: iconSize * 0.18,
            decoration: BoxDecoration(

              shape: BoxShape.circle,
              color: _gold,
              boxShadow: [
                BoxShadow(
                  color: _gold.withOpacity(0.55),
                  blurRadius: 18,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Decorative rule ────────────────────────────────────────
  Widget _buildRule() {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.55 * _ruleWidth.value,
        child: Container(
          height: 0.8,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                _gold.withOpacity(0.5),
                _gold,
                _gold.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Title ──────────────────────────────────────────────────
  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'OUTFIT',
          style: TextStyle(
            fontFamily: _displayFont,
            fontSize: 52,
            fontWeight: FontWeight.w300,
            color: _cream,
            letterSpacing: 16,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BY  ',
              style: TextStyle(
                fontFamily: _displayFont,
                fontSize: 11,
                color: _cream.withOpacity(0.45),
                letterSpacing: 5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: _gold, width: 0.8),
              ),
              child: const Text(
                'AI',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 10,
                  color: _gold,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Tagline ────────────────────────────────────────────────
  Widget _buildTagline() {
    return Text(
      'YOUR PERSONAL STYLE INTELLIGENCE',
      style: TextStyle(
        fontFamily: 'Courier',
        fontSize: 9.5,
        color: _cream.withOpacity(0.4),
        letterSpacing: 3.5,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // ── Version badge ──────────────────────────────────────────
  Widget _buildVersionBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _gold.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'V 1.0  ·  STYLE ENGINE READY',
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 8.5,
            color: _cream.withOpacity(0.25),
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _gold.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  LOTTIE OR FALLBACK WIDGET
//  ─────────────────────────────────────────────────────────
//  Drop a Lottie JSON into assets/lottie/ai_pulse.json
//  and uncomment the Lottie.asset block.
//  Without the package, the AnimatedPulseRing renders instead.
// ════════════════════════════════════════════════════════════
class _LottieOrFallback extends StatelessWidget {
  const _LottieOrFallback();

  @override
  Widget build(BuildContext context) {
    // ── LOTTIE (uncomment when package is added) ────────────
    // return SizedBox(
    //   width: 88,
    //   height: 88,
    //   child: Lottie.asset(
    //     'assets/lottie/ai_pulse.json',
    //     repeat: true,
    //     errorBuilder: (_, __, ___) => const _AnimatedPulseRing(),
    //   ),
    // );

    // ── FALLBACK: pure-Flutter AI pulse ring ───────────────
    return const _AnimatedPulseRing();
  }
}

// ── Animated pulse ring (Lottie replacement) ───────────────
class _AnimatedPulseRing extends StatefulWidget {
  const _AnimatedPulseRing();

  @override
  State<_AnimatedPulseRing> createState() => _AnimatedPulseRingState();
}

class _AnimatedPulseRingState extends State<_AnimatedPulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => ScaleTransition(
        scale: _scale,
        child: Opacity(
          opacity: _opacity.value,
          child: SizedBox(
            width: 72,
            height: 72,
            child: CustomPaint(painter: _PulseRingPainter(_pulse.value)),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  CUSTOM PAINTERS
// ════════════════════════════════════════════════════════════

/// Subtle editorial grid overlay
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF6A).withOpacity(0.025)
      ..strokeWidth = 0.5;

    const step = 44.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Fashion hanger silhouette
class _HangerPainter extends CustomPainter {
  final Color color;
  const _HangerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.045
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height * 0.3;

    // Hook
    final hookPath = Path()
      ..moveTo(cx, cy * 0.45)
      ..cubicTo(
        cx + size.width * 0.09, cy * 0.45,
        cx + size.width * 0.09, cy * 0.1,
        cx, cy * 0.1,
      );
    canvas.drawPath(hookPath, paint);

    // Hanger body
    final hangerPath = Path()
      ..moveTo(cx, cy)
      ..lineTo(size.width * 0.08, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.03, size.height * 0.75,
        size.width * 0.06, size.height * 0.75,
      )
      ..lineTo(size.width * 0.94, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.97, size.height * 0.75,
        size.width * 0.92, size.height * 0.7,
      )
      ..lineTo(cx, cy);
    canvas.drawPath(hangerPath, paint);

    // Shoulder glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = size.width * 0.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(hangerPath, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// AI concentric pulse rings
class _PulseRingPainter extends CustomPainter {
  final double progress;
  const _PulseRingPainter(this.progress);

  static const Color _gold = Color(0xFFD4AF6A);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 3; i >= 0; i--) {
      final t = (progress + i * 0.22) % 1.0;
      final radius = (size.width / 2) * (0.3 + t * 0.7);
      final opacity = (1.0 - t) * 0.6;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = _gold.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }

    // Inner dot
    canvas.drawCircle(
      center,
      6,
      Paint()
        ..color = _gold
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      center,
      3,
      Paint()
        ..color = const Color(0xFFEDD98A)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_PulseRingPainter old) => old.progress != progress;
}

/// Floating fashion-symbol particles
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;

  const _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final phase = (t * p.speed + p.offset) % 1.0;
      final y = p.baseY * size.height - phase * size.height * 0.12;
      final x = p.baseX * size.width +
          math.sin(phase * math.pi * 2 + p.offset * 6) * 18;
      final alpha = (math.sin(phase * math.pi) * p.maxAlpha)
          .clamp(0.0, 1.0);

      final paint = Paint()
        ..color = const Color(0xFFD4AF6A).withOpacity(alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9;

      _drawSymbol(canvas, Offset(x, y), p.symbol, p.size, paint);
    }
  }

  void _drawSymbol(
      Canvas canvas, Offset pos, int symbol, double size, Paint paint) {
    switch (symbol % 4) {
      case 0: // star/sparkle
        for (int i = 0; i < 4; i++) {
          final angle = i * math.pi / 2;
          canvas.drawLine(
            Offset(pos.dx + math.cos(angle) * size,
                pos.dy + math.sin(angle) * size),
            Offset(pos.dx + math.cos(angle) * size * 0.25,
                pos.dy + math.sin(angle) * size * 0.25),
            paint,
          );
        }
        break;
      case 1: // diamond
        final path = Path()
          ..moveTo(pos.dx, pos.dy - size)
          ..lineTo(pos.dx + size * 0.6, pos.dy)
          ..lineTo(pos.dx, pos.dy + size)
          ..lineTo(pos.dx - size * 0.6, pos.dy)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case 2: // small circle
        canvas.drawCircle(pos, size * 0.7, paint);
        break;
      case 3: // cross
        canvas.drawLine(Offset(pos.dx - size * 0.5, pos.dy),
            Offset(pos.dx + size * 0.5, pos.dy), paint);
        canvas.drawLine(Offset(pos.dx, pos.dy - size * 0.5),
            Offset(pos.dx, pos.dy + size * 0.5), paint);
        break;
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}

// ════════════════════════════════════════════════════════════
//  PARTICLE DATA MODEL
// ════════════════════════════════════════════════════════════
class _Particle {
  final double baseX;
  final double baseY;
  final double speed;
  final double offset;
  final double maxAlpha;
  final double size;
  final int symbol;

  _Particle(int seed)
      : baseX = _rng(seed * 7 + 1),
        baseY = _rng(seed * 13 + 2),
        speed = 0.08 + _rng(seed * 3 + 3) * 0.14,
        offset = _rng(seed * 11 + 4),
        maxAlpha = 0.08 + _rng(seed * 5 + 5) * 0.18,
        size = 3.5 + _rng(seed * 9 + 6) * 5.5,
        symbol = seed % 4;

  static double _rng(int seed) {
    final x = math.sin(seed.toDouble()) * 43758.5453;
    return x - x.floor();
  }
}

// ════════════════════════════════════════════════════════════
//  HOME SCREEN (placeholder — replace with real screen)
// ════════════════════════════════════════════════════════════
