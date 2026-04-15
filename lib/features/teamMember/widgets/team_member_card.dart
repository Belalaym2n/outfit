// features/team/team_member_card.dart

import 'package:flutter/material.dart';

import '../../../core/sharedWidgets/text_styles.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../data/team_member_model.dart';


class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    super.key,
    required this.member,
    required this.onTap,
  });

  final TeamMember member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        padding: const EdgeInsets.all(Sp.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _CardHeader(member: member),
            const SizedBox(height: Sp.xs),
            _HairlineDivider(),
            const SizedBox(height: Sp.xs),
            _CardBody(member: member, onTap: onTap),
          ],
        ),
      ),
    );
  }
}


class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.member});
  final TeamMember member;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Avatar(member: member, radius: 24),
        const SizedBox(width: Sp.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                style: T.cardTitle.copyWith(color: AppColors.primaryColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                member.role,
                style: T.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (member.accentTag != null) ...[
          const SizedBox(width: Sp.xs),
          _Badge(label: member.accentTag!),
        ],
      ],
    );
  }
}


class _CardBody extends StatelessWidget {
  const _CardBody({required this.member, required this.onTap});
  final TeamMember member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          member.about,
          style: T.cardBody,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: Sp.xs),
        Align(
          alignment: Alignment.centerRight,
          child: _ViewProfileButton(onTap: onTap),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.member, required this.radius});
  final TeamMember member;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (member.avatarAsset != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(member.avatarAsset!),
        backgroundColor: AppColors.surfaceAlt,
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.ink,
      child: Text(
        member.initials,
        style: TextStyle(
          fontSize: radius * 0.7,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Small pill badge — role shorthand.
class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.inkSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(label, style: T.caption),
    );
  }
}

/// "View Profile →" text button — intentionally minimal.
class _ViewProfileButton extends StatelessWidget {
  const _ViewProfileButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('View Profile', style: T.fieldLabel.copyWith(color: AppColors.ink)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward, size: 13, color: AppColors.ink),
        ],
      ),
    );
  }
}

class _HairlineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.divider);
}

// ── Large avatar exposed for the profile screen ───────────────────────────

/// Standalone large avatar — also used by [TeamMemberScreen].
class TeamMemberAvatar extends StatelessWidget {
  const TeamMemberAvatar({super.key, required this.member, this.radius = 48});
  final TeamMember member;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (member.avatarAsset != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(member.avatarAsset!),
        backgroundColor: AppColors.surfaceAlt,
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.ink,
      child: Text(
        member.initials,
        style: TextStyle(
          fontSize: radius * 0.55,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
