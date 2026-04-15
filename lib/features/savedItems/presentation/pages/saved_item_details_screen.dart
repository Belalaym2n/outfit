import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/sharedWidgets/animations/bg_animation.dart';
import 'package:graduation_proj/features/savedItems/presentation/pages/saved_items_presentation.dart';

import '../../../../core/utils/app_colors.dart';


class OutfitDetailsScreen extends StatefulWidget {
  const OutfitDetailsScreen({
    super.key,
    required this.outfit,
    required this.dark,
  });
  final OutfitModel outfit;
  final bool        dark;

  @override
  State<OutfitDetailsScreen> createState() => _OutfitDetailsScreenState();
}

class _OutfitDetailsScreenState extends State<OutfitDetailsScreen>
    with TickerProviderStateMixin {

  late final AnimationController _detailCtrl;
  late final AnimationController _btnCtrl;

  late final Animation<double> _bgFade;
  late final Animation<double> _viewerFade;
  late final Animation<Offset>  _viewerSlide;
  late final Animation<double> _contentFade;
  late final List<Animation<double>> _pieceFades;
  late final List<Animation<Offset>>  _pieceSlides;

  late final Animation<double> _btnScale;

  // 3D viewer drag state
  double _rotateY = 0;
  double _rotateX = 0;
  Offset _dragStart = Offset.zero;

  bool _savedLocal = true;

  @override
  void initState() {
    super.initState();
    _savedLocal = true;
    _initControllers();
    _initAnimations();
    _detailCtrl.forward();
  }

  void _initControllers() {
    _detailCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400),
    );
    _btnCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 220),
    );
  }

  void _initAnimations() {
    Animation<double> fade(double s, double e) => CurvedAnimation(
      parent: _detailCtrl,
      curve: Interval(s, e, curve: Curves.easeOut),
    );
    Animation<Offset> slide(double s, double e,
        {Offset from = const Offset(0, 0.10)}) =>
        Tween<Offset>(begin: from, end: Offset.zero).animate(
            CurvedAnimation(parent: _detailCtrl,
                curve: Interval(s, e, curve: Curves.easeOutCubic)));

    _bgFade      = fade(0.00, 0.35);
    _viewerFade  = fade(0.05, 0.42);
    _viewerSlide = slide(0.05, 0.42, from: const Offset(0, 0.08));
    _contentFade = fade(0.30, 0.60);

    final n = widget.outfit.pieces.length;
    _pieceFades  = List.generate(n,
            (i) => fade( 0.40 + i * 0.06, (0.66 + i * 0.06).clamp(0, 1)));
    _pieceSlides = List.generate(n,
            (i) => slide(0.40 + i * 0.06, (0.66 + i * 0.06).clamp(0, 1),
            from: const Offset(0.06, 0)));

    _btnScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.94), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.94, end: 1.02), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _detailCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails d) {
    _dragStart = d.localPosition;
  }

  void _onDragUpdate(DragUpdateDetails d) {
    final dx = d.localPosition.dx - _dragStart.dx;
    final dy = d.localPosition.dy - _dragStart.dy;
    setState(() {
      _rotateY = (dx * 0.015).clamp(-0.4, 0.4);
      _rotateX = (-dy * 0.010).clamp(-0.25, 0.25);
    });
    _dragStart = d.localPosition;
  }

  void _onDragEnd(DragEndDetails _) {
    setState(() { _rotateY = 0; _rotateX = 0; });
  }

  @override
  Widget build(BuildContext context) {
    final dark   = widget.dark;
    final outfit = widget.outfit;
    final mq     = MediaQuery.of(context);
    final hPad   = mq.size.width >= 600 ? 32.0 : 20.0;
    final textHigh = dark ? AppColors.textHigh : LT.textHigh;
    final textMid  = dark ? AppColors.textMid  : LT.textMid;

    return Scaffold(
      backgroundColor: dark ? AppColors.bg1 : LT.bg1,
      body: Stack(children: [

        // Background
        FadeTransition(
          opacity: _bgFade,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end:   Alignment.bottomRight,
                colors: dark
                    ? [AppColors.bg1, AppColors.bg2, AppColors.bg3]
                    : [LT.bg1, LT.bg2, LT.bg3],
              ),
            ),
          ),
        ),

        // const _GrainOverlay(),

        SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
 
              // ── Nav
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _bgFade,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: hPad, vertical: 12),
                    child: Row(children: [
                      _GlassBtn(
                        icon: Icons.arrow_back_ios_new_rounded,
                        dark: dark,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      _GlassBtn(
                        icon: Icons.ios_share_rounded,
                        dark: dark,
                        onTap: () {},
                      ),
                    ]),
                  ),
                ),
              ),

              // ── 3D Outfit Viewer
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _viewerFade,
                  child: SlideTransition(
                    position: _viewerSlide,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: _OutfitViewer3D(
                        outfit:    outfit,
                        rotateX:   _rotateX,
                        rotateY:   _rotateY,
                        onDragStart:  _onDragStart,
                        onDragUpdate: _onDragUpdate,
                        onDragEnd:    _onDragEnd,
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 28)),

              // ── Name + tags
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _contentFade,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(outfit.brand,
                            style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600,
                              color: dark ? AppColors.accent : LT.accent,
                              letterSpacing: 1.4,
                            )),
                        const SizedBox(height: 4),
                        Text(outfit.name,
                            style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700,
                              color: textHigh, letterSpacing: -1.0, height: 1.1,
                            )),

                        const SizedBox(height: 12),

                        // Tags
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: outfit.tags.map((t) => _TagChip(
                              label: t, dark: dark)).toList(),
                        ),

                        const SizedBox(height: 20),

                        // Fabric info
                        _InfoRow(
                          label: 'Fabric',
                          value: outfit.fabric,
                          dark: dark,
                        ),

                        const SizedBox(height: 16),

                        // Color palette
                        _SectionHeader(label: 'Colour Palette', dark: dark),
                        const SizedBox(height: 10),
                        Row(
                          children: outfit.colorHex.map((c) =>
                              _ColorChip(color: c)).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Pieces breakdown
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _contentFade,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: _SectionHeader(
                        label: 'Outfit Pieces', dark: dark),
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (_, i) => FadeTransition(
                      opacity: _pieceFades[i],
                      child: SlideTransition(
                        position: _pieceSlides[i],
                        child: _PieceCard(
                          piece: outfit.pieces[i],
                          dark:  dark,
                        ),
                      ),
                    ),
                    childCount: outfit.pieces.length,
                  ),
                ),
              ),

              // ── Score + CTA
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _pieceFades.last,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 28, hPad,
                        mq.padding.bottom + 24),
                    child: Column(children: [
                      // Score row
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: dark ? AppColors.cardBg : LT.cardBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: dark ? AppColors.cardBorder : LT.cardBorder),
                        ),
                        child: Row(children: [
                          Text('AI Style Score',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600,
                                  color: textHigh)),
                          const Spacer(),
                          Text('${outfit.score}',
                              style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w800,
                                color: dark ? AppColors.accent : LT.accent,
                                letterSpacing: -1.0,
                              )),
                          Text(' / 100',
                              style: TextStyle(
                                  fontSize: 14, color: textMid)),
                        ]),
                      ),

                      const SizedBox(height: 16),

                      // Save / unsave CTA
                      ScaleTransition(
                        scale: _btnScale,
                        child: GestureDetector(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            setState(() => _savedLocal = !_savedLocal);
                            await _btnCtrl.forward();
                            _btnCtrl.reset();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 280),
                            height: 56,
                            decoration: BoxDecoration(
                              color: _savedLocal
                                  ? (dark ? AppColors.savedRed : LT.savedRed)
                                  : (dark ? AppColors.cardBg : LT.cardBg),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _savedLocal
                                    ? Colors.transparent
                                    : (dark ? AppColors.cardBorder : LT.cardBorder),
                              ),
                              boxShadow: _savedLocal ? [
                                BoxShadow(
                                  color: (dark ? AppColors.savedRed : LT.savedRed)
                                      .withOpacity(0.30),
                                  blurRadius: 20,
                                  offset: const Offset(0, 7),
                                ),
                              ] : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _savedLocal
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: _savedLocal
                                      ? Colors.white
                                      : textMid,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _savedLocal
                                        ? Colors.white
                                        : textMid,
                                  ),
                                  child: Text(_savedLocal
                                      ? 'Saved to Collection'
                                      : 'Save to Collection'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
// ─────────────────────────────────────────────────────────────
class _PieceCard extends StatelessWidget {
  const _PieceCard({required this.piece, required this.dark});
  final PieceModel piece;
  final bool       dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? AppColors.cardBg : LT.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dark ? AppColors.cardBorder : LT.cardBorder),
      ),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: (dark ? AppColors.glassWhite : LT.glassWhite),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: dark ? AppColors.glassBorder : LT.glassBorder),
          ),
          child: Icon(piece.icon, size: 17,
              color: dark ? AppColors.textMid : LT.textMid),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(piece.type,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: dark ? AppColors.textLow : LT.textLow, letterSpacing: 1.0)),
          const SizedBox(height: 2),
          Text(piece.name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                  color: dark ? AppColors.textHigh : LT.textHigh)),
        ]),
        const Spacer(),
        Icon(Icons.chevron_right_rounded,
            size: 18, color: dark ? AppColors.textLow : LT.textLow),
      ]),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.dark});
  final String label;
  final bool   dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: dark ? AppColors.glassWhite : LT.glassWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: dark ? AppColors.glassBorder : LT.glassBorder),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
              color: dark ? AppColors.textMid : LT.textMid)),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 28, height: 28,
    margin: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
      boxShadow: [BoxShadow(
        color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: -2,
      )],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.dark});
  final String label, value;
  final bool   dark;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label,
          style: TextStyle(fontSize: 13, color: dark ? AppColors.textMid : LT.textMid)),
      const Spacer(),
      Text(value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
              color: dark ? AppColors.textHigh : LT.textHigh)),
    ]);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.dark});
  final String label;
  final bool   dark;

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: TextStyle(
      fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.4,
      color: dark ? AppColors.textLow : LT.textLow,
    ),
  );
}

