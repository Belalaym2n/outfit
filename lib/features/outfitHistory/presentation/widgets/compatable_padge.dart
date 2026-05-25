
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_texts.dart';
import '../../data/models/outfit_history_model.dart';
import 'outfit_images_grid.dart';

class CompatBadge extends StatelessWidget {
  final bool isCompatible;

  const CompatBadge({required this.isCompatible});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: isCompatible
          ? AppColors.scoreHigh.withOpacity(0.12)
          : AppColors.scoreLow.withOpacity(0.10),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      isCompatible ? 'Compatible' : 'Not Compatible',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: isCompatible ? AppColors.scoreHigh : AppColors.scoreLow,
      ),
    ),
  );
}
