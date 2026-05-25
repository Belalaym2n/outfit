
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/cahsing/app_storage_service.dart';
import 'package:graduation_proj/core/sharedWidgets/bg_screen.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../data/models/outfit_item_model.dart';
import '../../manager/outfit_states.dart';

class SaveCTAButton extends StatefulWidget {
  const SaveCTAButton({
    required this.saved,
    required this.isLoading,
    required this.onTap,
  });
  final bool         saved;
  final bool         isLoading;
  final VoidCallback onTap;

  @override
  State<SaveCTAButton> createState() => _SaveCTAButtonState();
}

class _SaveCTAButtonState extends State<SaveCTAButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return GestureDetector(
      onTapDown:   (_) => setState(() => _scale = 0.96),
      onTapCancel: ()  => setState(() => _scale = 1.0),
      onTapUp:     (_) {
        setState(() => _scale = 1.0);
        if (!widget.isLoading) widget.onTap();
      },
      child: AnimatedScale(
        scale:    _scale,
        duration: const Duration(milliseconds: 130),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height:   h * 0.058,
          decoration: BoxDecoration(
            color:        widget.saved
                ? AppColors.accentSoft
                : AppColors.accent,
            borderRadius: BorderRadius.circular(w * 0.032),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
              width:  20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: widget.saved
                    ? AppColors.accent
                    : AppColors.surface,
              ),
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.saved
                      ? Icons.check_rounded
                      : Icons.bookmark_add_outlined,
                  size:  w * 0.046,
                  color: widget.saved
                      ? AppColors.accent
                      : AppColors.surface,
                ),
                SizedBox(width: w * 0.022),
                Text(
                  widget.saved
                      ? 'Saved to Collection'
                      : 'Save to Collection',
                  style: TextStyle(
                    fontSize:   w * 0.036,
                    fontWeight: FontWeight.w700,
                    color:      widget.saved
                        ? AppColors.accent
                        : AppColors.surface,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
