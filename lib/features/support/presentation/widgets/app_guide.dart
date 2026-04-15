
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';
import 'package:graduation_proj/features/support/presentation/widgets/fade_slide_in.dart';
import 'package:graduation_proj/features/support/presentation/widgets/nav_bar.dart' show NavBar;
import 'package:graduation_proj/features/support/presentation/widgets/scale_button.dart';

import '../../../../core/sharedWidgets/widgets/premim_card.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_texts.dart';


// ═══════════════════════════════════════════════════════
class AppGuideScreen extends StatelessWidget {
  const AppGuideScreen({super.key});

  static const _steps = [
    _StepData(
      icon: Icons.upload_file_outlined,
      title: 'Upload Your Outfit',
      description:
      'Take a photo or select from your gallery. Our system accepts any angle.',
    ),
    _StepData(
      icon: Icons.auto_awesome_outlined,
      title: 'AI Analyzes Style Harmony',
      description:
      'Advanced vision models evaluate color theory, proportions, and seasonal fit.',
    ),
    _StepData(
      icon: Icons.equalizer_outlined,
      title: 'Get Compatibility Score',
      description:
      'Receive a nuanced score across five fashion dimensions with clear explanations.',
    ),
    _StepData(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Improve with Smart Suggestions',
      description:
      'Personalized recommendations to elevate your look — one step at a time.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(

      padding: const EdgeInsets.fromLTRB(20, 28, 20, 48),
      sliver: SliverList(
        delegate: SliverChildListDelegate([

          ...List.generate(_steps.length, (i) {
            return FadeSlideIn(
              delay: Duration(milliseconds: 200 + i * 100),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _StepCard(step: _steps[i], number: i + 1),
              ),
            );
          }),

          const SizedBox(height: 24),


          const SizedBox(height: 24),

          FadeSlideIn(
            delay: const Duration(milliseconds: 700),
            child: ScaleButton(

              label: 'Start Your First Analysis',
              icon: Icons.arrow_forward_rounded,
              onTap: () {},
            ),
          ),

        ]),
      ),
    );
  }
}

class _StepData {
  final IconData icon;
  final String title;
  final String description;
  const _StepData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _StepCard extends StatelessWidget {
  final _StepData step;
  final int number;
  const _StepCard({required this.step, required this.number});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number badge
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(step.icon, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('$number',
                            style: const TextStyle(
                                color: AppColors.primaryColor, fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: AppConstants.w*0.5,
                      child: Text(step.title,
                          style: T.heading.copyWith(fontSize: 16,overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(step.description, style: T.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}