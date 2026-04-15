// ═══════════════════════════════════════════════════════════════
//  AI OUTFIT RECOMMENDATION — SAVED OUTFITS SCREEN
//  Cinematic · Glassmorphism · 3D Tilt · Hero Transitions
// ═══════════════════════════════════════════════════════════════
//
//  ANIMATION ARCHITECTURE
//  ──────────────────────────────────────────────────────────────
//  _bgCtrl     (12s, ∞)  — ambient blob float + grain shift
//  _entranceCtrl (1800ms) — header slide + card stagger via Interval
//  _badgeCtrl  (600ms)   — counter badge scale pop
//  Per-card _SaveBtn      — heart burst with particle emitter
//  Per-card _TiltCard     — GestureDetector → Matrix4 3D tilt
//  Details _detailCtrl   (1400ms) — catalog entrance cascade
//  Details _rotateCtrl   — drag-driven 3D outfit rotation
// ═══════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/sharedWidgets/animations/bg_animation.dart';
import 'package:graduation_proj/features/savedItems/presentation/pages/saved_item_details_screen.dart';

import '../../../../core/utils/app_colors.dart';
import '../widgets/emptyPage/empty_screen.dart';
import '../widgets/saveitemScreenWidgets/hero_scale_route.dart';
import '../widgets/saveitemScreenWidgets/outfit_card.dart';

// ─────────────────────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────────────────────


// ─────────────────────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────────────────────
abstract final class DK { // Dark palette

}

abstract final class LT { // Light palette
  static const bg1        = Color(0xFFF5F2ED);
  static const bg2        = Color(0xFFEFEBE4);
  static const bg3        = Color(0xFFE8E4DC);
  static const glassWhite = Color(0x18FFFFFF);
  static const glassBorder = Color(0x22000000);
  static const textHigh   = Color(0xFF1A1814);
  static const textMid    = Color(0xFF6B6560);
  static const textLow    = Color(0xFFAEAA9A);
  static const accent     = Color(0xFF8B6F4E);
  static const savedRed   = Color(0xFFD94F45);
  static const cardBg     = Color(0xFFFFFFFF);
  static const cardBorder = Color(0xFFE4E0D8);
}

