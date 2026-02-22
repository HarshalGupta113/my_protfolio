import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

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
            'Skills & Competencies',
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
                _buildSkillCategory(
                  position: 0,
                  title: 'Programming Languages',
                  skills: [
                    SkillItem('Java', FontAwesomeIcons.java, 85),
                    SkillItem('Kotlin', Icons.android, 80),
                    SkillItem('Flutter', Icons.flutter_dash, 90),
                    SkillItem('Dart', Icons.code, 90),
                  ],
                ),

                const SizedBox(height: 40),

                _buildSkillCategory(
                  position: 1,
                  title: 'Databases',
                  skills: [
                    SkillItem('Firebase', Icons.local_fire_department, 85),
                    SkillItem('MySQL', Icons.storage, 75),
                    SkillItem('MongoDB', FontAwesomeIcons.database, 70),
                  ],
                ),

                const SizedBox(height: 40),

                _buildSkillCategory(
                  position: 2,
                  title: 'Soft Skills',
                  skills: [
                    SkillItem('Problem-Solving', Icons.psychology, 90),
                    SkillItem('Teamwork', Icons.group, 85),
                    SkillItem('Time Management', Icons.schedule, 80),
                    SkillItem('Adaptability', Icons.trending_up, 85),
                  ],
                ),

                const SizedBox(height: 40),

                _buildSkillCategory(
                  position: 3,
                  title: 'Other Skills',
                  skills: [
                    SkillItem('REST APIs', FontAwesomeIcons.server, 85),
                    SkillItem('Git & GitHub', FontAwesomeIcons.github, 80),
                    SkillItem('Agile Methodology', Icons.sync, 75),
                    SkillItem('Unit Testing', Icons.bug_report, 70),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCategory({
    required int position,
    required String title,
    required List<SkillItem> skills,
  }) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: 800),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Builder(
            builder: (context) {
              final isMobile = ResponsiveBreakpoints.of(context).isMobile;
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
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64FFDA),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    if (isMobile)
                      Column(
                        children: skills
                            .map(
                              (skill) => Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: _buildSkillItem(skill),
                              ),
                            )
                            .toList(),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 6,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                            ),
                        itemCount: skills.length,
                        itemBuilder: (context, index) {
                          final skill = skills[index];
                          return _buildSkillItem(skill);
                        },
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

  Widget _buildSkillItem(SkillItem skill) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(skill.icon, color: const Color(0xFF64FFDA), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  skill.name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${skill.proficiency}%',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64FFDA),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Progress bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: skill.proficiency / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF64FFDA),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkillItem {
  final String name;
  final IconData icon;
  final int proficiency;

  SkillItem(this.name, this.icon, this.proficiency);
}
