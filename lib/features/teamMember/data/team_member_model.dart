// features/team/team_member_model.dart

/// Immutable data model for a single Outfit AI team member.
class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.about,
    required this.roleInProject,
    this.avatarAsset,
    this.linkedInUrl,
    this.whatsAppNumber,
    this.accentTag,
  });

  /// Unique URL-safe slug — used for deep linking: outfitai://team/{id}
  final String id;
  final String name;
  final String role;

  /// Paragraph shown in the About section of the profile screen.
  final String about;

  /// Short sentence shown in the "Role in the Project" section.
  final String roleInProject;

  /// Local asset path, e.g. 'assets/images/team/belal.jpg'.
  /// Falls back to an initials avatar when null.
  final String? avatarAsset;

  /// Full LinkedIn profile URL.
  final String? linkedInUrl;

  /// WhatsApp number in E.164 format WITHOUT the '+', e.g. "201012345678".
  final String? whatsAppNumber;

  /// Short badge text shown on the team card, e.g. "Team Lead".
  final String? accentTag;

  // ── Derived helpers ────────────────────────────────────────────

  String get deepLink => 'outfitai://team/$id';

  String get shareText =>
      'Check out $name from the Outfit AI team!\n$deepLink';

  String get whatsAppUrl => 'https://wa.me/$whatsAppNumber';

  /// Up-to-2-letter initials derived from [name].
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
