import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

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
            'Get In Touch',
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
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),

          const SizedBox(height: 60),

          // Footer
          AnimationConfiguration.staggeredList(
            position: 3,
            duration: const Duration(milliseconds: 800),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2025 Harshal Naresh Gupta. All rights reserved.',
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                      if (!isMobile)
                        Text(
                          'Built with Flutter ❤️',
                          style: GoogleFonts.poppins(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildContactInfo(),
        const SizedBox(height: 40),
        _buildContactForm(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: _buildContactInfo()),
        const SizedBox(width: 60),
        Expanded(flex: 2, child: _buildContactForm()),
      ],
    );
  }

  Widget _buildContactInfo() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 800),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let\'s work together!',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64FFDA),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'I\'m always interested in new opportunities and exciting projects. Whether you have a project in mind or just want to chat about technology, feel free to reach out!',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 30),

              // Contact items
              _buildContactItem(
                icon: Icons.email,
                title: 'Email',
                subtitle: 'harshalgupta113@gmail.com',
                onTap: () => _launchURL('mailto:harshalgupta113@gmail.com'),
              ),

              const SizedBox(height: 20),

              _buildContactItem(
                icon: Icons.phone,
                title: 'Phone',
                subtitle: '+91 8433797599',
                onTap: () => _launchURL('tel:+918433797599'),
              ),

              const SizedBox(height: 20),

              _buildContactItem(
                icon: Icons.location_on,
                title: 'Location',
                subtitle: 'Mumbai, India',
                onTap: () {},
              ),

              const SizedBox(height: 30),

              // Social links
              Row(
                children: [
                  _buildSocialIcon(
                    FontAwesomeIcons.linkedin,
                    () => _launchURL(
                      'https://www.linkedin.com/in/harshal-g-510624136/',
                    ),
                  ),
                  const SizedBox(width: 15),
                  _buildSocialIcon(
                    FontAwesomeIcons.github,
                    () => _launchURL('https://github.com/harshalgupta113'),
                  ),
                  const SizedBox(width: 15),
                  _buildSocialIcon(
                    FontAwesomeIcons.envelope,
                    () => _launchURL('mailto:harshalgupta113@gmail.com'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return AnimationConfiguration.staggeredList(
      position: 1,
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
                Text(
                  'Send me a message',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // Name field
                _buildTextField(
                  label: 'Your Name',
                  hint: 'Enter your full name',
                ),

                const SizedBox(height: 20),

                // Email field
                _buildTextField(
                  label: 'Email Address',
                  hint: 'Enter your email address',
                ),

                const SizedBox(height: 20),

                // Subject field
                _buildTextField(label: 'Subject', hint: 'What is this about?'),

                const SizedBox(height: 20),

                // Message field
                _buildTextField(
                  label: 'Message',
                  hint: 'Tell me about your project...',
                  maxLines: 5,
                ),

                const SizedBox(height: 30),

                // Send button
                SizedBox(
                  width: double.infinity,
                  child: Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () {
                        // Handle form submission
                        _showThankYouDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF64FFDA),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Send Message',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF64FFDA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF64FFDA), size: 20),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF64FFDA), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            'Thank You!',
            style: GoogleFonts.poppins(
              color: const Color(0xFF64FFDA),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Thanks for reaching out! I\'ll get back to you as soon as possible.',
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64FFDA),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
