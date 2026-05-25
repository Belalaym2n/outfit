import 'package:flutter/cupertino.dart';

import '../../../../../core/sharedWidgets/text_styles.dart';
import '../../../../../core/utils/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/pages/outfit_details_screen.dart';

import '../../../../../core/utils/app_constants.dart';

// ─────────────────────────────────────────────────────────────
class SaveFullLookButton extends StatefulWidget {
  final bool saved;
  final VoidCallback onTap;

  const SaveFullLookButton({required this.saved, required this.onTap});

  @override
  State<SaveFullLookButton> createState() => _SaveFullLookButtonState();
}

class _SaveFullLookButtonState extends State<SaveFullLookButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: h * 0.054,
          decoration: BoxDecoration(
            color: widget.saved ? AppColors.accentSoft : AppColors.accent,
            borderRadius: BorderRadius.circular(w * 0.032),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.saved
                    ? Icons.check_rounded
                    : Icons.bookmark_add_outlined,
                size: w * 0.042,
                color: widget.saved ? AppColors.accent : AppColors.surface,
              ),
              SizedBox(width: w * 0.022),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: T.cardTitle.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.surface,
                  letterSpacing: 0.3,
                ),
                child: Text(
                  widget.saved ? 'Saved to Collection' : 'Save Full Look',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
