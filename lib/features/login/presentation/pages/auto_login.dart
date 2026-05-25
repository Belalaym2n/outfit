import 'package:flutter/cupertino.dart';
import '../../../../core/apiManager/dio_client.dart';
 import '../../../../core/services/taken_helper.dart';
import '../../../bottom_nav/bottom_nav.dart';
import 'login_screen.dart';

class AutoLogin extends StatefulWidget {
  const AutoLogin({super.key});

  @override
  State<AutoLogin> createState() => _AutoLoginState();
}

class _AutoLoginState extends State<AutoLogin> {
  String? token;
  bool isLoading = true;

  checkUserLogin() async {
    final storedToken = await DioClient.getToken();

    if (storedToken != null && storedToken.isNotEmpty) {
      final isExpired = TokenHelper.isExpired(storedToken);

      if (!isExpired) {
        token = storedToken;
      } else {
        await DioClient.clearToken();
        token = null;
      }
    } else {
      token = null;
    }

    setState(() {
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
      return const CupertinoActivityIndicator();
    }

    return token != null ? BottomNav() : LoginScreen();
  }
}