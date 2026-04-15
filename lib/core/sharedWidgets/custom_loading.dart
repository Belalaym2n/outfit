 import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomLoadingWidget extends StatefulWidget {
  const CustomLoadingWidget({super.key});

  @override
  State<CustomLoadingWidget> createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 6.3,
            child: Transform.scale(
              scale: 1 + (_controller.value * 0.1),
              child: child,
            ),
          );
        },
        child: Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor:
            AlwaysStoppedAnimation<Color>(AppColors.primaryColor), // لونك الأساسي
          ),
        ),
      ),
    );
  }
}



 class LoadingWidget extends StatelessWidget {
   final String? message;
   final Color? color;
   final double? size;

   const LoadingWidget({
     Key? key,
     this.message,
     this.color,
     this.size,
   }) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Center(
       child: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           SizedBox(
             width: size ?? 40,
             height: size ?? 40,
             child: CircularProgressIndicator(
               strokeWidth: 3,
               valueColor: AlwaysStoppedAnimation<Color>(
                 color ?? Theme.of(context).primaryColor,
               ),
             ),
           ),
           if (message != null) ...[
             const SizedBox(height: 16),
             Text(
               message!,
               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                 color: Colors.grey[600],
               ),
               textAlign: TextAlign.center,
             ),
           ],
         ],
       ),
     );
   }
 }