import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
            'Projects Undertaken (During Post Graduation)',
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
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildProjectCard(
          position: 0,
          title: 'Fitness Tracker App',
          description:
              'Developed an Android app using Kotlin to track daily step counts and calculate BMI with health suggestions. Integrated Android Fitness APIs for step tracking and day-specific data display.',
          technologies: ['Kotlin', 'Android', 'Fitness APIs', 'BMI Calculator'],
          features: [
            'Daily step count tracking',
            'BMI calculation with health suggestions',
            'Android Fitness API integration',
            'Day-specific data display',
          ],
        ),

        const SizedBox(height: 30),

        _buildProjectCard(
          position: 1,
          title: 'Flutter Movie App',
          description:
              'A Flutter-based movie app that uses the TMDb API to display movies and TV shows. This project demonstrates key Flutter concepts such as API integration, navigation, state management, and responsive UI design.',
          technologies: ['Flutter', 'Dart', 'TMDb API', 'State Management'],
          features: [
            'Movie and TV show listings',
            'API integration with TMDb',
            'Responsive UI design',
            'Navigation and state management',
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildProjectCard(
            position: 0,
            title: 'Fitness Tracker App',
            description:
                'Developed an Android app using Kotlin to track daily step counts and calculate BMI with health suggestions. Integrated Android Fitness APIs for step tracking and day-specific data display.',
            technologies: [
              'Kotlin',
              'Android',
              'Fitness APIs',
              'BMI Calculator',
            ],
            features: [
              'Daily step count tracking',
              'BMI calculation with health suggestions',
              'Android Fitness API integration',
              'Day-specific data display',
            ],
          ),
        ),

        const SizedBox(width: 30),

        Expanded(
          child: _buildProjectCard(
            position: 1,
            title: 'Flutter Movie App',
            description:
                'A Flutter-based movie app that uses the TMDb API to display movies and TV shows. This project demonstrates key Flutter concepts such as API integration, navigation, state management, and responsive UI design.',
            technologies: ['Flutter', 'Dart', 'TMDb API', 'State Management'],
            features: [
              'Movie and TV show listings',
              'API integration with TMDb',
              'Responsive UI design',
              'Navigation and state management',
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard({
    required int position,
    required String title,
    required String description,
    required List<String> technologies,
    required List<String> features,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
