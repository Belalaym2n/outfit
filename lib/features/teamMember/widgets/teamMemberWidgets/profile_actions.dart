import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/text_styles.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart' show Sp;
import '../../data/team_member_model.dart';
import '../team_member_card.dart';

class  MemberProfileActions extends StatelessWidget {
  const MemberProfileActions({
    required this.member,
    required this.hPad,
    required this.fade,
    required this.slide,
    required this.onLinkedIn,
    required this.onWhatsApp,
  });

  final TeamMember member;
  final double hPad;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final VoidCallback onLinkedIn;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    return FadeSlide(
      fade: fade,
      slide: slide,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CONNECT', style: T.caption),
            const SizedBox(height: Sp.xs),
            Row(
              children: [
                if (member.linkedInUrl != null)
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.link_rounded,
                      label: 'LinkedIn',
                      filled: true,
                      onTap: onLinkedIn,
                    ),
                  ),
                if (member.linkedInUrl != null && member.whatsAppNumber != null)
                  const SizedBox(width: Sp.xs),
                if (member.whatsAppNumber != null)
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'WhatsApp',
                      filled: false,
                      onTap: onWhatsApp,
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


class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _press, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    HapticFeedback.lightImpact();
    await _press.forward();
    _press.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: widget.filled ? AppColors.ink : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.filled ? AppColors.ink : AppColors.divider,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.filled ? AppColors.white : AppColors.textMid,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: widget.filled
                    ? T.fieldLabel.copyWith(color: AppColors.white)
                    : T.fieldLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
