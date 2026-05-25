import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../recommendedItem/data/models/outfit_item_model.dart';
import '../../../../recommendedItem/presentation/manager/outfit_states.dart';

class  SavedItemCard extends StatefulWidget {
    SavedItemCard({
    required this.item,
    required this.cardHeight,
    required this.saveStatus,
    required this.onUnsave,
    required this.onTap,
    this.isLoading=false,
  });
bool isLoading;
  final OutfitItemModel item;
  final double cardHeight;
  final SaveStatus saveStatus;
  final VoidCallback onUnsave;
  final VoidCallback onTap;

  @override
  State<SavedItemCard> createState() => _SavedItemCardState();
}

class _SavedItemCardState extends State<SavedItemCard>
    with SingleTickerProviderStateMixin {
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
    _enterOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut));
    _enterSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) => _enterCtrl.forward());
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.item.images.isNotEmpty
        ? widget.item.images.first
        : null;

    return AnimatedBuilder(
      animation: _enterCtrl,
      builder: (_, child) => FractionalTranslation(
        translation: _enterSlide.value,
        child: Opacity(opacity: _enterOpacity.value, child: child),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: widget.cardHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withOpacity(0.08),
                  blurRadius: 18,
                  spreadRadius: -4,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  // ── Image ──────────────────────────────
                  Positioned.fill(
                    child: Hero(
                      tag: 'outfit_img_${widget.item.id}',
                      child: imageUrl != null
                          ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 400,
                        errorBuilder: (_, __, ___) => _CardPlaceholder(),
                      )
                          : _CardPlaceholder(),
                    ),
                  ),

                  // ── Bottom overlay ─────────────────────

                if(!widget.isLoading)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _NameOverlay(item: widget.item),
                  ),

                  // ── Unsave button ──────────────────────
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _UnsaveButton(
                      saveStatus: widget.saveStatus,
                      onTap: widget.onUnsave,
                    ),
                  ),

                  // ── AI score badge ─────────────────────
                  if (widget.item.aiScore > 0)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _ScoreBadge(score: widget.item.aiScore),
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

class _CardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.border,
    child: Center(
      child: Icon(
        Icons.checkroom_outlined,
        size: AppConstants.w * 0.14,
        color: AppColors.ink.withOpacity(0.12),
      ),
    ),
  );
}

class _NameOverlay extends StatelessWidget {
  const _NameOverlay({required this.item});

  final OutfitItemModel item;

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.65), Colors.transparent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (item.categories.isNotEmpty)
            Text(
              item.categories.first.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.75),
                letterSpacing: 0.8,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

class _UnsaveButton extends StatefulWidget {
  const _UnsaveButton({required this.saveStatus, required this.onTap});

  final SaveStatus saveStatus;
  final VoidCallback onTap;

  @override
  State<_UnsaveButton> createState() => _UnsaveButtonState();
}

class _UnsaveButtonState extends State<_UnsaveButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.saveStatus == SaveStatus.loading;
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
        _pulse.forward(from: 0);
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, child) =>
            Transform.scale(scale: 1.0 - _pulse.value * 0.12, child: child),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.90),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.red,
              ),
            )
                : const Icon(Icons.bookmark, color: Colors.red, size: 18),
          ),
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.55),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.auto_awesome, color: Colors.amber, size: 10),
        const SizedBox(width: 3),
        Text(
          score.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}