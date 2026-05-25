

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/animations/slide_naviagation.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart' show Sp;
import '../../../../core/utils/app_texts.dart';

class  ShimmerList extends StatefulWidget {
  final double hPad;
  const ShimmerList({required this.hPad});

  @override
  State<ShimmerList> createState() => _ShimmerListState();
}

class _ShimmerListState extends State<ShimmerList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _shimmer = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: EdgeInsets.fromLTRB(widget.hPad, 0, widget.hPad, Sp.xl),
    itemCount: 6,
    separatorBuilder: (_, __) => const SizedBox(height: Sp.sm),
    itemBuilder: (_, __) => AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) => _ShimmerCard(progress: _shimmer.value),
    ),
  );
}

class _ShimmerCard extends StatelessWidget {
  final double progress;
  const _ShimmerCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final color = Color.lerp(AppColors.surfaceAlt, AppColors.divider, progress)!;
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
    );
  }
}