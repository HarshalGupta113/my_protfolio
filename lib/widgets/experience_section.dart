import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'visual_effects.dart';

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
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(title: 'Work Experience', isMobile: isMobile),
          const SizedBox(height: 40),
          Column(
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
                isLast: false,
              ),
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
                isLast: true,
              ),
            ],
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
    required bool isLast,
  }) {
    return ScrollReveal(
      staggerIndex: position,
      style: position.isEven ? RevealStyle.fadeLeft : RevealStyle.fadeRight,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isCurrentJob ? AppColors.accent : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accent, width: 2),
                      boxShadow: isCurrentJob
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.45),
                                blurRadius: 10,
                              ),
                            ]
                          : const [],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.accent.withValues(alpha: 0.8),
                            AppColors.accent.withValues(
                              alpha: isLast ? 0.05 : 0.35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 30),
                child: HoverCard(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                color: const Color(0xFF64FFDA).withValues(alpha: 0.2),
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
                      Text(
                        duration,
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Responsibilities Handled:',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ...description.map(
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
