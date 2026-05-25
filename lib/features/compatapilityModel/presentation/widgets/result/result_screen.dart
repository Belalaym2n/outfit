import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/features/compatapilityModel/presentation/manager/outfit_bloc.dart';
import 'package:graduation_proj/features/compatapilityModel/presentation/manager/outfit_states.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../data/models/outfite_response_model.dart';
import '../feedback/feedback_card.dart';
import '../problemSection/problem_section.dart';
import '../problemSection/retery_button.dart';
import '../score/score_section.dart';
import 'result_header.dart';
import 'result_nav_bar.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.result});

  /// The parsed API response passed from the upload screen
  final OutfitResponseModel result;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _scoreCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _btnCtrl;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _scoreCircleScale;
  late final Animation<double> _scoreProgress;
  late final Animation<double> _feedbackFade;
  late final Animation<Offset> _feedbackSlide;
  late final Animation<double> _problemFade;
  late final Animation<Offset> _problemSlide;
  late final Animation<double> _ctaFade;
  late final Animation<Offset> _ctaSlide;
  late final Animation<int> _scoreCounter;
  late final Animation<double> _pulseScale;
  late final Animation<double> _btnScale;

  double get _finalScore => widget.result.originalScore;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _entranceCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _scoreCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) _pulseCtrl.repeat(reverse: true);
    });
  }

  void _setupControllers() {
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _scoreCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
  }
  double get _finalScorePercent =>
      widget.result.improvedScore>=widget.result.originalScore?

      widget.result.improvedScore * 100:
      widget.result.originalScore * 100;
  void _setupAnimations() {

    Animation<double> fade(double s, double e) => CurvedAnimation(
      parent: _entranceCtrl,
      curve: Interval(s, e, curve: Curves.easeOut),
    );
    Animation<Offset> slide(
      double s,
      double e, {
      Offset from = const Offset(0, 0.15),
    }) => Tween<Offset>(begin: from, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: Interval(s, e, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = fade(0.00, 0.30);
    _headerSlide = slide(0.00, 0.30, from: const Offset(0, 0.12));
    _scoreCircleScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.10, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _scoreProgress = Tween<double>(
      begin: 0.0,
      end: _finalScorePercent /100,
    ).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
      ),
    );
    _feedbackFade = fade(0.38, 0.65);
    _feedbackSlide = slide(0.38, 0.65);
    _problemFade = fade(0.52, 0.78);
    _problemSlide = slide(0.52, 0.78);
    _ctaFade = fade(0.72, 1.0);
    _ctaSlide = slide(0.72, 1.0, from: const Offset(0, 0.08));
    final int scorePercent = (_finalScore * 100).toInt();

    _scoreCounter = IntTween(
      begin: 0,
      end: _finalScorePercent.toInt(),
    ).animate(
      CurvedAnimation(
        parent: _scoreCtrl,
        curve: Curves.easeOut,
      ),
    );
    _pulseScale = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _btnScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.02), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));
  }

  Future<void> _onRetry() async {
    HapticFeedback.lightImpact();
    await _btnCtrl.forward();
    _btnCtrl.reset();
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _scoreCtrl.dispose();
    _pulseCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.width >= 600;
    final hPad = isTablet ? 40.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: ResultNavBar(hPad: hPad)),
            SliverToBoxAdapter(
              child: ResultHeader(
                hPad: hPad,
                headerFade: _headerFade,
                headerSlide: _headerSlide,
                isCompatible: widget.result.isCompatible,
              ),
            ),
            SliverToBoxAdapter(
              child: ScoreSection(
                improvedScore: widget.result.improvedScore,
                originalScore: widget.result.originalScore,
                hPad: hPad,
                circleScale: _scoreCircleScale,
                progress: _scoreProgress,
                counter: _scoreCounter,
                pulseScale: _pulseScale,
                // improvedScore: widget.result.improvedScore,
              ),
            ),
            SliverToBoxAdapter(
              child: FadeSlide(
                fade: _feedbackFade,
                slide: _feedbackSlide,
                child: FeedbackCard(
                  hPad: hPad,

                  highlights: widget.result.highlights
                      .map((e) => e.toInt())
                      .toList(),                isCompatible: widget.result.isCompatible,
                ),
              ),
            ),
            // Render one ProblemSection per replacement suggestion
            // if (widget.result.replacements.isNotEmpty)
            //   ...widget.result.replacements.entries.map(
            //     (entry) => SliverToBoxAdapter(
            //       child: FadeSlide(
            //         fade: _problemFade,
            //         slide: _problemSlide,
            //         child:ProblemSection(
            //           currentImage: ,
            //           hPad: hPad,
            //           itemLabel:entry.key=="Shoe"?"Shoes": entry.key,
            //           base64Image: entry.value,
            //           suggestion: "Outfix AI Suggestion",
            //         ),
            //       ),
            //     ),
            //   ),

            showIssueDetected(hPad),
            SliverToBoxAdapter(
              child: FadeSlide(
                fade: _ctaFade,
                slide: _ctaSlide,
                child: RetryButton(
                  hPad: hPad,
                  scale: _btnScale,
                  onTap: _onRetry,
                  safeBot: mq.padding.bottom,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  showIssueDetected(double hPad) {
    final bloc = context.read<OutfitBloc>(); // 🔥 هنا
    final images = bloc.state.images;

    return SliverList(
      delegate: SliverChildListDelegate(
        widget.result.replacements.entries.map((entry) {

          final index = _getIndexFromLabel(entry.key);

          Uint8List? currentImage;
          final file = images[index];

          if (file != null) {
            currentImage = File(file.path).readAsBytesSync();
          }

          return FadeSlide(
            fade: _problemFade,
            slide: _problemSlide,
            child: ProblemSection(
              currentImage: currentImage,       // من bloc
              base64Image: entry.value,         // 🔥 من .value
              hPad: hPad,
              itemLabel: entry.key == "Shoe" ? "Shoes" : entry.key,
              suggestion: "Outfix AI Suggestion",
            ),
          );
        }).toList(),
      ),
    );
  }   int _getIndexFromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'top':
        return 0;
      case 'bottom':
        return 1;
      case 'shoes':
      case 'shoe':
        return 2;
      case 'bag':
        return 3;
      default:
        return 4;
    }
  }
}