// ─────────────────────────────────────────────────────────────
//  OUTFIT DATA MODEL
// ─────────────────────────────────────────────────────────────
class OutfitModel {
  const OutfitModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.score,
    required this.tags,
    required this.colorHex,
    required this.pieces,
    required this.fabric,
    this.isSaved = true,
  });

  final String       id;
  final String       name;
  final String       brand;
  final int          score;
  final List<String> tags;
  final List<Color>  colorHex;
  final List<PieceModel> pieces;
  final String       fabric;
  final bool         isSaved;

  static final List<OutfitModel> samples = [
    OutfitModel(
      id: '1', name: 'Urban Minimal', brand: 'Acne Studios',
      score: 92, tags: ['Street', 'Minimal', 'Mono'],
      colorHex: [const Color(0xFF2C2C2C), const Color(0xFF8C7B6E),
        const Color(0xFFD4C4B0)],
      fabric: 'Merino Wool · Cotton',
      pieces: [
        PieceModel('Jacket',  Icons.checkroom_rounded,     'Oversized Wool Coat'),
        PieceModel('Shirt',   Icons.dry_cleaning_rounded,  'Cotton Mock-neck'),
        PieceModel('Trousers',Icons.content_cut_rounded,   'Wide-leg Trousers'),
        PieceModel('Shoes',   Icons.directions_walk_rounded,'Chunky Derby Boots'),
      ],
    ),
    OutfitModel(
      id: '2', name: 'Evening Edit', brand: 'A.P.C.',
      score: 88, tags: ['Smart', 'Evening', 'Tonal'],
      colorHex: [const Color(0xFF1A1A2E), const Color(0xFF4A4060),
        const Color(0xFFB8A8C8)],
      fabric: 'Silk Blend · Cashmere',
      pieces: [
        PieceModel('Blazer',  Icons.checkroom_rounded,     'Structured Blazer'),
        PieceModel('Shirt',   Icons.dry_cleaning_rounded,  'Silk Dress Shirt'),
        PieceModel('Trousers',Icons.content_cut_rounded,   'Tailored Trousers'),
        PieceModel('Shoes',   Icons.directions_walk_rounded,'Oxford Brogue'),
      ],
    ),
    OutfitModel(
      id: '3', name: 'Weekend Drift', brand: 'Our Legacy',
      score: 79, tags: ['Casual', 'Relaxed', 'Earth'],
      colorHex: [const Color(0xFF8B7355), const Color(0xFFC4A882),
        const Color(0xFFF0E8D8)],
      fabric: 'Linen · Organic Cotton',
      pieces: [
        PieceModel('Jacket',  Icons.checkroom_rounded,     'Linen Overshirt'),
        PieceModel('Shirt',   Icons.dry_cleaning_rounded,  'Washed Tee'),
        PieceModel('Trousers',Icons.content_cut_rounded,   'Cargo Trousers'),
        PieceModel('Shoes',   Icons.directions_walk_rounded,'Suede Loafers'),
      ],
    ),
    OutfitModel(
      id: '4', name: 'Cold Archive', brand: 'Rick Owens',
      score: 95, tags: ['Avant-garde', 'Dark', 'Structured'],
      colorHex: [const Color(0xFF0F0F0F), const Color(0xFF2D2D2D),
        const Color(0xFF4A4440)],
      fabric: 'Heavyweight Cotton · Leather',
      pieces: [
        PieceModel('Jacket',  Icons.checkroom_rounded,     'Draped Leather Coat'),
        PieceModel('Shirt',   Icons.dry_cleaning_rounded,  'Elongated Tank'),
        PieceModel('Trousers',Icons.content_cut_rounded,   'Podment Trousers'),
        PieceModel('Shoes',   Icons.directions_walk_rounded,'Platform Boots'),
      ],
    ),
    OutfitModel(
      id: '5', name: 'Studio Soft', brand: 'Lemaire',
      score: 84, tags: ['Soft', 'Intellectual', 'Muted'],
      colorHex: [const Color(0xFFD4C4A8), const Color(0xFFB8A888),
        const Color(0xFF8C7A60)],
      fabric: 'Wool Flannel · Silk',
      pieces: [
        PieceModel('Jacket',  Icons.checkroom_rounded,     'Cocoon Jacket'),
        PieceModel('Shirt',   Icons.dry_cleaning_rounded,  'Twisted Knit'),
        PieceModel('Trousers',Icons.content_cut_rounded,   'Relaxed Chinos'),
        PieceModel('Shoes',   Icons.directions_walk_rounded,'Piped Derby'),
      ],
    ),
    OutfitModel(
      id: '6', name: 'Monochrome II', brand: 'Toteme',
      score: 90, tags: ['Minimal', 'Clean', 'Formal'],
      colorHex: [const Color(0xFFE8E0D4), const Color(0xFFCFC4B0),
        const Color(0xFF9A8E7A)],
      fabric: 'Lyocell · Wool Blend',
      pieces: [
        PieceModel('Jacket',  Icons.checkroom_rounded,     'Column Coat'),
        PieceModel('Shirt',   Icons.dry_cleaning_rounded,  'Band Collar Shirt'),
        PieceModel('Trousers',Icons.content_cut_rounded,   'Straight Trousers'),
        PieceModel('Shoes',   Icons.directions_walk_rounded,'Pointed Flats'),
      ],
    ),
  ];
}

class PieceModel {
  const PieceModel(this.type, this.icon, this.name);
  final String   type;
  final IconData icon;
  final String   name;
}

// ─────────────────────────────────────────────────────────────
//  SAVED OUTFITS SCREEN
// ─────────────────────────────────────────────────────────────
class SavedOutfitsScreen extends StatefulWidget {
  const SavedOutfitsScreen({super.key});

  @override
  State<SavedOutfitsScreen> createState() => _SavedOutfitsScreenState();
}

