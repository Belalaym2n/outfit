
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/sharedWidgets/animations/bg_animation.dart';
import 'package:graduation_proj/features/savedItems/presentation/pages/saved_item_details_screen.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../pages/saved_items_presentation.dart';
import '../savedItemDetailsWidgets/name_overly.dart';
import '../savedItemDetailsWidgets/save_button.dart';
import '../savedItemDetailsWidgets/score_padge.dart';



class OutfitGrid extends StatelessWidget {
  const OutfitGrid({
    required this.outfits,
    required this.savedStates,
    required this.cardScales,
    required this.cardFades,
    required this.cardSlides,
    required this.dark,
    required this.onToggleSave,
    required this.onTap,
  });

  final List<OutfitModel>       outfits;
  final List<bool>              savedStates;
  final List<Animation<double>> cardScales;
  final List<Animation<double>> cardFades;
  final List<Animation<Offset>>  cardSlides;
  final bool                    dark;
  final ValueChanged<int>       onToggleSave;
  final ValueChanged<int>       onTap;

  @override
  Widget build(BuildContext context) {
    // Build Pinterest-like pairs with slight height variation
    final leftCol  = <int>[];
    final rightCol = <int>[];
    for (var i = 0; i < outfits.length; i++) {
      (i.isEven ? leftCol : rightCol).add(i);
    }

    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _Column(
            indices: leftCol, outfits: outfits, savedStates: savedStates,
            scales: cardScales, fades: cardFades, slides: cardSlides,
            dark: dark, onToggle: onToggleSave, onTap: onTap,
            altHeight: false,
          )),
          const SizedBox(width: 12),
          Expanded(child: _Column(
            indices: rightCol, outfits: outfits, savedStates: savedStates,
            scales: cardScales, fades: cardFades, slides: cardSlides,
            dark: dark, onToggle: onToggleSave, onTap: onTap,
            altHeight: true,
          )),
        ],
      ),
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({
    required this.indices,
    required this.outfits,
    required this.savedStates,
    required this.scales,
    required this.fades,
    required this.slides,
    required this.dark,
    required this.onToggle,
    required this.onTap,
    required this.altHeight,
  });

  final List<int>               indices;
  final List<OutfitModel>       outfits;
  final List<bool>              savedStates;
  final List<Animation<double>> scales, fades;
  final List<Animation<Offset>>  slides;
  final bool                    dark, altHeight;
  final ValueChanged<int>       onToggle, onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (altHeight) const SizedBox(height: 20),
        ...indices.map((i) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: AnimatedBuilder(
            animation: Listenable.merge([scales[i], fades[i]]),
            builder: (_, child) => FadeTransition(
              opacity: fades[i],
              child: SlideTransition(
                position: slides[i],
                child: ScaleTransition(
                  scale: scales[i],
                  child: child,
                ),
              ),
            ),
            child: _TiltCard(
              outfit: outfits[i],
              isSaved: savedStates[i],
              dark:   dark,
              index:  i,
              onToggleSave: () => onToggle(i),
              onTap:        () => onTap(i),
            ),
          ),
        )),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  3D TILT CARD
//  GestureDetector tracks pointer position → Matrix4 perspective
//  tilt ±6° on X/Y. Resets smoothly on pointer exit.
// ─────────────────────────────────────────────────────────────
class _TiltCard extends StatefulWidget {
  const _TiltCard({
    required this.outfit,
    required this.isSaved,
    required this.dark,
    required this.index,
    required this.onToggleSave,
    required this.onTap,
  });

  final OutfitModel  outfit;
  final bool         isSaved;
  final bool         dark;
  final int          index;
  final VoidCallback onToggleSave;
  final VoidCallback onTap;

  @override
  State<_TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<_TiltCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _resetCtrl;
  late final Animation<double>   _resetAnim;

  double _tiltX = 0, _tiltY = 0;
  double _lastX = 0, _lastY = 0;
  bool   _hovering = false;
  bool   _pressed  = false;

  @override
  void initState() {
    super.initState();
    _resetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _resetAnim = CurvedAnimation(parent: _resetCtrl,
        curve: Curves.easeOutCubic);
    _resetCtrl.addListener(() {
      setState(() {
        _tiltX = _lastX * (1 - _resetAnim.value);
        _tiltY = _lastY * (1 - _resetAnim.value);
      });
    });
  }

