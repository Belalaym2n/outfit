// ═══════════════════════════════════════════════════════════════
//  outfit_details_screen.dart  —  FIXED & COMPLETE
//  Uses OutfitItemModel only. Single source of truth = OutfitBloc.
// ═══════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/cahsing/app_storage_service.dart';
import 'package:graduation_proj/core/sharedWidgets/bg_screen.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../savedItems/data/models/saved_item_model.dart';
import '../../data/models/outfit_item_model.dart';
import '../manager/events.dart';
import '../manager/outfit_bloc.dart';
import '../manager/outfit_states.dart';
import '../widgets/fullOutfit/smaill_save_button.dart';
import '../widgets/recommended/info_section.dart';


 class OutfitItemDetailsScreen extends StatelessWidget {
  final OutfitItemModel item;
  const OutfitItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // We read the live item from Bloc state so isSaved is always current.
    return BlocBuilder<OutfitBloc, OutfitState>(
      builder: (context, state) {
        final liveItem = state.items.firstWhere(
              (e) => e.id == item.id,
          orElse: () => item,
        );
        return _OutfitDetailsView(item: liveItem, state: state);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Internal stateful view (handles tilt + stagger animations)
// ═══════════════════════════════════════════════════════════════
class _OutfitDetailsView extends StatefulWidget {
  final OutfitItemModel item;
  final OutfitState state;
  const _OutfitDetailsView({required this.item, required this.state});

  @override
  State<_OutfitDetailsView> createState() => _OutfitDetailsViewState();
}

class _OutfitDetailsViewState extends State<_OutfitDetailsView>
    with TickerProviderStateMixin {

  late final AnimationController _staggerCtrl;

  late final Animation<double> _nameFade, _scoreFade, _descFade, _tagsFade, _btnFade;
  late final Animation<Offset>  _nameSlide, _scoreSlide, _descSlide, _tagsSlide;

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    Animation<double> _fade(double from, double to) =>
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: _staggerCtrl,
            curve: Interval(from, to, curve: Curves.easeOut)));

    Animation<Offset> _slide(double from, double to) =>
        Tween<Offset>(begin: const Offset(0, 0.28), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _staggerCtrl,
                curve: Interval(from, to, curve: Curves.easeOutCubic)));

    _nameFade   = _fade(0.00, 0.38);
    _nameSlide  = _slide(0.00, 0.38);
    _scoreFade  = _fade(0.18, 0.52);
    _scoreSlide = _slide(0.18, 0.52);
    _descFade   = _fade(0.32, 0.66);
    _descSlide  = _slide(0.32, 0.66);
    _tagsFade   = _fade(0.48, 0.78);
    _tagsSlide  = _slide(0.48, 0.78);
    _btnFade    = _fade(0.64, 1.00);

    Future.delayed(const Duration(milliseconds: 280), () {
      if (mounted) _staggerCtrl.forward();
    });
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    super.dispose();
  }

  void _handleSaveToggle(BuildContext context) {
    final bloc       = context.read<OutfitBloc>();
    final saveStatus = bloc.state.saveStatusFor(widget.item.id);
    if (saveStatus == SaveStatus.loading) return; // guard double-tap

    final userId = AppStorageService.instance.getEmail();
    final savedItem = SavedItemModel(
      userId:      userId,
      itemId:      widget.item.id,
      category:    widget.item.categories.isNotEmpty
          ? widget.item.categories.first
          : 'outfit',
      outfitModel: widget.item,
      timestamp:   DateTime.now(),
    );

    if (widget.item.isSaved) {
      bloc.add(UnsaveItemEvent(outfit: savedItem));
    } else {
      bloc.add(SaveItemEvent(outfit: savedItem));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppConstants.initSize(context);

    return Scaffold(

      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            _BackgroundDecor(),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _HeroImageSection(
                    item:          widget.item,
                    saveStatus:    widget.state.saveStatusFor(widget.item.id),
                    onSaveToggle:  () => _handleSaveToggle(context),
                    onBack:        () => Navigator.pop(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: InfoSection(
                    item:         widget.item,
                    staggerCtrl:  _staggerCtrl,
                    nameFade:     _nameFade,   nameSlide:  _nameSlide,
                    scoreFade:    _scoreFade,  scoreSlide: _scoreSlide,
                    descFade:     _descFade,   descSlide:  _descSlide,
                    tagsFade:     _tagsFade,   tagsSlide:  _tagsSlide,
                    btnFade:      _btnFade,
                    saveStatus:   widget.state.saveStatusFor(widget.item.id),
                    onSaveToggle: () => _handleSaveToggle(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Hero image section  —  3D tilt + parallax
// ═══════════════════════════════════════════════════════════════
class _HeroImageSection extends StatefulWidget {
  final OutfitItemModel item;
  final SaveStatus      saveStatus;
  final VoidCallback    onSaveToggle;
  final VoidCallback    onBack;

  const _HeroImageSection({
    required this.item,
    required this.saveStatus,
    required this.onSaveToggle,
    required this.onBack,
  });

  @override
  State<_HeroImageSection> createState() => _HeroImageSectionState();
}

class _HeroImageSectionState extends State<_HeroImageSection>
    with TickerProviderStateMixin {

  double _tiltX = 0.0;
  double _tiltY = 0.0;

  late final AnimationController _springCtrl;
  late Animation<double> _springTiltX;
  late Animation<double> _springTiltY;

  late final AnimationController _badgeCtrl;
  late final Animation<double>   _badgeFade;
  late final Animation<double>   _badgeScale;

  @override
  void initState() {
    super.initState();
    _springCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _springTiltX = Tween<double>(begin: 0, end: 0).animate(_springCtrl);
    _springTiltY = Tween<double>(begin: 0, end: 0).animate(_springCtrl);

    _badgeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _badgeFade  = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOut));
    _badgeScale = Tween<double>(begin: 0.72, end: 1).animate(
        CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOutBack));

    Future.delayed(const Duration(milliseconds: 320),
            () { if (mounted) _badgeCtrl.forward(); });
  }

  @override
  void dispose() {
    _springCtrl.dispose();
    _badgeCtrl.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    final w = AppConstants.w;
    final h = AppConstants.h;
    setState(() {
      _tiltY = (_tiltY + d.delta.dx / (w * 0.5)).clamp(-1.0, 1.0);
      _tiltX = (_tiltX - d.delta.dy / (h * 0.4)).clamp(-1.0, 1.0);
    });
  }

  void _onPanEnd(DragEndDetails _) {
    final fromX = _tiltX;
    final fromY = _tiltY;

    _springTiltX = Tween<double>(begin: fromX, end: 0).animate(
        CurvedAnimation(parent: _springCtrl, curve: Curves.elasticOut));
    _springTiltY = Tween<double>(begin: fromY, end: 0).animate(
        CurvedAnimation(parent: _springCtrl, curve: Curves.elasticOut));

    _springCtrl.reset();

    void _listener() {
      if (mounted) {
        setState(() {
          _tiltX = _springTiltX.value;
          _tiltY = _springTiltY.value;
        });
      }
    }

    _springCtrl.addListener(_listener);
    _springCtrl.forward().whenComplete(() {
      _springCtrl.removeListener(_listener);
      if (mounted) setState(() { _tiltX = 0; _tiltY = 0; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final w      = AppConstants.w;
    final h      = AppConstants.h;
    final imageH = h * 0.52;
    const maxAngle = 5 * math.pi / 180;

    final imageUrl = widget.item.images.isNotEmpty
        ? widget.item.images.first
        : null;

    return SizedBox(
      width:  w,
      height: imageH,
      child: Stack(
        children: [
          // ── 3D tilting image ──────────────────────────────
          GestureDetector(
            onPanUpdate: _onPanUpdate,
            onPanEnd:    _onPanEnd,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0008)
                ..rotateX(_tiltX * maxAngle)
                ..rotateY(-_tiltY * maxAngle),
              alignment: Alignment.center,
              child: Hero(
                tag: 'outfit_img_${widget.item.id}',
                child: Container(
                  width:  w,
                  height: imageH,
                  decoration: BoxDecoration(
                    color:    AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color:      AppColors.ink
                            .withOpacity(0.14 + _tiltY.abs() * 0.06),
                        blurRadius: 32 + _tiltY.abs() * 12,
                        offset:     Offset(_tiltY * 14, 8 + _tiltX * 6),
                      ),
                    ],
                  ),
                  child:  imageUrl != null
                      ? Image.network(
                    imageUrl,
                    fit:        BoxFit.cover,
                    cacheWidth: 600,
                    errorBuilder: (_, __, ___) =>
                        _ImagePlaceholder(w: w),
                  )
                      : _ImagePlaceholder(w: w),
                ),
              ),
            ),
          ),

          // ── Bottom gradient fade ──────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: h * 0.14,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end:   Alignment.topCenter,
                  colors: [AppColors.bg, AppColors.bg.withOpacity(0)],
                ),
              ),
            ),
          ),

          // ── Back button ───────────────────────────────────
          Positioned(
            top:  MediaQuery.of(context).padding.top + 12,
            left: w * 0.04,
            child: _CircleButton(
              icon:  Icons.arrow_back_ios_new_rounded,
              onTap: widget.onBack,
            ),
          ),

          // ── Save button ───────────────────────────────────
          Positioned(
            top:   MediaQuery.of(context).padding.top + 12,
            right: w * 0.04,
            child: SaveButtonWidget(
              saved:     widget.item.isSaved,
              isLoading: widget.saveStatus == SaveStatus.loading,
              onTap:     widget.onSaveToggle,
            ),
          ),

          // ── AI Score badge ────────────────────────────────
          if (widget.item.aiScore > 0)
            Positioned(
              top:   MediaQuery.of(context).padding.top + 68,
              right: w * 0.04,
              child: AnimatedBuilder(
                animation: _badgeCtrl,
                builder: (_, child) => Opacity(
                  opacity: _badgeFade.value,
                  child: Transform.scale(
                      scale: _badgeScale.value, child: child),
                ),
                child: _AiScoreBadge(score: widget.item.aiScore),
              ),
            ),

          // ── Drag hint ─────────────────────────────────────
          Positioned(
            bottom: h * 0.055,
            left: 0, right: 0,
            child: Center(
              child: Text(
                'Drag to tilt',
                style: TextStyle(
                  color:       AppColors.inkSubtle.withOpacity(0.55),
                  fontSize:    w * 0.028,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// ─────────────────────────────────────────────────────────────
//  Small reusable widgets
// ─────────────────────────────────────────────────────────────



class _AiScoreBadge extends StatelessWidget {
  const _AiScoreBadge({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color:        Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.amber, size: 11),
          const SizedBox(width: 3),
          Text(
            score.toStringAsFixed(1),
            style: const TextStyle(
              color:      Colors.white,
              fontSize:   11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


class _CircleButton extends StatefulWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData     icon;
  final VoidCallback onTap;

  @override
  State<_CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<_CircleButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final w    = AppConstants.w;
    final size = w * 0.102;
    return GestureDetector(
      onTapDown:   (_) => setState(() => _scale = 0.90),
      onTapCancel: ()  => setState(() => _scale = 1.0),
      onTapUp:     (_) { setState(() => _scale = 1.0); widget.onTap(); },
      child: AnimatedScale(
        scale:    _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape:  BoxShape.circle,
            color:  AppColors.surface.withOpacity(0.88),
            boxShadow: [
              BoxShadow(
                color:      AppColors.ink.withOpacity(0.10),
                blurRadius: 12,
                offset:     const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(widget.icon, size: size * 0.4, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.w});
  final double w;

  @override
  Widget build(BuildContext context) => Container(
    color:  AppColors.border,
    child:  Center(
      child: Icon(
        Icons.checkroom_outlined,
        size:  w * 0.26,
        color: AppColors.ink.withOpacity(0.12),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  Background decorative blobs (ambient)
// ─────────────────────────────────────────────────────────────
class _BackgroundDecor extends StatefulWidget {
  @override
  State<_BackgroundDecor> createState() => _BackgroundDecorState();
}

class _BackgroundDecorState extends State<_BackgroundDecor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _float;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000))
      ..repeat(reverse: true);
    _float = Tween<double>(begin: -10, end: 10).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;
    return AmbientBg(float1: _ctrl, float2: _float);
  }
}

