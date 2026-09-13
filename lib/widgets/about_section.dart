import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'visual_effects.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
          SectionHeading(title: 'About Me', isMobile: isMobile),
          const SizedBox(height: 40),
          isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildPersonalInfo(),
        const SizedBox(height: 40),
        _buildPersonalDetails(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildPersonalInfo()),
        const SizedBox(width: 60),
        Expanded(flex: 1, child: _buildPersonalDetails()),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollReveal(
          style: RevealStyle.blurUp,
          child: Text(
            'Get to know me!',
            style: GoogleFonts.poppins(
              color: const Color(0xFF64FFDA),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ScrollReveal(
          staggerIndex: 1,
          style: RevealStyle.fadeUp,
          dy: 18,
          child: Text(
            'I\'m a passionate Flutter Developer and Software Engineer with experience in building cross-platform mobile applications. I completed my Master of Computer Application (MCA) in 2025 from Guru Nanak Institute of Management Studies, Mumbai.',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ScrollReveal(
          staggerIndex: 2,
          style: RevealStyle.fadeUp,
          dy: 18,
          child: Text(
            'I have hands-on experience working with Flutter, Dart, REST APIs, and various mobile development technologies. I\'ve worked at Expointe IO as a Flutter Developer Intern and INOVEC Solution as a Software Developer Intern, where I developed cross-platform mobile apps and collaborated with teams to implement UI/UX designs.',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ScrollReveal(
          staggerIndex: 3,
          style: RevealStyle.fadeUp,
          dy: 18,
          child: Text(
            'I\'m committed to delivering high-quality solutions that enhance user experience and meet business objectives. I enjoy working in Agile environments and conducting unit testing to ensure app stability and quality.',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ScrollReveal(
          staggerIndex: 4,
          style: RevealStyle.blurUp,
          child: Text(
            'When I\'m not coding, I enjoy playing video games and exploring new technologies to stay updated with the latest trends in software development.',
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 15,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalDetails() {
    return ScrollReveal(
      staggerIndex: 1,
      style: RevealStyle.fadeRight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 500;
          return HoverCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Details',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64FFDA),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetailItem('Name', 'Harshal Naresh Gupta', isMobile),
                _buildDetailItem(
                  'Date of Birth',
                  '21st October, 2000',
                  isMobile,
                ),
                _buildDetailItem('Nationality', 'Indian', isMobile),
                _buildDetailItem('Gender', 'Male', isMobile),
                _buildDetailItem(
                  'Languages',
                  'English, Hindi & Marathi',
                  isMobile,
                ),
                _buildDetailItem('Location', 'Mumbai, India', isMobile),
                _buildDetailItem('Phone', '+91 8433797599', isMobile),
                _buildDetailItem(
                  'Email',
                  'harshalgupta113@gmail.com',
                  isMobile,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isMobile) {
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label:',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                '$label:',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }
  }
}
