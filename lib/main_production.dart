import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/routes/app_router.dart';
import 'core/apiManager/dio_client.dart';
import 'core/intialization/init_di.dart';
import 'core/services/deep_link_helper.dart';
import 'main.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'config/routes/app_router.dart';
import 'core/apiManager/dio_client.dart';
import 'core/cahsing/app_storage_service.dart';
import 'core/intialization/init_di.dart';
import 'core/services/deep_link_helper.dart';
import 'firebase_options.dart';
import 'main.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initDI();
  DioClient.init();
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarIconBrightness: Brightness.light,
  //   ),
  // );
  // 🔥 قفل الـ rotation هنا
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await DeepLinkService.instance.init(appRouter);
  await GetStorage.init();

  await AppStorageService.instance.init();


  runApp(MyApp());

}
