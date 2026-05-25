
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_texts.dart';
import '../../data/models/outfit_history_model.dart';
import 'outfit_images_grid.dart';


class ScoreRow extends StatelessWidget {
  final String label;
  final double score;
  final bool highlight;

  const ScoreRow({
    required this.label,
    required this.score,
    this.highlight = false,
  });

  Color get _scoreColor {
    if (score >= 75) return AppColors.scoreHigh;
    if (score >= 50) return AppColors.scoreMid;
    return AppColors.scoreLow;
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 54,
        child: Text(
          label,
          style: T.label.copyWith(
            color: highlight ? AppColors.textMid : AppColors.textLow,
          ),
        ),
      ),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 5,
            backgroundColor: AppColors.surfaceAlt,
            valueColor: AlwaysStoppedAnimation<Color>(
              highlight ? _scoreColor : AppColors.textLow,
            ),
          ),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        '${score.toStringAsFixed(0)}%',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: highlight ? _scoreColor : AppColors.textLow,
        ),
      ),
    ],
  );
}
