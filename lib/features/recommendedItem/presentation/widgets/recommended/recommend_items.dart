// ═══════════════════════════════════════════════════════════════
//  recommend_items.dart  (REFACTORED)
//  Horizontal carousel — image caching, smooth scroll, clean UI.
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../compatapilityModel/presentation/manager/outfit_bloc.dart';
import '../../../data/models/outfit_item_model.dart';
import '../../manager/outfit_states.dart';
import '../../pages/outfit_details_screen.dart' hide AppConstants;
import '../fullOutfit/smaill_save_button.dart';

// ─────────────────────────────────────────────────────────────
//  RecommendedItemsRow
// ─────────────────────────────────────────────────────────────
class RecommendedItemsRow extends StatelessWidget {
  const RecommendedItemsRow({
    super.key,
    required this.items,
    required this.saveStatuses,
    required this.onSaveToggle,
    required this.savedIds,
    required this.onNavigate,
  });
  final Function(OutfitItemModel item) onNavigate;
  final List<OutfitItemModel> items;
  final Map<String, SaveStatus> saveStatuses;
  final void Function(OutfitItemModel item) onSaveToggle;
  final Set<String> savedIds;

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final cardW = w * 0.52;

    if (items.isEmpty) {
      return SizedBox(
        height: AppConstants.h * 0.38,
        child: Center(
          child: Text(
            'No recommendations yet',
            style: TextStyle(color: AppColors.inkMuted, fontSize: 14),
          ),
        ),
      );
    }

    return SizedBox(
      height: AppConstants.h * 0.38,
      child: ListView.builder(
        // ── Performance: reuse items, don't rebuild unnecessarily
        addRepaintBoundaries: true,
        addAutomaticKeepAlives: false,
        cacheExtent: cardW * 3,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: w * 0.055),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return Padding(
            padding: EdgeInsets.only(right: w * 0.04),
            child: RecommendedItemCard(
              onNavigate: onNavigate, // ✅

              key: ValueKey(item.id), // stable key prevents unnecessary rebuilds
              item: item,
              isSaved: savedIds.contains(item.id),
              cardWidth: cardW,
              saveStatus: saveStatuses[item.id] ?? SaveStatus.idle,
              entranceDelay: Duration(milliseconds: 100 + i * 80),
              onSaveToggle: () => onSaveToggle(item),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  RecommendedItemCard
// ─────────────────────────────────────────────────────────────
class RecommendedItemCard extends StatefulWidget {
  const RecommendedItemCard({
    super.key,
    required this.item,
    required this.cardWidth,
    required this.saveStatus,
    required this.entranceDelay,
    required this.onSaveToggle,
    required this.onNavigate,
    required this.isSaved,
  });

  final OutfitItemModel item;
  final double cardWidth;
  final SaveStatus saveStatus;
  final Duration entranceDelay;
  final VoidCallback onSaveToggle;
  final void Function(OutfitItemModel item) onNavigate;  final bool isSaved;

  @override
  State<RecommendedItemCard> createState() => _RecommendedItemCardState();
}

class _RecommendedItemCardState extends State<RecommendedItemCard>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final Animation<double> _enterOpacity;
  late final Animation<Offset> _enterSlide;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _enterOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut),
    );
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
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onNavigate(widget.item); // ✅ أهم سطر
        },
        child: AnimatedScale(
          scale: _pressed ? 0.965 : 1.0,
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
                  // ── Image area ──────────────────────────────
                  Expanded(
                    flex: 6,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(w * 0.056),
                          ),
                          child: _ItemImage(
                            imageUrl: widget.item.images.isNotEmpty
                                ? widget.item.images.first
                                : null,
                          ),
                        ),

                        // ── Save button ─────────────────────
                        Positioned(
                          top: h * 0.012,
                          right: w * 0.03,
                          child: SaveButtonWidget(
                            saved: widget.isSaved,
                            isLoading: widget.saveStatus == SaveStatus.loading,
                            onTap: widget.onSaveToggle,
                          ),
                        ),

                        // ── AI Score badge ──────────────────
                        if (widget.item.aiScore > 0)
                          Positioned(
                            bottom: h * 0.012,
                            left: w * 0.03,
                            child: _AiScoreBadge(score: widget.item.aiScore),
                          ),
                      ],
                    ),
                  ),

                  // ── Text area ───────────────────────────────
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.all(w * 0.038),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: h * 0.005),
                          Text(
                            widget.item.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.inkMuted,
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.item.categories.isNotEmpty) ...[
                            SizedBox(height: h * 0.006),
                            _CategoryChip(label: widget.item.categories.first),
                          ],
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

// ─────────────────────────────────────────────────────────────
//  _ItemImage — handles loading, error, fade-in (no external pkg)
// ─────────────────────────────────────────────────────────────
class _ItemImage extends StatefulWidget {
  const _ItemImage({this.imageUrl});
  final String? imageUrl;

  @override
  State<_ItemImage> createState() => _ItemImageState();
}

class _ItemImageState extends State<_ItemImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fade;
  bool _loaded = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty || _error) {
      return _PlaceholderBox();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Shimmer placeholder shown while loading ──────────
        if (!_loaded) _ShimmerPlaceholder(),

        // ── Actual image with fade-in once loaded ────────────
        FadeTransition(
          opacity: _fade,
          child: Image.network(
            widget.imageUrl!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            // Tells Flutter to cache decoded image in memory
            cacheWidth: 400,
            frameBuilder: (ctx, child, frame, wasSynch) {
              if (wasSynch || frame != null) {
                // Image is ready (from cache or instantly loaded)
                if (!_loaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() => _loaded = true);
                      _fadeCtrl.forward();
                    }
                  });
                }
                return child;
              }
              // Still loading — show shimmer underneath (don't show child yet)
              return const SizedBox.shrink();
            },
            errorBuilder: (_, __, ___) {
              if (!_error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _error = true);
                });
              }
              return _PlaceholderBox();
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Shimmer placeholder (no external package)
// ─────────────────────────────────────────────────────────────
class _ShimmerPlaceholder extends StatefulWidget {
  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1.0 + _anim.value * 2, 0),
            end: Alignment(1.0 + _anim.value * 2, 0),
            colors: [
              AppColors.border,
              AppColors.border.withOpacity(0.5),
              AppColors.border,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Fallback placeholder (no image / error)
// ─────────────────────────────────────────────────────────────
class _PlaceholderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: double.infinity,
    color: AppColors.border,
    child: Center(
      child: Icon(
        Icons.checkroom_outlined,
        size: AppConstants.w * 0.14,
        color: AppColors.ink.withOpacity(0.14),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  AI Score badge
// ─────────────────────────────────────────────────────────────
class _AiScoreBadge extends StatelessWidget {
  const _AiScoreBadge({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.55),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.auto_awesome, color: Colors.amber, size: 11),
        const SizedBox(width: 3),
        Text(
          score.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  Category chip
// ─────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.accent.withOpacity(0.10),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: AppColors.accent,
        letterSpacing: 0.8,
      ),
    ),
  );
}