import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'visual_effects.dart';

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
      color: const Color(0xCC111111),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            title: 'Educational Qualifications',
            isMobile: isMobile,
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              _buildEducationCard(
                position: 0,
                degree: 'Master of Computer Application (MCA)',
                institute:
                    'Guru Nanak Institute of Management Studies, Mumbai',
                duration: '2025',
                percentage: 'Sem I - 8.57, Sem II - 8.36, Sem III - 8.2',
                isCurrentStudy: false,
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
    return ScrollReveal(
      staggerIndex: position,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 500;
          return HoverCard(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 15),
                Text(
                  institute,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
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
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return _HoverInfoItem(label: label, value: value, icon: icon);
  }
}

class _HoverInfoItem extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HoverInfoItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  State<_HoverInfoItem> createState() => _HoverInfoItemState();
}

class _HoverInfoItemState extends State<_HoverInfoItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hover
                ? AppColors.accent.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedRotation(
                  turns: _hover ? 0.08 : 0,
                  duration: Motion.fast,
                  child: Icon(
                    widget.icon,
                    color: const Color(0xFF64FFDA),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
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
              widget.value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
