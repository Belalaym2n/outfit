 import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graduation_proj/core/debugSystem/logs/app_logger.dart';
import 'config/routes/app_router.dart';
import 'core/apiManager/dio_client.dart';
import 'core/cahsing/app_storage_service.dart';
import 'core/debugSystem/observer/bloc_observer.dart';
import 'core/debugSystem/report/observability_service.dart';
import 'core/intialization/init_di.dart';
import 'core/services/deep_link_helper.dart';
import 'firebase_options.dart';
import 'main.dart';

 Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

   // 🟢 1. Firebase
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );

   // 🟢 2. Observability (لازم بدري)
   await ObservabilityService.instance.initialize();

   // 🟢 3. Dependency Injection
   initDI();

   // 🟢 4. Dio
   await DioClient.init();

   // 🟢 5. Bloc Observer 🔥
   Bloc.observer = AppBlocObserver();

   // 🟢 6. Catch Flutter errors 🔥
   FlutterError.onError = (details) {
     log.fatal(
       'FlutterError',
       details.exceptionAsString(),
       error: details.exception,
       st: details.stack,
     );
   };

   // 🟢 7. Catch async errors 🔥
   PlatformDispatcher.instance.onError = (error, stack) {
     AppLogger.instance.fatal(
       'AsyncError',
       'Unhandled async error',
       error: error,
       st: stack,
     );
     return true;
   };

   // UI configs
   SystemChrome.setSystemUIOverlayStyle(
     const SystemUiOverlayStyle(
       statusBarColor: Colors.transparent,
       statusBarIconBrightness: Brightness.light,
     ),
   );

   await SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
   ]);

   await GetStorage.init();
   await AppStorageService.instance.init();

   await DeepLinkService.instance.init(appRouter);

   runApp(  MyApp() );
   // runApp( DevicePreview(
   //     enabled: !kReleaseMode,
   //     builder: (context) =>MyApp()));
 }