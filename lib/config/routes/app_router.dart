import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_proj/features/bottom_nav/bottom_nav.dart';
import 'package:graduation_proj/features/login/presentation/pages/auto_login.dart';

import '../../features/login/presentation/pages/login_screen.dart';
import '../../features/onBoarding/on_boarding_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/signUp/presentation/pages/create_acc.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/teamMember/page/member_link_stream.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const bottomNav = '/main';

  static const login = '/login';
  static const autoLogin = '/autoLogin';
  static const signUp = '/signup';
  static const onBoard = '/onboarding';

  static const profile = '/profile';
  static const notification = '/notification';

  static const addLoad = '/add-load';
  static const loadDetails = '/load-details';

  static const problems = '/problems';
  static const forgetPassword = '/forget-password';
  static const support = '/support';

  // dynamic
  static const member = '/member/:id';

  static String memberPath(String id) => '/member/$id';
}
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,

  routes: [
    /// Splash
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),



    /// Auth
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.autoLogin,
      builder: (context, state) => const AutoLogin(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),

    /// Main Layout
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const BottomNav(),
    ),

    /// Profile





    /// Deep Link 🔥
    GoRoute(
      path: AppRoutes.member,
      builder: (context, state) {
        final memberId = state.pathParameters['id']!;
        return MemberDeepLinkScreen(memberId: memberId);
      },
    ),
  ],

  /// Error Page
  errorBuilder: (context, state) {

    print("error ${state.error}");
  return   Scaffold
  (
    body: Center(
      child: Text('Route Not Found: ${state.uri}'),
    )
  );}

);