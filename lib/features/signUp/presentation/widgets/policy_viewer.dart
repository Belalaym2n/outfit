

import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/sharedWidgets/text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PolicyViewerScreen
// A reusable, premium full-screen modal for displaying legal documents.
// Entrance: slide-up + fade. Header is sticky with a subtle divider.
// ─────────────────────────────────────────────────────────────────────────────

/// Call this to open the viewer from anywhere:
///   PolicyViewerScreen.show(context, type: PolicyType.terms);
///   PolicyViewerScreen.show(context, type: PolicyType.privacy);
enum PolicyType { terms, privacy }

class PolicyViewerScreen extends StatefulWidget {
  const PolicyViewerScreen({super.key, required this.type});

  final PolicyType type;

  // ── Static launcher ────────────────────────────────────────────────────────
  static Future<void> show(BuildContext context, {required PolicyType type}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => PolicyViewerScreen(type: type),
    );
  }

  @override
  State<PolicyViewerScreen> createState() => _PolicyViewerScreenState();
}

class _PolicyViewerScreenState extends State<PolicyViewerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _contentFadeAnim;

  final ScrollController _scrollCtrl = ScrollController();
  bool _showHeaderDivider = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _fadeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    // Content fades in slightly after the sheet settles
    _contentFadeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );

    _ctrl.forward();

    _scrollCtrl.addListener(() {
      final shouldShow = _scrollCtrl.offset > 4;
      if (shouldShow != _showHeaderDivider) {
        setState(() => _showHeaderDivider = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Close with reverse animation ──────────────────────────────────────────
  Future<void> _close() async {
    await _ctrl.reverse();
    if (mounted) Navigator.of(context).pop();
  }

  // ── Data helpers ──────────────────────────────────────────────────────────
  String get _title => widget.type == PolicyType.terms
      ? 'Terms of Service'
      : 'Privacy Policy';

  String get _lastUpdated => widget.type == PolicyType.terms
      ? 'Last updated: January 15, 2025'
      : 'Last updated: January 15, 2025';

  List<_PolicySection> get _sections => widget.type == PolicyType.terms
      ? _termsContent
      : _privacyContent;

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          height: mq.size.height * 0.91,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            bottom: true,
            child: Column(
              children: [
                // ── Drag handle ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 4),
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ── Sticky header ─────────────────────────────────────────
                _Header(
                  title: _title,
                  showDivider: _showHeaderDivider,
                  onClose: _close,
                ),

                // ── Scrollable content ────────────────────────────────────
                Expanded(
                  child: FadeTransition(
                    opacity: _contentFadeAnim,
                    child: CustomScrollView(
                      controller: _scrollCtrl,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                            child: Text(_lastUpdated, style: T.caption),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, i) => _SectionTile(section: _sections[i]),
                            childCount: _sections.length,
                          ),
                        ),
                        // Bottom breathing room
                        SliverToBoxAdapter(
                          child: SizedBox(height: mq.padding.bottom + 32),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.showDivider,
    required this.onClose,
  });

  final String title;
  final bool showDivider;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(
          bottom: BorderSide(
            color: showDivider ? AppColors.divider : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: T.subtitle)),
          _CloseButton(onTap: onClose),
        ],
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.divider.withOpacity(0.8)
              : AppColors.divider.withOpacity(0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close_rounded,
          size: 17,
          color: AppColors.ink.withOpacity(0.75),
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({required this.section});
  final _PolicySection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.heading, style: T.cardTitle),
          const SizedBox(height: 8),
          Text(section.body, style: T.body),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class _PolicySection {
  const _PolicySection({required this.heading, required this.body});
  final String heading;
  final String body;
}

// ── Terms of Service content ──────────────────────────────────────────────────
const _termsContent = [
  _PolicySection(
    heading: '1. Acceptance of Terms',
    body:
    'By accessing or using our AI Outfit Analysis service ("Service"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the Service. We reserve the right to update these terms at any time, and continued use of the Service constitutes acceptance of any changes.',
  ),
  _PolicySection(
    heading: '2. Description of Service',
    body:
    'Our Service provides AI-powered outfit analysis, scoring, style suggestions, and item replacement recommendations. We use machine learning models to evaluate uploaded images of clothing and outfits. The Service is provided "as is" and we make no guarantees about the accuracy or completeness of any analysis.',
  ),
  _PolicySection(
    heading: '3. User Accounts',
    body:
    'You must create an account to access the Service. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account. We reserve the right to terminate accounts that violate these terms.',
  ),
  _PolicySection(
    heading: '4. User Content',
    body:
    'You retain all rights to images and content you upload ("User Content"). By uploading content, you grant us a limited, non-exclusive license to process and analyze it solely for the purpose of providing the Service. We do not sell your images to third parties. You represent that you have the right to upload all content you submit.',
  ),
  _PolicySection(
    heading: '5. Prohibited Uses',
    body:
    'You agree not to: (a) upload content that violates any applicable law; (b) attempt to reverse engineer or extract our AI models; (c) use the Service for commercial resale without written permission; (d) upload images containing personally identifiable information of others without their consent; or (e) use automated means to access the Service at scale.',
  ),
  _PolicySection(
    heading: '6. Intellectual Property',
    body:
    'The Service, including its AI models, design, software, and all related intellectual property, is owned by us and protected by applicable intellectual property laws. These Terms do not grant you any right, title, or interest in the Service beyond the limited license to use it as described herein.',
  ),
  _PolicySection(
    heading: '7. Disclaimer of Warranties',
    body:
    'THE SERVICE IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. WE DISCLAIM ALL WARRANTIES INCLUDING IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. STYLE RECOMMENDATIONS ARE SUBJECTIVE AND SHOULD NOT BE RELIED UPON AS PROFESSIONAL FASHION ADVICE.',
  ),
  _PolicySection(
    heading: '8. Limitation of Liability',
    body:
    'TO THE MAXIMUM EXTENT PERMITTED BY LAW, WE SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, OR CONSEQUENTIAL DAMAGES ARISING FROM YOUR USE OF THE SERVICE. OUR TOTAL LIABILITY SHALL NOT EXCEED THE AMOUNT PAID BY YOU IN THE TWELVE MONTHS PRECEDING THE CLAIM.',
  ),
  _PolicySection(
    heading: '9. Governing Law',
    body:
    'These Terms shall be governed by and construed in accordance with applicable laws, without regard to conflict of law principles. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts in the applicable jurisdiction.',
  ),
  _PolicySection(
    heading: '10. Contact',
    body:
    'If you have questions about these Terms of Service, please contact us at legal@outfitai.app. We will make reasonable efforts to respond within 5 business days.',
  ),
];

// ── Privacy Policy content ────────────────────────────────────────────────────
const _privacyContent = [
  _PolicySection(
    heading: '1. Information We Collect',
    body:
    'We collect information you provide directly (name, email, account details), content you upload (outfit images), and usage data (features used, analysis history, device information). We also collect technical data such as IP addresses, browser type, and crash reports to improve the Service.',
  ),
  _PolicySection(
    heading: '2. How We Use Your Information',
    body:
    'We use your information to: provide and improve the AI analysis Service; personalize your experience and suggestions; send transactional communications; analyze aggregate usage patterns to improve our models; and comply with legal obligations. We do not use your images to train our AI models without your explicit consent.',
  ),
  _PolicySection(
    heading: '3. Image Data & AI Processing',
    body:
    'Outfit images you upload are processed by our AI systems to generate analysis results. Images are stored securely and associated with your account to power your analysis history. You may delete your image history at any time from your account settings. Deleted images are purged from our systems within 30 days.',
  ),
  _PolicySection(
    heading: '4. Data Sharing',
    body:
    'We do not sell your personal data. We share data only with: (a) trusted service providers who assist in operating the Service under strict confidentiality agreements; (b) analytics partners using anonymized, aggregated data only; and (c) when required by law, legal process, or to protect our rights and safety.',
  ),
  _PolicySection(
    heading: '5. Data Retention',
    body:
    'We retain your account data for as long as your account is active or as needed to provide the Service. Analysis history is retained for 12 months by default. You may request deletion of your data at any time. Upon account deletion, personal data is purged within 30 days, except where retention is required by law.',
  ),
  _PolicySection(
    heading: '6. Security',
    body:
    'We implement industry-standard security measures including encryption in transit and at rest, access controls, and regular security audits. However, no method of transmission over the internet is 100% secure. We encourage you to use a strong password and to notify us of any suspected security breach.',
  ),
  _PolicySection(
    heading: '7. Your Rights',
    body:
    'Depending on your location, you may have rights to: access, correct, or delete your personal data; restrict or object to certain processing; receive a portable copy of your data; and withdraw consent at any time. To exercise these rights, contact us at privacy@outfitai.app.',
  ),
  _PolicySection(
    heading: '8. Cookies & Tracking',
    body:
    'We use essential cookies to operate the Service and optional analytics cookies to understand usage patterns. You may control cookie preferences through your device or browser settings. Disabling certain cookies may affect Service functionality.',
  ),
  _PolicySection(
    heading: '9. Children\'s Privacy',
    body:
    'Our Service is not directed to children under 13 years of age. We do not knowingly collect personal information from children. If you believe we have inadvertently collected data from a child, please contact us immediately and we will delete such information.',
  ),
  _PolicySection(
    heading: '10. Contact Us',
    body:
    'For privacy-related questions or to exercise your rights, contact our Privacy Team at privacy@outfitai.app. For EU residents, you may also lodge a complaint with your local data protection authority.',
  ),
];