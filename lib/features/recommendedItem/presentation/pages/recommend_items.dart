// ═══════════════════════════════════════════════════════════════
//  recommended_section.dart
//  AI Outfit Recommendation System — "Recommended" Section
//
//  Contains:
//    • RecommendedSection          (root widget, drop into any screen)
//    • _RecommendedItemsRow        (horizontal carousel — Part 1)
//    • _FullOutfitShowcase         (large swipeable cards — Part 2)
//    • RecommendedItemCard         (single-piece card)
//    • FullOutfitCard              (full-look card)
//    • SaveButtonWidget            (animated bookmark)
//    • _FloatingBackground         (decorative blobs)
//
//  No external packages required.
//  All sizes via AppConstants (w / h). Swap in your real asset paths.
// ═══════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/pages/outfit_details_screen.dart';

 import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_texts.dart';

 

class _T {
  static const headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: -0.6,
    height: 1.15,
  );
  static final sectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.inkSubtle,
    letterSpacing: 1.6,
  );
  static const cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.2,
  );
  static const cardBody = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
    height: 1.5,
    letterSpacing: 0.1,
  );
  static const badge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.surface,
    letterSpacing: 0.3,
  );
}

// ─────────────────────────────────────────────────────────────
//  DATA MODELS  (replace with real models / API later)
// ─────────────────────────────────────────────────────────────
class RecommendedItemModel {
  final String id;
  final String name;
  final String aiSuggestion;
  final Color placeholder; // replace with real image asset / network url
  bool saved;

  RecommendedItemModel({
    required this.id,
    required this.name,
    required this.aiSuggestion,
    required this.placeholder,
    this.saved = false,
  });

  static List<RecommendedItemModel> get samples => [
    RecommendedItemModel(
      id: '1',
      name: 'Linen Blazer',
      aiSuggestion: 'Pairs well with your neutral palette',
      placeholder: const Color(0xFFD4C9B8),
    ),
    RecommendedItemModel(
      id: '2',
      name: 'Wide-Leg Trousers',
      aiSuggestion: 'Balances your fitted upper choices',
      placeholder: const Color(0xFFBFC8D4),
    ),
    RecommendedItemModel(
      id: '3',
      name: 'Knit Turtleneck',
      aiSuggestion: 'Ideal for autumn layering',
      placeholder: const Color(0xFFD4BFBE),
    ),
    RecommendedItemModel(
      id: '4',
      name: 'Slim Chelsea Boot',
      aiSuggestion: 'Adds clean elongation to your look',
      placeholder: const Color(0xFFC8C0B4),
    ),
  ];
}

class FullOutfitModel {
  final String id;
  final String name;
  final String description;
  final int score; // 0–100
  final Color placeholder;
  bool saved;

  FullOutfitModel({
    required this.id,
    required this.name,
    required this.description,
    required this.score,
    required this.placeholder,
    this.saved = false,
  });

  static List<FullOutfitModel> get samples => [
    FullOutfitModel(
      id: '1',
      name: 'Quiet Luxury Sunday',
      description:
          'Cream cashmere, tailored trousers and leather loafers — '
          'a score driven by perfect tonal harmony.',
      score: 94,
      placeholder: const Color(0xFFE8E2D8),
    ),
    FullOutfitModel(
      id: '2',
      name: 'Urban Editorial',
      description:
          'Structured coat over a raw-hem denim look — '
          'contemporary contrast with strong silhouette score.',
      score: 87,
      placeholder: const Color(0xFFCDD4DC),
    ),
    FullOutfitModel(
      id: '3',
      name: 'Coastal Minimal',
      description:
          'Linen separates in analogous sand tones — '
          'exceptional colour harmony, near-perfect fit ratio.',
      score: 91,
      placeholder: const Color(0xFFDDE0D8),
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════
//  ROOT WIDGET  —  RecommendedSection
//  Drop this directly into any screen's Column / CustomScrollView.
// ═══════════════════════════════════════════════════════════════
class RecommendedSection extends StatefulWidget {
  const RecommendedSection({super.key});

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection>
    with SingleTickerProviderStateMixin {
  // Master controller — drives section-level fade + slide entrance
  late final AnimationController _sectionCtrl;
  late final Animation<double> _sectionOpacity;
  late final Animation<Offset> _sectionSlide;

  List<RecommendedItemModel> _items = RecommendedItemModel.samples;
  List<FullOutfitModel> _outfits = FullOutfitModel.samples;

  @override
  void initState() {
    super.initState();
    _sectionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _sectionOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _sectionCtrl, curve: Curves.easeOut));
    _sectionSlide =
        Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
          CurvedAnimation(parent: _sectionCtrl, curve: Curves.easeOutCubic),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) => _sectionCtrl.forward());
  }

