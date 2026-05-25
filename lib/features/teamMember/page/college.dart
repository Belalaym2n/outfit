
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:graduation_proj/features/teamMember/page/team_member_screen.dart';

import '../../../core/sharedWidgets/animations/slide_naviagation.dart';
import '../data/team_member_model.dart';
import '../widgets/team_member_card.dart';

class OurCollege extends StatefulWidget {
  const OurCollege({super.key});

  @override
  State<OurCollege> createState() => _OurCollegeState();
}

class _OurCollegeState extends State<OurCollege> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      TeamMemberScreen(member: TeamMember(
          id: 'cis-faculty',
          name: 'Faculty of Computer and Information Science (CIS)',
          role: 'Academic Institution',
          accentTag: 'CIS',
          about:
          'The Faculty of Computer and Information Science (CIS) is a leading academic institution dedicated to advancing knowledge in computing, '
              'information systems, and artificial intelligence. '
              'CIS provides a strong educational environment that fosters innovation, critical thinking, and research excellence, '
              'preparing students to meet real-world technological challenges.',
          roleInProject:
          'CIS served as the academic foundation for this project, providing the educational environment, resources, and guidance necessary '
              'to develop a high-quality system. '
              'The project was developed following CIS academic standards, ensuring a solid balance between theoretical knowledge and practical implementation.',
          linkedInUrl: 'https://example.com/cis',
          whatsAppNumber: '201000000000',
        ),
       ),

    );
  }
}
