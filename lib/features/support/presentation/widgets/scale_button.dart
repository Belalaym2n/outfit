
import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────
//  ENTRY POINT

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/sharedWidgets/Buttons/primary_buttons.dart';

 class ScaleButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  const ScaleButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryBtn(label: widget.label, scale: _scale, onTap: widget.onTap);
  }
}
