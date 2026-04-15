import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

import 'bottom_nav.dart';
import 'nav_model.dart';

class CustomFloatingBottomNav extends StatelessWidget {
  final List<FloatingNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double? horizontalPadding;
  final double? bottomPadding;

  const CustomFloatingBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.horizontalPadding,
    this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double maxNavWidth = screenWidth > 600 ?
    480.0 : double.infinity;

    final double hPad =
        horizontalPadding ??
        (screenWidth > 900
            ? 48.0
            : screenWidth > 600
            ? 32.0
            : 20.0);

    // Bottom padding above safe area
    final double bPad = (bottomPadding ?? 16.0) + safeBottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 0, hPad, bPad),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxNavWidth),
          child: _NavBarContainer(
            isDark: isDark,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (index) {
                return BottomNavItem(
                  item: items[index],
                  isSelected: index == currentIndex,
                  isDark: isDark,
                  onTap: () => onTap(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarContainer extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _NavBarContainer({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.w*0.9,
      // High border-radius for the pill / capsule shape
      decoration: BoxDecoration(

        color: isDark ? const Color(0xFF0F0F0F) : const Color(0xFF111111),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          // Primary deep shadow for the floating effect
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.6 : 0.35),
            blurRadius: 24,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
          // Subtle ambient shadow
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.15),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: child,
    );
  }
}
