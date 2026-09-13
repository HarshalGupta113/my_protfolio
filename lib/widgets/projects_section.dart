import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'visual_effects.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _showAllProjects = false;

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
          SectionHeading(title: 'Projects', isMobile: isMobile),
          const SizedBox(height: 40),
          ScrollReveal(
            child: Text(
              'Live Projects',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (isMobile)
            _buildMobileLayout()
          else
            StickyViewport(
              pages: _getDisplayedProjects().length,
              builder: (context, progress) => _ProjectStage(
                projects: _getDisplayedProjects(),
                progress: progress,
              ),
            ),
          if (_getProjectsList().length > 2) ...[
            const SizedBox(height: 40),
            Center(
              child: GlowButton(
                filled: false,
                onPressed: () {
                  setState(() {
                    _showAllProjects = !_showAllProjects;
                  });
                },
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _showAllProjects ? 'Show Less' : 'See More Projects',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64FFDA),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedRotation(
                      turns: _showAllProjects ? 0.5 : 0,
                      duration: Motion.normal,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF64FFDA),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getProjectsList() {
    return [
      {
        'title': 'My YRF - Employee Management System',
        'description':
            'A comprehensive HRMS (Human Resource Management System) mobile application for Yash Raj Films. The app provides employees with seamless access to HR services, attendance tracking, leave management, and company updates. Available on both Android and iOS platforms.',
        'technologies': [
          'Flutter',
          'Dart',
          'REST API',
          'Firebase',
          'Push Notifications',
        ],
        'features': [
          'Employee attendance and leave management',
          'Digital HR services and documentation',
          'Real-time notifications and updates',
          'Cross-platform support (Android & iOS)',
          'Secure authentication and data management',
        ],
        'links': {
          'android':
              'https://play.google.com/store/apps/details?id=com.yashrajfilms.hrms&hl=en_IN',
          'ios': 'https://apps.apple.com/in/app/my-yrf/id6749893849',
        },
      },
      {
        'title': 'Novo Cinemas - Movie Booking App',
        'description':
            'A feature-rich cinema booking application for Novo Cinemas and Grand Cinema chains. The app offers seamless movie booking, seat selection, show timings, and loyalty rewards. Provides users with a smooth ticket booking experience across multiple cinema locations.',
        'technologies': [
          'Flutter',
          'Dart',
          'Payment Gateway',
          'REST API',
          'Location Services',
        ],
        'features': [
          'Browse movies and showtimes',
          'Interactive seat selection and booking',
          'Multiple payment options integration',
          'Loyalty program and rewards',
          'Multi-cinema location support',
        ],
        'links': {
          'android':
              'https://play.google.com/store/apps/details?id=com.grandcinema.gcapp.screens&hl=en_IN',
          'ios': 'https://apps.apple.com/in/app/novo-cinemas/id363121411',
        },
      },
      {
        'title': 'Fitness Tracker App',
        'description':
            'Developed an Android app using Kotlin to track daily step counts and calculate BMI with health suggestions. Integrated Android Fitness APIs for step tracking and day-specific data display.',
        'technologies': ['Kotlin', 'Android', 'Fitness APIs', 'BMI Calculator'],
        'features': [
          'Daily step count tracking',
          'BMI calculation with health suggestions',
          'Android Fitness API integration',
          'Day-specific data display',
        ],
      },
      {
        'title': 'Flutter Movie App',
        'description':
            'A Flutter-based movie app that uses the TMDb API to display movies and TV shows. This project demonstrates key Flutter concepts such as API integration, navigation, state management, and responsive UI design.',
        'technologies': ['Flutter', 'Dart', 'TMDb API', 'State Management'],
        'features': [
          'Movie and TV show listings',
          'API integration with TMDb',
          'Responsive UI design',
          'Navigation and state management',
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getDisplayedProjects() {
    final projects = _getProjectsList();
    return _showAllProjects ? projects : projects.take(2).toList();
  }

  Widget _buildMobileLayout() {
    final projects = _getDisplayedProjects();
    return Column(
      children: projects
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < projects.length - 1 ? 30 : 0,
              ),
              child: _buildProjectCard(
                position: entry.key,
                title: entry.value['title'],
                description: entry.value['description'],
                technologies: List<String>.from(entry.value['technologies']),
                features: List<String>.from(entry.value['features']),
                links: entry.value['links'],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildProjectCard({
    required int position,
    required String title,
    required String description,
    required List<String> technologies,
    required List<String> features,
    Map<String, String>? links,
  }) {
    return ScrollReveal(
      staggerIndex: position,
      style: position.isEven ? RevealStyle.fadeLeft : RevealStyle.fadeRight,
      child: HoverCard(
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
            const SizedBox(height: 15),
            Text(
              description,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Technologies Used:',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: technologies
                  .asMap()
                  .entries
                  .map((entry) => _TechBadge(label: entry.value, index: entry.key))
                  .toList(),
            ),
            const SizedBox(height: 25),
            Text(
              'Key Features:',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            ...features.map(
              (feature) => Padding(
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
                        feature,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (links != null && links.isNotEmpty) ...[
              const SizedBox(height: 25),
              Text(
                'Available On:',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  if (links['android'] != null)
                    _buildStoreButton(
                      label: 'Google Play',
                      icon: Icons.android,
                      url: links['android']!,
                    ),
                  if (links['ios'] != null)
                    _buildStoreButton(
                      label: 'App Store',
                      icon: Icons.apple,
                      url: links['ios']!,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStoreButton({
    required String label,
    required IconData icon,
    required String url,
  }) {
    return _StoreButton(label: label, icon: icon, url: url);
  }
}

class _ProjectStage extends StatelessWidget {
  final List<Map<String, dynamic>> projects;
  final double progress;

  const _ProjectStage({
    required this.projects,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final n = projects.isEmpty ? 1 : projects.length;
    final raw = progress * n;
    final index = raw.floor().clamp(0, n - 1);
    final local = (raw - index).clamp(0.0, 1.0);
    final project = projects[index];
    final number = (index + 1).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 88, 50, 32),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 12, bottom: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                switchInCurve: Motion.curve,
                layoutBuilder: (current, previous) {
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      ...previous,
                      if (current != null) current,
                    ],
                  );
                },
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.06),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _ProjectInfo(
                  key: ValueKey(index),
                  number: number,
                  title: project['title'] as String,
                  description: project['description'] as String,
                  technologies: List<String>.from(project['technologies']),
                  features: List<String>.from(project['features']),
                  links: project['links'] as Map<String, String>?,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 4,
            child: _CinematicVisual(
              index: index,
              local: local,
              title: project['title'] as String,
              number: number,
              total: n,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectInfo extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final List<String> technologies;
  final List<String> features;
  final Map<String, String>? links;

  const _ProjectInfo({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.technologies,
    required this.features,
    this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: GoogleFonts.poppins(
            color: AppColors.accent.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: const Color(0xFF64FFDA),
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Technologies Used:',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: technologies
              .asMap()
              .entries
              .map((entry) => _TechBadge(label: entry.value, index: entry.key))
              .toList(),
        ),
        const SizedBox(height: 22),
        Text(
          'Key Features:',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...features.map(
          (feature) => Padding(
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
                    feature,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (links != null && links!.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text(
            'Available On:',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              if (links!['android'] != null)
                _StoreButton(
                  label: 'Google Play',
                  icon: Icons.android,
                  url: links!['android']!,
                ),
              if (links!['ios'] != null)
                _StoreButton(
                  label: 'App Store',
                  icon: Icons.apple,
                  url: links!['ios']!,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _CinematicVisual extends StatefulWidget {
  final int index;
  final double local;
  final String title;
  final String number;
  final int total;

  const _CinematicVisual({
    required this.index,
    required this.local,
    required this.title,
    required this.number,
    required this.total,
  });

  @override
  State<_CinematicVisual> createState() => _CinematicVisualState();
}

class _CinematicVisualState extends State<_CinematicVisual> {
  Offset _pointer = Offset.zero;

  static const _palettes = [
    [Color(0xFF0B2A24), Color(0xFF64FFDA)],
    [Color(0xFF16132B), Color(0xFF8AA4FF)],
    [Color(0xFF2A1C0E), Color(0xFFE2B98A)],
    [Color(0xFF0C2230), Color(0xFF6EC8F0)],
  ];

  @override
  Widget build(BuildContext context) {
    final fine = Motion.isFinePointer(context);
    final reduce = Motion.reduce(context);
    final palette = _palettes[widget.index % _palettes.length];
    final peak = 1 - (widget.local - 0.5).abs() * 2;
    final scale = reduce ? 1.0 : 0.92 + 0.08 * peak;
    final radius = 18.0 + 10 * peak;

    return MouseRegion(
      onHover: fine
          ? (event) {
              final box = context.findRenderObject() as RenderBox?;
              if (box == null) return;
              final local = box.globalToLocal(event.position);
              setState(() => _pointer = local);
            }
          : null,
      onExit: fine ? (_) => setState(() => _pointer = Offset.zero) : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cx = constraints.maxWidth / 2;
          final cy = constraints.maxHeight / 2;
          final dx = _pointer == Offset.zero ? 0.0 : (_pointer.dx - cx) / cx;
          final dy = _pointer == Offset.zero ? 0.0 : (_pointer.dy - cy) / cy;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(dx * 0.08)
              ..rotateX(-dy * 0.06)
              ..scaleByDouble(scale, scale, 1, 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeOut,
              height: constraints.maxHeight.clamp(280, 640),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: palette[1].withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: palette[1].withValues(alpha: 0.16),
                    blurRadius: 36,
                    offset: const Offset(0, 18),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    palette[0],
                    Color.lerp(palette[0], palette[1], 0.35)!,
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    right: 12,
                    top: 8,
                    child: Text(
                      widget.number,
                      style: GoogleFonts.poppins(
                        fontSize: 88,
                        fontWeight: FontWeight.w700,
                        color: palette[1].withValues(alpha: 0.28),
                        height: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PROJECT',
                          style: GoogleFonts.poppins(
                            color: palette[1],
                            fontSize: 12,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: List.generate(widget.total, (i) {
                            final active = i == widget.index;
                            return AnimatedContainer(
                              duration: Motion.fast,
                              margin: const EdgeInsets.only(right: 8),
                              width: active ? 28 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: active
                                    ? palette[1]
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TechBadge extends StatefulWidget {
  final String label;
  final int index;
  const _TechBadge({required this.label, required this.index});

  @override
  State<_TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<_TechBadge> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        transform: Matrix4.identity()
          ..translateByDouble(0, _hover ? -2 : 0, 0, 1)
          ..scaleByDouble(_hover ? 1.04 : 1, _hover ? 1.04 : 1, 1, 1),
        decoration: BoxDecoration(
          color: const Color(0xFF64FFDA).withValues(alpha: _hover ? 0.18 : 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF64FFDA).withValues(alpha: _hover ? 0.7 : 0.3),
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.poppins(
            color: const Color(0xFF64FFDA),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _StoreButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final String url;

  const _StoreButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  State<_StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<_StoreButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            debugPrint('Could not launch ${widget.url}');
          }
        },
        child: AnimatedContainer(
          duration: Motion.fast,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          transform: Matrix4.identity()
            ..translateByDouble(0, _hover ? -2 : 0, 0, 1),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _hover ? 0.1 : 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hover
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: const Color(0xFF64FFDA), size: 20),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedSlide(
                offset: _hover ? const Offset(0.12, -0.12) : Offset.zero,
                duration: Motion.fast,
                child: Icon(
                  Icons.open_in_new,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
