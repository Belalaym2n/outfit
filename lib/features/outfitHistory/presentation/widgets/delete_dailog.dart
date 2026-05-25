
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

class  DeleteDialog extends StatelessWidget {
  const DeleteDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: AppColors.divider),
    ),
    title: Text('Delete Entry', style: T.heading),
    content: Text(
      'This outfit analysis will be permanently removed.',
      style: T.body,
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text('Cancel', style: T.label),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(
          'Delete',
          style: T.label.copyWith(color: AppColors.scoreLow),
        ),
      ),
    ],
  );
}