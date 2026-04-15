import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'config/routes/app_router.dart';
import 'core/apiManager/dio_client.dart';
import 'core/cahsing/app_storage_service.dart';
import 'core/intialization/init_di.dart';
import 'core/services/deep_link_helper.dart';
import 'main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDI();
  DioClient.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await DeepLinkService.instance.init(appRouter);
  await GetStorage.init();
  
  await AppStorageService.instance.init();

  runApp(MyApp());
}