class _GlassBtn extends StatelessWidget {
  const _GlassBtn({required this.icon, required this.dark, required this.onTap});
  final IconData icon;
  final bool     dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: dark ? AppColors.glassWhite : LT.glassWhite,
            shape: BoxShape.circle,
            border: Border.all(
                color: dark ? AppColors.glassBorder : LT.glassBorder),
          ),
          child: Icon(icon, size: 17,
              color: dark ? AppColors.textHigh : LT.textHigh),
        ),
      ),
    ),
  );
}


class _OutfitViewer3D extends StatelessWidget {
  const _OutfitViewer3D({
    required this.outfit,
    required this.rotateX,
    required this.rotateY,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final OutfitModel outfit;
  final double rotateX, rotateY;
  final GestureDragStartCallback  onDragStart;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback    onDragEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart:  onDragStart,
      onPanUpdate: onDragUpdate,
      onPanEnd:    onDragEnd,
      child: Column(children: [

        // Main 3D viewer
        AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          height: 280,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(rotateX)
              ..rotateY(rotateY),
            child: Stack(children: [

              // Outfit color panel
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end:   Alignment.bottomRight,
                      colors: outfit.colorHex.length >= 2
                          ? outfit.colorHex.sublist(0, 2)
                          : [outfit.colorHex.first, outfit.colorHex.first.withOpacity(0.5)],
                    ),
                  ),
                  child: Stack(children: [

                    // Spotlight glow
                    Positioned(
                      top: -40, left: -20, right: -20,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          boxShadow: [BoxShadow(
                            color: Colors.white.withOpacity(0.12),
                            blurRadius: 80,
                            spreadRadius: 20,
                          )],
                        ),
                      ),
                    ),

                    // Light reflection strip
                    Positioned(
                      top: 20,
                      left: 40 + rotateY * 50,
                      child: Container(
                        width: 60, height: 260,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end:   Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Center icon
                    Center(
                      child: Opacity(
                        opacity: 0.22,
                        child: Icon(
                          Icons.dry_cleaning_rounded,
                          size: 100, color: Colors.white,
                        ),
                      ),
                    ),

                    // Drag hint
                    Positioned(
                      bottom: 14,
                      left: 0, right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.30),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.rotate_90_degrees_ccw_rounded,
                                  size: 12, color: Colors.white60),
                              SizedBox(width: 5),
                              Text('Drag to rotate',
                                  style: TextStyle(fontSize: 11,
                                      color: Colors.white60)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
        ),

        // 3D shadow below
        AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: outfit.colorHex.first.withOpacity(0.25),
                blurRadius: 24 + rotateX.abs() * 10,
                spreadRadius: -4,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