  @override
  void dispose() {
    _sectionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppConstants.init(context);
    final w = AppConstants.w;
    final h = AppConstants.h;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedBuilder(
        animation: _sectionCtrl,
        builder: (_, child) => FractionalTranslation(
          translation: _sectionSlide.value,
          child: Opacity(opacity: _sectionOpacity.value, child: child),
        ),
        child:
            // ── Scrollable content ────────────────────────────
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.02),

                  // ── Part 1: Individual Items ─────────────────
                  _SectionHeader(
                    label: 'CURATED FOR YOU',
                    title: 'Recommended\nItems',
                  ),
                  SizedBox(height: h * 0.022),
                  _RecommendedItemsRow(
                    items: _items,
                    onSaveToggle: (id) => setState(() {
                      final idx = _items.indexWhere((e) => e.id == id);
                      if (idx != -1) _items[idx].saved = !_items[idx].saved;
                    }),
                  ),

                  SizedBox(height: h * 0.048),

                  // ── Part 2: Full Outfit Showcase ─────────────
                  _SectionHeader(label: 'FULL LOOKS', title: 'Complete\nOutfits'),
                  SizedBox(height: h * 0.022),
                  _FullOutfitShowcase(
                    outfits: _outfits,
                    onSaveToggle: (id) => setState(() {
                      final idx = _outfits.indexWhere((e) => e.id == id);
                      if (idx != -1) _outfits[idx].saved = !_outfits[idx].saved;
                    }),
                  ),

                  SizedBox(height: h * 0.04),
                ],
              ),
            ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SECTION HEADER
// ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final String title;

  const _SectionHeader({required this.label, required this.title});

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.055),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: T.label),
          const SizedBox(height: 6),
          Text(title, style: T.headline),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PART 1 — RECOMMENDED ITEMS ROW  (horizontal carousel)
// ═══════════════════════════════════════════════════════════════
class _RecommendedItemsRow extends StatelessWidget {
  final List<RecommendedItemModel> items;
  final ValueChanged<String> onSaveToggle;

  const _RecommendedItemsRow({required this.items, required this.onSaveToggle});

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final cardW = w * 0.52; // ~188 px on 360-wide device

    return SizedBox(
      height: AppConstants.h * 0.38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: w * 0.055),
        itemCount: items.length,
        itemBuilder: (context, i) => Padding(
          padding: EdgeInsets.only(right: w * 0.04),
          child: RecommendedItemCard(
            item: items[i],
            cardWidth: cardW,
            // Stagger: each card delays by 80 ms
            entranceDelay: Duration(milliseconds: 100 + i * 80),
            onSaveToggle: () => onSaveToggle(items[i].id),
          ),
        ),
      ),
    );
  }
}



class RecommendedItemCard extends StatefulWidget {
  final RecommendedItemModel item;
  final double cardWidth;
  final Duration entranceDelay;
  final VoidCallback onSaveToggle;

  const RecommendedItemCard({
    super.key,
    required this.item,
    required this.cardWidth,
    required this.entranceDelay,
    required this.onSaveToggle,
  });

  @override
  State<RecommendedItemCard> createState() => _RecommendedItemCardState();
}

