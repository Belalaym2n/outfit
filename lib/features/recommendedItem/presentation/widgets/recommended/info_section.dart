
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/cahsing/app_storage_service.dart';
import 'package:graduation_proj/core/sharedWidgets/bg_screen.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/widgets/recommended/save_details_icon.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../data/models/outfit_item_model.dart';
import '../../manager/outfit_states.dart';


class  InfoSection extends StatelessWidget {
  final OutfitItemModel item;
  final AnimationController staggerCtrl;
  final Animation<double> nameFade, scoreFade, descFade, tagsFade, btnFade;
  final Animation<Offset>  nameSlide, scoreSlide, descSlide, tagsSlide;
  final SaveStatus         saveStatus;
  final VoidCallback       onSaveToggle;

  const InfoSection({
    required this.item,
    required this.staggerCtrl,
    required this.nameFade,    required this.nameSlide,
    required this.scoreFade,   required this.scoreSlide,
    required this.descFade,    required this.descSlide,
    required this.tagsFade,    required this.tagsSlide,
    required this.btnFade,
    required this.saveStatus,
    required this.onSaveToggle,
  });

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return AnimatedBuilder(
      animation: staggerCtrl,
      builder: (_, __) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: w * 0.055, vertical: h * 0.008),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Title ──────────────────────────────────────
            FadeSlide(
              fade: nameFade, slide: nameSlide,
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize:       w * 0.072,
                  fontWeight:     FontWeight.w700,
                  color:          AppColors.ink,
                  letterSpacing:  -1.2,
                  height:         1.05,
                ),
              ),
            ),

            SizedBox(height: h * 0.010),

            // ── Gender + categories row ────────────────────
            FadeSlide(
              fade: nameFade, slide: nameSlide,
              child: Wrap(
                spacing: w * 0.02,
                children: [
                  if (item.gender.isNotEmpty)
                    _TagCapsule(
                      label: item.gender.toUpperCase(),
                      color: AppColors.accent,
                    ),
                  ...item.categories.map(
                        (c) => _TagCapsule(
                      label: c.toUpperCase(),
                      color: AppColors.accent.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.022),

            // ── AI Score bar ───────────────────────────────
            FadeSlide(
              fade: scoreFade, slide: scoreSlide,
              child: _ScoreRow(score: item.aiScore),
            ),

            SizedBox(height: h * 0.02),

            // ── Description ────────────────────────────────
            FadeSlide(
              fade: descFade, slide: descSlide,
              child: Text(
                item.description,
                style: TextStyle(
                  fontSize:  w * 0.036,
                  height:    1.65,

                  color:     AppColors.inkMuted,
                  letterSpacing: 0.1,
                ),
                maxLines: 2,
              ),
            ),

            SizedBox(height: h * 0.02),

            // ── Colour swatches ────────────────────────────
            if (item.colors.isNotEmpty)
              FadeSlide(
                fade:tagsFade, slide: tagsSlide,
                child: _ColorRow(colors: item.colors),
              ),

            SizedBox(height: h * 0.014),

            // ── Tags ───────────────────────────────────────
            if (item.tags.isNotEmpty)
              FadeSlide(
                fade:tagsFade, slide: tagsSlide,
                child: Wrap(
                  spacing:    w * 0.022,
                  runSpacing: h * 0.010,
                  children: item.tags
                      .map((t) => _TagCapsule(label: t))
                      .toList(),
                ),
              ),

            SizedBox(height: h * 0.036),

            // ── Save / Unsave CTA ──────────────────────────
            Opacity(
              opacity: btnFade.value,
              child:  SaveCTAButton(
                saved:     item.isSaved,
                isLoading: saveStatus == SaveStatus.loading,
                onTap:     onSaveToggle,
              ),
            ),

            SizedBox(height: h * 0.055),
          ],
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.score});
  final double score;

  Color get _barColor {
    if (score >= 8.0) return AppColors.scoreHigh;
    if (score >= 6.0) return AppColors.scoreMid;
    return const Color(0xFFFF453A);
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'AI Match Score',
              style: TextStyle(
                fontSize:      w * 0.032,
                fontWeight:    FontWeight.w500,
                color:         AppColors.inkSubtle,
                letterSpacing: 0.4,
              ),
            ),
            const Spacer(),
            Text(
              score.toStringAsFixed(1),
              style: TextStyle(
                fontSize:      w * 0.042,
                fontWeight:    FontWeight.w700,
                color:         AppColors.ink,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: w * 0.024),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: TweenAnimationBuilder<double>(
            tween:    Tween(begin: 0, end: (score / 10).clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 900),
            curve:    Curves.easeOutCubic,
            builder: (_, value, __) => Stack(
              children: [
                Container(
                    height: w * 0.018,
                    width:  double.infinity,
                    color:  AppColors.border),
                Container(
                  height: w * 0.018,
                  width:  AppConstants.w * 0.89 * value,
                  decoration: BoxDecoration(
                    color:         _barColor,
                    borderRadius:  BorderRadius.circular(100),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow({required this.colors});
  final List<String> colors;

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    return Row(
      children: [
        Text(
          'Colors',
          style: TextStyle(
            fontSize:  w * 0.030,
            color:     AppColors.inkSubtle,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: w * 0.022),
        ...colors.map((c) => Padding(
          padding: EdgeInsets.only(right: w * 0.016),
          child: Container(
            width:  w * 0.048,
            height: w * 0.048,
            decoration: BoxDecoration(
              shape:  BoxShape.circle,
              color:  _parseColor(c),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Center(
              child: Text(
                c.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize:   w * 0.020,
                  color:      Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }

  Color _parseColor(String name) {
    const map = {
      'white': Color(0xFFF5F5F5), 'black': Color(0xFF1A1A1A),
      'blue':  Color(0xFF4A90D9), 'red':   Color(0xFFD94545),
      'green': Color(0xFF4CAF50), 'yellow':Color(0xFFFFC107),
      'brown': Color(0xFF8B6F47), 'gray':  Color(0xFF9E9E9E),
      'grey':  Color(0xFF9E9E9E), 'beige': Color(0xFFF5E6C8),
      'pink':  Color(0xFFE91E8C), 'purple':Color(0xFF9C27B0),
      'orange':Color(0xFFFF9800), 'navy':  Color(0xFF1A237E),
    };
    return map[name.toLowerCase()] ?? const Color(0xFF8B7355);
  }
}

class _TagCapsule extends StatelessWidget {
  const _TagCapsule({required this.label, this.color});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final w      = AppConstants.w;
    final accent = color ?? AppColors.accent;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: w * 0.04, vertical: w * 0.018),
      decoration: BoxDecoration(
        color:        accent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(100),
        border:       Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize:      w * 0.028,
          fontWeight:    FontWeight.w600,
          color:         accent,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}