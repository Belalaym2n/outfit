
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_proj/features/profile/data/models/user_data.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/sharedWidgets/text_styles.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';




class ProfileHeader extends StatelessWidget {
    ProfileHeader({
    super.key,
    required this.hPad,
    required this.headerFade,
    required this.headerSlide,
    required this.avatarScale,
    required this.avatarFade,
    required this.userModel,
  });

   UserModel userModel;
  final double            hPad;
  final Animation<double> headerFade;
  final Animation<Offset>  headerSlide;
  final Animation<double> avatarScale;
  final Animation<double> avatarFade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, Sp.md, hPad, Sp.md),
      child: Column(
        children: [

          // ── Avatar with scale pop-in ──────────────────────────
          ScaleTransition(
            scale: avatarScale,
            child: FadeTransition(
              opacity: avatarFade,
              child: Stack(
                children: [
                  // Profile image circle
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:AppColors.surfaceAlt,
                      border: Border.all(color:AppColors.divider, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 28,
                          spreadRadius: -6,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 48,
                          color:AppColors.textLow,
                        ),
                      ),
                    ),
                  ),

                  // Edit icon overlay — top-right
                  Positioned(
                    top: 2, right: 2,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color:AppColors.ink,
                        shape: BoxShape.circle,
                        border: Border.all(color:AppColors.bg, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white, size: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: Sp.sm),

          // ── Name, email, badge ────────────────────────────────
           FadeSlide(
            fade: headerFade, slide: headerSlide,
            child: Column(
              children: [

                // Name
                Text(userModel.name, style: T.display),

                const SizedBox(height: 4),

                // Email
                  Text(
                 userModel.email,
                  style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w400,
                    color:AppColors.textLow, letterSpacing: 0.0,
                  ),
                ),

                const SizedBox(height: 12),

                // AI badge pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color:AppColors.divider),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5, height: 5,
                        decoration: const BoxDecoration(
                          color:AppColors.textHigh, shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text('AI Style Explorer', style: T.fieldLabel),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