class _RecommendedItemCardState extends State<RecommendedItemCard>
    with TickerProviderStateMixin {
  // ── Entrance: fade + slide up ──────────────────────────────
  late final AnimationController _enterCtrl;
  late final Animation<double> _enterOpacity;
  late final Animation<Offset> _enterSlide;

  // ── Tap: lift scale ────────────────────────────────────────
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _enterOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut));
    _enterSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.entranceDelay, () {
      if (mounted) _enterCtrl.forward();
    });
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = AppConstants.h;
    final w = AppConstants.w;

    return AnimatedBuilder(
      animation: _enterCtrl,
      builder: (_, child) => FractionalTranslation(
        translation: _enterSlide.value,
        child: Opacity(opacity: _enterOpacity.value, child: child),
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.965),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTapUp: (_) => setState(() => _scale = 1.0),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: widget.cardWidth,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(w * 0.056),
                border: Border.all(color: AppColors.border, width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image area ───────────────────────────
                  Expanded(
                    flex: 6,
                    child: Stack(
                      children: [

                            InkWell(
                                onTap: () {
                              print("sd");
                              openOutfitDetails(
                                context,
                                RecommendedItemModelDetails(
                                  saved: false,
                                  id: '1',
                                  name: 'Linen Blazer',
                                  aiSuggestion: 'Pairs well with your neutral palette',
                                  placeholder: const Color(0xFFD4C9B8),
                                ),
                              );
                            },

                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(w * 0.056),
                            ),
                            child: Container(
                              width: double.infinity,
                              color: widget.item.placeholder,
                              child: Center(
                                child: Icon(
                                  Icons.checkroom_outlined,
                                  size: w * 0.14,
                                  color: AppColors.ink.withOpacity(0.14),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Save button — top right
                        Positioned(
                          top: h * 0.012,
                          right: w * 0.03,
                          child: SaveButtonWidget(
                            saved: widget.item.saved,
                            onTap: widget.onSaveToggle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Text area ────────────────────────────
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.all(w * 0.038),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.item.name,
                            style: T.cardTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: h * 0.006),
                          Text(
                            widget.item.aiSuggestion,
                            style: T.cardBody,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PART 2 — FULL OUTFIT SHOWCASE  (large page-view cards)
// ═══════════════════════════════════════════════════════════════
class _FullOutfitShowcase extends StatefulWidget {
  final List<FullOutfitModel> outfits;
  final ValueChanged<String> onSaveToggle;

  const _FullOutfitShowcase({
    required this.outfits,
    required this.onSaveToggle,
  });

  @override
  State<_FullOutfitShowcase> createState() => _FullOutfitShowcaseState();
}

class _FullOutfitShowcaseState extends State<_FullOutfitShowcase> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return Column(
      children: [
        // ── PageView ────────────────────────────────────────
        SizedBox(
          height: h * 0.54,
          child: PageView.builder(
            controller: _pageCtrl,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: widget.outfits.length,
            itemBuilder: (context, i) {
              return AnimatedBuilder(
                animation: _pageCtrl,
                builder: (_, child) {
                  // Parallax scale effect: current page = 1.0, others = 0.94
                  double page = 0;
                  try {
                    page = _pageCtrl.page ?? i.toDouble();
                  } catch (_) {
                    page = i.toDouble();
                  }
                  final diff = (page - i).abs();
                  final scale = (1 - diff * 0.06).clamp(0.9, 1.0);
                  final opacity = (1 - diff * 0.4).clamp(0.6, 1.0);
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(opacity: opacity, child: child),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                  child: FullOutfitCard(
                    outfit: widget.outfits[i],
                    isActive: _currentPage == i,
                    entranceDelay: Duration(milliseconds: 200 + i * 100),
                    onSaveToggle: () =>
                        widget.onSaveToggle(widget.outfits[i].id),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Page dots ───────────────────────────────────────
        SizedBox(height: h * 0.018),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.outfits.length, (i) {
            final active = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.accent : AppColors.inkSubtle.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FullOutfitCard
// ─────────────────────────────────────────────────────────────
class FullOutfitCard extends StatefulWidget {
  final FullOutfitModel outfit;
  final bool isActive;
  final Duration entranceDelay;
  final VoidCallback onSaveToggle;

  const FullOutfitCard({
    super.key,
    required this.outfit,
    required this.isActive,
    required this.entranceDelay,
    required this.onSaveToggle,
  });

  @override
  State<FullOutfitCard> createState() => _FullOutfitCardState();
}

class _FullOutfitCardState extends State<FullOutfitCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut));
    _scale = Tween<double>(
      begin: 0.93,
      end: 1,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.entranceDelay, () {
      if (mounted) _enterCtrl.forward();
    });
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return AnimatedBuilder(

      animation: _enterCtrl,
      builder: (_, child) => FractionalTranslation(
        translation: _slide.value,
        child: Transform.scale(
          scale: _scale.value,
          child: Opacity(opacity: _opacity.value, child: child),
        ),
      ),
      child: Container(
        height: AppConstants.h*0.4,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(w * 0.072),
          border: Border.all(
            color: widget.isActive ? AppColors.accent.withOpacity(0.12) : AppColors.border,
            width: widget.isActive ? 1.2 : 0.8,
          ),
          boxShadow: [

            // Subtle glow on active card
            if (widget.isActive)
              BoxShadow(
                color: AppColors.accent.withOpacity(0.06),
                blurRadius: 48,
                spreadRadius: 4,
                offset: const Offset(0, 12),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Large image area ───────────────────────────
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  // Placeholder outfit image
                  InkWell(
                  onTap: () {
        print("sd");
        openOutfitDetails(
        context,
        RecommendedItemModelDetails(

        saved: false,
        id: '1', name: 'Linen Blazer',
        aiSuggestion: 'Pairs well with your neutral palette',
        placeholder: const Color(0xFFD4C9B8),
        ),
        );},child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(w * 0.072),
                    ),
                    child: Container(
                      height:h*0.3,
                      width: double.infinity,
                      color: widget.outfit.placeholder,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: w * 0.22,
                            color: AppColors.ink.withOpacity(0.10),
                          ),
                        ],
                      ),
                    ),
                  )  ),

                  // AI Score badge — top left
                  Positioned(
                    top: h * 0.018,
                    left: w * 0.04,
                    child: _ScoreBadge(score: widget.outfit.score),
                  ),

                  // Save button — top right
                  Positioned(
                    top: h * 0.018,
                    right: w * 0.04,
                    child: SaveButtonWidget(
                      saved: widget.outfit.saved,
                      onTap: widget.onSaveToggle,
                      large: true,
                    ),
                  ),
                ],
              ),
            ),

            // ── Text + CTA area ────────────────────────────
            Expanded(
              flex:5,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.018,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.outfit.name,
                            style: T.cardTitle.copyWith(fontSize: 17),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: h * 0.006),
                          Text(
                            widget.outfit.description,
                            style: T.cardBody,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.03),

                      // Save Full Look button
                      _SaveFullLookButton(
                        saved: widget.outfit.saved,
                        onTap: widget.onSaveToggle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SaveButtonWidget  (bookmark icon with micro-animation)
// ─────────────────────────────────────────────────────────────
class SaveButtonWidget extends StatefulWidget {
  final bool saved;
  final VoidCallback onTap;
  final bool large;

  const SaveButtonWidget({
    super.key,
    required this.saved,
    required this.onTap,
    this.large = false,
  });

  @override
  State<SaveButtonWidget> createState() => _SaveButtonWidgetState();
}

class _SaveButtonWidgetState extends State<SaveButtonWidget>
    with SingleTickerProviderStateMixin {
  // Bounce controller fires on save
  late final AnimationController _bounceCtrl;
  late final Animation<double> _bounceScale;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    // Bounce curve: scale up then settle
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.35,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.35,
          end: 0.90,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.90,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_bounceCtrl);
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _bounceCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final size = widget.large ? w * 0.106 : w * 0.092;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _bounceScale,
        builder: (_, child) =>
            Transform.scale(scale: _bounceScale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.saved ? AppColors.accent : AppColors.surface.withOpacity(0.88),
            boxShadow: [
              BoxShadow(
                color: (widget.saved ? AppColors.accent : AppColors.ink).withOpacity(
                  widget.saved ? 0.24 : 0.10,
                ),
                blurRadius: widget.saved ? 14 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            widget.saved
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            size: size * 0.48,
            color: widget.saved ? AppColors.surface : AppColors.inkMuted,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Save Full Look button (text + icon row)
// ─────────────────────────────────────────────────────────────
class _SaveFullLookButton extends StatefulWidget {
  final bool saved;
  final VoidCallback onTap;

  const _SaveFullLookButton({required this.saved, required this.onTap});

  @override
  State<_SaveFullLookButton> createState() => _SaveFullLookButtonState();
}

class _SaveFullLookButtonState extends State<_SaveFullLookButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: h * 0.054,
          decoration: BoxDecoration(
            color: widget.saved ? AppColors.accentSoft : AppColors.accent,
            borderRadius: BorderRadius.circular(w * 0.032),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.saved
                    ? Icons.check_rounded
                    : Icons.bookmark_add_outlined,
                size: w * 0.042,
                color: widget.saved ? AppColors.accent : AppColors.surface,
              ),
              SizedBox(width: w * 0.022),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: T.cardTitle.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.surface,
                  letterSpacing: 0.3,

                ),
                child: Text(
                  widget.saved ? 'Saved to Collection' : 'Save Full Look',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  AI Compatibility Score badge
// ─────────────────────────────────────────────────────────────
class _ScoreBadge extends StatelessWidget {
  final int score;

  const _ScoreBadge({required this.score});

  Color get _color {
    if (score >= 88) return AppColors.scoreHigh;
    if (score >= 72) return AppColors.scoreMid;
    return AppColors.scoreLow;
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.032, vertical: w * 0.016),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(w * 0.028),
        border: Border.all(color: _color.withOpacity(0.28), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w * 0.018,
            height: w * 0.018,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
          ),
          SizedBox(width: w * 0.018),
          Text(
            '$score% Match',
            style: TextStyle(
              fontSize: w * 0.029,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Floating decorative background
// ─────────────────────────────────────────────────────────────
class _FloatingBackground extends StatefulWidget {
  const _FloatingBackground();

  @override
  State<_FloatingBackground> createState() => _FloatingBackgroundState();
}

class _FloatingBackgroundState extends State<_FloatingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    // Gentle 4-second float loop
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _float = Tween<double>(
      begin: -12,
      end: 12,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return AnimatedBuilder(
      animation: _float,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: h * 0.05 + _float.value,
            right: -w * 0.18,
            child: _Blob(size: w * 0.65, opacity: 0.06),
          ),
          Positioned(
            bottom: h * 0.28 - _float.value * 0.6,
            left: -w * 0.22,
            child: _Blob(size: w * 0.55, opacity: 0.05),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final double opacity;

  const _Blob({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: opacity,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.accent),
    ),
  );
}
