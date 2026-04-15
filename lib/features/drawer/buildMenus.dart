
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:graduation_proj/features/homePage/presentation/home_page.dart';

import '../../core/utils/app_texts.dart';
import '../compatapilityModel/presentation/pages/request_to_recommend.dart';
import '../support/presentation/pages/support_screen.dart';
import '../teamMember/page/team_screen.dart';
import 'drawer_user_card.dart';
import 'logout_button.dart';

// ─────────────────────────────────────────────────────────────
//  DESIGN TOKENS  (consistent with full project)
// ─────────────────────────────────────────────────────────────
abstract final class C {
  static const Color bg = Color(0xFFF7F6F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF2F1EE);
  static const Color divider = Color(0xFFE8E6E1);
  static const Color dividerSoft = Color(0xFFF0EEE9);

  static const Color textHigh = Color(0xFF1A1917);
  static const Color textMid = Color(0xFF6B6861);
  static const Color textLow = Color(0xFFAEABA4);

  static const Color ink = Color(0xFF1A1917);
  static const Color inkSoft = Color(0x181A1917);

  // Drawer bg — very slightly warmer than page
  static const Color drawerBg = Color(0xFFF4F3F0);

  // Unread dot — dark, not colorful
  static const Color unreadDot = Color(0xFF1A1917);

  // Notification type tints (all very desaturated)
  static const Color typeScore = Color(0xFFEDECE9);
  static const Color typeTip = Color(0xFFEDECE9);
  static const Color typeSystem = Color(0xFFEDECE9);
}

abstract final class Sp {
  static const double xs = 8.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 40.0;
}

// ─────────────────────────────────────────────────────────────
//  CUSTOM ROUTE — FADE + SCALE
//  Incoming screen scales 0.92 → 1.0 while fading in.
//  Feels directional and modern without being flashy.
// ─────────────────────────────────────────────────────────────
class FadeScaleRoute extends PageRouteBuilder {
  FadeScaleRoute({required Widget page})
    : super(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        transitionsBuilder: (_, anim, __, child) {
          final curved = CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      );
}

// ─────────────────────────────────────────────────────────────
//  SHARED HELPERS
// ─────────────────────────────────────────────────────────────
class _FadeSlide extends StatelessWidget {
  const _FadeSlide({
    required this.fade,
    required this.slide,
    required this.child,
  });

  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget child;

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: fade,
    child: SlideTransition(position: slide, child: child),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Sp.xs),
    child: Text(text, style: T.caption),
  );
}

