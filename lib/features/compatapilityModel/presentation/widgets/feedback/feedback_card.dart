import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_texts.dart';
import '../score/score_chip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Item catalogue
// ─────────────────────────────────────────────────────────────────────────────

/// Maps a highlight index returned by the API to a human-readable label.
///
/// The API encodes outfit items as:
///   0 → Top | 1 → Bottom | 2 → Shoe | 3 → Bag | 4 → Accessory
///
/// Falls back to a generic "Item N" for any future additions to the API,
/// making the system trivially extensible: just grow [_itemLabels].
const List<String> _itemLabels = [
  'Top',
  'Bottom',
  'Shoes',
  'Bag',
  'Accessory',
];

/// Returns the display label for a given highlight [index].
///
/// Example:
/// ```dart
/// getItemLabel(2); // → "Shoe"
/// getItemLabel(9); // → "Item 10"
/// ```
String getItemLabel(int index) =>
    index >= 0 && index < _itemLabels.length
        ? _itemLabels[index]
        : 'Item ${index + 1}';

// ─────────────────────────────────────────────────────────────────────────────
// FeedbackCard
// ─────────────────────────────────────────────────────────────────────────────

/// Displays AI-generated outfit compatibility feedback.
///
/// [highlights] is a list of **item indices** (not scores) that the API has
/// flagged as mismatched. For example `[2, 4]` means Shoe and Accessory are
/// problematic. Previously this was incorrectly typed as `List<double>` and
/// treated as score values – that is now fully corrected.
class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    super.key,
    required this.hPad,
    required this.highlights,
    required this.isCompatible,
  });

  final double hPad;

  /// Indices of mismatched items as returned by the API.
  /// Valid range per item: 0–4 (see [_itemLabels]).
  final List<int> highlights;

  final bool isCompatible;

  // ── feedback body copy ────────────────────────────────────────────────────

  String get _feedbackText {
    if (isCompatible) {
      return 'Your outfit demonstrates strong coordination between all pieces. '
          'The colour palette is cohesive and the formality levels match well. '
          'Keep up this great styling sense!';
    }
    return 'Your outfit shows some coordination between pieces, however certain '
        'items introduce inconsistencies in formality or colour harmony. '
        'Review the suggestions below to elevate your overall look.';
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool hasHighlights = highlights.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              spreadRadius: -3,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── header ───────────────────────────────────────────────────────
            _Header(hasHighlights: hasHighlights),

            const SizedBox(height: 14),

            // ── body copy ─────────────────────────────────────────────────
            Text(_feedbackText, style: T.body),

            // ── highlighted items ──────────────────────────────────────────
            if (hasHighlights) ...[
              const SizedBox(height: 16),
              _HighlightChips(highlights: highlights),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets  (keep FeedbackCard.build() scannable)
// ─────────────────────────────────────────────────────────────────────────────

/// Card header: icon + title + optional subtitle.
class _Header extends StatelessWidget {
  const _Header({required this.hasHighlights});

  final bool hasHighlights;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon badge.
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            size: 16,
            color: AppColors.textHigh,
          ),
        ),

        const SizedBox(width: 10),

        // Title + optional subtitle column.
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Feedback', style: T.heading),
            if (hasHighlights) ...[
              const SizedBox(height: 2),
              Text(
                'The following items need improvement',
                style: T.body.copyWith(
                  fontSize: 11,
                  color: AppColors.textMid,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Staggered [ScoreChip] grid – renders ONLY the flagged items.
class _HighlightChips extends StatelessWidget {
  const _HighlightChips({required this.highlights});

  final List<int> highlights;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (int i = 0; i < highlights.length; i++)
          ScoreChip(
            // Every chip in the highlights list is a mismatch by definition.
            label: getItemLabel(highlights[i]),
            warning: true,
            // Stagger each chip by 60 ms so they cascade in gracefully.
            animationDelay: Duration(milliseconds: i * 60),
          ),
      ],
    );
  }
}