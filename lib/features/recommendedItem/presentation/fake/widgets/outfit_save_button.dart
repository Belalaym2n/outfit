import 'package:flutter/material.dart';

import '../../manager/outfit_states.dart';

class OutfitSaveButton extends StatefulWidget {
  final bool isSaved;
  final SaveStatus saveStatus;
  final VoidCallback onTap;

  const OutfitSaveButton({
    super.key,
    required this.isSaved,
    required this.saveStatus,
    required this.onTap,
  });

  @override
  State<OutfitSaveButton> createState() => _OutfitSaveButtonState();
}

class _OutfitSaveButtonState extends State<OutfitSaveButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.4, end: 0.88)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.88, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_ctrl);
  }

  @override
  void didUpdateWidget(OutfitSaveButton old) {
    super.didUpdateWidget(old);
    if (!old.isSaved && widget.isSaved) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = 32.0;

    if (widget.saveStatus == SaveStatus.loading) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Padding(
          padding: EdgeInsets.all(7),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF2C2C2C),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                widget.isSaved ? const Color(0xFF2C2C2C) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(widget.isSaved ? 0.18 : 0.10),
                blurRadius: widget.isSaved ? 12 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            widget.isSaved
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            size: 16,
            color: widget.isSaved ? Colors.white : const Color(0xFF7A7570),
          ),
        ),
      ),
    );
  }
}
