import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/app_router.dart' as Go;
import '../../core/cahsing/get_storage_helper.dart';
import '../../core/cahsing/secure_storage.dart';
import '../../core/utils/app_colors.dart';

// ─────────────────────────────────────────────────────────────
class DrawerLogoutBtn extends StatefulWidget {
  const DrawerLogoutBtn();

  @override
  State<DrawerLogoutBtn> createState() => _DrawerLogoutBtnState();
}

class _DrawerLogoutBtnState extends State<DrawerLogoutBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.96), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.0), weight: 60),
  ]).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();
          GetStorageHelper.clear();
          SecureStorageHelper.clear();
          context.go(Go.AppRoutes.login);
         },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFFD32F2F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, size: 16, color: AppColors.white),
              const SizedBox(width: 8),
              Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
