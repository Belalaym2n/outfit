
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/animations/slide_naviagation.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart' show Sp;
import '../../../../core/utils/app_texts.dart';

class  EmptyState extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Sp.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: const Icon(
              Icons.checkroom_outlined,
              color: AppColors.textLow,
              size: 32,
            ),
          ),
          const SizedBox(height: Sp.md),
          Text('No History Yet', style: T.heading),
          const SizedBox(height: Sp.xs),
          Text(
            'Your outfit history is empty.\nAnalyze an outfit to get started.',
            style: T.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
