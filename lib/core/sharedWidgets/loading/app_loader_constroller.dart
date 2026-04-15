import 'dart:ui';
import 'package:flutter/material.dart';

import 'ai_analysis_loader.dart';

/// Single entry point for showing/hiding the AI loading overlay.
/// Setup: pass [navigatorKey] to MaterialApp.
class AppLoadingController {
  AppLoadingController._();

  /// Add to MaterialApp: navigatorKey: AppLoadingController.navigatorKey
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static OverlayEntry? _entry;
  static bool _isVisible = false;

  static OverlayState? get _overlay =>
      navigatorKey.currentState?.overlay;

  /// Call from BlocConsumer listener when status == loading
  static void show() {
    if (_isVisible || _overlay == null) return;
    _isVisible = true;

    // Dismiss keyboard first
    final context = navigatorKey.currentContext;
    if (context != null) FocusScope.of(context).unfocus();

    _entry = OverlayEntry(builder: (_) => const _AILoadingOverlay());
    _overlay!.insert(_entry!);
  }

  /// Call from BlocConsumer listener when status == success / failure
  static void hide() {
    if (!_isVisible) return;
    _isVisible = false;
    _entry?.remove();
    _entry = null;
  }

  /// Safety net: force-hide (e.g. on route change)
  static void forceHide() {
    _isVisible = false;
    _entry?.remove();
    _entry = null;
  }
}

// ── Internal overlay widget ──────────────────────────────────────────────────
class _AILoadingOverlay extends StatefulWidget {
  const _AILoadingOverlay();

  @override
  State<_AILoadingOverlay> createState() => _AILoadingOverlayState();
}

class _AILoadingOverlayState extends State<_AILoadingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<double>   _scaleAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    )..forward();

    _fadeAnim = CurvedAnimation(
      parent: _fadeCtrl,
      curve: Curves.easeOut,
    );
    _scaleAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Blurred dark scrim ────────────────────────────────────────
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(color: const Color(0xC50D0D0D)),
            ),

            // ── Centered card with spring-in scale ────────────────────────
            Center(
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 216,
                  padding: const EdgeInsets.fromLTRB(40, 36, 40, 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0x1AFFFFFF),
                      width: 0.5,
                    ),
                  ),
                  child: const AIAnalysisLoader(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}