import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../data/team_member_model.dart';

class TeamShareService {
  TeamShareService._();

   static const _githubBase =
      'https://belalaym2n.github.io/outfit_ai_deep_link/';

  static Future<void> shareMember(
      TeamMember member, {
        Rect? sharePositionOrigin,
      }) async {
    HapticFeedback.lightImpact();

     final deepLink = '$_githubBase/member/${member.id}';

    final text = '👤 ${member.name}\n'
        '${member.role}\n\n'
        '$deepLink';

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );

  }}