class _AmbientBg extends StatelessWidget {
  const _AmbientBg({required this.anim});

  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.sizeOf(context);
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: -s.width * 0.36 + anim.value * 0.6,
            right: -s.width * 0.18,
            child: _Blob(d: s.width * 0.86, o: 0.040),
          ),
          Positioned(
            bottom: -s.width * 0.28 - anim.value * 0.4,
            left: -s.width * 0.28,
            child: _Blob(d: s.width * 0.70, o: 0.032),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.d, required this.o});

  final double d, o;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: o,
    child: Container(
      width: d,
      height: d,
      decoration: const BoxDecoration(
        color: C.textHigh,
        shape: BoxShape.circle,
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
//  HOME PAGE SCREEN  (drop-in replacement — same structure)

// Placeholder — replace with your real HomePage
class PlaceholderMainScreen extends StatelessWidget {
  const PlaceholderMainScreen({required this.ctrl});

  final ZoomDrawerController ctrl;

  @override
  Widget build(BuildContext context) {
    return HomePage(zoomDrawerController: ctrl);
  }
}

// ═══════════════════════════════════════════════════════════════
//  BUILD MENU SCREEN  (upgraded drawer)
// ═══════════════════════════════════════════════════════════════
//
//  ANIMATION:
//  _drawerCtrl (1400ms) starts in initState.
//  User card: Interval(0.00, 0.35) — first to appear.
//  Menu items: each item gets Interval(0.25 + i*0.06, 0.55 + i*0.06)
//  producing a natural cascade. Bottom section fades last.
// ═══════════════════════════════════════════════════════════════
class BuildMenuScreen extends StatefulWidget {
  const BuildMenuScreen({
    super.key,
    required this.zoomCtrl,
    required this.isMobile,
    required this.onNavigate,
  });

  final ZoomDrawerController zoomCtrl;
  final bool isMobile;
  final Function(Widget screen) onNavigate;

  @override
  State<BuildMenuScreen> createState() => _BuildMenuScreenState();
}

class _BuildMenuScreenState extends State<BuildMenuScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drawerCtrl;

  // User card entrance
  late final Animation<double> _userFade;
  late final Animation<Offset> _userSlide;

  // Per-item staggered fades (max 8 items)
  late final List<Animation<double>> _itemFades;
  late final List<Animation<Offset>> _itemSlides;

  // Bottom section fade
  late final Animation<double> _bottomFade;

  int _selectedIndex = 0;
  static const int _notifBadge = 3;

  @override
  void initState() {
    super.initState();

    _drawerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    // ── User card
    _userFade = CurvedAnimation(
      parent: _drawerCtrl,
      curve: const Interval(0.00, 0.35, curve: Curves.easeOut),
    );
    _userSlide = Tween<Offset>(begin: const Offset(0, 0.20), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _drawerCtrl,
            curve: const Interval(0.00, 0.38, curve: Curves.easeOutCubic),
          ),
        );

    // ── Menu items (6 items)
    _itemFades = List.generate(
      6,
      (i) => CurvedAnimation(
        parent: _drawerCtrl,
        curve: Interval(
          0.22 + i * 0.055,
          (0.50 + i * 0.055).clamp(0, 1),
          curve: Curves.easeOut,
        ),
      ),
    );
    _itemSlides = List.generate(
      6,
      (i) => Tween<Offset>(begin: const Offset(-0.15, 0), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _drawerCtrl,
              curve: Interval(
                0.22 + i * 0.055,
                (0.50 + i * 0.055).clamp(0, 1),
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );

    // ── Bottom section
    _bottomFade = CurvedAnimation(
      parent: _drawerCtrl,
      curve: const Interval(0.70, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _drawerCtrl.dispose();
    super.dispose();
  }

  void _navigate(int idx, Widget screen) {
    setState(() => _selectedIndex = idx);
    widget.zoomCtrl.toggle?.call();
    Future.delayed(const Duration(milliseconds: 240), () {
      if (mounted) widget.onNavigate(screen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final h = mq.size.height;
    final w = mq.size.width;

    return Container(
      color: C.drawerBg,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.046,
          vertical: h * 0.012,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.1),

            // ── User card
            _FadeSlide(
              fade: _userFade,
              slide: _userSlide,
              child:    DrawerUserCard(),
            ),

            SizedBox(height: h * 0.038),

            // ── Section label
            FadeTransition(
              opacity: _itemFades[0],
              child: const _SectionLabel('MENU'),
            ),

            SizedBox(height: h * 0.008),

            // ── Menu items
            _buildItem(0, Icons.home_rounded, 'Home', null),
            _buildItem(1, Icons.auto_awesome_rounded, 'AI Analysis', UploadScreen()),

            _buildItem(
              4,
              Icons.help_outline_rounded,
              'Support',
              const SupportCenterScreen(),
            ),
            _buildItem(
              5,
              Icons.notifications_outlined,
              'Our Team',
              const OurTeamScreen(),
            ),

            SizedBox(height: h * 0.25),

            // ── Logout — minimal outlined style
            FadeTransition(
              opacity: _bottomFade,
              child: const DrawerLogoutBtn(),
            ),

            SizedBox(height: h * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    int idx,
    IconData icon,
    String title,
    Widget? screen, {
    int badge = 0,
  }) {
    return _FadeSlide(
      fade: _itemFades[idx],
      slide: _itemSlides[idx],
      child: _DrawerMenuItem(
        icon: icon,
        title: title,
        isSelected: _selectedIndex == idx,
        badge: badge,
        onTap: () {
          if (screen != null) {
            _navigate(idx, screen);
          } else {
            setState(() => _selectedIndex = idx);
            widget.zoomCtrl.toggle?.call();
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  DRAWER USER CARD
// ─────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────
//  DRAWER MENU ITEM
//  Selected state: soft ink-tinted background + left indicator.
// ─────────────────────────────────────────────────────────────
class _DrawerMenuItem extends StatefulWidget {
  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final int badge;

  @override
  State<_DrawerMenuItem> createState() => _DrawerMenuItemState();
}

class _DrawerMenuItemState extends State<_DrawerMenuItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? C.ink.withOpacity(0.07)
              : _pressed
              ? C.ink.withOpacity(0.04)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Left active indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 3,
              height: widget.isSelected ? 18 : 0,
              decoration: BoxDecoration(
                color: C.ink,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(width: widget.isSelected ? 10 : 13),

            // Icon
            Icon(
              widget.icon,
              size: 19,
              color: widget.isSelected ? C.ink : C.textMid,
            ),

            const SizedBox(width: 12),

            // Title
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: T.drawerItem.copyWith(
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: widget.isSelected ? C.ink : C.textMid,
                ),
                child: Text(widget.title),
              ),
            ),

            // Badge
            if (widget.badge > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: C.ink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.badge}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  DRAWER LOGOUT BUTTON — minimal outlined



// ═══════════════════════════════════════════════════════════════
//  SUPPORT CENTER SCREEN
// ═══════════════════════════════════════════════════════════════
//
//  ANIMATION:
//  _supportCtrl (2200ms) — large timeline, 4 major sections:
//    Nav    → 0.00–0.22
//    Video  → 0.10–0.36
//    Guide  → 0.28–0.55, steps stagger 0.04 each
//    Report → 0.52–0.76
//    Idea   → 0.70–0.92
