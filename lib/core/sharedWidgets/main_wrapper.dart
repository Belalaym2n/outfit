
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'offline_network.dart';



class MainWrapper extends StatelessWidget {
  final Widget childWidget;

  const MainWrapper({required this.childWidget, super.key});

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
          BuildContext context,
          List<ConnectivityResult> connectivity,
          Widget child,
          ) {
        final bool connected = !connectivity.contains(ConnectivityResult.none);
        return connected
            ? childWidget
            : OfflineNetwork();
      },
      child: childWidget,

    );
  }
}
