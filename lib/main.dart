import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/routes/app_router.dart';
import 'core/apiManager/dio_client.dart';
import 'core/intialization/init_di.dart';
import 'core/services/deep_link_helper.dart';
import 'core/sharedWidgets/loading/app_loader_constroller.dart';
import 'core/sharedWidgets/loading/app_loader_constroller.dart';
import 'core/utils/app_colors.dart';
import 'core/utils/app_constants.dart';
import 'package:device_preview/device_preview.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConstants.initSize(context);
    return MaterialApp.router(
      routerConfig: appRouter,
      // navigatorKey: AppLoadingController.navigatorKey,

      theme: ThemeData(
        brightness: Brightness.light,
         highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      // initialRoute: "/",
      // onGenerateRoute: (settings) => Routes.onGenerate(settings),
    );
  }
}
