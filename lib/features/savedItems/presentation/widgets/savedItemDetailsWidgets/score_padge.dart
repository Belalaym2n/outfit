
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class  ScoreBadge extends StatelessWidget {
  const ScoreBadge({required this.score, required this.dark});
  final int  score;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.28),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Text(
            '$score',
            style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w800,
              color: Colors.white, letterSpacing: -0.3,
            ),
          ),
        ),
      ),
    );
  }
}

