
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_texts.dart';

class  StatCard extends StatefulWidget {
  const StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });
  final String   value;
  final String   label;
  final IconData icon;

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(0.0, _hovered ? -3.0 : 0.0),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color:AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ?AppColors.textHigh.withOpacity(0.18) :AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.08 : 0.04),
              blurRadius: _hovered ? 20 : 12,
              spreadRadius: -3,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color:AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(widget.icon, color:AppColors.textMid, size: 16),
            ),
            const SizedBox(height: 10),
            // Value
            Text(widget.value, style: T.label),
            const SizedBox(height: 3),
            // Label
            Text(widget.label, style: T.label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
