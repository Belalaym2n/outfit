import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/app_colors.dart';
import '../data/team_data.dart';          // ← local data, no API
import 'team_member_screen.dart';

class MemberDeepLinkScreen extends StatelessWidget {
  const MemberDeepLinkScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    // TeamData.findById() is synchronous — no Future, no loading spinner needed
    final member = TeamData.findById(memberId);

    if (member == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_off_outlined,
                    color: Colors.white38, size: 72),
                const SizedBox(height: 20),
                Text(
                  'Member "$memberId" not found.',
                  style: const TextStyle(color: Colors.white60, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton.tonal(
                  onPressed: () => context.go('/'),
                  child: const Text('Go to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Member found → go directly to the screen, no intermediate loading
    return TeamMemberScreen(member: member);
  }
}