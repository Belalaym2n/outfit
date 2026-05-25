
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:graduation_proj/core/sharedWidgets/Buttons/primary_buttons.dart';
import 'package:graduation_proj/core/sharedWidgets/widgets/app_name.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/pages/fake.dart';

import '../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../core/sharedWidgets/bg_screen.dart';
import '../../../core/sharedWidgets/text_styles.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../compatapilityModel/presentation/pages/request_to_recommend.dart' hide T;
   import '../../recommendedItem/presentation/pages/outfit_items_page.dart';
import '../../recommendedItem/presentation/widgets/fullOutfit/full_outfit_item.dart';
import '../data/models/feature_models.dart';
import '../widgets/header_section.dart';
import '../widgets/screenItems/feature_section.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key, required this.zoomDrawerController});

  ZoomDrawerController zoomDrawerController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final AnimationController _buttonController;

  // Entrance animations (all Interval-driven from one controller)
  late final Animation<double> _badgeFade;
  late final Animation<Offset> _badgeSlide;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _ctaFade;
  late final Animation<Offset> _ctaSlide;
  late final List<Animation<double>> _cardFades;
  late final List<Animation<Offset>> _cardSlides;

  // Ambient pulse
  late final Animation<double> _ambientScale;
  late final Animation<double> _ambientOpacity;

  // Button press
  late final Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
    _entranceController.forward();
  }

  void _initControllers() {
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
  }

  // ── Background float ─────────────────────────────────────────
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  void _initAnimations() {
    // Helper closures keep the init block concise
    Animation<double> fade(double s, double e) => CurvedAnimation(
      parent: _entranceController,
      curve: Interval(s, e, curve: Curves.easeOut),
    );

    Animation<Offset> slide(
      double s,
      double e, {
      Offset from = const Offset(0, 0.18),
    }) => Tween<Offset>(begin: from, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Interval(s, e, curve: Curves.easeOutCubic),
      ),
    );

    // Staggered entrance — intervals offset by ~0.12 steps
    _badgeFade = fade(0.00, 0.35);
    _badgeSlide = slide(0.00, 0.35);
    _headlineFade = fade(0.12, 0.50);
    _headlineSlide = slide(0.12, 0.50, from: const Offset(0, 0.14));
    _subtitleFade = fade(0.28, 0.62);
    _subtitleSlide = slide(0.28, 0.62, from: const Offset(0, 0.12));
    _ctaFade = fade(0.42, 0.74);
    _ctaSlide = slide(0.42, 0.74, from: const Offset(0, 0.10));

    // Cards stagger 0.08 apart
    _cardFades = List.generate(
      3,
      (i) => fade(0.55 + i * 0.08, 0.80 + i * 0.08),
    );
    _cardSlides = List.generate(
      3,
      (i) =>
          slide(0.55 + i * 0.08, 0.80 + i * 0.08, from: const Offset(0, 0.12)),
    );

    // Ambient breath
    _ambientScale = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _ambientOpacity = Tween<double>(begin: 0.04, end: 0.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Button: compress -> overshoot -> settle
    _buttonScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.02), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 30),
        ]).animate(
          CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
        );

    _bg1 = Tween<double>(begin: -14, end: 14).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bg2 = Tween<double>(begin: 10, end: -10).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _onCtaTap() async {
    HapticFeedback.lightImpact();
    await _buttonController.forward();
    _buttonController.reset();
    // TODO: Navigate to analysis screen
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _buttonController.dispose();
    super.dispose();
  }
  // List<FullOutfitModel> _outfits = FullOutfitModel.samples;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.width >= 600;
    final hPad = isTablet ? 48.0 : 24.0;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.bg,
        toolbarHeight: 0,
        elevation: 0,

      ),
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Ambient background
          AmbientBg(float1: _bg1, float2: _bg2),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _TopBar(hPad: hPad)),
              //
              SliverToBoxAdapter(
                child: HeaderSection(
                  hPad: hPad,
                  badgeFade: _badgeFade,
                  badgeSlide: _badgeSlide,
                  headlineFade: _headlineFade,
                  headlineSlide: _headlineSlide,
                  subtitleFade: _subtitleFade,
                  subtitleSlide: _subtitleSlide,
                  ctaFade: _ctaFade,
                  ctaSlide: _ctaSlide,
                  buttonScale: _buttonScale,
                  onCtaTap: _onCtaTap,
                ),
              ),

              // Divider
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: Sp.lg,
                  ),
                  child: const _HairlineDivider(),
                ),
              ),

              // Section label
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _cardFades[0],
                  child: Padding(
                    padding: EdgeInsets.only(left: hPad, bottom: Sp.sm),
                    child:   Text('CAPABILITIES', style:  T.caption),
                  ),
                ),
              ),

              // Feature cards
              SliverToBoxAdapter(
                child: FeaturesSection(
                  hPad: hPad,
                  cardFades: _cardFades,
                  cardSlides: _cardSlides,
                  isTablet: isTablet,
                ),
              ),

              SliverToBoxAdapter(
                child: const SizedBox(height: 60),
              ),

              SliverToBoxAdapter(
                child: const SizedBox(height: 60),
              ),
              // // SliverToBoxAdapter(
              // //   child:      FullOutfitShowcase(
              // //     outfits: OutfitStaticData.all,
              // //     onSaveToggle: (id) => setState(() {
              // //       final idx = _outfits.indexWhere((e) => e.id == id);
              // //       if (idx != -1) _outfits[idx].saved = !_outfits[idx].saved;
              // //     }),
              // //   ),
              // // ),


              SliverToBoxAdapter(
                child: const OutfitItemsPage(),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(height: 100),
              ),],
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.hPad});

  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: Sp.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Wordmark(),
          _IconBtn(
            icon: Icons.menu_rounded,
            onTap: () {
              ZoomDrawer.of(context)?.toggle();
            },
          ),
        ],
      ),
    );
  }
}

class _HairlineDivider extends StatelessWidget {
  const _HairlineDivider();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.surface3);
}




class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Icon(icon, color: AppColors.white, size: 20),
    ),
  );
}
