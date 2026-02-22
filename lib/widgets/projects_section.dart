import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _showAllProjects = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 50,
        vertical: 80,
      ),
      color: const Color(0xFF0A0A0A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Projects',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: 60,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFF64FFDA),
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),

          const SizedBox(height: 40),

          Text(
            'Live Projects',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 30),

          AnimationLimiter(
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),

          if (_getProjectsList().length > 2) ...[
            const SizedBox(height: 40),
            Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAllProjects = !_showAllProjects;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF64FFDA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFF64FFDA),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _showAllProjects ? 'Show Less' : 'See More Projects',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF64FFDA),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          _showAllProjects
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: const Color(0xFF64FFDA),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getProjectsList() {
    return [
      {
        'title': 'My YRF - Employee Management System',
        'description':
            'A comprehensive HRMS (Human Resource Management System) mobile application for Yash Raj Films. The app provides employees with seamless access to HR services, attendance tracking, leave management, and company updates. Available on both Android and iOS platforms.',
        'technologies': [
          'Flutter',
          'Dart',
          'REST API',
          'Firebase',
          'Push Notifications',
        ],
        'features': [
          'Employee attendance and leave management',
          'Digital HR services and documentation',
          'Real-time notifications and updates',
          'Cross-platform support (Android & iOS)',
          'Secure authentication and data management',
        ],
        'links': {
          'android':
              'https://play.google.com/store/apps/details?id=com.yashrajfilms.hrms&hl=en_IN',
          'ios': 'https://apps.apple.com/in/app/my-yrf/id6749893849',
        },
      },
      {
        'title': 'Novo Cinemas - Movie Booking App',
        'description':
            'A feature-rich cinema booking application for Novo Cinemas and Grand Cinema chains. The app offers seamless movie booking, seat selection, show timings, and loyalty rewards. Provides users with a smooth ticket booking experience across multiple cinema locations.',
        'technologies': [
          'Flutter',
          'Dart',
          'Payment Gateway',
          'REST API',
          'Location Services',
        ],
        'features': [
          'Browse movies and showtimes',
          'Interactive seat selection and booking',
          'Multiple payment options integration',
          'Loyalty program and rewards',
          'Multi-cinema location support',
        ],
        'links': {
          'android':
              'https://play.google.com/store/apps/details?id=com.grandcinema.gcapp.screens&hl=en_IN',
          'ios': 'https://apps.apple.com/in/app/novo-cinemas/id363121411',
        },
      },
      {
        'title': 'Fitness Tracker App',
        'description':
            'Developed an Android app using Kotlin to track daily step counts and calculate BMI with health suggestions. Integrated Android Fitness APIs for step tracking and day-specific data display.',
        'technologies': ['Kotlin', 'Android', 'Fitness APIs', 'BMI Calculator'],
        'features': [
          'Daily step count tracking',
          'BMI calculation with health suggestions',
          'Android Fitness API integration',
          'Day-specific data display',
        ],
      },
      {
        'title': 'Flutter Movie App',
        'description':
            'A Flutter-based movie app that uses the TMDb API to display movies and TV shows. This project demonstrates key Flutter concepts such as API integration, navigation, state management, and responsive UI design.',
        'technologies': ['Flutter', 'Dart', 'TMDb API', 'State Management'],
        'features': [
          'Movie and TV show listings',
          'API integration with TMDb',
          'Responsive UI design',
          'Navigation and state management',
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getDisplayedProjects() {
    final projects = _getProjectsList();
    return _showAllProjects ? projects : projects.take(2).toList();
  }

  Widget _buildMobileLayout() {
    final projects = _getDisplayedProjects();
    return Column(
      children: projects
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < projects.length - 1 ? 30 : 0,
              ),
              child: _buildProjectCard(
                position: entry.key,
                title: entry.value['title'],
                description: entry.value['description'],
                technologies: List<String>.from(entry.value['technologies']),
                features: List<String>.from(entry.value['features']),
                links: entry.value['links'],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDesktopLayout() {
    final projects = _getDisplayedProjects();
    List<Widget> rows = [];

    for (int i = 0; i < projects.length; i += 2) {
      List<Widget> rowChildren = [];

      // First card in the row
      rowChildren.add(
        Expanded(
          child: _buildProjectCard(
            position: i,
            title: projects[i]['title'],
            description: projects[i]['description'],
            technologies: List<String>.from(projects[i]['technologies']),
            features: List<String>.from(projects[i]['features']),
            links: projects[i]['links'],
          ),
        ),
      );

      // Add spacing and second card if it exists
      if (i + 1 < projects.length) {
        rowChildren.add(const SizedBox(width: 30));
        rowChildren.add(
          Expanded(
            child: _buildProjectCard(
              position: i + 1,
              title: projects[i + 1]['title'],
              description: projects[i + 1]['description'],
              technologies: List<String>.from(projects[i + 1]['technologies']),
              features: List<String>.from(projects[i + 1]['features']),
              links: projects[i + 1]['links'],
            ),
          ),
        );
      } else {
        // Add empty space if odd number of projects
        rowChildren.add(const Expanded(child: SizedBox()));
      }

      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < projects.length ? 30 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowChildren,
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildProjectCard({
    required int position,
    required String title,
    required String description,
    required List<String> technologies,
    required List<String> features,
    Map<String, String>? links,
  }) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: 800),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project title
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64FFDA),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // Description
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 25),

                // Technologies used
                Text(
                  'Technologies Used:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: technologies
                      .map(
                        (tech) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF64FFDA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF64FFDA).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tech,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64FFDA),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 25),

                // Key features
                Text(
                  'Key Features:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                ...features
                    .map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6, right: 10),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF64FFDA),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                feature,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),

                // App Store Links (if available)
                if (links != null && links.isNotEmpty) ...[
                  const SizedBox(height: 25),
                  Text(
                    'Available On:',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      if (links['android'] != null)
                        _buildStoreButton(
                          label: 'Google Play',
                          icon: Icons.android,
                          url: links['android']!,
                        ),
                      if (links['ios'] != null)
                        _buildStoreButton(
                          label: 'App Store',
                          icon: Icons.apple,
                          url: links['ios']!,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreButton({
    required String label,
    required IconData icon,
    required String url,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            debugPrint('Could not launch $url');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF64FFDA), size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.open_in_new,
                color: Colors.white.withOpacity(0.5),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
