// core/sharedWidgets/loading/button_loader.dart
//
// PrimaryBtn — A luxury primary button with a built-in loading state.
// When [loading] is true, the label fades out and a minimal
// inline loader appears. The button keeps its exact size throughout
// so the layout never shifts.
//
// Usage:
//   PrimaryBtn(
//     label: 'Generate Outfit',
//     onTap: _handleTap,
//     loading: _isLoading,
//   )

import 'package:flutter/material.dart';
import 'app_loader.dart';

/// A full-width primary action button designed for the luxury
/// minimal AI fashion app aesthetic.
///
/// Seamlessly transitions between idle and loading states.
class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.disabled = false,
    this.height = 52.0,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Button label text.
  final String label;

  /// Callback for tap. Set [loading] or [disabled] to prevent taps.
  final VoidCallback? onTap;

  /// When true, replaces label with the inline ambient loader.
  final bool loading;

  /// When true, dims the button and blocks interaction.
  final bool disabled;

  /// Fixed height — layout never shifts regardless of state.
  final double height;

  /// Defaults to [Color(0xFF1A1917)] — warm near-black ink.
  final Color? backgroundColor;

  /// Defaults to [Color(0xFFF7F6F3)] — warm off-white surface.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? const Color(0xFF1A1917);
    final fg = foregroundColor ?? const Color(0xFFF7F6F3);
    final isInteractive = !loading && !disabled && onTap != null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? 0.38 : 1.0,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: isInteractive ? onTap : null,
            borderRadius: BorderRadius.circular(12),
            splashColor: fg.withOpacity(0.06),
            highlightColor: fg.withOpacity(0.04),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: child,
                ),
                child: loading
                    ? _InlineLoader(color: fg, key: const ValueKey('loader'))
                    : _LabelContent(
                  label: label,
                  color: fg,
                  key: const ValueKey('label'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Label content ─────────────────────────────────────────

class _LabelContent extends StatelessWidget {
  const _LabelContent({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: color,
      ),
    );
  }
}

// ─── Inline loader ─────────────────────────────────────────
// Smaller version of AppLoader tuned for button scale (28px).
// Uses a lighter orb opacity so it reads on the dark surface.

class _InlineLoader extends StatelessWidget {
  const _InlineLoader({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      size: 28,
      color: color,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SECONDARY BUTTON VARIANT
// ─────────────────────────────────────────────────────────────

/// A secondary / ghost button variant with the same loading support.
///
/// Uses a hairline border and transparent background.
class SecondaryBtn extends StatelessWidget {
  const SecondaryBtn({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.disabled = false,
    this.height = 52.0,
  });

  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final bool disabled;
  final double height;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1A1917);
    const border = Color(0xFFE8E6E1);
    final isInteractive = !loading && !disabled && onTap != null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? 0.38 : 1.0,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 1.0),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: isInteractive ? onTap : null,
              borderRadius: BorderRadius.circular(12),
              splashColor: ink.withOpacity(0.04),
              highlightColor: ink.withOpacity(0.02),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: child,
                  ),
                  child: loading
                      ? AppLoader(
                    size: 28,
                    color: ink,
                    key: const ValueKey('loader'),
                  )
                      : Text(
                    label,
                    key: const ValueKey('label'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                      color: ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}