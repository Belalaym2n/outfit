import 'package:flutter/material.dart';

/// Manages and exposes all staggered animations for the splash screen.
class SplashAnimations {
  SplashAnimations({required TickerProvider vsync}) {
    // ── Master controller ─────────────────────────────────────
    master = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3200),
    );

    // ── Ambient blob floaters ─────────────────────────────────
    float1 = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 4000),
    );
    float2 = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 5200),
    );

    // ── Glow pulse (looping) ──────────────────────────────────
    glowController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2400),
    );

    _buildCurves();
  }

  // Controllers
  late final AnimationController master;
  late final AnimationController float1;
  late final AnimationController float2;
  late final AnimationController glowController;

  // ── Logo ───────────────────────────────────────────────────
  late final Animation<double> logoFade;
  late final Animation<double> logoScale;

  // ── Title ─────────────────────────────────────────────────
  late final Animation<double> titleFade;
  late final Animation<Offset> titleSlide;

  // ── Tagline ───────────────────────────────────────────────
  late final Animation<double> taglineFade;
  late final Animation<Offset> taglineSlide;

  // ── Bottom bar ────────────────────────────────────────────
  late final Animation<double> bottomFade;
  late final Animation<double> progress;

  // ── Glow ─────────────────────────────────────────────────
  late final Animation<double> glow;

  // ── Float animations ─────────────────────────────────────
  late final Animation<double> float1Anim;
  late final Animation<double> float2Anim;

  void _buildCurves() {
    const ease = Curves.easeOutCubic;

    // Logo: 0–35%
    logoFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.0, 0.35, curve: ease),
    );
    logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: master,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
      ),
    );

    // Title: 28–55%
    titleFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.28, 0.55, curve: ease),
    );
    titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: master,
      curve: const Interval(0.28, 0.55, curve: ease),
    ));

    // Tagline: 42–65%
    taglineFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.42, 0.65, curve: ease),
    );
    taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: master,
      curve: const Interval(0.42, 0.65, curve: ease),
    ));

    // Bottom bar: 58–80%
    bottomFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.58, 0.80, curve: ease),
    );
    progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: master,
        curve: const Interval(0.60, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Glow pulse (looping sine)
    glow = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: glowController, curve: Curves.easeInOut),
    );

    // Float blobs
    float1Anim = Tween<double>(begin: -12.0, end: 12.0).animate(
      CurvedAnimation(parent: float1, curve: Curves.easeInOut),
    );
    float2Anim = Tween<double>(begin: 10.0, end: -10.0).animate(
      CurvedAnimation(parent: float2, curve: Curves.easeInOut),
    );
  }

  Future<void> play() async {
    float1.repeat(reverse: true);
    float2.repeat(reverse: true);
    glowController.repeat(reverse: true);
    await Future.delayed(const Duration(milliseconds: 200));
    await master.forward();
  }

  void dispose() {
    master.dispose();
    float1.dispose();
    float2.dispose();
    glowController.dispose();
  }
}