import 'package:flutter/foundation.dart';
import 'team_member_model.dart';

/// Fetches team member data.
/// Replace the body of [getMemberById] with your actual API / cache call.
class TeamRepository {
  TeamRepository._();
  static final TeamRepository instance = TeamRepository._();

  Future<TeamMember?> getMemberById(String id) async {
    try {
      // ── Option 1: HTTP ───────────────────────────────────────────
      // final response = await DioClient.instance.get('/team/$id');
      // return TeamMember.fromJson(response.data);

      // ── Option 2: scan in-memory list ────────────────────────────
      // return _cachedMembers.firstWhereOrNull((m) => m.id == id);

      throw UnimplementedError('Wire up your real data source.');
    } catch (e) {
      debugPrint('[TeamRepository] getMemberById($id) error: $e');
      return null;
    }
  }
}