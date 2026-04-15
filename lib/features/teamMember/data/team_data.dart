// features/team/team_data.dart

import 'team_member_model.dart';

/// Single source of truth for every Outfit AI team member.
///
/// To add a member, append a new [TeamMember] entry.
/// To look up by deep-link slug, use [TeamData.findById].
abstract final class TeamData {
  static const List<TeamMember> members = [
    TeamMember(
      id: 'dr-sheeren',
      name: 'Dr. Sheeren',
      role: 'Academic Supervisor',
      accentTag: 'Supervisor',
      about:
      'Dr. Sheeren is an academic professional with strong expertise in scientific research. '
          'She is known for her ability to guide students and simplify complex concepts, '
          'while emphasizing structured research methodologies and analytical thinking, '
          'especially in areas related to artificial intelligence and system evaluation.',
      roleInProject:
          'Oversaw the academic direction of the project, guided the research '
          'process, and provided valuable feedback on the AI evaluation framework '
          'to ensure the system follows sound scientific and methodological standards.',
      linkedInUrl: 'https://linkedin.com/in/placeholder-dr-shery',
      whatsAppNumber: '201000000000',
    ),
    TeamMember(
      id: 'belal',
      name: 'Belal Ayman',
      role: 'Team Leader / Flutter Engineer',
      accentTag: 'Team Lead',
      about:
          'I’m Belal Ayman, a Flutter developer and software engineer passionate '
          'about building modern, scalable, and visually polished digital products. '
          'With a background in Computer Science, I enjoy transforming ideas into '
          'real-world applications through strong system design and clean architecture. '
          'I have developed and delivered 8+ production projects including mobile '
          'applications, web platforms, and dashboards for clients in Egypt and '
          'internationally, ensuring reliable performance and successful deployments '
          'on platforms such as Google Play and the App Store. I’m always eager to '
          'learn, grow, and deliver high-quality solutions that create real impact.',
      roleInProject:
          'Served as the Team Leader and main Flutter architect for the Outfit AI '
          'application. Responsible for the full development lifecycle including '
          'system design, application architecture, and complete Flutter implementation. '
          'Built the UI system, structured the project using scalable architecture, '
          'and integrated AI-powered features into a production-ready mobile app '
          'while leading the development team and coordinating the overall project direction.',
      linkedInUrl: 'https://linkedin.com/in/belal-ayman-6036192a6/',
      whatsAppNumber: '+201114324251',
    ),

    TeamMember(
      id: 'saad',
      name: 'Saad Mostafa',
      role: 'Backend Developer',
      accentTag: 'Backend',
      about:
      'Saad Mostafa is a backend developer specialized in building scalable and reliable systems. '
          'In the Outfit AI project, he led the development of the backend architecture, ensuring seamless '
          'data flow between the mobile application and AI services. His work enabled a stable, efficient, '
          'and high-performance foundation that directly supported real-time outfit analysis and user experience.',
      roleInProject:
      'Owned the design and implementation of backend services and APIs powering the application. '
          'Built and optimized the communication layer between the Flutter client and AI engine, ensuring '
          'efficient request handling, data consistency, and system scalability. Collaborated closely with '
          'AI and mobile teams to guarantee smooth integration and reliable end-to-end performance.',
      linkedInUrl: 'https://linkedin.com/in/placeholder-saad',
      whatsAppNumber: '201000000002',
    ),

    TeamMember(
      id: 'Rofidah',
      name: 'Rofidah',
      role: 'AI Engineer',
      accentTag: 'AI',
      about:
      'Rofidah is an AI engineer focused on building intelligent, production-ready machine learning solutions. '
          'In Outfit AI, she played a key role in shaping the core intelligence of the product by designing a structured '
          'and reliable outfit evaluation pipeline. Her contributions ensured that the AI delivers meaningful, consistent, '
          'and user-centric insights.',
      roleInProject:
      'Developed and optimized the AI model responsible for outfit evaluation. Structured the end-to-end pipeline, '
          'from data processing to scoring logic, ensuring accurate and interpretable outputs. Worked closely with backend '
          'and mobile teams to integrate AI results seamlessly into the user experience.',
      linkedInUrl: 'https://linkedin.com/in/placeholder-aref',
      whatsAppNumber: '201000000003',
    ),

    TeamMember(
      id: 'Misk',
      name: 'Misk',
      role: 'AI Engineer',
      accentTag: 'AI',
      about:
      'Misk is a detail-oriented contributor with a strong focus on user experience and interface quality. '
          'In Outfit AI, she played an important role in elevating the visual consistency and usability of the product, '
          'ensuring that complex AI-driven features are presented in a clear, intuitive, and engaging way.',
      roleInProject:
      'Refined UI components and improved user interaction flows to enhance overall usability. Focused on layout balance, '
          'visual clarity, and consistency across screens. Collaborated with developers to ensure the interface effectively '
          'communicates AI outputs while maintaining a smooth and engaging user experience.',
      linkedInUrl: 'https://linkedin.com/in/placeholder-meska',
      whatsAppNumber: '201000000004',
    ),

    TeamMember(
      id: 'mostafa',
      name: 'Mostafa',
      role: 'Backend Developer',
      accentTag: 'Backend',
      about:
      'Mostafa is a backend developer who contributed to strengthening the system integration and overall architecture '
          'of the Outfit AI project. His work focused on ensuring that all components operate cohesively, supporting a stable '
          'and efficient development environment.',
      roleInProject:
      'Handled system integration and supported backend development workflows. Ensured smooth interaction between different '
          'services and components, reducing friction in development and improving system reliability. Worked alongside team members '
          'to maintain a cohesive and well-functioning architecture.',
      linkedInUrl: 'https://linkedin.com/in/placeholder-mostafa',
      whatsAppNumber: '201000000005',
    ),

    TeamMember(
      id: 'mohamed-mostafa',
      name: 'Mohamed Mostafa',
      role: 'Flutter Developer',
      accentTag: 'Flutter',
      about:
      'Mohamed Mostafa is a Flutter developer with a strong focus on quality assurance and system reliability. '
          'In Outfit AI, he ensured that the AI-driven features deliver accurate and dependable results by rigorously '
          'validating the system under different scenarios.',
      roleInProject:
      'Designed and executed comprehensive test cases for the AI analysis pipeline. Validated system outputs to ensure '
          'accuracy, consistency, and reliability. Collaborated with AI and backend teams to identify issues, improve model '
          'performance, and enhance overall system stability.',
      linkedInUrl: 'https://linkedin.com/in/placeholder-mohamed-mostafa',
      whatsAppNumber: '201000000006',
    ),

    TeamMember(
      id: 'badawy',
      name: 'Ahmed Badawy Badawy',
      role: 'Software Contributor',
      accentTag: 'Dev',
      about:
      'Ahmed Badawy is a multidisciplinary contributor with a strong focus on product presentation and user experience. '
          'In Outfit AI, he played a key role in shaping how the product is structured and communicated, ensuring a clear, '
          'professional, and impactful representation of the system.',
      roleInProject:
      'Organized project assets and maintained a clear structure for development resources, improving team efficiency. '
          'Designed and delivered professional presentations to communicate the product vision effectively. Contributed to UI/UX '
          'direction by refining layouts, enhancing visual consistency, and suggesting improved user interaction flows in collaboration '
          'with the development team.',
      linkedInUrl: 'https://linkedin.com/in/placeholder-badawy',
      whatsAppNumber: '201000000007',
    ),
  ];

  /// Returns a [TeamMember] whose [id] matches [slug], or null.
  static TeamMember? findById(String slug) {
    try {
      return members.firstWhere((m) => m.id == slug);
    } catch (_) {
      return null;
    }
  }
}
