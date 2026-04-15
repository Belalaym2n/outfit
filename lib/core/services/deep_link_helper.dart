import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService instance = DeepLinkService._();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  GoRouter? _router;

  Future<void> init(GoRouter router) async {
    _router = router;

     final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      debugPrint('[DeepLinkService] cold-start: $initialUri');
      _navigate(initialUri);
    }

    // App already running, new link arrives
    _sub = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('[DeepLinkService] warm-start: $uri');
      _navigate(uri);
    }, onError: (e) => debugPrint('[DeepLinkService] error: $e'));
  }

  void _navigate(Uri uri) {
    debugPrint('Incoming URI: $uri');

    String? memberId;

    // ✅ custom scheme
    if (uri.scheme == 'outfitai' && uri.host == 'member') {
      memberId = uri.pathSegments.isNotEmpty
          ? Uri.decodeComponent(uri.pathSegments.first)
          : null;
    }

    if (memberId != null && memberId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _router?.go('/member/$memberId');
      });
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _router = null;
  }
}
