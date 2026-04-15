//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../core/sharedWidgets/text_styles.dart';
// import '../../core/utils/app_colors.dart';
// class AnimatedNextButton extends StatefulWidget {
//   final String label;
//   final Color color;
//   final VoidCallback onTap;
//
//   const AnimatedNextButton({
//     super.key,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });
//
//   @override
//   State<AnimatedNextButton> createState() => _AnimatedNextButtonState();
// }
//
// class _AnimatedNextButtonState extends State<AnimatedNextButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _pressController;
//   late final Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _pressController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//       reverseDuration: const Duration(milliseconds: 200),
//       lowerBound: 0,
//       upperBound: 1,
//     );
//
//     // Subtle scale-down on press: 1.0 → 0.96
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
//       CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pressController.dispose();
//     super.dispose();
//   }
//
//   void _onTapDown(TapDownDetails _) {
//     HapticFeedback.lightImpact();
//     _pressController.forward();
//   }
//
//   void _onTapUp(TapUpDetails _) {
//     _pressController.reverse();
//     widget.onTap();
//   }
//
//   void _onTapCancel() => _pressController.reverse();
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _scaleAnimation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: child,
//         );
//       },
//       child: GestureDetector(
//         onTapDown: _onTapDown,
//         onTapUp: _onTapUp,
//         onTapCancel: _onTapCancel,
//         child: Container(
//           width: double.infinity,
//           height: 56,
//           decoration: BoxDecoration(
//             color: widget.color,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: widget.color.withOpacity(0.4),
//                 blurRadius: 16,
//                 offset: const Offset(0, 6),
//               ),
//               BoxShadow(
//                 color: AppColors.shadowColor,
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           alignment: Alignment.center,
//           child: Text(widget.label, style: AppTextStyles.button),
//         ),
//       ),
//     );
//   }
// }