import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:graduation_proj/features/homePage/presentation/home_page.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../drawer/buildMenus.dart';

// ═══════════════════════════════════════════════════════════════
class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ZoomDrawerController ctrl = ZoomDrawerController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs     = Theme.of(context).colorScheme;

    return ZoomDrawer(
      controller:                  ctrl,
      menuBackgroundColor:         C.drawerBg,
      shadowLayer1Color:           isDark ? cs.surfaceVariant : const Color(0xFFF0EFEC),
      shadowLayer2Color:           isDark
          ? cs.surfaceVariant.withOpacity(0.7)
          : const Color(0xFFE6E4DF).withOpacity(0.4),
      borderRadius:                28.0,
      showShadow:                  true,
      style:                       DrawerStyle.defaultStyle,
      angle:                       -10.0,
      drawerShadowsBackgroundColor: const Color(0xFFD8D6D0),
      slideWidth:                  MediaQuery.sizeOf(context).width * 0.72,
      // Replace with your real HomePage widget:
      mainScreen:                PlaceholderMainScreen(ctrl: ctrl),
      menuScreen:                  BuildMenuScreen(
        zoomCtrl:     ctrl,
        isMobile:     true,
        onNavigate:   (screen) {
          Navigator.push(context, FadeScaleRoute(page: screen));
        },
      ),
    );
  }
}
