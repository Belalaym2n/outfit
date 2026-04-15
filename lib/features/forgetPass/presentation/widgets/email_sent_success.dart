
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/sharedWidgets/text_styles.dart' show T;
import '../../../../core/sharedWidgets/text_styles.dart';
import '../../../../core/utils/app_colors.dart';

class EmailSentSuccessView extends StatelessWidget {
  const EmailSentSuccessView({
    required this.scaleAnim,
    required this.fadeAnim,
    required this.onBack,
  });

  final Animation<double> scaleAnim;
  final Animation<double> fadeAnim;
  final VoidCallback      onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.62,
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([scaleAnim, fadeAnim]),
          builder: (_, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Bouncing success icon
              Transform.scale(
                scale: scaleAnim.value,
                child: Container(
                  width: 88, height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.divider, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 24,
                        spreadRadius: -4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mark_email_read_rounded,
                    color: AppColors.textHigh,
                    size: 36,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Animated message text
              Opacity(
                opacity: fadeAnim.value,
                child: Column(
                  children: [
                    const Text(
                      'Check your inbox',
                      style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700,
                        color: AppColors.textHigh, letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Reset link sent successfully.\nFollow the instructions in the email to reset your password.',
                        style: T.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Back to sign in
                    GestureDetector(
                      onTap: onBack,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: AppColors.divider),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Back to Sign In',
                          style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600,
                            color: AppColors.textHigh,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}