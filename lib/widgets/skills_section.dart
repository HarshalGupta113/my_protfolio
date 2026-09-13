import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'visual_effects.dart';

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
      color: const Color(0xCC111111),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(title: 'Skills & Competencies', isMobile: isMobile),
          const SizedBox(height: 40),
          Column(
            children: [
              _buildSkillCategory(
                position: 0,
                title: 'Programming Languages',
                skills: [
                  SkillItem.awesome('Java', FontAwesomeIcons.java, 85),
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
                  SkillItem.awesome('MongoDB', FontAwesomeIcons.database, 70),
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
                  SkillItem.awesome('REST APIs', FontAwesomeIcons.server, 85),
                  SkillItem.awesome('Git & GitHub', FontAwesomeIcons.github, 80),
                  SkillItem('Agile Methodology', Icons.sync, 75),
                  SkillItem('Unit Testing', Icons.bug_report, 70),
                ],
              ),
            ],
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
    return ScrollReveal(
      staggerIndex: position,
      style: position.isEven ? RevealStyle.scale : RevealStyle.fadeLeft,
      child: Builder(
        builder: (context) {
          final isMobile = ResponsiveBreakpoints.of(context).isMobile;
          return HoverCard(
            padding: const EdgeInsets.all(30),
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
    );
  }

  Widget _buildSkillItem(SkillItem skill) {
    return Tooltip(
      message: '${skill.name} — ${skill.proficiency}%',
      waitDuration: const Duration(milliseconds: 400),
      child: SkillHoverTile(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SkillIcon(icon: skill.icon, faIcon: skill.faIcon),
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
            AnimatedSkillBar(progress: skill.proficiency / 100),
          ],
        ),
      ),
    );
  }
}

class _SkillIcon extends StatefulWidget {
  final IconData? icon;
  final FaIconData? faIcon;
  const _SkillIcon({this.icon, this.faIcon});

  @override
  State<_SkillIcon> createState() => _SkillIconState();
}

class _SkillIconState extends State<_SkillIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF64FFDA);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedRotation(
        turns: _hover ? 0.08 : 0,
        duration: Motion.fast,
        child: AnimatedScale(
          scale: _hover ? 1.12 : 1,
          duration: Motion.fast,
          child: widget.faIcon != null
              ? FaIcon(widget.faIcon!, color: color, size: 20)
              : Icon(widget.icon, color: color, size: 20),
        ),
      ),
    );
  }
}

class SkillItem {
  final String name;
  final IconData? icon;
  final FaIconData? faIcon;
  final int proficiency;

  SkillItem(this.name, this.icon, this.proficiency) : faIcon = null;
  SkillItem.awesome(this.name, this.faIcon, this.proficiency) : icon = null;
}
