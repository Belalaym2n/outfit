import 'package:flutter/cupertino.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/widgets/fullOutfit/save_button.dart';

import '../../../../../core/sharedWidgets/text_styles.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/pages/outfit_details_screen.dart';

import '../../../data/models/outfit_item_model.dart';
import '../../../domain/entities/outfit_entity.dart';
import '../../pages/recommend_items.dart';
import 'build_outfit_image.dart';


class  ScoreBadge extends StatelessWidget {
  final int score;

  const ScoreBadge({required this.score});

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
