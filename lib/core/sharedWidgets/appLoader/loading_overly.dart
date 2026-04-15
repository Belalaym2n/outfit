// core/sharedWidgets/loading/loading_overlay.dart
//
// AppLoadingOverlay — Full-screen ambient loading overlay.
// Blurs and dims the current screen while showing the AppLoader.
// Fades in/out gracefully so transitions feel considered.
//
// Usage:
//   AppLoadingOverlay.show(context);
//   AppLoadingOverlay.hide(context);
//
// Or wrap a Future:
//   await AppLoadingOverlay.runWhile(context, () => myAsyncCall());

import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_loader.dart';

/// A singleton-style full-screen overlay that communicates
/// loading state with blur, dim, and the ambient orb animation.
class AppLoadingOverlay {
  AppLoadingOverlay._();

  static OverlayEntry? _entry;
  static bool _visible = false;

  // ─── Public API ────────────────────────────────────────────

  /// Show the overlay above everything in the current [context].
  /// Safe to call multiple times — subsequent calls are no-ops.
  static void show(BuildContext context) {
    if (_visible) return;
    _visible = true;

    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (_) => const _LoadingOverlayView(),
    );
    overlay.insert(_entry!);
  }

  /// Hide and remove the overlay.
  /// Safe to call when not showing — will be a no-op.
  static void hide(BuildContext context) {
    if (!_visible) return;
    _visible = false;
    _entry?.remove();
    _entry = null;
  }

  /// Convenience: show overlay, await [work], then hide.
  ///
  /// ```dart
  /// final result = await AppLoadingOverlay.runWhile(
  ///   context,
  ///   () => apiService.fetchOutfits(),
  /// );
  /// ```
  static Future<T> runWhile<T>(
      BuildContext context,
      Future<T> Function() work,
      ) async {
    show(context);
    try {
      return await work();
    } finally {
      hide(context);
    }
  }
}

// ─── Internal overlay view ─────────────────────────────────

class _LoadingOverlayView extends StatefulWidget {
  const _LoadingOverlayView();

  @override
  State<_LoadingOverlayView> createState() => _LoadingOverlayViewState();
}

class _LoadingOverlayViewState extends State<_LoadingOverlayView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeCtrl,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _fadeCtrl.forward();
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
      child: Stack(
        children: [
          // ── Blur layer ─────────────────────────────────────
          // BackdropFilter blurs whatever is behind the overlay.
          // sigma 12 is soft enough to feel intentional, not broken.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: const SizedBox.expand(),
          ),

          // ── Dim layer ──────────────────────────────────────
          // Warm off-white dim (not harsh black) keeps the luxury feel.
          Container(
            color: const Color(0xFFF7F6F3).withOpacity(0.72),
          ),

          // ── Loader card ────────────────────────────────────
          Center(
            child: _LoaderCard(),
          ),
        ],
      ),
    );
  }
}

// ─── Loader card (centered content) ───────────────────────

class _LoaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The ambient orb animation
        const AppLoader(size: 72),

        const SizedBox(height: 20),

        // Optional subtle label
        Text(
          'Analyzing',
          style: TextStyle(
            fontFamily: 'SF Pro Display', // Falls back gracefully
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.8,
            color: const Color(0xFF6B6861),
          ),
        ),
      ],
    );
  }
}