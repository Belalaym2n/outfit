import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Colors;
import '../../../../core/utils/app_colors.dart';
class PremiumCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const PremiumCard({super.key, required this.child, this.padding});

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _elevation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _elevation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _elevation,
        builder: (_, child) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
             boxShadow: [
              BoxShadow(
                color: AppColors.ink.withOpacity(0.04 + _elevation.value * 0.04),
                blurRadius: 16 + _elevation.value * 12,
                offset: Offset(0, 4 + _elevation.value * 4),
              ),
            ],
          ),
          padding: widget.padding ?? const EdgeInsets.all(24),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
