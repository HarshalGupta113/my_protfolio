import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'visual_effects.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sending = false;

  static const _inbox = 'harshalgupta113@gmail.com';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_sending || !_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    setState(() => _sending = true);

    var delivered = false;
    try {
      final response = await http
          .post(
            Uri.parse('https://formsubmit.co/ajax/$_inbox'),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              '_replyto': email,
              '_subject': subject.isNotEmpty
                  ? 'Portfolio: $subject'
                  : 'Portfolio Contact',
              'message': message,
              '_template': 'table',
              '_captcha': 'false',
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        delivered = true;
      }
    } catch (_) {
      delivered = false;
    }

    if (!mounted) return;
    setState(() => _sending = false);

    if (delivered) {
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
      _showThankYouDialog(context);
      return;
    }

    final mailto = Uri.encodeFull(
      'mailto:$_inbox?subject=${subject.isNotEmpty ? subject : 'Portfolio Contact'}&body='
      'Name: $name\nEmail: $email\n\n$message',
    );
    await _launchURL(mailto);
    if (!mounted) return;
    _showMessage(
      context,
      'Could not send directly. Your email app was opened as a backup.',
    );
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1A1A),
        content: Text(
          text,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
      filled: true,
      fillColor: Colors.black.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF64FFDA), width: 2),
      ),
    );
  }

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
          SectionHeading(title: 'Get In Touch', isMobile: isMobile),
          const SizedBox(height: 40),
          isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          const SizedBox(height: 60),
          ScrollReveal(
            staggerIndex: 3,
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
    return ScrollReveal(
      staggerIndex: 0,
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
                    faIcon: FontAwesomeIcons.linkedin,
                    onTap: () => _launchURL(
                      'https://www.linkedin.com/in/harshal-g-510624136/',
                    ),
                  ),
                  const SizedBox(width: 15),
                  _buildSocialIcon(
                    faIcon: FontAwesomeIcons.github,
                    onTap: () =>
                        _launchURL('https://github.com/harshalgupta113'),
                  ),
                  const SizedBox(width: 15),
                  _buildSocialIcon(
                    faIcon: FontAwesomeIcons.envelope,
                    onTap: () =>
                        _launchURL('mailto:harshalgupta113@gmail.com'),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Widget _buildContactForm() {
    return ScrollReveal(
      staggerIndex: 1,
      child: HoverCard(
        padding: const EdgeInsets.all(30),
        child: Form(
              key: _formKey,
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
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: _inputDecoration(
                      'Your Name',
                      'Enter your full name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: _inputDecoration(
                      'Email Address',
                      'Enter your email address',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email address';
                      }
                      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Subject field
                  TextFormField(
                    controller: _subjectController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: _inputDecoration(
                      'Subject',
                      'What is this about?',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Message field
                  TextFormField(
                    controller: _messageController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: _inputDecoration(
                      'Message',
                      'Tell me about your project...',
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your message';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: Builder(
                      builder: (context) => GlowButton(
                        borderRadius: BorderRadius.circular(10),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        onPressed: _sending
                            ? null
                            : () => _submitForm(context),
                        child: Center(
                          child: _sending
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  'Send Message',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
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
    return _ContactRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  Widget _buildSocialIcon({
    IconData? icon,
    FaIconData? faIcon,
    required VoidCallback onTap,
  }) {
    return HoverIconButton(
      onTap: onTap,
      child: faIcon != null
          ? FaIcon(faIcon, color: Colors.white70, size: 20)
          : Icon(icon, color: Colors.white70, size: 20),
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

class _ContactRow extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Motion.fast,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          transform: Matrix4.identity()
            ..translateByDouble(_hover ? 4 : 0, 0, 0, 1),
          child: Row(
            children: [
              AnimatedContainer(
                duration: Motion.fast,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF64FFDA).withOpacity(_hover ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _hover
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.2),
                            blurRadius: 12,
                          ),
                        ]
                      : const [],
                ),
                child: Icon(
                  widget.icon,
                  color: const Color(0xFF64FFDA),
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
