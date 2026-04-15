// import 'package:flutter/material.dart';
// import 'package:graduation_proj/features/login/presentation/pages/login_screen.dart';
// import 'on_board_model.dart';
// import 'on_board_page.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   // Single controller — shared across every page widget.
//   final PageController _pageController = PageController();
//
//   // Only used to track the integer page for the "next" logic.
//   // We do NOT call setState inside a scroll listener anymore.
//   int _currentPage = 0;
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _goToNextPage() {
//     if (_currentPage < onboardingPages.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 480),
//         curve: Curves.easeInOutCubic,
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // ── Smooth background color ────────────────────────────────────────────
//     // AnimatedBuilder rebuilds ONLY this ColoredBox subtree, not the whole
//     // scaffold. PageController extends Animation<double>, so it's listenable.
//     return AnimatedBuilder(
//
//       animation: _pageController,
//       builder: (context, child) {
//         final page = _pageController.hasClients
//             ? (_pageController.page ?? 0.0)
//             : 0.0;
//
//         final lower = page.floor().clamp(0, onboardingPages.length - 1);
//         final upper = page.ceil().clamp(0, onboardingPages.length - 1);
//         final t = page - lower;
//
//         final bg = Color.lerp(
//           onboardingPages[lower].backgroundColor,
//           onboardingPages[upper].backgroundColor,
//           t,
//         )!;
//
//         // child is the PageView — built once, never rebuilt by this AnimatedBuilder.
//         return ColoredBox(color: bg, child: child);
//       },
//       // PageView is in the `child` slot so it is NOT rebuilt on every scroll tick.
//       child: PageView.builder(
//
//         controller: _pageController,
//         physics: const BouncingScrollPhysics(),
//         itemCount: onboardingPages.length,
//         onPageChanged: (index) => _currentPage = index, // plain assignment, no setState
//         itemBuilder: (context, index) {
//           return OnboardingPageWidget(
//             // No ValueKey — we no longer want forced rebuilds.
//             data: onboardingPages[index],
//             pageIndex: index,
//             totalPages: onboardingPages.length,
//             pageController: _pageController,
//             onNext: _goToNextPage,
//           );
//         },
//       ),
//     );
//   }
// }