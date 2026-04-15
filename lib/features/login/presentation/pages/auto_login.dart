 import 'package:flutter/cupertino.dart';
import 'package:graduation_proj/features/login/presentation/pages/login_screen.dart';
import 'package:graduation_proj/features/splash/splash_screen.dart';

import '../../../../core/apiManager/dio_client.dart';
import '../../../../core/cahsing/app_keys.dart';
import '../../../../core/cahsing/secure_storage.dart';
import '../../../bottom_nav/bottom_nav.dart';
class AutoLogin extends StatefulWidget {
  const AutoLogin({super.key});

  @override
  State<AutoLogin> createState() => _AutoLoginState();
}

class _AutoLoginState extends State<AutoLogin> {
  late String? userID;
  bool isLoading = true;

  checkUserLogin() async {
    final token = await DioClient.getToken();
    setState(() {
      userID = token;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CupertinoActivityIndicator(); // أو أي لودينج ويدجت يعجبك
    }

    return userID != null ? BottomNav() : LoginScreen();
  }
}
