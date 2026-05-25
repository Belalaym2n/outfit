import 'package:flutter/material.dart';

class OutfitImageSlider extends StatefulWidget {
  final List<String> images;
  final double height;
  final BorderRadius borderRadius;

  const OutfitImageSlider({
    super.key,
    required this.images,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<OutfitImageSlider> createState() => _OutfitImageSliderState();
}

class _OutfitImageSliderState extends State<OutfitImageSlider> {
  final PageController _pageCtrl = PageController();
  int _current = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Page view ──────────────────────────────────────
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: widget.images.length,
            itemBuilder: (context, i) => ClipRRect(
              borderRadius: widget.borderRadius,
              child: Image.network(
                widget.images[i],
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: const Color(0xFFF0EEE9),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        color: const Color(0xFF9B8F82),
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF0EEE9),
                  child: const Icon(
                    Icons.checkroom_outlined,
                    size: 48,
                    color: Color(0xFFCCC4BB),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Dot indicators ─────────────────────────────────
        if (widget.images.length > 1)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (i) {
                final active = i == _current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: active ? 14 : 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white
                        : Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
