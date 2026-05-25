import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_proj/features/splash/splash_animation.dart';
import 'package:graduation_proj/features/splash/splash_bottom_bar.dart';
import 'package:graduation_proj/features/splash/splash_logo.dart';
import 'package:graduation_proj/features/splash/splash_tag_line.dart';
import 'package:graduation_proj/features/splash/splash_title.dart';

import '../../config/routes/app_router.dart';
import '../../core/sharedWidgets/animations/bg_animation.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_constants.dart';
/// Entry point splash — cinematic staggered reveal.
/// After animation completes, navigates to HomePage.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final SplashAnimations _anims;

  @override
  void initState() {
    super.initState();


    _anims = SplashAnimations(vsync: this);
    _startSequence();
  }

  Future<void> _startSequence() async {
    await _anims.play();

    if (!mounted) return;

    // Brief pause at full state before leaving
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    _navigate();
  }

  void _navigate() {
    context.go(AppRoutes.autoLogin);
  }
  @override
  void dispose() {
    _anims.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // ── Layer 0: Ambient floating blobs ──────────────────
       AmbientBg(
              float1: _anims.float1Anim,
              float2: _anims.float2Anim,

          ),

          // ── Layer 1: Subtle grid texture overlay ─────────────
          const Positioned.fill(child: _GridOverlay()),

          // ── Layer 2: Main content ─────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sp.sm),
            child: Center(
              child: Column(

                children: [
                  const Spacer(flex: 5),

                  // Logo
                  SplashLogo(
                    scaleAnim: _anims.logoScale,
                    fadeAnim: _anims.logoFade,
                    glowAnim: _anims.glow,
                  ),

                  const SizedBox(height: Sp.sm),

                  // Title
                  SplashTitle(
                    fadeAnim: _anims.titleFade,
                    slideAnim: _anims.titleSlide,
                  ),

                  const SizedBox(height: Sp.xs),

                  // Tagline
                  SplashTagline(
                    fadeAnim: _anims.taglineFade,
                    slideAnim: _anims.taglineSlide,
                  ),

                  const Spacer(flex: 5),

                  // Bottom progress bar
                  SplashBottomBar(
                    fadeAnim: _anims.bottomFade,
                    progressAnim: _anims.progress,
                  ),

                  const SizedBox(height: Sp.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Extremely subtle dot-grid texture — gives the off-white bg some depth.
class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotGridPainter(),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider.withOpacity(0.55)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    const radius = 0.9;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}