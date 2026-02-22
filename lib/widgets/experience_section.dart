import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

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
            'Work Experience',
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

          AnimationLimiter(
            child: Column(
              children: [
                _buildExperienceCard(
                  position: 0,
                  company: 'Expointe IO',
                  role: 'Flutter Developer Intern',
                  duration: 'February 2025 to Currently',
                  description: [
                    'Developed cross-platform mobile apps using Flutter and Dart',
                    'Integrated REST APIs and third-party services',
                    'Collaborated with designers and backend teams to implement UI/UX designs',
                    'Optimized app performance and participated in Agile processes',
                    'Conducted unit testing to ensure stability and quality',
                  ],
                  isCurrentJob: true,
                ),

                const SizedBox(height: 30),

                _buildExperienceCard(
                  position: 1,
                  company: 'INOVEC Solution',
                  role: 'Software Developer Intern (Android)',
                  duration: 'December 2022 to February 2023 (3 months)',
                  description: [
                    'Designed and built advanced applications',
                    'Collaborated on defining and deploying new features',
                    'Integrated external APIs for enhanced functionality',
                    'Conducted unit testing for robustness',
                    'Worked on bug fixes and performance improvements',
                    'Helped maintain code quality, organization, and automation',
                  ],
                  isCurrentJob: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard({
    required int position,
    required String company,
    required String role,
    required String duration,
    required List<String> description,
    required bool isCurrentJob,
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
                // Header with company and duration
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64FFDA),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            role,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (isCurrentJob)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF64FFDA).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF64FFDA),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Current',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF64FFDA),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // Duration
                Text(
                  duration,
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                // Responsibilities
                Text(
                  'Responsibilities Handled:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                // Description list
                ...description
                    .map(
                      (item) => Padding(
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
                                item,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 15,
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
