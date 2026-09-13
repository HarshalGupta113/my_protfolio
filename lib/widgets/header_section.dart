import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'visual_effects.dart';

class HeaderSection extends StatelessWidget {
  final VoidCallback? onContactTap;
  final ValueNotifier<Offset> pointer;
  final ValueNotifier<double> scrollOffset;
  const HeaderSection({
    super.key,
    this.onContactTap,
    required this.pointer,
    required this.scrollOffset,
  });

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
    final reduce = Motion.reduce(context);
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
        ),
      ),
      child: ValueListenableBuilder<double>(
        valueListenable: scrollOffset,
        builder: (context, offset, _) {
          final t = reduce || isMobile
              ? 0.0
              : (offset / height).clamp(0.0, 1.0);
          return Stack(
            children: [
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(0, t * 70),
                  child: HeroParticles(enabled: !reduce, pointer: pointer),
                ),
              ),
              Positioned(
                right: isMobile ? -40 : 80,
                top: isMobile ? 120 : 140,
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: pointer,
                    builder: (context, _) {
                      final p = pointer.value;
                      final size = MediaQuery.sizeOf(context);
                      final nx =
                          size.width == 0 ? 0 : (p.dx / size.width - 0.5);
                      final ny =
                          size.height == 0 ? 0 : (p.dy / size.height - 0.5);
                      return Transform.translate(
                        offset: Offset(nx * 18, ny * 14 - t * 90),
                        child: Transform.scale(
                          scale: 1 + t * 0.25,
                          child: Container(
                            width: isMobile ? 180 : 280,
                            height: isMobile ? 180 : 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.accent.withValues(
                                    alpha: 0.16 * (1 - t),
                                  ),
                                  AppColors.accent.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Opacity(
                opacity: (1 - t * 0.92).clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, -48 * t),
                  child: Transform.scale(
                    scale: 1 - 0.08 * t,
                    alignment: Alignment.centerLeft,
                    child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 50,
              vertical: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroEntrance(
                  index: 0,
                  reduce: reduce,
                  child: Text(
                    'Hello, I\'m',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: isMobile ? 18 : 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                HeroEntrance(
                  index: 1,
                  reduce: reduce,
                  child: Text(
                    'Harshal Naresh Gupta',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: isMobile ? 32 : 56,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                HeroEntrance(
                  index: 2,
                  reduce: reduce,
                  child: Row(
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
                ),
                const SizedBox(height: 30),
                HeroEntrance(
                  index: 3,
                  reduce: reduce,
                  child: SizedBox(
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
                ),
                const SizedBox(height: 40),
                HeroEntrance(
                  index: 4,
                  reduce: reduce,
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 15,
                    children: [
                      _buildSocialButton(
                        faIcon: FontAwesomeIcons.linkedin,
                        label: 'LinkedIn',
                        onTap: () => _launchURL(
                          'https://www.linkedin.com/in/harshal-g-510624136/',
                        ),
                      ),
                      _buildSocialButton(
                        icon: Icons.email,
                        label: 'Email',
                        onTap: () =>
                            _launchURL('mailto:harshalgupta113@gmail.com'),
                      ),
                      _buildSocialButton(
                        icon: Icons.phone,
                        label: 'Call',
                        onTap: () => _launchURL('tel:+918433797599'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                HeroEntrance(
                  index: 5,
                  reduce: reduce,
                  child: GlowButton(
                    onPressed: onContactTap,
                    magnetic: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 30 : 40,
                      vertical: isMobile ? 12 : 16,
                    ),
                    child: Text(
                      'Get In Touch',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
                  ),
                ),
              ),
              ),
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
          );
        },
      ),
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    FaIconData? faIcon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _SocialChip(
      icon: icon,
      faIcon: faIcon,
      label: label,
      onTap: onTap,
    );
  }
}

class _SocialChip extends StatefulWidget {
  final IconData? icon;
  final FaIconData? faIcon;
  final String label;
  final VoidCallback onTap;

  const _SocialChip({
    this.icon,
    this.faIcon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final reduce = Motion.reduce(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: reduce ? Duration.zero : Motion.fast,
          curve: Motion.curve,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          transform: Matrix4.identity()
            ..translateByDouble(0, _hover ? -3 : 0, 0, 1),
          decoration: BoxDecoration(
            color: _hover
                ? AppColors.accent.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: _hover
                  ? AppColors.accent.withValues(alpha: 0.55)
                  : Colors.white.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.16),
                      blurRadius: 16,
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                turns: _hover ? 0.06 : 0,
                duration: Motion.fast,
                child: widget.faIcon != null
                    ? FaIcon(
                        widget.faIcon!,
                        color: _hover ? AppColors.accent : Colors.white70,
                        size: 16,
                      )
                    : Icon(
                        widget.icon,
                        color: _hover ? AppColors.accent : Colors.white70,
                        size: 16,
                      ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  color: _hover ? Colors.white : Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
