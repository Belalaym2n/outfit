import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/sharedWidgets/text_styles.dart';

/// Production-grade CustomTextField
///
/// Performance contract:
/// - Zero [setState] calls — all reactive state lives in [ValueNotifier]s
/// - [_FocusedBorder]   → rebuilds ONLY when focus changes
/// - [_ObscureToggle]   → rebuilds ONLY when obscure flag flips
/// - [_ErrorMessage]    → rebuilds ONLY when error string changes
/// - The outer [Column] (label + container) is effectively static after first
///   build; no rebuild cascades from focus, obscure, or validation changes.
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.validator,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // ── Reactive state ──────────────────────────────────────────────────────────
  final FocusNode _focus = FocusNode();
  final ValueNotifier<bool> _focused = ValueNotifier(false);
  final ValueNotifier<bool> _obscure = ValueNotifier(true);
  final ValueNotifier<String?> _error = ValueNotifier(null);

  // Internal controller only when caller didn't supply one.
  late final TextEditingController _internalCtrl;
  late final TextEditingController _effectiveCtrl;

  @override
  void initState() {
    super.initState();

    // Avoid creating a controller inside build().
    if (widget.controller == null) {
      _internalCtrl = TextEditingController();
      _effectiveCtrl = _internalCtrl;
    } else {
      _effectiveCtrl = widget.controller!;
    }

    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    _focused.value = _focus.hasFocus;
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    _focused.dispose();
    _obscure.dispose();
    _error.dispose();
    // Only dispose the controller we own.
    if (widget.controller == null) {
      _internalCtrl.dispose();
    }
    super.dispose();
  }

  // Called by TextFormField — updates only the error notifier.
  String? _validate(String? value) {
    final result = widget.validator?.call(value);
    // Defer to avoid calling setState-like ops during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _error.value = result;
    });
    // Return null so TextFormField doesn't draw its own error widget.
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // This Column rebuilds at most once on initial mount.
    // None of the ValueNotifier changes cascade here.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label: only color/weight animate; no rebuild ──────────────────────
        _AnimatedLabel(focused: _focused, label: widget.label),

        const SizedBox(height: 8),

        // ── Animated container + field ─────────────────────────────────────────
        _FocusedBorder(
          focused: _focused,
          error: _error,
          child:ValueListenableBuilder<bool>(
    valueListenable: _obscure,
    builder: (_, isObscured, __) { return TextFormField(
            controller: _effectiveCtrl,
            validator: _validate,
            focusNode: _focus,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            style: T.fieldText,
            cursorColor: AppColors.ink,
            cursorWidth: 1.5,
            // obscureText is driven by ValueListenableBuilder inside
            // _ObscureAwareFormField — see below for why we use a builder here.
            obscureText: widget.isPassword && _obscure.value,
            // We rebuild only the suffix icon subtree via _ObscureToggle.
            decoration: InputDecoration(
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              hintText: widget.hint,
              hintStyle: T.fieldText.copyWith(color: AppColors.textLow),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              suffixIcon: widget.isPassword
                  ? _ObscureToggle(
                obscure: _obscure,
                onToggle: () =>
                _obscure.value = !_obscure.value,
              )
                  : null,

              error: null
            ),
          );})),

        // ── Error message: animated, zero-cost when hidden ────────────────────
        _ErrorMessage(error: _error),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets — each subscribes only to the notifier it needs.
// ─────────────────────────────────────────────────────────────────────────────

/// Rebuilds ONLY when [focused] changes (2 states).
class _AnimatedLabel extends StatelessWidget {
  const _AnimatedLabel({
    required this.focused,
    required this.label,
  });

  final ValueNotifier<bool> focused;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: focused,
      builder: (_, isFocused, __) {
        return AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: T.fieldLabel.copyWith(
            color: isFocused ? AppColors.textHigh : AppColors.textMid,
            fontWeight: isFocused ? FontWeight.w600 : FontWeight.w500,
          ),
          child: Text(label),
        );
      },
    );
  }
}

/// Rebuilds ONLY when [focused] or [error] changes — animates the
/// border + shadow of the container that wraps the raw [TextFormField].
class _FocusedBorder extends StatelessWidget {
  const _FocusedBorder({
    required this.focused,
    required this.error,
    required this.child,
  });

  final ValueNotifier<bool> focused;
  final ValueNotifier<String?> error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: focused,
      builder: (_, isFocused, __) {
        return ValueListenableBuilder<String?>(
          valueListenable: error,
          builder: (_, errorText, __) {
            final hasError = errorText != null && errorText.isNotEmpty;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: hasError
                      ? AppColors.error          // red border on error
                      : isFocused
                      ? AppColors.dividerFoc
                      : AppColors.divider,
                  width: isFocused || hasError ? 1.5 : 1.0,
                ),
                boxShadow: isFocused
                    ? [
                  BoxShadow(
                    color: AppColors.ink.withOpacity(0.08),
                    blurRadius: 18,
                    spreadRadius: -3,
                    offset: const Offset(0, 5),
                  ),
                ]
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    spreadRadius: -2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: child,
            );
          },
        );
      },
    );
  }
}

/// Rebuilds ONLY when [obscure] changes. Sits inside the suffix slot.
class _ObscureToggle extends StatelessWidget {
  const _ObscureToggle({
    required this.obscure,
    required this.onToggle,
  });

  final ValueNotifier<bool> obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscure,
      builder: (_, isObscured, __) {
        return GestureDetector(
          onTap: onToggle,
          child: Icon(
            isObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textLow,
            size: 18,
          ),
        );
      },
    );
  }
}

/// Animated error message.
///
/// Uses [SizeTransition] + [FadeTransition] for an elegant fintech-style
/// reveal. Rebuilds only when [error] changes.
class _ErrorMessage extends StatefulWidget {
  const _ErrorMessage({required this.error});

  final ValueNotifier<String?> error;

  @override
  State<_ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<_ErrorMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _size;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _size = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);

    widget.error.addListener(_onErrorChanged);
  }

  void _onErrorChanged() {
    final hasError =
        widget.error.value != null && widget.error.value!.isNotEmpty;
    if (hasError) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    widget.error.removeListener(_onErrorChanged);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.error,
      builder: (_, errorText, __) {
        return SizeTransition(
          sizeFactor: _size,
          axisAlignment: -1,
          child: FadeTransition(
            opacity: _fade,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 13,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      errorText ?? '',
                      style: T.fieldLabel.copyWith(
                        color: AppColors.error,
                         fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}