  @override
  void dispose() {
    _resetCtrl.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent e, Size size) {
    _resetCtrl.stop();
    final cx = size.width  / 2;
    final cy = size.height / 2;
    setState(() {
      _tiltY =  (e.localPosition.dx - cx) / cx * 6.0;
      _tiltX = -(e.localPosition.dy - cy) / cy * 6.0;
    });
  }

  void _onPointerExit() {
    _lastX = _tiltX;
    _lastY = _tiltY;
    _resetCtrl.forward(from: 0);
    setState(() => _hovering = false);
  }

  // Map index to a pseudo-random card height for Pinterest feel
  double get _cardHeight {
    const heights = [210.0, 260.0, 230.0, 280.0, 220.0, 250.0];
    return heights[widget.index % heights.length];
  }

  Color get _outfitColor =>
      widget.outfit.colorHex.first.withOpacity(0.85);

  @override
  Widget build(BuildContext context) {
    final dark = widget.dark;
    final cardBg = dark ? AppColors.cardBg : LT.cardBg;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp:   (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit:  (_) => _onPointerExit(),
        child: Listener(
          onPointerMove: (e) {
            final box = context.findRenderObject() as RenderBox?;
            if (box != null) _onPointerMove(e, box.size);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            transform: _buildMatrix(),
            transformAlignment: Alignment.center,
            child: Container(
              height: _cardHeight,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: dark ? AppColors.cardBorder : LT.cardBorder,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _outfitColor.withOpacity(
                        _hovering ? 0.20 : _pressed ? 0.12 : 0.10),
                    blurRadius: _hovering ? 32 : 18,
                    spreadRadius: -4,
                    offset: Offset(0, _hovering ? 12 : 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(dark ? 0.35 : 0.08),
                    blurRadius: 20,
                    spreadRadius: -6,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(children: [

                  // ── Outfit color backdrop (pseudo-image)
                  Positioned.fill(
                    child: _OutfitVisual(outfit: widget.outfit),
                  ),

                  // ── Bottom name overlay
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: NameOverlay(
                      outfit: widget.outfit,
                      dark:   dark,
                    ),
                  ),

                  // ── Save button
                  Positioned(
                    top: 10, right: 10,
                    child:  SaveButton(
                      isSaved: widget.isSaved,
                      dark:    dark,
                      onToggle: widget.onToggleSave,
                    ),
                  ),

                  // ── Score badge
                  Positioned(
                    top: 10, left: 10,
                    child:  ScoreBadge(
                      score: widget.outfit.score,
                      dark:  dark,
                    ),
                  ),

                  // ── Light reflection on hover
                  if (_hovering)
                    Positioned(
                      top: -60, left: -40,
                      child: Container(
                        width: 200, height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.10),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Matrix4 _buildMatrix() {
    const perspective = 0.001;
    final scale = _pressed ? 0.97 : _hovering ? 1.02 : 1.0;

    return Matrix4.identity()
      ..setEntry(3, 2, perspective)
      ..rotateX(_tiltX * math.pi / 180)
      ..rotateY(_tiltY * math.pi / 180)
      ..scale(scale);
  }
}

class _OutfitVisual extends StatelessWidget {
  const _OutfitVisual({required this.outfit});
  final OutfitModel outfit;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OutfitPainter(outfit.colorHex),
      child: Center(
        child: Opacity(
          opacity: 0.18,
          child: Icon(
            Icons.dry_cleaning_rounded,
            size: 64,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
class _OutfitPainter extends CustomPainter {
  const _OutfitPainter(this.colors);
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    // Vertical gradient using outfit palette
    final grad = LinearGradient(
      begin: Alignment.topLeft,
      end:   Alignment.bottomRight,
      colors: colors.length >= 2
          ? colors.sublist(0, math.min(colors.length, 3))
          : [colors.first, colors.first.withOpacity(0.6)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..shader = grad);

    // Subtle texture stripes
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;
    for (var y = 0.0; y < size.height; y += 18) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(_OutfitPainter old) => old.colors != colors;
}
