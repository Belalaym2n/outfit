
import 'package:flutter/material.dart';
import 'package:graduation_proj/features/homePage/presentation/home_page_screen.dart';
import 'package:graduation_proj/features/savedItems/presentation/pages/saved_items_presentation.dart';
import 'package:graduation_proj/features/support/presentation/pages/support_screen.dart';

import '../homePage/presentation/home_page.dart';
import '../profile/presentation/pages/profile_screen.dart';
import '../profile/presentation/pages/profile_screen_page.dart';
import 'custom_floatin_bottom_nav.dart';
import 'nav_model.dart' show FloatingNavItem;


class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _DemoPageState();
}

class _DemoPageState extends State<BottomNav> {
  // Current selected tab index
  int _currentIndex = 0;
   static const List<FloatingNavItem> _navItems = [
    FloatingNavItem(icon: Icons.home_rounded, label: 'Home'),
     FloatingNavItem(icon: Icons.bookmark_rounded, label: 'Saved'),
     FloatingNavItem(icon: Icons.person, label: 'Profile'),

   ];

  // Each tab has its own body widget
  static const List<Widget> _pages = [
    HomePageScreen(),

    SavedOutfitsScreen( ),
    ProfileScreenPage(),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody lets the body render behind the floating nav
      extendBody: true,
      body: _pages[_currentIndex],
      // ---------------------------------------------------------------------------
      // INTEGRATION – drop CustomFloatingBottomNav into bottomNavigationBar slot
      // (or position it yourself in a Stack if you prefer more layout control)
      // ---------------------------------------------------------------------------
      bottomNavigationBar: CustomFloatingBottomNav(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// Simple placeholder page body
class _PageBody extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PageBody({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
              : [const Color(0xFFF0F4FF), const Color(0xFFE8EEFF)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64,
              color: isDark ? Colors.white38 : Colors.black26),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}




class  BottomNavItem extends StatelessWidget {
  final FloatingNavItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const BottomNavItem({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Duration shared across all animations in this item
    const duration = Duration(milliseconds: 300);
    const curve = Curves.easeInOut;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: TweenAnimationBuilder<double>(
        // Micro scale-pop when item becomes selected
        tween: Tween(begin: 1.0, end: isSelected ? 1.05 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          child: child,
        ),
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          // Horizontal padding expands when selected to make room for label
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16.0 : 12.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            // White pill appears behind selected item
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------------------------------------------------------------
              // ICON – color animates between white (unselected) and black (selected)
              // ---------------------------------------------------------------
              AnimatedSwitcher(
                duration: duration,
                switchInCurve: curve,
                switchOutCurve: curve,
                child: Icon(
                  item.icon,
                  key: ValueKey(isSelected), // triggers rebuild on change
                  size: 22,
                  color: isSelected ? Colors.black : Colors.white,
                ),
              ),

              // ---------------------------------------------------------------
              // LABEL – only rendered when selected; AnimatedSize provides
              // smooth width expansion so the row grows without jumping.
              // ---------------------------------------------------------------
              AnimatedSize(
                duration: duration,
                curve: curve,
                child: isSelected
                    ? Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: AnimatedSwitcher(
                    duration: duration,
                    switchInCurve: curve,
                    switchOutCurve: curve,
                    transitionBuilder: (child, animation) =>
                        FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.2, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                    child: Text(
                      item.label,
                      key: ValueKey(item.label),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        height: 1,
                      ),
                    ),
                  ),
                )
                // When not selected, render a zero-size widget so
                // AnimatedSize can smoothly shrink to nothing.
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
