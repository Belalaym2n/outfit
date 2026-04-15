// features/team/team_deep_links.dart
//
// Handles incoming deep links of the form:
//   outfitai://team/{member-id}
//
// Setup in main.dart:
//   TeamDeepLinks.init(navigatorKey);
//
// Android — AndroidManifest.xml intent-filter (inside <activity>):
//   <intent-filter>
//     <action android:name="android.intent.action.VIEW"/>
//     <category android:name="android.intent.category.DEFAULT"/>
//     <category android:name="android.intent.category.BROWSABLE"/>
//     <data android:scheme="outfitai" android:host="team"/>
//   </intent-filter>
//
// iOS — Info.plist CFBundleURLSchemes:
//   <string>outfitai</string>

import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart';

import '../data/team_data.dart';
import '../page/team_member_screen.dart';

abstract final class TeamDeepLinks {
  static StreamSubscription<String?>? _sub;

  /// Call once from main.dart after the navigator is ready.
  static Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    // ── 1. Handle the cold-start link (app was not running) ─────
    // try {
    //   final initial = await getInitialLink();
    //   if (initial != null) {
    //     _navigate(navigatorKey, initial);
    //   }
    // } catch (_) {
    //   // Silently ignore malformed URIs on cold start.
    // }
    //
    // // ── 2. Listen for links while the app is already running ────
    // _sub = linkStream.listen(
    //   (link) {
    //     if (link != null) _navigate(navigatorKey, link);
    //   },
    //   onError: (_) {/* ignore stream errors */},
    // );
  }

  /// Cancel the stream subscription — call from your root widget's dispose.
  static void dispose() => _sub?.cancel();

  // ── Internal ──────────────────────────────────────────────────

  static void _navigate(
    GlobalKey<NavigatorState> navigatorKey,
    String rawLink,
  ) {
    final uri = Uri.tryParse(rawLink);
    if (uri == null) return;

    // outfitai://team/{id}
    if (uri.scheme == 'outfitai' &&
        uri.host == 'team' &&
        uri.pathSegments.isNotEmpty) {
      final slug = uri.pathSegments.first;
      final member = TeamData.findById(slug);
      if (member == null) return;

      final ctx = navigatorKey.currentContext;
      if (ctx == null) return;

      Navigator.of(ctx).push(
        SlideRoute(page: TeamMemberScreen(member: member)),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// SlideRoute — copied here so this file compiles independently.
// In the real project, import from your routing package instead.
// ---------------------------------------------------------------------------
class SlideRoute<T> extends PageRouteBuilder<T> {
  SlideRoute({required Widget page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 380),
        );
}
