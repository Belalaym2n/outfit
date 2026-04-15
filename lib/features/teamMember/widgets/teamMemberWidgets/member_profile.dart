import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/text_styles.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart' show Sp;
import '../../data/team_member_model.dart';
import '../team_member_card.dart';


class  MemberProfileHero extends StatelessWidget {
  const MemberProfileHero({
    required this.member,
    required this.hPad,
    required this.heroFade,
    required this.heroSlide,
    required this.nameFade,
    required this.nameSlide,
  });

  final TeamMember member;
  final double hPad;
  final Animation<double> heroFade;
  final Animation<Offset> heroSlide;
  final Animation<double> nameFade;
  final Animation<Offset> nameSlide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, Sp.lg, hPad, Sp.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          FadeTransition(
            opacity: heroFade,
            child: SlideTransition(
              position: heroSlide,
              child: TeamMemberAvatar(member: member, radius: 44),
            ),
          ),
            SizedBox(height: Sp.sm),

          // Name
          FadeTransition(
            opacity: nameFade,
            child: SlideTransition(
              position: nameSlide,
              child: Text(member.name, style: T.display),
            ),
          ),
          const SizedBox(height: 4),

          // Role badge
          FadeTransition(
            opacity: nameFade,
            child: _RoleBadge(role: member.role),
          ),
          const SizedBox(height: Sp.md),

          Container(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}

// ── Textual content: About + Role in the Project ──────────────────────────

class MemberProfileContent extends StatelessWidget {
  const MemberProfileContent({
    required this.member,
    required this.hPad,
    required this.section1Fade,
    required this.section1Slide,
    required this.section2Fade,
    required this.section2Slide,
  });

  final TeamMember member;
  final double hPad;
  final Animation<double> section1Fade;
  final Animation<Offset> section1Slide;
  final Animation<double> section2Fade;
  final Animation<Offset> section2Slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── About ──────────────────────────────────────────
          FadeSlide(
            fade: section1Fade,
            slide: section1Slide,
            child: _InfoSection(
              label: 'ABOUT',

              body: member.about,
            ),
          ),
          const SizedBox(height: Sp.md),

          // ── Role in the Project ────────────────────────────
          FadeSlide(
            fade: section2Fade,
            slide: section2Slide,
            child: _InfoSection(
              label: 'ROLE IN THE PROJECT',
              body: member.roleInProject,
            ),
          ),
          const SizedBox(height: Sp.md),
        ],
      ),
    );
  }
}

// ── Action buttons: LinkedIn + WhatsApp ───────────────────────────────────



class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.inkSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(role, style: T.fieldLabel),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.label, required this.body});
  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: T.cardTitle.copyWith(color: AppColors.primaryColor)),
        const SizedBox(height: Sp.xs),
        Text(body, style: T.body),
      ],
    );
  }
}