class _SavedOutfitsScreenState extends State<SavedOutfitsScreen>
    with TickerProviderStateMixin {

  late final AnimationController _bgCtrl;
  late final AnimationController _entranceCtrl;
  late final AnimationController _badgeCtrl;

  // Bg float
  late final Animation<double> _blob1X, _blob1Y, _blob2X, _blob2Y;

  // Entrance
  late final Animation<double> _bgFade;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final List<Animation<double>> _cardScales;
  late final List<Animation<double>> _cardFades;
  late final List<Animation<Offset>> _cardSlides;

  // Badge
  late final Animation<double> _badgeScale;

  // Mutable saved state
  late final List<bool> _savedStates;
  final List<OutfitModel> _outfits = OutfitModel.samples;

  // ── Background float ─────────────────────────────────────────
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  @override
  void initState() {
    super.initState();
    _savedStates = List.filled(_outfits.length, true);
    _setupControllers();
    _setupAnimations();

    _bgCtrl.repeat(reverse: true);

    // Staggered start
    _entranceCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _badgeCtrl.forward();
    });
  }

  void _setupControllers() {
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _badgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  void _setupAnimations() {
    // ── Background blob drift (independent slow loop)
    _blob1X = Tween<double>(begin: -30, end: 30).animate(
        CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
    _blob1Y = Tween<double>(begin: -20, end: 20).animate(
        CurvedAnimation(parent: _bgCtrl, curve: const _OffsetCurve(0.3)));
    _blob2X = Tween<double>(begin: 25, end: -25).animate(
        CurvedAnimation(parent: _bgCtrl, curve: const _OffsetCurve(0.6)));
    _blob2Y = Tween<double>(begin: 15, end: -15).animate(
        CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    // ── Entrance
    _bgFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _headerFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.05, 0.40, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.15), end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.05, 0.40, curve: Curves.easeOutCubic),
    ));

    // ── Cards: stagger 80ms = ~0.044 per card in 1800ms
    final n = _outfits.length;
    _cardScales = List.generate(n, (i) {
      final s = 0.20 + i * 0.055;
      final e = (s + 0.30).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.88, end: 1.0).animate(
          CurvedAnimation(parent: _entranceCtrl,
              curve: Interval(s, e, curve: Curves.easeOutCubic)));
    });
    _cardFades = List.generate(n, (i) {
      final s = 0.20 + i * 0.055;
      final e = (s + 0.30).clamp(0.0, 1.0);
      return CurvedAnimation(parent: _entranceCtrl,
          curve: Interval(s, e, curve: Curves.easeOut));
    });
    _cardSlides = List.generate(n, (i) {
      final s = 0.20 + i * 0.055;
      final e = (s + 0.30).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
          .animate(CurvedAnimation(parent: _entranceCtrl,
          curve: Interval(s, e, curve: Curves.easeOutCubic)));
    });

    // ── Badge: easeOutBack pop
    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOutBack),
    );

    // Ambient background
    _bg1 = Tween<double>(begin: -14, end: 14).animate(
      CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut),
    );
    _bg2 = Tween<double>(begin: 10, end: -10).animate(
      CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entranceCtrl.dispose();
    _badgeCtrl.dispose();
    super.dispose();
  }

  void _toggleSave(int idx) {
    HapticFeedback.lightImpact();
    setState(() => _savedStates[idx] = !_savedStates[idx]);
  }

  @override
  Widget build(BuildContext context) {
    final dark = false;
    final mq = MediaQuery.of(context);
    final hPad = mq.size.width >= 600 ? 32.0 : 18.0;

    return Scaffold(
      backgroundColor: LT.bg1,
      body: Stack(children: [
        AmbientBg(float1: _bg1, float2: _bg2),


        SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [

               SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: _GlassHeader(
                      dark: dark,
                      count: _savedStates
                          .where((s) => s)
                          .length,
                      badgeScale: _badgeScale,
                      hPad: hPad,
                    ),
                  ),
                ),
              ),

              // ── Grid or empty state
              _savedStates
                  .where((s) => s)
                  .isEmpty
                  ? SliverFillRemaining(
                child:  EmptyState(dark: dark),
              )
                  : SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    hPad, 0, hPad, mq.padding.bottom + 32),
                sliver:  OutfitGrid(
                  outfits: _outfits,
                  savedStates: _savedStates,
                  cardScales: _cardScales,
                  cardFades: _cardFades,
                  cardSlides: _cardSlides,
                  dark: dark,
                  onToggleSave: _toggleSave,
                  onTap: (i) =>
                      Navigator.push(
                        context,
                       HeroScaleRoute(
                          page: OutfitDetailsScreen(
                            outfit: _outfits[i],
                            dark: dark,
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _GlassHeader extends StatelessWidget {
  const _GlassHeader({
    required this.dark,
    required this.count,
    required this.badgeScale,
    required this.hPad,
  });

  final bool            dark;
  final int             count;
  final Animation<double> badgeScale;
  final double          hPad;

  @override
  Widget build(BuildContext context) {
    final textHigh = dark ? AppColors.textHigh : LT.textHigh;
    final textMid  = dark ? AppColors.textMid  : LT.textMid;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: dark ? AppColors.glassWhite : LT.glassWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: dark ? AppColors.glassBorder : LT.glassBorder,
                width: 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved Outfits',
                        style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w700,
                          color: textHigh, letterSpacing: -1.0, height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Your curated fashion collection',
                        style: TextStyle(
                          fontSize: 14, color: textMid, letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated counter badge
                ScaleTransition(
                  scale: badgeScale,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: dark
                          ? AppColors.accent.withOpacity(0.15)
                          : LT.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: dark
                            ? AppColors.accent.withOpacity(0.30)
                            : LT.accent.withOpacity(0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800,
                            color: dark ? AppColors.accent : LT.accent,
                            letterSpacing: -0.5, height: 1.0,
                          ),
                        ),
                        Text(
                          'Items',
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500,
                            color: dark
                                ? AppColors.accent.withOpacity(0.7)
                                : LT.accent.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _OffsetCurve extends Curve {
  const _OffsetCurve(this.offset);
  final double offset;

  @override
  double transformInternal(double t) {
    final shifted = (t + offset) % 1.0;
    return Curves.easeInOut.transform(shifted);
  }
}