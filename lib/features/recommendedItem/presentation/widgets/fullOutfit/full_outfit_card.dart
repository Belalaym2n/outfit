import 'package:flutter/cupertino.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/widgets/fullOutfit/save_button.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/widgets/fullOutfit/smaill_save_button.dart';

import '../../../../../core/sharedWidgets/text_styles.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/pages/outfit_details_screen.dart';

import '../../../data/models/outfit_item_model.dart';
import '../../../domain/entities/outfit_entity.dart';
import '../../manager/outfit_states.dart';
import '../../pages/recommend_items.dart';
import 'build_outfit_image.dart';




class FullOutfitCard extends StatefulWidget {
  final OutfitItemModel
  outfit;
  final bool isActive;
  final Duration entranceDelay;
  final VoidCallback onSaveToggle;
  final bool saveStatus;
  final VoidCallback onUnsave;

  const FullOutfitCard({
    super.key,
    required this.outfit,
    required this.isActive,
    required this.entranceDelay,
    required this.onSaveToggle,

    required this.saveStatus,
     required this.onUnsave,
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
        height: AppConstants.h * 0.4,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(w * 0.072),
          border: Border.all(
            color: widget.isActive
                ? AppColors.accent.withOpacity(0.12)
                : AppColors.border,
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
                      // openOutfitDetails(
                      //   context,
                      //   RecommendedItemModelDetails(
                      //     saved: false,
                      //     id: '1',
                      //     name: 'Linen Blazer',
                      //     aiSuggestion: 'Pairs well with your neutral palette',
                      //     placeholder: const Color(0xFFD4C9B8),
                      //   ),
                      // );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(w * 0.072),
                      ),

                      child: BuildOutfitImage(images: widget.outfit.images),
                    ),
                  ),

                  // AI Score badge — top left
                  // Positioned(
                  //   top: h * 0.018,
                  //   left: w * 0.04,
                  //   child: _ScoreBadge(score: widget.outfit.score),
                  // ),

                  // Save button — top right
                  Positioned(
                    top: h * 0.018,
                    right: w * 0.04,
                    child: SaveButtonWidget(
                      saved: widget.outfit.isSaved,
                      onTap: widget.onSaveToggle,
                      large: true,
                    ),
                  ),
                ],
              ),
            ),

            // ── Text + CTA area ────────────────────────────
            Expanded(
              flex: 5,
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
                            widget.outfit.title,
                            style: T.cardTitle.copyWith(
                              fontSize: 17,
                              color: AppColors.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: h * 0.006),
                          Text(
                            widget.outfit.categories.toString(),
                            style: T.cardBody,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.03),

                      // Save Full Look button
                      SaveFullLookButton(
                        saved: widget.outfit.isSaved,
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