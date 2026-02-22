import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 50,
        vertical: 80,
      ),
      color: const Color(0xFF111111),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Educational Qualifications',
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
                _buildEducationCard(
                  position: 0,
                  degree: 'Master of Computer Application (MCA)',
                  institute:
                      'Guru Nanak Institute of Management Studies, Mumbai',
                  duration: 'Pursuing',
                  percentage: 'Sem I - 8.57, Sem II - 8.36, Sem III - 8.2',
                  isCurrentStudy: true,
                ),

                const SizedBox(height: 30),

                _buildEducationCard(
                  position: 1,
                  degree: 'Bachelors in Computer Science',
                  institute: 'N.G Acharya D.K Marathe College',
                  duration: '2022',
                  percentage: '7.98 CGPI',
                  isCurrentStudy: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard({
    required int position,
    required String degree,
    required String institute,
    required String duration,
    required String percentage,
    required bool isCurrentStudy,
  }) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: 800),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 500;
              return Container(
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
                    // Header with degree and status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            degree,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64FFDA),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isCurrentStudy)
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
                    const SizedBox(height: 15),
                    // Institute
                    Text(
                      institute,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Duration and Percentage
                    if (isMobile)
                      Column(
                        children: [
                          _buildInfoItem(
                            'Year of Passing',
                            duration,
                            Icons.calendar_today,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoItem(
                            'Percentage / CGPI',
                            percentage,
                            Icons.grade,
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              'Year of Passing',
                              duration,
                              Icons.calendar_today,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildInfoItem(
                              'Percentage / CGPI',
                              percentage,
                              Icons.grade,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF64FFDA), size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
