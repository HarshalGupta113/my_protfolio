import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
        ),
      ),
      child: Stack(
        children: [
          // Background particles effect (simplified)
          Positioned.fill(child: CustomPaint(painter: ParticlesPainter())),

          // Main content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 50,
              vertical: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Text(
                  'Hello, I\'m',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 10),

                // Name
                Text(
                  'Harshal Naresh Gupta',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: isMobile ? 32 : 56,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 20),

                // Animated title
                Row(
                  children: [
                    Text(
                      'I\'m a ',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: isMobile ? 18 : 28,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    DefaultTextStyle(
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64FFDA),
                        fontSize: isMobile ? 18 : 28,
                        fontWeight: FontWeight.w600,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText('Flutter Developer'),
                          TypewriterAnimatedText('Software Engineer'),
                          TypewriterAnimatedText('Mobile App Developer'),
                          TypewriterAnimatedText('Full Stack Developer'),
                        ],
                        repeatForever: true,
                        pause: const Duration(milliseconds: 1000),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Description
                SizedBox(
                  width: isMobile ? double.infinity : 600,
                  child: Text(
                    'Motivated and adaptable professional seeking to leverage skills in software development and technology to contribute to innovative projects. Committed to delivering high-quality solutions that enhance user experience and meet business objectives.',
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: isMobile ? 14 : 16,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Social links and buttons
                Wrap(
                  spacing: 20,
                  runSpacing: 15,
                  children: [
                    // LinkedIn
                    _buildSocialButton(
                      icon: FontAwesomeIcons.linkedin,
                      label: 'LinkedIn',
                      onTap: () => _launchURL(
                        'https://www.linkedin.com/in/harshal-g-510624136/',
                      ),
                    ),

                    // Email
                    _buildSocialButton(
                      icon: Icons.email,
                      label: 'Email',
                      onTap: () =>
                          _launchURL('mailto:harshalgupta113@gmail.com'),
                    ),

                    // Phone
                    _buildSocialButton(
                      icon: Icons.phone,
                      label: 'Call',
                      onTap: () => _launchURL('tel:+918433797599'),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // CTA Button
                ElevatedButton(
                  onPressed: () {
                    // Scroll to contact section
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64FFDA),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 30 : 40,
                      vertical: isMobile ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Get In Touch',
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Mobile menu button
          if (isMobile)
            Positioned(
              top: 50,
              right: 20,
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw some simple dots as particles
    for (int i = 0; i < 50; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 47) % size.height;
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
